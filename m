Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0592DE56A;
	Mon,  4 May 2026 06:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777875351; cv=none; b=IoDTghFZSzTVK/9Ay/aZlWD3SWOJfEuD6uz/p0kx9jZB1CKZyHBTN7OklQfJc/M7TQv1alPYXKLBj8K6ldPXMux15B8+HtajdQDoxsdlbgthUTtk1u6zI6KQGPRzgokQ7cwsA4WRciHVplm/vQnnI4KA+j1bdxke0Vp3U/KfycE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777875351; c=relaxed/simple;
	bh=bt+hPFYYNbZdxzCJfA44fBJlfQ7pJF3zNfqkgtBhs24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Sh2XtxOcH/g6ZvQjhtvwCpBYwZU/lqBfopBg0dfnIaKbZBdlIdvA9+wU03L5yc0eVxixlS+gUIGE2zZ3sCNQ9Gej3anMZKAz1z5wcwMGwJBIR/1z3doacIxPbMSmywycRVquItZgnNmkAztucdgiR+RVsPjweFRC+wBPC8E1C4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Opffhxl2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Opffhxl2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D0FC2BCC9;
	Mon,  4 May 2026 06:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777875350;
	bh=bt+hPFYYNbZdxzCJfA44fBJlfQ7pJF3zNfqkgtBhs24=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Opffhxl2bQ+IJWVpS/aE0X5zgH6cqkttNO8KSTmu/i4ra0s5HKfwaWkp8JKLUSKjr
	 tjOrg8YZ6qvMMOIblyiHGFIcUyGEjZfqRa4N7pHuT5SJp9HkC/fTrdeyQV3ct+5K56
	 fD2V2Po7DqchWnhN+NgqqE4V1sgtKGonlzfoyRgD9UzosuKrPZMbBat6B60ygX1a8r
	 SIfGIu9uIh2NJTYCZMHIT1c2YkBfi9/+yXQe/ei6XH8M//33Yi6cGBIzZ4eHz7eZ/8
	 uYpIDotXHBBr7O67jIb5+L+IHvn6PDRitk02+W+g2/xQpfeHvT3LadJsHOA9lzDkPx
	 i1hz24aU9Wj/Q==
Message-ID: <a196b98a-a4f7-4e97-9005-d8a9f5e4814b@kernel.org>
Date: Mon, 4 May 2026 08:15:46 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 001/311] drm/amd/pm: disable OD_FAN_CURVE if temp or
 pwm range invalid for smu v13
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Yang Wang <kevinyang.wang@amd.com>,
 Alex Deucher <alexander.deucher@amd.com>, Sasha Levin <sashal@kernel.org>
References: <20260408175939.393281918@linuxfoundation.org>
 <20260408175939.452810365@linuxfoundation.org>
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
In-Reply-To: <20260408175939.452810365@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08. 04. 26, 20:00, Greg Kroah-Hartman wrote:
> 6.19-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Yang Wang <kevinyang.wang@amd.com>
> 
> [ Upstream commit 3e6dd28a11083e83e11a284d99fcc9eb748c321c ]

This appears to break 6.19.12 wrt fan speed on Radeon Pro W7700:
https://bugzilla.suse.com/show_bug.cgi?id=1263854

7.0 is broken the same way.

They say:
> As mentioned in the summary, lact fails to control the fan speed on my
> AMD Radeon PRO W7700 graphic card. It worked perfectly until kernel
> 6.19.11 but failed after upgrading to kernel 6.19.12 and also fails
> with actual kernel 7.0.2.
> 
> I assume the problem is related to the following kernel commit to
> kernel 6.19.12:
> 
> commit 9b96266a2d469ca6576fd0a071a48e71a9436686
> Author: Yang Wang <kevinyang.wang@amd.com>
> Date:   Wed Apr 1 12:16:37 2026 -0400
> 
> Since kernel 6.19.12 the "gpu_od"-Folder under
> 
> /sys/class/drm/card1/device/
> 
> does no longer exist, so lactd fails to read/write data within that folder
> and beyond.
> 
> My problem is that the 'sensors' utility reports high memory temperatures on
> my W7700. Even when idle the memory stays above 75°C and and rises up to
> 102°C when watching an AV1-encoded movie.
> 
> The fan is now controlled solely by the Radeon firmware. The fan runs
> at ~600 rpm (30%) and does not speed up when the memory temperature
> approaches the critical value of 105°C.
> 
> The current situation, with temperatures running very high, is likely to
> have a negative impact on the graphics card's lifespan.
> 
> # sensors amdgpu-pci-e300
> amdgpu-pci-e300
> Adapter: PCI adapter
> vddgfx:      179.00 mV 
> fan1:         596 RPM  (min =    0 RPM, max = 5300 RPM)
> edge:         +63.0°C  (crit = +100.0°C, hyst = -273.1°C)
>                        (emerg = +105.0°C)
> junction:     +70.0°C  (crit = +105.0°C, hyst = -273.1°C)
>                        (emerg = +110.0°C)
> mem:          +84.0°C  (crit = +105.0°C, hyst = -273.1°C)  <=== idle+)
>                        (emerg = +110.0°C)
> PPT:          49.00 W  (cap = 150.00 W)
> pwm1:             38%
> sclk:          15 MHz 
> mclk:         772 MHz
> 
> +) i noticed that e.g. the firefox browser has a negative impact on the
> mlck value and the therefore the mem temperature.
> 
> The possibility to set the fan min to 900-1000 rpm with lact has helped
> to keep the temperatures below 65°C when idle and below 85°C when playing
> an AV1-encoded movie.


Any ideas?


> Forcibly disable the OD_FAN_CURVE feature when temperature or PWM range is invalid,
> otherwise PMFW will reject this configuration on smu v13.0.x
> 
> example:
> $ sudo cat /sys/bus/pci/devices/<BDF>/gpu_od/fan_ctrl/fan_curve
> 
> OD_FAN_CURVE:
> 0: 0C 0%
> 1: 0C 0%
> 2: 0C 0%
> 3: 0C 0%
> 4: 0C 0%
> OD_RANGE:
> FAN_CURVE(hotspot temp): 0C 0C
> FAN_CURVE(fan speed): 0% 0%
> 
> $ echo "0 50 40" | sudo tee fan_curve
> 
> kernel log:
> [  756.442527] amdgpu 0000:03:00.0: amdgpu: Fan curve temp setting(50) must be within [0, 0]!
> [  777.345800] amdgpu 0000:03:00.0: amdgpu: Fan curve temp setting(50) must be within [0, 0]!
> 
> Closes: https://github.com/ROCm/amdgpu/issues/208
> Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
> Acked-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> (cherry picked from commit 470891606c5a97b1d0d937e0aa67a3bed9fcb056)
> Cc: stable@vger.kernel.org
> [ adapted forward declaration placement to existing FEATURE_MASK macro ]
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

thanks,
-- 
js
suse labs

