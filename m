Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D2129CF0;
	Thu, 11 Jul 2024 10:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720695445; cv=none; b=fq9IUgUnmtEm0BuqFY5oqwJcBX0h3MdBLqKLGiSxF7QukzSSDFGuEtr8Jc2XaggdnIt+JGh495sGYGxMg8DJ3tjmv35nOZ8mI0wC5tT1fMCJ1iDpFmEccVUTXJFYyD67nVwyTVKlcMMVeNTgDN3YxwnSMM/brRH91kJaCuFGo1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720695445; c=relaxed/simple;
	bh=+gEUZWwJxf6UBZ5/l0igGZen8dsW6JJDK458gV3RP5M=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=PXudvb9MeAFdcyPB/Hv/mtcEaRVdtQBEg4Rp8Vp5UpWH9oZsol8Sfx760tEOO6Rjow/w2fJoQfctY22JbYRBh/VGGhtJYcB0EWiYTueZuoRLpRxmBZibM7SHeitUUE9QvraeSsko66DHG7ua/caRpZEkZtytEA1ooCB5E+Gld2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=ckjYxlHu; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="ckjYxlHu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1720695406; x=1721300206; i=frank.scheiner@web.de;
	bh=VzEYr0o+A2uEVOWKMUMa1+D6NeJfJnWMktoA/muX5PI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ckjYxlHuK95a9bJSJlwrZb+sDXGGtZeQthPhTDvoK5rSpGcU3H72pzL6qZfj6CxH
	 b3wZv39M7bcNyGzKSRnqGil0GAr5QNGHyqmHUQMvKk7ry/LN1e5wSes3d+pTusnrg
	 qsTvDp0EPIIweeAt+F1q0Tc3iI6KBX4X1y2/N3Yn4F2So3KwZXPeGPAi/A/QETqh6
	 fPPtRJmMelXHQF8m3YF3wrKZS7pC7P/eEg626UoS4HozAuziQTjsydrljn1eNpqv4
	 +NxcBdv5s4TLlI8qOdknfv0EXc0r6wqExdHS2EihhygLiHhiqiBl8HLNi45Vnm7xM
	 4MY9DtE1V+mMr62UUA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.30] ([87.155.230.91]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1N79RI-1sK2OQ1fI4-013Kgf; Thu, 11
 Jul 2024 12:56:46 +0200
Message-ID: <76458f11-0ca4-4d3b-a9bc-916399f76b54@web.de>
Date: Thu, 11 Jul 2024 12:56:44 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, allen.lkml@gmail.com, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, jonathanh@nvidia.com,
 linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net,
 sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
 =?UTF-8?B?VG9tw6HFoSBHbG96YXI=?= <tglozar@gmail.com>
References: <20240704094505.095988824@linuxfoundation.org>
Subject: Re: [PATCH 5.10 000/284] 5.10.221-rc2 review
Content-Language: en-US
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <20240704094505.095988824@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Fbq7Hjr7X2/6ACoXjJUp9J9n84tJ5yO9w0OJ9P0SzPkif0/w2pg
 SRSj9DIyr2EryV/M2d1Ae+pOzl4zTHF5nWDyTWn9onLoMODiT4ahfxd1DHHRoPG+2TB166v
 v9FsJI40B7uY6QnSy+mW5KKfFNaLvHSpmS5plv6cnO3PaYFj/xsOtM067Ma3GTkuihRTAc3
 5NRm/k7qElvIyPrIppfFQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:KYa8x5bIf0s=;GYogy+6iurgHSxK2th2isUgduVZ
 FAaCvByYxSNBykzRUrGPx4t9f5f+yFqnDIKQIwO8MB8JXasA9GqULx5HbZeCUS8L95epaH7wv
 aTE5EP+iA+eGqcm87RnswHMABe3OrDsQ4lM0T+GtvAvqfsnfw2nGFavFf/b3T303X0XEaMyu9
 p3RVypLzS5r27m2lzAZwx4hWPOxOCPsoPcsa+5/wFDXpWOT+KHMiftaSLlwwFntP3aWXZWSUE
 cBrjqyo3VE7cANXh0tXpPtz4qkgLBFOSnMlkuvfoX+G5sc910TcF2iALcNBNpoy9fKq9SqPox
 /y0n7C6jADCg1Qvh82H6XC1QxeEy6+cVAERRS8gYeuT/1iHlNjzeNKgbROnei3SRAGn/xlSQ9
 PrMID4WNREW1UPa64oIkML0zhEEBUlwTLxv97gcLOUlzxT9BfKAzOfrLd9dl/LotqRNNYeBY9
 w280NeicdQJT7HuxFO1OUF9HUb0X4ghsMoArO4ORtoJTigxV/pCKRG7IVA/irbR4WrY6+ozgQ
 81DkKUgg9XWeCHlUJEuJjgvkjFg+HrEQblJgGjC0Z+QpcGTBLcVHUX+50/vvR2dA/MDiIyCgJ
 rzcvsXqMPvQFvRKOsSyFUKeZzU0l39HGx56F74djSp+wowB7xondNEa/zOz7kIkmI+yDrCA96
 R9FMV0aBn06tq1v5k1SJ91Z33/kynwyAWzgcVOxv8EcYd4AC3yMEYEgqtAOjBbC5LT0j376R1
 zUq9h6mEOkveJ0GNtCHM9EfqkYtN/+7799VO20z3BF+H8tBfjZlY75Y1WJHC53aTicKa5tBVs
 GYX2W6gm3gvqSXTi74bkT2McsCfyVwwaYe7Ug7iPMOr4s=

Dear Greg, dear Sasha,

I noticed a build failure for linux-5.10.y for ia64 ([1]) (sorry,
actually since 5.10.221-rc1, but I didn't notice that build failure
before yesterday :-/ and as the review window for 5.10.222-rc1 is not
yet open, I thought I send it now as response to the last review window
announcement for 5.10.221-rc2):

https://github.com/linux-ia64/linux-stable-rc/actions/runs/9771252437/job/=
26974019958#step:8:3524:
```
[...]
CC [M]  drivers/pps/pps.o
drivers/firmware/efi/memmap.c:16:10: fatal error: asm/efi.h: No such
file or directory
    16 | #include <asm/efi.h>
       |          ^~~~~~~~~~~
compilation terminated.
[...]
```

[1]:
https://github.com/linux-ia64/linux-stable-rc/actions/runs/9771252437#summ=
ary-26974019958

This is related to the recent addition of this change set:

efi: memmap: Move manipulation routines into x86 arch tree

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
/commit/?h=3Dlinux-5.10.y&id=3D31e0721aeabde29371f624f56ce2f403508527a5

...to linux-5.10.y. For ia64 this change set on its own seems incomplete
as it requires a header not available for ia64 w/o additional changes.

Adding:

efi: ia64: move IA64-only declarations to new asm/efi.h header

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D8ff059b8531f3b98e14f0461859fc7cdd95823e4

...or from here (according to GitHub this is in linux-stable(-rc)
starting with linux-5.12.y):

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?i=
d=3D8ff059b8531f3b98e14f0461859fc7cdd95823e4

fixes it for me with 5.10.222-rc1, see for example [2].

[2]:
https://github.com/linux-ia64/linux-stable-rc/actions/runs/9871144965#summ=
ary-27258970494

Cheers,
Frank
