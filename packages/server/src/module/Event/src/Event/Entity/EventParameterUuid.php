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
namespace Event\Entity;

use Doctrine\ORM\Mapping as ORM;
use Instance\Entity\InstanceInterface;
use Instance\Entity\InstanceProviderInterface;
use Uuid\Entity\UuidInterface;

/**
 * @ORM\Entity
 * @ORM\Table(name="event_parameter_uuid")
 */
class EventParameterUuid implements InstanceProviderInterface
{
    /**
     * @ORM\Id
     * @ORM\Column(type="integer")
     * @ORM\GeneratedValue
     */
    protected $id;

    /**
     * @ORM\OneToOne(targetEntity="EventParameter", inversedBy="object")
     * @ORM\JoinColumn(name="event_parameter_id", referencedColumnName="id")
     */
    protected $eventParameter;

    /**
     * @ORM\ManyToOne(targetEntity="Uuid\Entity\Uuid")
     */
    protected $uuid;

    /**
     * @param EventParameterInterface $eventParameter
     * @param UuidInterface           $uuid
     */
    public function __construct(EventParameterInterface $eventParameter, UuidInterface $uuid)
    {
        $this->eventParameter = $eventParameter;
        $this->uuid           = $uuid;
    }

    /**
     * @return EventParameterInterface
     */
    public function getEventParameter()
    {
        return $this->eventParameter;
    }

    /**
     * @return int
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * @return InstanceInterface
     */
    public function getInstance()
    {
        return $this->eventParameter->getInstance();
    }

    /**
     * @return UuidInterface
     */
    public function getValue()
    {
        return $this->uuid;
    }
}
