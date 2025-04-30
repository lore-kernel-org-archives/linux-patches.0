Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47C01E32C3;
	Wed, 30 Apr 2025 07:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745998876; cv=none; b=bPmTfa+ym+k6QwVxY4kBzksBLXiVrB0wF0UZY3Pk+Y4AzmyQ6UqVkTEOmlOmd2pTAqIuDDSNtu9JTP0YZej0y4EaRafcksa4FPXuHyteFQ7E7bwBBKf5pGFeaftKOepg+QcJeYA0hRwB85IcFgOg1qg0P5dy3vCpvyc7PkwD7Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745998876; c=relaxed/simple;
	bh=qOQ62V4AVicOTGuIMPRGDkeOIsulwOfC+LjZabxPgIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oKwWLCezeNiaYSXhDrYp584x0zZTSl7wsNj7H/dcPjHwf7GoasU8lYLtXUN15ClJ4s5EWWP8kRUo6Wk7Th+ZFxJrLftAva45vc3im81DCFhz7WuHbjRlJ7GwmXyw27hbP+Fis0hIOjzF7vSoK/jQbx4JE5p66X/d0gGvb4CPX98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L+bZvMt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L+bZvMt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C452EC4CEEA;
	Wed, 30 Apr 2025 07:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745998875;
	bh=qOQ62V4AVicOTGuIMPRGDkeOIsulwOfC+LjZabxPgIo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=L+bZvMt6wq1HOwxknicdPh2CnMbl7Xt9Aagmhgn/or1vl4hqGZYgArPZPvB+/P4Tz
	 fLA3ynO20GTgZTY54G2DUWeSipWjO1AK7BOE5B0IG2KtBO/d1mjt4FACVZVTdj2KmJ
	 cCJzGeP0pd4IG4mU8ROLU6lcX/M/ZWfPoRXkpRnR0+dp2s9zBUHJjnMpln1RFs+d/m
	 NNaq7DMUTdpyRkD3moR73zMKXOJJWteTuj5wlQ/xnKPkw6XRJ4esh9cUC/RYjvuCPN
	 VkYbtj3zrOnFgNcAHkrFndLbIkzU3OabD+UDbm2gm2MHTV2+eMo8+Wp1yYeCws+J0Z
	 IGIAiXzdtLY9Q==
Message-ID: <c8aba766-7245-486b-a826-a4af74072bed@kernel.org>
Date: Wed, 30 Apr 2025 09:41:12 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 019/311] s390/pci: Support mmap() of PCI resources
 except for ISM devices
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Niklas Schnelle <schnelle@linux.ibm.com>,
 Bjorn Helgaas <bhelgaas@google.com>, Sasha Levin <sashal@kernel.org>
References: <20250429161121.011111832@linuxfoundation.org>
 <20250429161121.820299536@linuxfoundation.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 xsFNBE6S54YBEACzzjLwDUbU5elY4GTg/NdotjA0jyyJtYI86wdKraekbNE0bC4zV+ryvH4j
 rrcDwGs6tFVrAHvdHeIdI07s1iIx5R/ndcHwt4fvI8CL5PzPmn5J+h0WERR5rFprRh6axhOk
 rSD5CwQl19fm4AJCS6A9GJtOoiLpWn2/IbogPc71jQVrupZYYx51rAaHZ0D2KYK/uhfc6neJ
 i0WqPlbtIlIrpvWxckucNu6ZwXjFY0f3qIRg3Vqh5QxPkojGsq9tXVFVLEkSVz6FoqCHrUTx
 wr+aw6qqQVgvT/McQtsI0S66uIkQjzPUrgAEtWUv76rM4ekqL9stHyvTGw0Fjsualwb0Gwdx
 ReTZzMgheAyoy/umIOKrSEpWouVoBt5FFSZUyjuDdlPPYyPav+hpI6ggmCTld3u2hyiHji2H
 cDpcLM2LMhlHBipu80s9anNeZhCANDhbC5E+NZmuwgzHBcan8WC7xsPXPaiZSIm7TKaVoOcL
 9tE5aN3jQmIlrT7ZUX52Ff/hSdx/JKDP3YMNtt4B0cH6ejIjtqTd+Ge8sSttsnNM0CQUkXps
 w98jwz+Lxw/bKMr3NSnnFpUZaxwji3BC9vYyxKMAwNelBCHEgS/OAa3EJoTfuYOK6wT6nadm
 YqYjwYbZE5V/SwzMbpWu7Jwlvuwyfo5mh7w5iMfnZE+vHFwp/wARAQABzSFKaXJpIFNsYWJ5
 IDxqaXJpc2xhYnlAa2VybmVsLm9yZz7CwXcEEwEIACEFAlW3RUwCGwMFCwkIBwIGFQgJCgsC
 BBYCAwECHgECF4AACgkQvSWxBAa0cEnVTg//TQpdIAr8Tn0VAeUjdVIH9XCFw+cPSU+zMSCH
 eCZoA/N6gitEcnvHoFVVM7b3hK2HgoFUNbmYC0RdcSc80pOF5gCnACSP9XWHGWzeKCARRcQR
 4s5YD8I4VV5hqXcKo2DFAtIOVbHDW+0okOzcecdasCakUTr7s2fXz97uuoc2gIBB7bmHUGAH
 XQXHvdnCLjDjR+eJN+zrtbqZKYSfj89s/ZHn5Slug6w8qOPT1sVNGG+eWPlc5s7XYhT9z66E
 l5C0rG35JE4PhC+tl7BaE5IwjJlBMHf/cMJxNHAYoQ1hWQCKOfMDQ6bsEr++kGUCbHkrEFwD
 UVA72iLnnnlZCMevwE4hc0zVhseWhPc/KMYObU1sDGqaCesRLkE3tiE7X2cikmj/qH0CoMWe
 gjnwnQ2qVJcaPSzJ4QITvchEQ+tbuVAyvn9H+9MkdT7b7b2OaqYsUP8rn/2k1Td5zknUz7iF
 oJ0Z9wPTl6tDfF8phaMIPISYrhceVOIoL+rWfaikhBulZTIT5ihieY9nQOw6vhOfWkYvv0Dl
 o4GRnb2ybPQpfEs7WtetOsUgiUbfljTgILFw3CsPW8JESOGQc0Pv8ieznIighqPPFz9g+zSu
 Ss/rpcsqag5n9rQp/H3WW5zKUpeYcKGaPDp/vSUovMcjp8USIhzBBrmI7UWAtuedG9prjqfO
 wU0ETpLnhgEQAM+cDWLL+Wvc9cLhA2OXZ/gMmu7NbYKjfth1UyOuBd5emIO+d4RfFM02XFTI
 t4MxwhAryhsKQQcA4iQNldkbyeviYrPKWjLTjRXT5cD2lpWzr+Jx7mX7InV5JOz1Qq+P+nJW
 YIBjUKhI03ux89p58CYil24Zpyn2F5cX7U+inY8lJIBwLPBnc9Z0An/DVnUOD+0wIcYVnZAK
 DiIXODkGqTg3fhZwbbi+KAhtHPFM2fGw2VTUf62IHzV+eBSnamzPOBc1XsJYKRo3FHNeLuS8
 f4wUe7bWb9O66PPFK/RkeqNX6akkFBf9VfrZ1rTEKAyJ2uqf1EI1olYnENk4+00IBa+BavGQ
 8UW9dGW3nbPrfuOV5UUvbnsSQwj67pSdrBQqilr5N/5H9z7VCDQ0dhuJNtvDSlTf2iUFBqgk
 3smln31PUYiVPrMP0V4ja0i9qtO/TB01rTfTyXTRtqz53qO5dGsYiliJO5aUmh8swVpotgK4
 /57h3zGsaXO9PGgnnAdqeKVITaFTLY1ISg+Ptb4KoliiOjrBMmQUSJVtkUXMrCMCeuPDGHo7
 39Xc75lcHlGuM3yEB//htKjyprbLeLf1y4xPyTeeF5zg/0ztRZNKZicgEmxyUNBHHnBKHQxz
 1j+mzH0HjZZtXjGu2KLJ18G07q0fpz2ZPk2D53Ww39VNI/J9ABEBAAHCwV8EGAECAAkFAk6S
 54YCGwwACgkQvSWxBAa0cEk3tRAAgO+DFpbyIa4RlnfpcW17AfnpZi9VR5+zr496n2jH/1ld
 wRO/S+QNSA8qdABqMb9WI4BNaoANgcg0AS429Mq0taaWKkAjkkGAT7mD1Q5PiLr06Y/+Kzdr
 90eUVneqM2TUQQbK+Kh7JwmGVrRGNqQrDk+gRNvKnGwFNeTkTKtJ0P8jYd7P1gZb9Fwj9YLx
 jhn/sVIhNmEBLBoI7PL+9fbILqJPHgAwW35rpnq4f/EYTykbk1sa13Tav6btJ+4QOgbcezWI
 wZ5w/JVfEJW9JXp3BFAVzRQ5nVrrLDAJZ8Y5ioWcm99JtSIIxXxt9FJaGc1Bgsi5K/+dyTKL
 wLMJgiBzbVx8G+fCJJ9YtlNOPWhbKPlrQ8+AY52Aagi9WNhe6XfJdh5g6ptiOILm330mkR4g
 W6nEgZVyIyTq3ekOuruftWL99qpP5zi+eNrMmLRQx9iecDNgFr342R9bTDlb1TLuRb+/tJ98
 f/bIWIr0cqQmqQ33FgRhrG1+Xml6UXyJ2jExmlO8JljuOGeXYh6ZkIEyzqzffzBLXZCujlYQ
 DFXpyMNVJ2ZwPmX2mWEoYuaBU0JN7wM+/zWgOf2zRwhEuD3A2cO2PxoiIfyUEfB9SSmffaK/
 S4xXoB6wvGENZ85Hg37C7WDNdaAt6Xh2uQIly5grkgvWppkNy4ZHxE+jeNsU7tg=
In-Reply-To: <20250429161121.820299536@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29. 04. 25, 18:37, Greg Kroah-Hartman wrote:
> 6.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Niklas Schnelle <schnelle@linux.ibm.com>
> 
> [ Upstream commit aa9f168d55dc47c0de564f7dfe0e90467c9fee71 ]
...
> +static void zpci_ism_bar_no_mmap(struct pci_dev *pdev)
> +{
> +	/*
> +	 * ISM's BAR is special. Drivers written for ISM know
> +	 * how to handle this but others need to be aware of their
> +	 * special nature e.g. to prevent attempts to mmap() it.
> +	 */
> +	pdev->non_mappable_bars = 1;

I see:
arch/s390/pci/pci_fixup.c: In function 'zpci_ism_bar_no_mmap':
arch/s390/pci/pci_fixup.c:19:13: error: 'struct pci_dev' has no member 
named 'non_mappable_bars'
    19 |         pdev->non_mappable_bars = 1;
       |             ^~





The above needs at least:
commit 888bd8322dfc325dc5ad99184baba4e1fd91082d
Author: Niklas Schnelle <schnelle@linux.ibm.com>
Date:   Wed Feb 26 13:07:46 2025 +0100

     s390/pci: Introduce pdev->non_mappable_bars and replace VFIO_PCI_MMAP

thanks,
-- 
js
suse labs

