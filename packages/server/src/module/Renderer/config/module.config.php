<?php
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
namespace Renderer;

use Renderer\Factory\EditorRendererFactory;
use Renderer\Factory\EditorRendererHelperFactory;
use Renderer\Factory\LegacyEditorRendererFactory;
use Renderer\Factory\LegacyEditorRendererHelperFactory;
use Renderer\Factory\RendererStorageFactory;
use Renderer\View\Helper\LegacyFormatHelper;

return [
    'renderer' => [
      'cache_enabled' => true
    ],

    'service_manager' => [
        'factories' => [
            __NAMESPACE__ . '\Storage\RendererStorage' => RendererStorageFactory::class,
            __NAMESPACE__ . '\LegacyEditorRenderer' => LegacyEditorRendererFactory::class,
            __NAMESPACE__ . '\EditorRenderer' => EditorRendererFactory::class
        ],
    ],
    'view_helpers'    => [
        'factories' => [
            'legacyEditorRenderer' => LegacyEditorRendererHelperFactory::class,
            'editorRenderer' => EditorRendererHelperFactory::class
        ],
        'invokables' => [
            'isLegacyFormat' => LegacyFormatHelper::class
        ],
    ]
];
