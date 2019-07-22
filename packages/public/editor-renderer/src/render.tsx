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
import { stringifyState } from '@serlo/editor-helpers'
import {
  convert,
  Edtr,
  Legacy,
  Splish,
  isEdtr
} from '@serlo/legacy-editor-to-editor'
import * as React from 'react'
import { renderToString } from 'react-dom/server'
import { ServerStyleSheet, StyleSheetManager } from 'styled-components'
import { Editor } from '@serlo/edtr-io'

export async function render(input: string): Promise<string> {
  if (input === undefined) {
    throw new Error('No input given')
  }

  if (input === '') {
    return ''
  }

  let data: Legacy | Splish | Edtr
  try {
    data = JSON.parse(input.trim().replace(/&quot;/g, '"'))
  } catch (e) {
    throw new Error('No valid json string given')
  }

  const sheet = new ServerStyleSheet()
  const state = isEdtr(data) ? data : convert(data)

  try {
    const children = renderToString(
      <StyleSheetManager sheet={sheet.instance}>
        <div className="r">
          <div className="c24">
            <Editor initialState={state} editable={true} />
          </div>
        </div>
      </StyleSheetManager>
    )

    return wrapOutput(children)
  } catch (e) {
    return wrapOutput()
  }

  function wrapOutput(children = ''): string {
    return `${sheet.getStyleTags()}<div class="ory-content" data-raw-content='${stringifyState(
      state
    )}'>${children}</div>`
  }
}
