Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795677532;
	b=T5dUXUaNXc+U2dPtIMRxdrRakizPksJMzx9NvpMiKmGzOMZjisd6N2285pyFXMdjIa5C
	 xA9FpspF1WC4iZUg5nZxR9CE5aLuzj8tml5hMSj9RMWdVXSke6JmKZqefOTylBePnvDEt
	 ry8h/6XKYNyTPsyzY3OMKQXJ82HW5wQoD7EkuHUI5sGforJhU4uSBwgeiLpqwHZJhdHNc
	 RWXAfIOmJYOQzpcwzsph2TsSgScI3hPNGJqvZbL3qNG2pPXtMHrj28+NrNzFl02sBCvuO
	 qBDEEEBmkgpFoSWsbwD7ANZ3tj/7IDH+Q9qv4/9s+WIqjejA20lrcvLPBMSKurDhNfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795677532;
	h=Received:DKIM-Signature:Content-Type:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To;
	bh=4xTlEr7IrVqZkWQ3qKf4ATv3NinDByy4Fotyedx2UKc=;
	b=mr07a4KjmDPfGzINoHnc4ecRQfv83G4NjFX6d2wifSDJEoBOem2pSk6Da2S6mq7umoo6
	 SuZgqzXDoVB9nIa8rA1jEGvvKC54zchh5uB+ROY8CR61Q7xHShvY1eYjSimx+HymDAt1T
	 hUij8Isnm2nsENegGVVnxhdE89Ft5+bZwbpvIHV7LFa5gwknVsdI1Ld3I3ZdpgQxgSzY4
	 CE3jLAynHduFjEaNiB1dmULLBFtBRjNKkM8lqTb9cXk/D6fdpDYw+WXWug6z04TCBHBAh
	 vIzZhp8DVXdaviAlm0UEMqE3EWY8oZVvvF/Ky7NEL5I5dhRGpfgpZ3uQBPJZZDPe8lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="YikK1t/B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F95606A31C;
	Thu, 26 Nov 2026 07:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YikK1t/B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585621F000C4;
	Thu, 26 Nov 2026 07:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795677532;
	bh=4xTlEr7IrVqZkWQ3qKf4ATv3NinDByy4Fotyedx2UKc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YikK1t/B2Pjh8snomrGjPU2mTyaN/gUlgg/Wii3Qylst/BYwUYWVv6FWoB9W6GYBL
	 7SBrvLRey89E3LhfLNZyDZFXTFzA9ZfDg5JOmvZvMl1IOwDG4OnPpeoxDlK7XO+yKV
	 alezfsx0dwXhksE/7ySnb/Wn4mZkCEb3+I4vHJIRLWEfPd6GUeG8fbDqfBO3pImzbY
	 H8VpMWBiLc/aKfeNH3hlPnM8mpIq+NLDDYYJsWZ3W92ZJzjx4alnResoLpfGrSYy/x
	 dD5ZvC4tcan58F233hJxnu8nrO7qlMPwCv/1zIIiBqiXP2kJobKfjA5l7yEucOLv+y
	 aBzEpuD50YdWw==
Content-Type: multipart/mixed; boundary="------------zE9qbDXoP0z0nuYd1DObj9DS"
Message-ID: <912422fe-72c8-498b-a210-e8c385840674@kernel.org>
Date: Thu, 26 Nov 2026 08:18:48 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.3 0395/1005] drm/xe: Fix build with DRM_XE=y and
 CONFIGFS_FS=m
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
 Matt Roper <matthew.d.roper@intel.com>, Rodrigo Vivi
 <rodrigo.vivi@intel.com>, Matthew Brost <matthew.brost@intel.com>,
 Dave Airlie <airlied@redhat.com>, Sasha Levin <sashal@kernel.org>
References: <20261125143821.729802100@linuxfoundation.org>
 <20261125143830.996724307@linuxfoundation.org>
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
In-Reply-To: <20261125143830.996724307@linuxfoundation.org>

This is a multi-part message in MIME format.
--------------zE9qbDXoP0z0nuYd1DObj9DS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25. 11. 26, 15:28, Greg Kroah-Hartman wrote:
> 7.3-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Rodrigo Vivi <rodrigo.vivi@intel.com>
> 
> [ Upstream commit da475c094342b6d5c8bc020b19d6900130bed047 ]

This has a later (proper) fix to actually "select CONFIGFS_FS":
c1234293de14 ("drm: xe: select configfs")

It needs a context update (xe_configfs_get_migrate_ulls_period_ms and 
xe_configfs_get_disable_vram_page_offline do not exist in 7.3 yet), 
though -- a 7.3 backport attached.

> When xe is built-in but configfs is a module, xe_configfs.o is not
> linked into xe, while IS_ENABLED(CONFIG_CONFIGFS_FS) in xe_configfs.h
> still exposes the real declarations, leading to undefined references.
> 
> Use IS_REACHABLE() so this case falls back to the stubs, the same as
> CONFIGFS_FS=n.
> 
> Fixes: 16280ded45fb ("drm/xe: Add configfs to enable survivability mode")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202610160935.Qk4ZxBxY-lkp@intel.com/
> Closes: https://lore.kernel.org/oe-kbuild-all/202610162335.FEwMdGY9-lkp@intel.com/
> Suggested-by: Matt Roper <matthew.d.roper@intel.com>
> Assisted-by: LLM
> Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
> Link: https://patch.msgid.link/20261021194555.2171344-2-rodrigo.vivi@intel.com
> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> (cherry picked from commit 30499cbd796117b63be3b59a1781c25ea3f4b27f)
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/gpu/drm/xe/xe_configfs.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/xe/xe_configfs.h b/drivers/gpu/drm/xe/xe_configfs.h
> index 4fbbeafba4734..65b15b7483e1b 100644
> --- a/drivers/gpu/drm/xe/xe_configfs.h
> +++ b/drivers/gpu/drm/xe/xe_configfs.h
> @@ -14,7 +14,7 @@
>   
>   struct pci_dev;
>   
> -#if IS_ENABLED(CONFIG_CONFIGFS_FS)
> +#if IS_REACHABLE(CONFIG_CONFIGFS_FS)
>   int xe_configfs_init(void);
>   void xe_configfs_exit(void);
>   void xe_configfs_check_device(struct pci_dev *pdev);

-- 
js
suse labs

--------------zE9qbDXoP0z0nuYd1DObj9DS
Content-Type: text/x-patch; charset=UTF-8; name="drm-xe-select-configfs.patch"
Content-Disposition: attachment; filename="drm-xe-select-configfs.patch"
Content-Transfer-Encoding: base64

RnJvbTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4KRGF0ZTogTW9uLCAyNiBPY3Qg
MjAyNiAxMToyNTo1MCArMDEwMApTdWJqZWN0OiBkcm06IHhlOiBzZWxlY3QgY29uZmlnZnMK
R2l0LWNvbW1pdDogYzEyMzQyOTNkZTE0Nzk0OWJmOWNmMDZlM2VkNTlhZDg3NjZlMjlhMApQ
YXRjaC1tYWlubGluZTogdjcuNC1yYzMKUmVmZXJlbmNlczogZ2l0LWZpeGVzCgpUaGUgb3Jp
Z2luYWwgYWRkaXRpb24gb2YgY29uZmlnZnMgdG8geGUgbWlzc2VkIGEgY29tcGlsZS10aW1l
IGRlcGVuZGVuY3ksCndoaWNoIGxlYWRzIHRvIGEgbGluayBmYWlsdXJlIHdoZW4gY29uZmln
ZnMgaXMgZW5hYmxlZCBhcyBhIGxvYWRhYmxlIG1vZHVsZToKCmxkLmxsZC0yMTogZXJyb3I6
IHVuZGVmaW5lZCBzeW1ib2w6IHhlX2NvbmZpZ2ZzX2dldF9zdXJ2aXZhYmlsaXR5X21vZGUK
Pj4+IHJlZmVyZW5jZWQgYnkgeGVfc3Vydml2YWJpbGl0eV9tb2RlLmM6MjI0Cj4+PiAgICAg
ICAgICAgICAgIGRyaXZlcnMvZ3B1L2RybS94ZS94ZV9zdXJ2aXZhYmlsaXR5X21vZGUubzoo
eGVfc3Vydml2YWJpbGl0eV9tb2RlX2lzX3JlcXVlc3RlZCkgaW4gYXJjaGl2ZSB2bWxpbnV4
LmEKCkEgcmVjZW50IHdvcmthcm91bmQgYWRkZWQgYSAnSVNfUkVBQ0hBQkxFKCknIGNoZWNr
IGFyb3VuZCB0aGUgY2FsbHMgaW50bwpjb25maWdmcywgd2hpY2ggbWFrZXMgaXQgbGluayBp
biB0aGlzIGNvbmZpZ3VyYXRpb24sIGJ1dCB0aGlzIGlzIGdlbmVyYWxseQphIGJhZCBpZGVh
IGJlY2F1c2UgaXQgbWFrZXMgdGhlIGFjdHVhbCBiZWhhdmlvciBpbmNvbnNpc3RlbnQgYW5k
IGNvbmZ1c2luZwp0byB1c2VycyB0aGF0IGV4cGVjdCBjb25maWdmcyB0byB3b3JrIGlmIGJv
dGggeGUgYW5kIGNvbmZpZ2ZzIGFyZSBlbmFibGVkLgoKVXNlICdzZWxlY3QgQ09ORklHRlNf
RlMnIGluc3RlYWQsIGxpa2UgZXZlcnkgb3RoZXIgY29uZmlnZnMgdXNlciBkb2VzLAphbmQg
cmVtb3ZlIHRoZSB1bm5lY2Vzc2FyeSBzdHViIGZ1bmN0aW9ucy4gVGhlcmUgaXMgbGl0dGxl
IHByYWN0aWNhbApkaWZmZXJlbmNlIGhlcmUgYXMgYW55b25lIHVzaW5nIFhFIGdyYXBoaWNz
IGlzIGxpa2VseSB0byBoYXZlIGEgY29tcGxleApjb25maWd1cmF0aW9uIHRoYXQgYWxyZWFk
eSBzZWxlY3RzIGNvbmZpZ2ZzIGFueXdheSwgYW5kIHRoZSBsaW5rIGVycm9yCm9yIHRoZSBJ
U19SRUFDSEFCTEUoKSB3b3VsZCBvbmx5IG1hbmlmZXN0IGR1cmluZyByYW5kY29uZmlnIHRl
c3RpbmcuCgpGaXhlczogZGE0NzVjMDk0MzQyICgiZHJtL3hlOiBGaXggYnVpbGQgd2l0aCBE
Uk1fWEU9eSBhbmQgQ09ORklHRlNfRlM9bSIpCkZpeGVzOiAxNjI4MGRlZDQ1ZmIgKCJkcm0v
eGU6IEFkZCBjb25maWdmcyB0byBlbmFibGUgc3Vydml2YWJpbGl0eSBtb2RlIikKU2lnbmVk
LW9mZi1ieTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4KTGluazogaHR0cHM6Ly9w
YXRjaC5tc2dpZC5saW5rLzIwMjYxMDI2MTAyNjAzLjIwNDU0OTMtMS1hcm5kQGtlcm5lbC5v
cmcKU2lnbmVkLW9mZi1ieTogUm9kcmlnbyBWaXZpIDxyb2RyaWdvLnZpdmlAaW50ZWwuY29t
PgooY2hlcnJ5IHBpY2tlZCBmcm9tIGNvbW1pdCBiZTczMzM5ZGQ5ZDcwNjIzYjdkYmM5YzRl
M2I5NjY4MjRiNzcxMDY5KQpTaWduZWQtb2ZmLWJ5OiBNYXR0aGV3IEJyb3N0IDxtYXR0aGV3
LmJyb3N0QGludGVsLmNvbT4KQWNrZWQtYnk6IEppcmkgU2xhYnkgPGpzbGFieUBzdXNlLmN6
PgotLS0KIGRyaXZlcnMvZ3B1L2RybS94ZS9LY29uZmlnICAgICAgIHwgICAgMSArCiBkcml2
ZXJzL2dwdS9kcm0veGUveGVfY29uZmlnZnMuaCB8ICAgMjggLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMjggZGVsZXRp
b25zKC0pCgotLS0gYS9kcml2ZXJzL2dwdS9kcm0veGUvS2NvbmZpZworKysgYi9kcml2ZXJz
L2dwdS9kcm0veGUvS2NvbmZpZwpAQCAtMTEsNiArMTEsNyBAQCBjb25maWcgRFJNX1hFCiAJ
IyB0aGUgc2htZW1fcmVhZHBhZ2UoKSB3aGljaCBkZXBlbmRzIHVwb24gdG1wZnMKIAlzZWxl
Y3QgU0hNRU0KIAlzZWxlY3QgVE1QRlMKKwlzZWxlY3QgQ09ORklHRlNfRlMKIAlzZWxlY3Qg
RFJNX0JVRERZCiAJc2VsZWN0IERSTV9DTElFTlRfU0VMRUNUSU9OCiAJc2VsZWN0IERSTV9L
TVNfSEVMUEVSCi0tLSBhL2RyaXZlcnMvZ3B1L2RybS94ZS94ZV9jb25maWdmcy5oCisrKyBi
L2RyaXZlcnMvZ3B1L2RybS94ZS94ZV9jb25maWdmcy5oCkBAIC0xNCw3ICsxNCw2IEBACiAK
IHN0cnVjdCBwY2lfZGV2OwogCi0jaWYgSVNfUkVBQ0hBQkxFKENPTkZJR19DT05GSUdGU19G
UykKIGludCB4ZV9jb25maWdmc19pbml0KHZvaWQpOwogdm9pZCB4ZV9jb25maWdmc19leGl0
KHZvaWQpOwogdm9pZCB4ZV9jb25maWdmc19jaGVja19kZXZpY2Uoc3RydWN0IHBjaV9kZXYg
KnBkZXYpOwpAQCAtMzQsMzIgKzMzLDUgQEAgdTMyIHhlX2NvbmZpZ2ZzX2dldF9jdHhfcmVz
dG9yZV9wb3N0X2JiKAogdW5zaWduZWQgaW50IHhlX2NvbmZpZ2ZzX2dldF9tYXhfdmZzKHN0
cnVjdCBwY2lfZGV2ICpwZGV2KTsKIGJvb2wgeGVfY29uZmlnZnNfYWRtaW5fb25seV9wZihz
dHJ1Y3QgcGNpX2RldiAqcGRldik7CiAjZW5kaWYKLSNlbHNlCi1zdGF0aWMgaW5saW5lIGlu
dCB4ZV9jb25maWdmc19pbml0KHZvaWQpIHsgcmV0dXJuIDA7IH0KLXN0YXRpYyBpbmxpbmUg
dm9pZCB4ZV9jb25maWdmc19leGl0KHZvaWQpIHsgfQotc3RhdGljIGlubGluZSB2b2lkIHhl
X2NvbmZpZ2ZzX2NoZWNrX2RldmljZShzdHJ1Y3QgcGNpX2RldiAqcGRldikgeyB9Ci1zdGF0
aWMgaW5saW5lIGJvb2wgeGVfY29uZmlnZnNfZ2V0X3N1cnZpdmFiaWxpdHlfbW9kZShzdHJ1
Y3QgcGNpX2RldiAqcGRldikgeyByZXR1cm4gZmFsc2U7IH0KLXN0YXRpYyBpbmxpbmUgYm9v
bCB4ZV9jb25maWdmc19wcmltYXJ5X2d0X2FsbG93ZWQoc3RydWN0IHBjaV9kZXYgKnBkZXYp
IHsgcmV0dXJuIHRydWU7IH0KLXN0YXRpYyBpbmxpbmUgYm9vbCB4ZV9jb25maWdmc19tZWRp
YV9ndF9hbGxvd2VkKHN0cnVjdCBwY2lfZGV2ICpwZGV2KSB7IHJldHVybiB0cnVlOyB9Ci1z
dGF0aWMgaW5saW5lIHU2NCB4ZV9jb25maWdmc19nZXRfZW5naW5lc19hbGxvd2VkKHN0cnVj
dCBwY2lfZGV2ICpwZGV2KSB7IHJldHVybiBVNjRfTUFYOyB9Ci1zdGF0aWMgaW5saW5lIGJv
b2wgeGVfY29uZmlnZnNfZ2V0X3BzbWlfZW5hYmxlZChzdHJ1Y3QgcGNpX2RldiAqcGRldikg
eyByZXR1cm4gZmFsc2U7IH0KLXN0YXRpYyBpbmxpbmUgYm9vbCB4ZV9jb25maWdmc19nZXRf
ZW5hYmxlX211bHRpX3F1ZXVlKHN0cnVjdCBwY2lfZGV2ICpwZGV2KSB7IHJldHVybiB0cnVl
OyB9Ci1zdGF0aWMgaW5saW5lIHUzMiB4ZV9jb25maWdmc19nZXRfY3R4X3Jlc3RvcmVfbWlk
X2JiKHN0cnVjdCBwY2lfZGV2ICpwZGV2LAotCQkJCQkJICAgICBlbnVtIHhlX2VuZ2luZV9j
bGFzcyBjbGFzcywKLQkJCQkJCSAgICAgY29uc3QgdTMyICoqY3MpIHsgcmV0dXJuIDA7IH0K
LXN0YXRpYyBpbmxpbmUgdTMyIHhlX2NvbmZpZ2ZzX2dldF9jdHhfcmVzdG9yZV9wb3N0X2Ji
KHN0cnVjdCBwY2lfZGV2ICpwZGV2LAotCQkJCQkJICAgICAgZW51bSB4ZV9lbmdpbmVfY2xh
c3MgY2xhc3MsCi0JCQkJCQkgICAgICBjb25zdCB1MzIgKipjcykgeyByZXR1cm4gMDsgfQot
I2lmZGVmIENPTkZJR19QQ0lfSU9WCi1zdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludCB4ZV9j
b25maWdmc19nZXRfbWF4X3ZmcyhzdHJ1Y3QgcGNpX2RldiAqcGRldikKLXsKLQlyZXR1cm4g
eGVfbW9kcGFyYW0ubWF4X3ZmczsKLX0KLXN0YXRpYyBpbmxpbmUgYm9vbCB4ZV9jb25maWdm
c19hZG1pbl9vbmx5X3BmKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQotewotCXJldHVybiBYRV9E
RUZBVUxUX0FETUlOX09OTFlfUEY7Ci19Ci0jZW5kaWYKLSNlbmRpZgogCiAjZW5kaWYK

--------------zE9qbDXoP0z0nuYd1DObj9DS--
