import { Asset, AssetWrapper, Expression } from '@player-ui/player';

export interface ActionAsset<AnyTextAsset extends Asset = Asset> extends Asset<'action'> {
  /** The transition value of the action in the state machine */
  value?: string;

  /** A text-like asset for the action's label */
  label?: AssetWrapper<AnyTextAsset>;

  /** An optional expression to execute before transitioning */
  exp?: Expression;
}
