Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664E630B533;
	Tue, 14 Oct 2025 06:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760421883; cv=none; b=p8GhEFif6luwH+L/ikB1bJ183R8e72A8AMd8DeZYyIUjMw/PMtcXmji7skbfcJerS+wqNcJGdlyCjCtNKcFXTHS6wLKeNHKF0C2kepRcQjk44fum37kxembXPTH5NTDw+EM5OcbdWstUkOSRVVYHXinmZfkja7pOiWBblt/9oj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760421883; c=relaxed/simple;
	bh=flgK7qyz4pCTqFnbE9QQGTq97hEQ7NB77Po4NMF21KQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cto8uMnXRWP4gp/qQQTb6UgUSww18F8R6/3psisEsgDU/ugI8mS12pLVzVZvcni2/a3Bxe6/ij9ytmlIBs4QjutbljttbEjY4I98xQGjLBS2oEoYNr5nA7w+8vH4iu3g394BigENVCnuEi1UGHTBVRNna0p7pqwxZKIsgn0qz6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VAwLEoOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VAwLEoOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAE8C4CEF1;
	Tue, 14 Oct 2025 06:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760421883;
	bh=flgK7qyz4pCTqFnbE9QQGTq97hEQ7NB77Po4NMF21KQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VAwLEoOf2MjY9OprnuYPcac/cw2vwRGeM/WMpYqfx3eRHx/VB6lNHGEQ2DdoDy2B8
	 sO+F5zPN4JhSbanZm4b8GQahK9XbLmISb8tl0jRxSrhlJ1vNg/zxXcU9iUFC/fUXfZ
	 2GetTRpL0XMJknX0PG+uBtqSulvhHNQzmieHR3DXA2DMR4lRAI28F+i5V0YL3f8FEh
	 yjhT3t0r7FDzWc2BiUnfjQm684pW0N+f10R1HeXwgpwDzYIHwVq3MboFV5/L7ejxA4
	 n8pVp5SisPJHfJjUFsTq9N+Qb3NCrxZbobsdq8cl29xS5Lh78/g2djDg191F4J85zk
	 U/ADmNu7vUVow==
Message-ID: <84f47a51-ddcb-4b0f-ae08-53491b49ce61@kernel.org>
Date: Tue, 14 Oct 2025 08:04:39 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 230/563] drm/amdgpu: fix incorrect vm flags to map bo
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Jack Xiao <Jack.Xiao@amd.com>,
 Likun Gao <Likun.Gao@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 Sasha Levin <sashal@kernel.org>
References: <20251013144411.274874080@linuxfoundation.org>
 <20251013144419.612649904@linuxfoundation.org>
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
In-Reply-To: <20251013144419.612649904@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13. 10. 25, 16:41, Greg Kroah-Hartman wrote:
> 6.17-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jack Xiao <Jack.Xiao@amd.com>
> 
> [ Upstream commit b08425fa77ad2f305fe57a33dceb456be03b653f ]
> 
> It should use vm flags instead of pte flags
> to specify bo vm attributes.

Note this was reverted by:
commit be33e8a239aac204d7e9e673c4220ef244eb1ba3
Author: Alex Deucher <alexander.deucher@amd.com>
Date:   Mon Aug 25 13:40:22 2025 -0400

     Revert "drm/amdgpu: fix incorrect vm flags to map bo"

     This reverts commit b08425fa77ad2f305fe57a33dceb456be03b653f.

     Revert this to align with 6.17 because the fixes tag
     was wrong on this commit.


> Fixes: 7946340fa389 ("drm/amdgpu: Move csa related code to separate file")
> Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
> Reviewed-by: Likun Gao <Likun.Gao@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
> index 02138aa557935..dfb6cfd837606 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_csa.c
> @@ -88,8 +88,8 @@ int amdgpu_map_static_csa(struct amdgpu_device *adev, struct amdgpu_vm *vm,
>   	}
>   
>   	r = amdgpu_vm_bo_map(adev, *bo_va, csa_addr, 0, size,
> -			     AMDGPU_PTE_READABLE | AMDGPU_PTE_WRITEABLE |
> -			     AMDGPU_PTE_EXECUTABLE);
> +			     AMDGPU_VM_PAGE_READABLE | AMDGPU_VM_PAGE_WRITEABLE |
> +			     AMDGPU_VM_PAGE_EXECUTABLE);
>   
>   	if (r) {
>   		DRM_ERROR("failed to do bo_map on static CSA, err=%d\n", r);

-- 
js
suse labs

