Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EF1C2D1
	for <patches@lists.linux.dev>; Thu, 26 Jun 2025 11:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750938381; cv=none; b=BaRcRgUMLc91UR91Q/nf2jPKTvoJ2Eqc3NV6yj1HI5fxKqxskntn2bal4RxcNUG7IAG7bpUL1k2gejqO43StxopNHAoFTexnBnE+JW8O6KolGsBUdIhstYpHwZreBo9PGNduyZzVY2AHyzGUnLlqPDzS1n/ztJ3Tudvdi4FLUeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750938381; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KXzNq+3w55S/CnoZstOgFBggNVHZZfLL6bEHKMmLH4scoPQt7iM1gNGV8Ff2cuX2vOjhSGUHvxIibtCQub2M1iUM89GJk+/y4Cwal51i0VSI3mF8gIJsMqrjXUUqfZcbEj+wuYdflIe6XZ+Do5QhvugKQbwFQbxfufo5IiV2oqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=JjiI4V83; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="JjiI4V83"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1750938343; x=1751543143; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=JjiI4V83jcvlm940sKHsBpqhWUuO6tFH59PyDGZntop1La6tDffzGmhUqUS5ddjJ
	 nwfwDYsYag3jwuIw8U9JVeJXdEiOhQ80+Y3KRzlndM6aseJvlNSI48ejwHZWFIPPQ
	 fUNahBEEdJVJ6QXgJ7lBdKFbJDWmx9a3YyaXwce7lJHrYW1ub2T4jyrB8p496rslS
	 1hzaoo2U16U+iKt22jlDsfoLEs9/hK2Xa/efLF6Hc7qnFzUl5lfrHkAQrrEKcQaxe
	 fT6ZqNpalXHqcpk0AWhEd8LYM9lzmsqh3CZzk5/XWvIWeRxowtIe5vwrsqc87oY/y
	 PJqJ3zp6kjwVO5nz5A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.32.180]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MAwbz-1ub3dO0C41-009RmA; Thu, 26
 Jun 2025 13:45:43 +0200
Message-ID: <c5c91a92-df67-4e0a-8a15-408d0d3ab4fd@gmx.de>
Date: Thu, 26 Jun 2025 13:45:41 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/589] 6.15.4-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250626105243.160967269@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250626105243.160967269@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:UOwBZrQxvJYyw1/LbqDehl4nv74I6cjMoZzKXySH47/Q20oudwd
 T4HSg2V6lz/gGFx9m2jzg2TrnMa//AcfJMS+Rf4+W/CRQ0mTXU6tbZz/ORjNlnsuN+7GTat
 xV4b0iguwz3HaaSCoWQBbfRx2Mj3/9GI8jKwf8sIF04irMyFKNIGxX188vfmsf8bVbHPS9U
 yVkfUIctnfs5GAOUWaz6g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:f8om3O8eITA=;Ry667Rq4hget0Z/bwkbGVCEAxEH
 0QW3WyuZv5gIpBguYFvT0RNS4aH/TVg9vPs4HybBQn0Up71C3aZFzbKlPU8/3e2i89D7nlt1e
 E2oJO7Mbf4nkrO+lLDy4/OXPWEwdzPdfjpshWdWN9HpikABs+qde9omM4Bm0pSr/0vPsJz/cN
 s1VtXibwmYo/gPAqvfJisWXxQzDbpIhiIQFO1VVz4+keSB1k5K/DgnRJA3WN32o+XwJpE86Mj
 XGqXZUYl7Flws9AMF7OlwJMTBLeQWB0NQugRJneUBtjdDb+OttksvpMLdBbkpv5SN6wVja7ns
 Swqy9kJc+4xI5vOB03DQWX8g8TQmA0aL3HDOpaU19ISnieSV9lGKZaKYHuC521O2ZS0jZTnJ5
 xuTWJASdch7ZpdVkETFTa2crTYuZo3p/eFYCapi3HJCjftaVc3kCw3+j7jQzfSkt1DorAXisR
 X7IknwiXA9Y0Ol7A+B1qMGDjtrN38ndWKyJ+gZXWrC7HUtfNBX3BqvvuIrwUME/WxoBX4/rhM
 R2Je7dQGIhRQcJzFxXiQ6bp8mv5Z2xdk+XK2G2Gc793omoSkP8NB0ktF3aE3pdGBdZ4I7DXHl
 fFM/czX9DsAURfwR1TXBkfyz7TN7jiM23Lez7TtOzSNkw5lFSbJue8AvR07XsdLAld5PKBEf+
 SR+Yc9cxvGftNU7LZGvv+CjNwYr3fI8h6fmRO5ZCwkAHsUccpo6MdUR4jtxBE9yPbtF7SdoRk
 PXBsWgZjJ0yARxFDiEwrp9fZTbda0gJM9pun7d9S2aeow9XSIep6VAn2JBJhMq/4g9E1EzYH0
 ygSYjkhXXP+LmTL7QrU1iXY+UA+QhrMU2298zOnQWF2ignuHupcLXeoaLjZdGL82w8hZgXBCc
 L4Wdj0XwtGftgUSsD/UpMiakJbl5g0YYqzXjb/GGkWhphvwf3wkH9932KZvluwlA4DVxWg7VO
 ERnOrQLIMp6GET0+txN4tlfGGRtAsSGFCld+x2YD10Cdlo1b5KcDH/WfWuHYW8CMYCpxUhREs
 7j2dMuxxpBSsGpPnSGzE6d663Yp6tTp2wYuB9yWQvDtplDAgnFdLHZyFXOeWlrzhNqZIYkfZA
 51yCLelVHQcj0RWEiB+EAL72303qwvVqRvvNwG0W4vjv7dhQwLMEHTPEEHg7W+TMpSCyE4a2L
 RaZSicPt31VQ4kyA40E5eDJUe7LLvTyj5cIouLYU5TftN2syAnZTiONTO76YrcsfVjbacidwE
 6EL7pnPfJtMcaovsbrjo2Ptc+OywCDmO5UmAoHe/tszeX+xhUz/qYuWWHMQI9k0A/w3JSC9o6
 L6Casl/cyyb9wlfN/rac6SewFDkbk6Qd7Kt9/wjNs0Ohfcl2GpLxSPHZ3dsp/VuRIXSRIsV2D
 2/IdYXSzprAzKNqgK4a4tkEkGyRgGzwE/x2gGAbJdmpYoMGHQFZJ9Tab8lXniJxIK1abzYXtg
 dka04t3hfDxGAZJG75BPtaDoyObGcf4YxQ+iuYri9EzxCQNkwLkR+A19r7JnCWCzC5EbtbcGg
 WFvVHe+WqJcJUgUytuSkgQuD7mlxdFK/YWgpM5cvntXbOt5LcHl4IRNj2WJ0Tn9tYM/CYFC4i
 Skaz77Ox9+f4NBn2GHbU6FjWLvvnTD/PP8gA60K9ZEAzzNQDxJtWWz7TAFETfIinsyc3wbs9b
 RJ7HTsttCtJw53rdNuHZkD3DKoe0ecPfBBIEYqrDDFwZLuuV9JlLNmZXHwgLqm6UY5agOSIQQ
 AVjpzbjmCgHor9ebbme/FfLcW0MVDuccpPberSEfKOwCYqTmYHUrFA759GG4TBTOBwBkkKrt3
 psTNEpNtyiDP5yzpCOfoHcHj7G+l+fqqGE+9Hk/Udta+nTMVQj28sPnu3ewXmOG6g/Xey80mR
 +U8Q/aqdUiBUw5t2uX8mCeSNEy1QttwqiLjy+h/+ew0Rj+8bRTjHyD53+w3O4B/I/WSZ95DWN
 WDe3Ab5r54M19IuB2J6JWNwMwo6NSxro1tHHDWi49O3k5+L7D41dM2XwVDI/sFkCUWN00VFRF
 tC9PDLD4WK2Eoa/6Vc6ZuSoNx4yUdvA4Rij6plqzkMYTjjeowTXJmt5aeBb8XglIre86LP0fj
 T83m4O01jqGeKSXATzMt+NESp8/blfvsYqCxGAoROeD0Sb58nHb3bM0BYAfvClJkx7uEmazN7
 HZUuyzKLfjbYU2R7kyTrdeiLgkQdT29UL/i5juVbKh8e6OeHakhU5XbFzWQy6iqpFm+MtgMoD
 OhsoRdKciC9BY5tHDOFN0v4ZZSL29+z0EsV0CDVTV4urcOCA8fKhhrs38pI3lrJwCOj3UQ679
 4iHTeFk4T9ssKhi2Xm7TaMLxKq78jiBSyy2SihAZXgOdcxlV3R5ZIkZ8XIva4TprSzh6mr5Za
 sB/noGcQboGXUlT4Z72iQlqzYWuynRAQs/95REq12wG/igfmVOl4sFYke/iUKCvTG7DsidiR1
 +NcvwSPrXpghGxgzhPt2JJ5ZbzetqZ4HNOO61FlrJg6ZOot7jma6aNmqCHZLF2nLKk4S+9lce
 eGpfp2gO8FSpVL2N4iZQNiNhqv3C5QdoQYJPwBxoh7U/FhUUTS/wRQu1SOWqeSOavPSrEa2UL
 0wVIRCQJmxgSFW6JXsF7Dk6nMNKMJ/VpO3udirfT+zprCJ2fS6htU5GxVFCwUz096MDWaVWR8
 Z2WBDH3GWH/UYmP/+4S4xN1VVmOif1/UB97UlZoLwNw/7z5Mnj/xJFXxgPon5/EbKL9c/qwW/
 Ebj2ircft8aLfESRFNzMMUP2tJY3x8XonvtKOIwYrvY1yRuJXGY+txaEhz9GcgBrFFbB5/e0c
 IctzljOMoIyJbZlvVBJzmlFht1hG/a/Xt5WUPtr4W2cjsODhap4E2mWnafhVyVhfWpjGKKIAH
 YFGJgQ2F6F/naN4Fh6UbvUI7i/Ht1wD7LG7MO0njsGMgQSrsTEvDl8napLvlVG4nGrYgUftCg
 /Pn4tfIDc0fEItkhSzaLiWh8CgfkSe7pjXjNIp1k4hCXZhvVCMNHcbgNcjx9m1Rc/b2aswtLS
 NIFuQKovnvqRce7Vovkdn6Pdba9cm1I0jkuKvQz7ynX/hCKq+JaAa298VPmWrPNuy3/pd0+l4
 whVIOGfaYv/QkvAZ+d+0fY+0vEotpjWDW47EF35Zuzv6inZhWCsll6FiE8tuAJUoU+9cz7CfV
 PpWxS+E9AFej48XM8QQUGV8LkCoSyHxCcfKG4qfu46FIiG/2PjbPlUFOCQNDdV5e7Eq/XQ1Ri
 3FAbXo3S7gxaKLcBrcKBTGhwP9tj0WnneZQjLFcz8gnp4+QiBPMH6qJ6KsDXCTKDZk3xurFvv
 tUoE/wdEivw1XKYDv4gPDS2jaJvz+QtEmJvnSbQcpWWesl6wFdLJInRZ1tUdhPM12yEIrKnB+
 f8dm2x7WZUA01n2Yq2Ng==

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>
