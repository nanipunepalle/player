import { Asset, AssetPropsWithChildren } from '@player-tools/dsl';
import { ActionAsset } from '@player-ui/reference-assets-plugin';

export const ActionDSL = (props: AssetPropsWithChildren<ActionAsset>) => {
  return <Asset type="action" {...props} />;
}