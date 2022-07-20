import { SyncWaterfallHook } from 'tapable-ts';
import type { Parser, Node } from '../parser';
import { NodeType } from '../parser';
import type { ViewPlugin } from '.';
import type { View } from './plugin';
import type { Options } from './options';

export interface TemplateItemInfo {
  /** The index of the data for the current iteration of the template */
  index: number;
  /** The data for the current iteration of the template */
  data: any;
  /** The depth of the template node */
  depth: number;
}

export interface TemplateSubstitution {
  /** Regular expression to find and replace. The global flag will be always be added to this expression. */
  expression: string | RegExp;
  /** The value to replace matches with. */
  value: string;
}

export type TemplateSubstitutionsFunc = (
  baseSubstitutions: TemplateSubstitution[],
  templateItemInfo: TemplateItemInfo
) => TemplateSubstitution[];

/** A view plugin to resolve/manage templates */
export default class TemplatePlugin implements ViewPlugin {
  private readonly options: Options;

  hooks = {
    resolveTemplateSubstitutions: new SyncWaterfallHook<
      [TemplateSubstitution[], TemplateItemInfo]
    >(),
  };

  constructor(options: Options) {
    this.options = options;
  }

  private parseTemplate(parser: Parser, node: Node.Template): Node.Node | null {
    const { template, depth } = node;
    const data = this.options.data.model.get(node.data);

    if (!data) {
      return null;
    }

    if (!Array.isArray(data)) {
      throw new Error(`Template using '${node.data}' but is not an array`);
    }

    const values: Array<Node.Node> = [];

    data.forEach((dataItem, index) => {
      const templateSubstitutions =
        this.hooks.resolveTemplateSubstitutions.call(
          [
            {
              expression: new RegExp(`_index${depth || ''}_`),
              value: String(index),
            },
          ],
          {
            depth,
            data: dataItem,
            index,
          }
        );
      let templateStr = JSON.stringify(template);

      for (const { expression, value } of templateSubstitutions) {
        let flags = 'g';
        if (typeof expression === 'object') {
          flags = `${expression.flags}${expression.global ? '' : 'g'}`;
        }

        templateStr = templateStr.replace(new RegExp(expression, flags), value);
      }

      const parsed = parser.parseObject(
        JSON.parse(templateStr),
        NodeType.Value,
        { templateDepth: node.depth + 1 }
      );

      if (parsed) {
        values.push(parsed);
      }
    });

    const result: Node.MultiNode = {
      parent: node.parent,
      type: NodeType.MultiNode,
      values,
    };

    result.values.forEach((innerNode) => {
      // eslint-disable-next-line no-param-reassign
      innerNode.parent = result;
    });

    return result;
  }

  applyParserHooks(parser: Parser) {
    parser.hooks.onCreateASTNode.tap('template', (node) => {
      if (node && node.type === NodeType.Template) {
        return this.parseTemplate(parser, node);
      }

      return node;
    });
  }

  apply(view: View) {
    view.hooks.parser.tap('template', this.applyParserHooks.bind(this));
  }
}
