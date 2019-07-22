/**
 * This file is part of Serlo.org.
 *
 * Copyright (c) 2013-2019 Serlo Education e.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * @copyright Copyright (c) 2013-2019 Serlo Education e.V.
 * @license   http://www.apache.org/licenses/LICENSE-2.0 Apache License 2.0
 * @link      https://github.com/serlo-org/serlo.org for the canonical source repository
 */
import { blockquoteRendererPlugin as blockquote } from '@serlo/editor-plugin-blockquote-renderer'
import { geogebraRendererPlugin as geogebra } from '@serlo/editor-plugin-geogebra-renderer'
import { injectionRendererPlugin as injection } from '@serlo/editor-plugin-injection-renderer'
import { spoilerRendererPlugin as spoiler } from '@serlo/editor-plugin-spoiler-renderer'
import { tableRendererPlugin as table } from '@serlo/editor-plugin-table-renderer'
import { Plugin } from '@serlo/editor-plugins-registry'
import { v4 } from 'uuid'

import markdownToSlate from './markdownToSlate'
import { Element, LinkedImagesTMP, NormalizedObject } from './normalizeMarkdown'
import { ValueJSON } from 'slate'
import { ContentCell, Splish } from '../splishToEdtr/types'

const createPlugins = ({ normalized, elements }: NormalizedObject) => {
  const split = normalized
    .split(/(§\d+§)/)
    .map(s => s.trim())
    .filter(s => s !== '')

  if (!split.length) {
    return [
      {
        cells: [markdownToSlate('')]
      }
    ]
  }
  return split.map(markdown => {
    const elementIDMatch = /§(\d+)§/.exec(markdown)
    if (elementIDMatch !== null) {
      // explicitly cast the matched number for typescript
      const i = parseInt(elementIDMatch[1])
      return {
        cells: [createPluginCell(elements[i])]
      }
    } else {
      return {
        cells: [markdownToSlate(markdown)]
      }
    }
  })
}
const createPluginCell = (elem: Element): ContentCell<SplishPluginState> => {
  switch (elem.name) {
    case 'table':
      return {
        content: {
          plugin: {
            name: Plugin.Table,
            version: '0.0.0'
          },
          state: {
            src: elem.src
          }
        }
      }
    case 'spoiler':
      return {
        content: {
          plugin: {
            name: Plugin.Spoiler,
            version: '0.0.0'
          },
          state: {
            title: elem.title,
            content: {
              type: '@splish-me/editor-core/editable',
              state: {
                id: v4(),
                cells: [
                  {
                    id: v4(),
                    rows: createPlugins(elem.content)
                  }
                ]
              }
            }
          }
        }
      }
    case 'blockquote':
      return {
        content: {
          plugin: {
            name: Plugin.Blockquote,
            version: '0.0.0'
          },
          state: {
            child: {
              type: '@splish-me/editor-core/editable',
              state: {
                id: v4(),
                cells: [
                  {
                    id: v4(),
                    rows: createPlugins(elem.content)
                  }
                ]
              }
            }
          }
        }
      }
    case 'injection':
      return {
        content: {
          plugin: {
            name: Plugin.Injection,
            version: '0.0.0'
          },
          state: {
            description: elem.description,
            src: elem.src
          }
        }
      }
    case 'geogebra':
      return {
        content: {
          plugin: {
            name: Plugin.Geogebra,
            version: '0.0.0'
          },
          state: {
            description: elem.description,
            src: elem.src
          }
        }
      }
    case 'image':
      return {
        content: {
          plugin: {
            name: Plugin.Image,
            version: '0.0.0'
          },
          state: {
            description: elem.description,
            title: elem.title,
            src: elem.src,
            href: (elem as LinkedImagesTMP).href
              ? (elem as LinkedImagesTMP).href
              : undefined
          }
        }
      }
  }
}

interface SplishDocumentIdentifier {
  type: '@splish-me/editor-core/editable'
  state: Splish
}

export interface SplishSpoilerState {
  title: string
  content: SplishDocumentIdentifier
}

export interface SplishTableState {
  src: string
}

export interface SplishBlockquoteState {
  child: SplishDocumentIdentifier
}

export interface SplishInjectionState {
  description: string
  src: string
}

export interface SplishGeogebraState {}

export interface SplishImageState {
  description: string
  src: string
  title: string
  href?: string
}

export interface SplishTextState {
  importFromHtml?: string
  editorState?: ValueJSON
}

export type SplishPluginState =
  | SplishSpoilerState
  | SplishTableState
  | SplishBlockquoteState
  | SplishInjectionState
  | SplishGeogebraState
  | SplishImageState
  | SplishTextState

export default createPlugins
