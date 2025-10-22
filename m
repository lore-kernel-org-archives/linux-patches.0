Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F7B25A659
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 06:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761114277; cv=none; b=j01B6dcib/Fg4E+KDMEycboh1Jgdj728DhmVZxku3Qacaj3dH3wF8kpVFqOCl5YILxXuEgY499H9hHoTeiW0hE7B182+LXIYnfoHkglsOOAlKglLZjSjLWzyFXDOeMi4Q11mmFI9fIT83/XQzUkkdJsypPoPDgMRZuANuO0NMvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761114277; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fZypc2sv9VmQU6qXzqtZdS+rSWUK6MLb4Yqvjm5qDMgDiWzbaDnrEguoDmYKBpTneYMi5VgK/sQkmEM6oiUQqlHH+f/1Iwp5WhU7lsfe/f8eJs85D3aa2IRd7hmVczY5pMtz9zagK/5jq3DKQcc0zO220lVat6tgzkRJ5bpxI8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=hqwfhTYG; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="hqwfhTYG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1761114265; x=1761719065; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=hqwfhTYGCcRnBNUu4jXOuCUEH8C0RJ//BKrRb1ua8uGBkIxLNGU44yLx0xp+4Pfa
	 xrTJD2HS38iuzrq95Tt/58TwYYtvqUaHLdsj3061KwRg/QoIT7ANllcfjG3bJvCoM
	 FKmEP53Ukxtx0WbJrLz3iZrHsuRu8hbV1c2U1F11dHib++IpvbPn2a/zovfW2wUAF
	 ZPzOoXc++9dGwjy+JZbblyegcJo0LnYsvDH1+BjUamTiKcht7x7wQSa6xB/5/ifw/
	 hOIIlKEq7l1aXD4rMsgSdJkGJCOYiqiFRSvvx1FQjGfO1O49pPncHXR1AW0/ba4WC
	 bJbj4TUG/TICd4lxxQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.216]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N95eJ-1u9POY2aMZ-014iyY; Wed, 22
 Oct 2025 08:24:25 +0200
Message-ID: <880e4f43-7a35-4273-b5d5-0f16dc8decdf@gmx.de>
Date: Wed, 22 Oct 2025 08:24:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/160] 6.17.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251022053328.623411246@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251022053328.623411246@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:rB6+gqPJEKPcCitri7AjHXIxvTaeChAkkeUGOwUhNT/+OEDbopm
 f/6S6CvsXnRuonBZfT1XZnYOOkz5LodGJEnBRaHeSmX6/jg8EvDO6XYh8H0HVxTfgZSytS+
 XSjW6mY54KmCWRmplwOXQPm6ijKoonJDp/6vrdfvWlNdsKJ/UHrrD2G+erDDH7pugLtPp/U
 Ym6t+BK+3w7nCbB/xZKRA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:on9AkEJv0XE=;iGFxHtxpYzxU92xRBG9jduKxpHM
 H2JL2IsQb+MT5gVOkOcBtJNLhYtiDROPfcnywJ2Bt5BLlocKLJbAnmzM0ExL4hAhpgvdLXIbK
 IpTWegJ30XU119J8xqji6zObdOJFYQ+XpkfdLGOzFVNG3zf7lk1vOQHOyQl2X4uiD66uLzfDF
 kP7ZIF7bAHBBVK8hdqGPDG9FmeCQ5cH0e0tysndm24SLFwGIiNOZLyoOTu26UPcraGnp3KpSz
 ocsfqtjM4AzjbY154MGwToYA6Wb4g/sEXf9z6sf1o6TiVuqYzjU6MCXSxOb59l7lahSfm/MOx
 kVMVDnKbvSMdGwX5Vs58LS/PKlq0FpObSSF/DTOKPv9GKcLNEoLqUdOSWbcuYcaxiLCU6UnbU
 ISTjITgYsR8jiMFHIWFPJF8NfGbtpQongmB77qZu6GhNpxpfAFFyCPTxEbUzN5LM6zSxNYrNb
 p4QS47iMHSmZtKbZFouCBRuFPtE/VNU0QwpuRfb9d3BCmT216Avgl34NRyxt1WrwVrDDy+N5Y
 m4uP+JqFhtOUAlYBssqeWeiqZQyixpM7cRh+SkFasayUw/POKNrPWI9SRtu2C1KxgxRRPg/Of
 Bdgj7XyOplsiVFTbZVBP1oGe99bOoLwTvCrrcQj/sB3/Q5SiUurusf9wdLQvF/hNr0AmAWKAs
 zydZGQXBHTifCui09cyxC0KPhaVzisqRSiVoeCXC7kCNULD/94xYiheNGEtm6OV4+pK2NjRsu
 js48LsTl9etruNRuwrIxn5Lu/OzgoGxU4xwHU3n9m7kPeApOmKBpL1IQidP7JL4ydZHsM2mAx
 RqBAtjgXJmEB2cuQ715RFxT4xGsDt7tsx2PRCiV72UmpQf4Vwjl0XHLNNt4p17Xn8Mo34qr0v
 JYfXUooaffxeBv1Sgi7v+U8953OhDTrTlkDwgqulKwZ9hE+DRZsopTSiqjZaczVIEFTvU7N5U
 AHSXdJIQeRmOw6f/cmWGC2lU2Fn/qa77issLRj3y238xEiHMyTczl4tyDGEbK9cLXhy1V6D7O
 u8RFuOmbyZ61bd1sm8O7Efn4tO/wUmVSGpajmNioISXFf+rK1lfQ1KqNkuFKLIFtocHdas+5A
 M2cNPpZofuvWDTbwUFdsWQw/R/0MrmzhgSSdnxhj7k+50QHi9XVhl8Q3qhyrrQNFPUjb4OAtW
 hhI00np/VpjA7AXZmjpZmH2nZQEqgTpjCBsl3fbN+pSpsmq1qj/bEdLQa6rRjqoefP6Gsw31u
 Es8zqapK/br9M+K01IV1m0srfwjRyY0I6p7xuLNVXifF86+mo33feF+/MeMP3hDh0DaLi0Rqx
 yXLJ6ClhNC/GVEuCGpN8xQ7julTCE792VHBrRe8Hi+CequjXYocr1WBbxb4n2Rqyj6xHNUCZW
 LLmKFyAK1G7NzWItinprk45GOb2/FkB/BKUEaWU0Skn3mHfdHDJRjhWiIGTBRCWEcFIHp3RE/
 ESAMwa70bcksKmJRNmMgKPA3AUdM06x6bBJinuTWdsk/aZoXiKHjtAiAdT74KFTRh5l/Tnr34
 smR4Pde9xd5yCMNv9I6Wz9eF/2sBiZcssTNPBBllHnymwXqqihXRkMR5PohmXJYWe/M9r9qU6
 //LBTsX+uh4MND1pl9WAwaLqkVshZQw00yAaccyvb2sNuhyoOc81ZlpZC3D+vQ/QmyqQ6VWHv
 LePPENKnvAAFQQM+PW4+CA5L7n5/nzBf2kPqJWhpMBMGwDzxqB3WvZleVC/82DOLAjh4aI68g
 IruqTWe/7H18a/K7n/rgS0XX9M8vPezE6UIMgb7XpA23W5KkFLMonT6Burrnc/mgXSov9NhSk
 IX6Ydc7+S5BzHiWzrVTx+v+5z0W/jWiRTZkFb9bQQp6qGe2A4Qol423N67cYYHd3wP4loJZMj
 y9pKzyQkduxAdYftP0T4OibivoBRQoEJH5axp6NwfN+6QbG2d7Vu6NZl3KQk0apTEZ/zhAyaP
 IHysdu/f96fuVCnSo5hKUcvJJvWJRQEve72ngiwisWxCvGci5pUULXOqTpfJWf5Zf/23e9qY3
 CXIjIQqeuK1r5Cx9Lp2MQND1TUIEafeQ5xqx3MeXGfsigO+BICuPDss7tpCIpvsskwN+lvLRH
 D0EDGNW/72CQnx8jTPrEaotqmkevJK0nn2APY0AgDwssYPd4eAArwSirk1V7e76hw4AcXgjMX
 CLa0ImTUb2X0VB24xfmCcw8UJ54+4Kj/z9q937Pp3ANC+tgu6nLbtq9kE/g7NGROxEBXp3y5j
 jwNeUL8bXcPOgYGiMMgtBaDFCYsfg+esBkJMMyMr4VZwt6TnCzoGWcEGjytJ89fJqPRu9+zdV
 5qINFEC/yrAKeHL6G1yt6Ygzhlgn8oC/3Er3d2OyOV8qFmCfTEEEKR1215E9UuZNrVEqjdUjy
 Ol4CNe0/HTApPITUH24T3VoXRhmeoj4BrWLJ9w6DoFD9c9Lc1I6xlOM/XQ3CUnxgQQ+oKgcZk
 xtTUjuhc+fgHI2DNTLQCSldTK6v4AF+uFzfCiuKoOJtBlFajRvahnViopgpvxKKEcHV+Yap17
 8uy/uULFaz/2/TR1ANl3anJ/+JmFntEUXU7fw2DRxiUElNV2WbJwjxpgcHQ7W3Kuzfa335X+Z
 vogHueagz+hvD8cbqKsI6nou9ndrYrPlnymnp0xJRfXgUhVOlHKeFMqrA4StmjL31sjeUXK6d
 gT4N7uoIEJdDpOy/EsWSUFbCInFyLUooZkLGEZcmNX1FhS7tDDUfI2C3mDNrLLWLJJb3KiiVS
 rJH+bQC68M8lUe2R/PVypyGGy0Ikp5Oqf8mBXOJMkz9rpXieb1JThNAfjXYQidQm+auaQ/0t0
 i0TvFk8SlLlp0OzwiJ2LoNsQ4WTl5NeMeGGSBxTYQ0rIOGbIly3Slxo+Ub/sxdNxee4j6XT2s
 e+F/FtXt3+vrgD4scl2PKRURdbpxfgnIZKMuUBQaIHsTG89Q0bNXUfKMxmQPCSaPjvFBHJEhJ
 FwE6jUBwWP8uuAZ/NQtj7y8ygAQyg4Lp/rhxsTD8vqgNK3TJau+R91Civokgz7bKw3I+3dhd0
 n2zxWy+btqJHYuFvUq3pgEyIKYB6hiiACx8LMOKd01Jly/e+peQp+hfhWfxHhx64gzPupKyEr
 309oa2z+BfV1saLEWguWDHJ66h0w0z/JgE7B+kg+oZYzHaMBeUFmG2vqZiJZupuVWd1nhWA1K
 3kUidNqCo2U220oOfjaEzOuPeYjYjDMh+djhxGWKo49X3EyLCgXL0ZLG5cTu7gyv1JliMM+ES
 fOQm1/Ds9MkGMSQ8jjfDJkHgHsv1TvmCCbhAS6X65IV3jnQ4eN42RUNr78etdfLvk0FqDdWLS
 1poicsIogB8ZlUboDZ+q19tir1Jjes3SfD/LW42j4DR00I8aC/OLiy+c7SSMLML0pK25/Ygxe
 rDCdQ8iD1cuYGIHWJnLlEzk3wx/hAnKfHhufGLU2ZFjFMTKfywbUPFNDbE7626cVFU+yXejzB
 QorQmt0IpDDIxt3ng1zGaOzSYivw+Z6h3Lzd2EUXrC7F+s4JK7cWZzyKx4RS4RWEfClOcJnCn
 JPqk4KSyBjiptN9dJ0SbvgWP/vsPZoHWNm8qGKufURrR508DLmXA+EjG12/I5HLGGD1jvx33v
 vsVyaNKJtfDaHYem0la6Og3qZrBXLSwo1YbBpZ4llM1d/iqgjgUwzUvoSn8z9YZ07y7hxTihN
 QCdmrmcLg5Kt39Tp4Ucuv5O7+DJelmYoTpGexZNwhi/5YjfGv2cPzDwuTBoh8is2wALKAqvjn
 RAZpnZMmA4iT6RAYUtvdt232KZLptoRwNuEKV4hhjYj31maNxmeKPPeki9TOtQWm11oEK2bD8
 Ok1sztz9IUvuxGlpRGJPIwP72PYeNnKQQEcDwRyDWmiFi6nzM2J09/T1tfBwnpbYH9sxWOYCH
 UDu69Yt3EgqdtRnT5puljCu096iHYLYGZAsIXl9VNnS4xPYJhsVXM64bCDupSVkZQVRG5eLGF
 uo7CQIM5tiGYFhvgy+U266pulFvzWJZIbTghiuSB/M8B/8zZi2fg8IT/gDmZ4rrliPzJu4iT6
 LqkLZZUcLIeIq4Mhb2LFiy6JQUTmeXdkGvPDo2IVyJt6434Qqk/T6KNKybKuSQc/CmereLkOR
 G2IwL/9niUh9iIfY+dLYULoW1G4nS2uuPTKLi+cZlqH4EHwdEA4aVS4dwxUrFO+R1+vfA7fpj
 kE+tGyh/osvRxXLLREMBBsQUZVBuVrDTqoqJY0fFKxTFcOOvoSpLfpBSq5NqcuuDbaVmY4O3r
 ORzPlcTjbl1Qy+Fc2aItyJbf+W0l/IJOkOE/4UtZjGwdcXgLrTDF6DuDHZx8VP93oqGTYgWuJ
 whYDwWfBMztTrxGt4s37hfbWWUTw2t1tQtBsKshEMo1WC/eyfl+3vCAoAH2yVFG5JcpKNiMck
 vL2K4V5LofQ6Ij+UPk9SXNiMmFid/LGJMkY3BDW8DEJL3E/6H/QEMQQwu8WxFS/Z++ILkWnTP
 1xGvPyu3AISiryAByc9DsnON6Ouc6yvXjny1jiFWZubDDRJ0I0F864z/TkNNpYMZQPiSdPXjn
 E9RehrVpNYwHEln/CK3oAs6wrH9cyll70rgKCqWiBMQD2m1TA2XsOL/foc8JcqljBuEea9U+x
 wW9ZzFLDS6jP8avkT6V4PV6/R8K8vvNssmTBIrBrSvlr5AERbLLuoRho6V6xKjepCrgJUv1NZ
 46NCcY8vA42qpxwUiwnIrcBQ37FcTF9P49Z2oSHFsl1dd6ZlMcXp9lFFwAFjsCo83gPUUzpm1
 6A291MsimCRC8wR7/092a69rsJ1lh8EizYvqXV69ABpNO1j4QqHyFqAvn8ywzfow2fNVFGxpg
 DsGoMqU+bVanqNM8IXPZvFKYWggWyc59mk6WapLyutxYF8cJIxjpsjFR2vRtm4f8Dgauv5iUk
 P

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

