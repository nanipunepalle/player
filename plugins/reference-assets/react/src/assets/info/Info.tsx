import React from 'react';
import type { InfoAssetTransform } from '@player-ui/reference-assets-plugin';
import { ReactAsset } from '@player-ui/react';
import {
  ButtonGroup,
  Box,
  Heading,
  Divider,
  Stack,
  HStack,
} from '@chakra-ui/react';

import { ActionDSL } from './actionDSL';

/** The info view type is used to show information to the user */
export const Info = (props: InfoAssetTransform) => {

  return (
       <ActionDSL value="next" />
  );
};
