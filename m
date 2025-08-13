Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055EB2C15B5;
	Wed, 13 Aug 2025 06:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755066974; cv=none; b=IEQYL2zeg98F93wVpohmO9aNuKazPx8dgVmtt+MT2Af4Vm6+rHQ+BxXDaCeTMYgquKsWkmNcRYymy6/zvq68OLJoKtftmPyUJXU85WQkd9jNvKNG6hOF25cA9s5HsbPDR1a1nuFeHq4YvBrv5fXBEM2uCGoD1zS3YPqxSCDVYhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755066974; c=relaxed/simple;
	bh=XN/VFV6owpNhSeqhRPxjfBSPh30QuCdMXbPYfHCJCtI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Gm9yrly3IXVGmiGrR0qtZbsRJ47yV4NrM0lk3B5evfSuZm1G4emjLXxbmBQ4u+RKQUf0iDuxXU/mhZVa+unpU+qycBCU/mCN5n9HQbGLUKFbZRI8IIA3z9QahiXKOlt6seH1B6ZkyKqsTP5lIeNU0JwNEqricrK1tmWQAC6xjG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A9dcMyMP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A9dcMyMP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F76C4CEEB;
	Wed, 13 Aug 2025 06:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755066973;
	bh=XN/VFV6owpNhSeqhRPxjfBSPh30QuCdMXbPYfHCJCtI=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=A9dcMyMPRWPu6+6zYdeuZiSnciJ7BOdpQKzfsqEZ45eR7z6Jlges2D3lFMH0Y9HZO
	 BUC26Jp3+6vOLibDO1nR0TxgO0yHa1zcrG14neP0mBTrVrhqzUJs+cpPZIWNZvMDX5
	 dnd5mwnNctYitl8qU/EaYVO4HDNAXnFDKcBNF2sHgEe6vUE3amXP863iCWEe5q3OjL
	 Zsbd00QmOv8lNOLyBe1t4Np9+fZHVIEXMAXBk6NE8KiEO0Q0eBHtOWaM4xuI+vFZT0
	 DaVBu4LHCD2ZHQA3h8xyLhCcid2iUxzA6UB9PGnA2TsS1omAovbr5PHvO/fTd82Usq
	 75lf/cfuVO/5g==
Message-ID: <ca432b9e-e016-4d2d-b137-79def0aaca85@kernel.org>
Date: Wed, 13 Aug 2025 08:36:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 028/627] erofs: fix build error with
 CONFIG_EROFS_FS_ZIP_ACCEL=y
From: Jiri Slaby <jirislaby@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
 "Bo Liu (OpenAnolis)" <liubo03@inspur.com>,
 Gao Xiang <hsiangkao@linux.alibaba.com>, Sasha Levin <sashal@kernel.org>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173420.398660113@linuxfoundation.org>
 <d0af351b-715c-4f32-b33a-77d2459c2932@kernel.org>
Content-Language: en-US
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
In-Reply-To: <d0af351b-715c-4f32-b33a-77d2459c2932@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 13. 08. 25, 8:32, Jiri Slaby wrote:
> On 12. 08. 25, 19:25, Greg Kroah-Hartman wrote:
>> 6.16-stable review patch.  If anyone has any objections, please let me 
>> know.
>>
>> ------------------
>>
>> From: Bo Liu (OpenAnolis) <liubo03@inspur.com>
>>
>> [ Upstream commit 5e0bf36fd156b8d9b09f8481ee6daa6cdba1b064 ]
>>
>> fix build err:
>>   ld.lld: error: undefined symbol: crypto_req_done
>>     referenced by decompressor_crypto.c
>>         fs/erofs/decompressor_crypto.o:(z_erofs_crypto_decompress) in 
>> archive vmlinux.a
>>     referenced by decompressor_crypto.c
>>         fs/erofs/decompressor_crypto.o:(z_erofs_crypto_decompress) in 
>> archive vmlinux.a
>>
>>   ld.lld: error: undefined symbol: crypto_acomp_decompress
>>     referenced by decompressor_crypto.c
>>         fs/erofs/decompressor_crypto.o:(z_erofs_crypto_decompress) in 
>> archive vmlinux.a
>>
>>   ld.lld: error: undefined symbol: crypto_alloc_acomp
>>     referenced by decompressor_crypto.c
>>         fs/erofs/decompressor_crypto.o:(z_erofs_crypto_enable_engine) 
>> in archive vmlinux.a
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202507161032.QholMPtn- 
>> lkp@intel.com/
>> Fixes: b4a29efc5146 ("erofs: support DEFLATE decompression by using 
>> Intel QAT")
>> Signed-off-by: Bo Liu (OpenAnolis) <liubo03@inspur.com>
>> Link: https://lore.kernel.org/r/20250718033039.3609-1-liubo03@inspur.com
>> Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
>> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>   fs/erofs/Kconfig | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/erofs/Kconfig b/fs/erofs/Kconfig
>> index 6beeb7063871..7b26efc271ee 100644
>> --- a/fs/erofs/Kconfig
>> +++ b/fs/erofs/Kconfig
>> @@ -147,6 +147,8 @@ config EROFS_FS_ZIP_ZSTD
>>   config EROFS_FS_ZIP_ACCEL
>>       bool "EROFS hardware decompression support"
>>       depends on EROFS_FS_ZIP
>> +    select CRYPTO
>> +    select CRYPTO_DEFLATE
> 
> This is not correct as it forces CRYPTO=y and CRYPTO_DEFLATE=y even if 
> EROFS=m.
> 
> The upstream is bad, not only this stable patch.

-next is fixed by:

commit 8f11edd645782b767ea1fc845adc30e057f25184
Author: Geert Uytterhoeven <geert+renesas@glider.be>
Date:   Wed Jul 30 14:44:49 2025 +0200

     erofs: Do not select tristate symbols from bool symbols

I suggest postponing this patch until the above is merged and picked too...

> 
>>       help
>>         Saying Y here includes hardware accelerator support for reading
>>         EROFS file systems containing compressed data.  It gives better
> 

-- 
js
suse labs

