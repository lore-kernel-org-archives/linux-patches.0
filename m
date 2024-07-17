Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2E1125DE;
	Wed, 17 Jul 2024 08:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721206515; cv=none; b=iSngBOHfhMW7d46+PrHnpRTmMTG90vkOt09pGKU/bxSjm9BA0N7kJuOe13nChMpTeT4bJjOWnoz/Ex7WXVq78cX2PFyNJ+guefIduH02jRu2suVT3C8V+g5DAAxpYKT+9ldbkioPB72sf7RPAmpIK9S5wfHBy38TSoeDFjW31ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721206515; c=relaxed/simple;
	bh=pd4s4AR7E1paZHZ12GO/bLDev6ZB/amOcZAxHaFMPOo=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=b51FpfI5faqU4taGrf39WF/IdzkRWGZtkG+cJQOjimiPEtzgohm0qSC2nPTKrztHzNpExszbAhYI3t57Rj9omnuo5zx4sItLoJfZC7YPsHVQm09MevQpeBq39gm8FR7juI1ysSK+KUUzxHiM0d97+JbVMD3rYWCyoYdvL5tboNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=sVjdvMt5; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="sVjdvMt5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1721206482; x=1721811282; i=frank.scheiner@web.de;
	bh=pACsef4y0KFlrIpCzTL9xGMhp6hapO6kz5GpRGaWPg8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=sVjdvMt5c3IQI7TUjcCJ0m4MCIvX74aeqzzUQ3awH8LAEMoo2GXGPXPtk6MOQI6b
	 sDbi5V/FB65vHMOoUclF8wtY1ydm0+ykAHjM2KT1JCrTNlsdOxGZm/G3khxTe+q1F
	 yoyXcc1MhUUtD/4qFKLRcutu8ImqGqFhC9gnzgSPpwlJc1ZdY2wamxOYJmSquaw7h
	 UK9mmO97yOQQohQVWU/xlQtVkUYSYQN1kBZEnZ5Hy+NRoyGM3tZT7Vteok/cMn24t
	 qCGcybBVApc23UpLpPBgTechdOrPcnwXZgO29E5VdwdjHVo8Xa0yCqrbyELMg5NrT
	 Z8o9a3lKv3UhcPvAog==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.30] ([84.152.252.217]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MEUSE-1sa76u0fyE-004Hjv; Wed, 17
 Jul 2024 10:54:42 +0200
Message-ID: <01082e96-8c2e-4ebe-8030-6e308a03f9e5@web.de>
Date: Wed, 17 Jul 2024 10:54:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org, allen.lkml@gmail.com, broonie@kernel.org,
 conor@kernel.org, f.fainelli@gmail.com, jonathanh@nvidia.com,
 linux-kernel@vger.kernel.org, linux@roeck-us.net,
 lkft-triage@lists.linaro.org, patches@kernelci.org, patches@lists.linux.dev,
 pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org, srw@sladewatkins.net,
 stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org, =?UTF-8?B?VG9tw6HFoSBHbG96YXI=?=
 <tglozar@gmail.com>
References: <20240716152738.161055634@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/66] 4.19.318-rc1 review
Content-Language: en-US
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <20240716152738.161055634@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:wTq+LIOCT4rtn+gzEEK/9JdTCW4AJ25/w7OF6dR2nZfsgDVW+b3
 UMpXVbbt4gXcQg/dpQG8Rp31sadNwxwj91Inb2MARS0Yc7kYfackSbj4oU6Ouc+w4RdM1sb
 D5N8199gTjMHrrde9RL/C7WWVUjVR7viyEDZi9emI9lGtu9rWQO47zJ33/W3WRQ343bbw4T
 Ei/ZaPVFkgXV+YNFl4qSw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:s1ZMjZPxt4s=;ux0vIzCOd8DsijRpYIQrNfHprj3
 dy6bDUbd2zC+DrsMdO5FKTNdER2BBqY5Zd+eQIYYeCizy4VQLSyKgdovTfISimN/YZcmgoSvE
 M7LF5kXz5gzjVSLl+4lf4nb7180SrcsiOYB5Qw/uDKxeJcGPtcZgnk0e1/pGVxG4oIGf4emyP
 4haYe97yZmGROqkkneC9vDfVwF9je9AdTG/8MuFTR4gaH+5j38EC55cS/hGWX8Jt4J6zCtR5Y
 4SEzunW3/Xt5Q073UGPaSUL+KC4iUzMZzwWC3T0XKIHPGmz4D+5EkzhkBzbxruQ/M5kGOyeWJ
 0ltu0Aipfu1tfpeAoOp4hqGAw/Z3rSF55XSDKYQ9qGyIzD9BXrTsZKhni+m7rZKKs6cPBr2sO
 S4lnuBo6BjpPWet0mkPkivsXNqZGbHi8Ih0AMh7rb6oLFwuugemZkpMnEAFsdtyDDJKbRKhep
 YWWVRSYG2pcSoVDVt/fWRcXNJZqFtXJ6A64tkjZM7lqPHvUPHB3PZXNUmm666SSwkIVe4Vj1n
 3eV/DIBBhpH1Ql5GI8Ccm8N7CchQ8J67M/sO9mI1BjzJWH9Gs/Y0G0g6rUd23RUc9/oJX6mgg
 vksVNg7JHCt0W/Mi2XTPb96MONRo7GTLKYuPPIxkpBWcHmXYnuwKX/EMhZpGAF5d1fj3Vqk7K
 TJPH07anJTEYzqAhKBZmVxIj7K+gUV1d4iQD8HANEKFhfTjNbYXqRfu5YGeKR6BNyoPcmdHQv
 vMUCXictjNz3cfMDOVuUxyV97eCebe9pHyb8scEFH0kdeY9SUY5d9CxViiX7oYZeAJaMM2Hx/
 tlJ/qpEA+OZMgQ7tQGLdW5O8DlFAu3XutvRlswmB3w8+c=

Hi there,

fb3739759474d150a9927b920a80ea2afb4c2a51 (from mainline) should be
included in linux-4.19.y, if a589979f345720aca32ff43a2ccaa16a70871b9e
stays in.

****

## Long version ##

It looks like:

```
hpet: Support 32-bit userspace

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
/commit/?h=3Dlinux-4.19.y&id=3Da589979f345720aca32ff43a2ccaa16a70871b9e
```

...breaks the non-HP-Sim ia64 build ([1]) for us since yesterday:

```
[...]
drivers/char/hpet.c: In function 'hpet_read':
drivers/char/hpet.c:311:36: error: 'compat_ulong_t' undeclared (first
use in this function)
   311 |                 if (count < sizeof(compat_ulong_t))
       |                                    ^~~~~~~~~~~~~~
drivers/char/hpet.c:311:36: note: each undeclared identifier is reported
only once for each function it appears in
[...]
```

...as it uses a type not known to ia64 (and possibly other
architectures) w/o also including:

```
asm-generic: Move common compat types to asm-generic/compat.h

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?id=3Dfb3739759474d150a9927b920a80ea2afb4c2a51
```

The latter seems to be in mainline only since v4.20-rc1 and fixes the
non-HP-Sim ia64 build ([2]) for me.

So fb3739759474d150a9927b920a80ea2afb4c2a51 should be included in
linux-4.19.y, too, if a589979f345720aca32ff43a2ccaa16a70871b9e stays in.

[1]:
https://github.com/linux-ia64/linux-stable-rc/actions/runs/9947642032#summ=
ary-27481009307

[2]:
https://github.com/linux-ia64/linux-stable-rc/actions/runs/9970651775#summ=
ary-27550542084

Cheers,
Frank
