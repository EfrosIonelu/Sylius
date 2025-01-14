<?php

/*
 * This file is part of the Sylius package.
 *
 * (c) Sylius Sp. z o.o.
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

declare(strict_types=1);

namespace Sylius\Bundle\ApiBundle\Serializer;

use Sylius\Bundle\ApiBundle\Serializer\Exception\InvalidAmountTypeException;
use Sylius\Component\Taxation\Model\TaxRateInterface;
use Symfony\Component\Serializer\Normalizer\ContextAwareDenormalizerInterface;
use Symfony\Component\Serializer\Normalizer\DenormalizerAwareInterface;
use Symfony\Component\Serializer\Normalizer\DenormalizerAwareTrait;

/** @experimental */
final class TaxRateDenormalizer implements ContextAwareDenormalizerInterface, DenormalizerAwareInterface
{
    use DenormalizerAwareTrait;

    private const ALREADY_CALLED = 'sylius_tax_rate_denormalizer_already_called';

    public function supportsDenormalization(mixed $data, string $type, string $format = null, array $context = []): bool
    {
        return
            !isset($context[self::ALREADY_CALLED]) &&
            is_array($data) &&
            isset($data['amount']) &&
            is_a($type, TaxRateInterface::class, true)
        ;
    }

    public function denormalize(mixed $data, string $type, string $format = null, array $context = [])
    {
        $context[self::ALREADY_CALLED] = true;

        $data = (array) $data;

        if (!is_numeric($data['amount'])) {
            throw new InvalidAmountTypeException();
        }

        $data['amount'] = (string) $data['amount'];

        return $this->denormalizer->denormalize($data, $type, $format, $context);
    }
}
