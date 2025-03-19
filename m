Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAF51AF0BC
	for <patches@lists.linux.dev>; Wed, 19 Mar 2025 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742397803; cv=none; b=p7iJk+3eM1CqjBlyCSLmI9fHhwe1MJnUA7eJdjxhm8XYDEnFtH0nCUKwfuAVUvlGAnealrNidYAMP8pE8LnOsAzGOpy8BPUdJZpVidgy3EzoNP7qsZ7HlYLA9Q8BtazcmiLTV4aO9mXGxFBPSil3YebMKPJYl6+vYXXBP5HieKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742397803; c=relaxed/simple;
	bh=K8QsbPhk3iE2g5mRU+pM6Dwov0ogzDt1edO5SeIdQ2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JG2aQ5/M9RavviesUU0tFYfCePcNAjr9mO9Yn+YsLKHLS3aAj9yMq563qxdWZ2FJTIhAf20uht0lBlHxULPinlebGpEffJxHNHt+REbSuAfBdoULdM2GoRT0mipHZd0FIMnP+UNrQc42XQCa2speMEm2PI2tjSNSaXmtPSkxdb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=EEc7jCrd; arc=none smtp.client-ip=212.227.15.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="EEc7jCrd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1742397778; x=1743002578; i=rwarsow@gmx.de;
	bh=zr1kNpQluBJWeRvzP2vQQDfQWJstvl1L64TGUGtrH3s=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=EEc7jCrd6JS1tnvjcn/B5CgfU7HNbllxh/CCYwk9y57PIoAQKKA/K/yuSJ3i77TW
	 AbKR/b210BdcMymepvKB67InGdH8I4TiC8vPiOHWpBuZz6nbM2hhn8PrJi6Cf22+b
	 FaNxI/kue11S8O0eBijNp+G6eAeDoVbdaQCr4vLgOLhCdIgelrTY0hh1+oFCVIUpG
	 9UMMmNflwojbaVlZMTQx/dmKEtALgE8N2+BqO1v309mtMW2N+/nck9NR8HwGqdxtE
	 XFr6Kpqct7673PB/RuPUW9p0rTae8WXzXetuj/hCaPIqJdm2ZPRAtIlGNu114vXOa
	 5M3Z0hyk/l1HnUsujA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.34.177]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MY68d-1tgp9o3iOL-00QVRE; Wed, 19
 Mar 2025 16:22:57 +0100
Message-ID: <8330d511-9411-4b1b-91cd-dfbbf6d0fe37@gmx.de>
Date: Wed, 19 Mar 2025 16:22:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/241] 6.13.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250319143027.685727358@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:9Bwh10FpqO6KPV7oxnRs5GwpiZ0qdbOAcVKQQr4CoVSqQuyygfa
 eOaCXhR0caaqcKTpiVQ+3RMJHeKRopCF/0veoifOhjPIOzVqkBO5OlLAQg5XGYTWEaJcW8L
 R2JazD8kuB+h4m12pMsLtxLivyQLonJdUFoJ8s8200HcI4ifVruPvuO2bFvDG2Rw0KTUhDX
 gw7K4+T7fcBqvbpz/ooHQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:5IS7PFwG1RE=;s4QxJcidotvsFWHVPp+DPaXhxgg
 lrQfLoq/BJ8MXPYGurCJ7+k800ReVldqu1LPGtBJcA8pJdse5JBq9EywW9DteTny/43tARljx
 fuCsjIoSUvSfwwxsSJMzjv5dxU34FQ7eSYICCAIDgcBsPdQBE+TM61V1xUOm6rVxIOf61sUqu
 yGsBM6PQN6BXQrGq5AWSwRSDzbwWrnnqtSo2UgOQo6V3iJMiZC8V3nYu59W75ESmoSJNaSSMw
 YaCD+ESFV/Pwx50noPUq50GyjpdIdkzLLAqcYdvjtE9VaIJ86r64OpLZDHIDnk/mRYASkxjdF
 b+BWwA4Ej3j0tZQD41vUJCwGnZS7iZ3+dPp+zv1struJ19wXF2JOsJCxCt9VpxwBSf51jbMIa
 3UIsqwR2W2izToft1PN+Kbp0QIwqkVcnKij6z0oGZnQItEFAF9ObTTGQZQXuMt4xyr8izRbVB
 voIx6W2wMPFkjsri8Y8kme2ihu6GBY1kMtJoOMH4fq2EkkhQPmx/nlSCDYSy8rEl0lN5IGFU2
 odxYPccSsYrq9V1QpkhtDPKjDoijWZqj4w3gE4k4SxoNaCoLxh8OiglzHXjCkLvR11FqJBTTM
 ZPGBPzXhYTRVSv+26X97n4zW10DOPdrw6Kswxq0zfmxq0zWbHxAUUB/CVk5mbNgGDjZktVVsp
 wVzlEeCKGr7dUqc1//7Dl7Mq/c3wMg7Lf6DeSrU+y/n9qoYdgCm8uOLOknpV7EYZJZNtasg/m
 DJBcB3H4ePSzAMdC6XuTR8DerPJlj4huNeDYRhqVngQcddCe5qi/1e35WBfAPJA0nyv88lmDP
 p7vDx2KHg04mlL65lC3GUS6d3bu/7k1mOIxsAYCUG/appiyvP/Edlfi6iDYMgRcWTcZ3KoK7b
 NkxaUXIw62d2Ma9D135y88/j/pYRHV9PllI3xZ9wYFFWqkYy75O7Phlom/A3eOdPseouXWHbT
 AiVZmc71+t8lMu+l2XBYCaBBpSRboyyvuCG25LUq5/tfkMYDSXh3f/Y6ND3qYIbv2MpUdeD6p
 3EptWs1Bb3HmibO4cNBwzG1eMcLXOxFhNatVUmcMk65ZpU96PxoynX8u1EyYHqoPn594vZx7Y
 TCFeBqSAB8s+MmZUcu+K5fJ2y8rsFky3U63Zj//wuB+UuP61b26txc+F8/naAI7BL5ISM993I
 R4dFoZPp6Ih9F1GBLJjBLAP5qNU07MER84J0dRNlg1rnuFNywU1dcYuesae05XW0kyjMgfYYk
 pONGI9wuYRmRs/Mwu0K5v5fxBOdnGy+FlUwXxA2gUXSfsKj80bM5jxpWkwGMW1dw5VyP/ixak
 aOXIi9vwGmv/ngcDi0xyGum8jmjzvT4SnvDAaxsKoTO1kYl/ScxDwrZ0RZ8jsOMsMY5w0ucTs
 YEftVqeLGJ704sxWCCGUCDWR7LIShzZOFT7p7dMAZBcQotADFEVEE25cT09h9TAU9T8A4/WZ+
 hQHrRE+0IiCgJpy/XM2GVjEMGPxk=

Hi Greg

moved to Fedora 42 (Beta) with

gcc-15.0.1-0.10.fc42.x86_64
gcc version 15.0.1 20250313 (Red Hat 15.0.1-0) (GCC)

with this
Kernel 6.13.x doesn't compile
Kernel 6.14.0-rc7 does

so I'm offline until 6.14.x stable kernel releases

sorry !

Errors
=3D=3D=3D=3D=3D=3D

C032A7D52A7F0000:error:03000098:digital envelope
routines:do_sigver_init:invalid digest:crypto/evp/m_sigver.c:342:
make[3]: *** [certs/Makefile:53: certs/signing_key.pem] Error 1
make[3]: *** Deleting file 'certs/signing_key.pem'
make[2]: *** [scripts/Makefile.build:442: certs] Error 2

...

   CC      fs/ext4/indirect.o
fs/netfs/fscache_cache.c:375:67: warning: initializer-string for array
of =E2=80=98char=E2=80=99 truncates NUL terminator but destination lacks =
=E2=80=98nonstring=E2=80=99
attribute (6 chars into 5 available) [-Wunterminated-string-initialization=
]
   375 | static const char fscache_cache_states[NR__FSCACHE_CACHE_STATE]
=3D "-PAEW";
       |
   ^~~~~~~
   CC      fs/netfs/fscache_cookie.o

...

   CC      kernel/seccomp.o
fs/netfs/fscache_cookie.c:32:69: warning: initializer-string for array
of =E2=80=98char=E2=80=99 truncates NUL terminator but destination lacks =
=E2=80=98nonstring=E2=80=99
attribute (11 chars into 10 available)
[-Wunterminated-string-initialization]
    32 | static const char
fscache_cookie_states[FSCACHE_COOKIE_STATE__NR] =3D "-LCAIFUWRD";
       |
     ^~~~~~~~~~~~
   CC      fs/nfsd/nfssvc.o

...

   CC      fs/nfsd/blocklayoutxdr.o
fs/cachefiles/key.c:12:9: warning: initializer-string for array of
=E2=80=98char=E2=80=99 truncates NUL terminator but destination lacks =E2=
=80=98nonstring=E2=80=99
attribute (65 chars into 64 available)
[-Wunterminated-string-initialization]
    12 |         "0123456789"                    /* 0 - 9 */
       |         ^~~~~~~~~~~~
   CC      fs/cachefiles/main.o

...

   AR      fs/built-in.a
make[1]: *** [/home/DATA/DEVEL/linux-6.13.7/Makefile:1989: .] Error 2
make: *** [Makefile:251: __sub-make] Error 2


