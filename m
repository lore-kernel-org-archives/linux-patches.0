Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9F6219E4
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 11:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="bFO8+4/4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de; s=s29768273;
	t=1701431860; x=1702036660; i=frank.scheiner@web.de;
	bh=yDnxc0mwxkB4hTCa+vldN21uOr8NxnMJiPSs7aj03Y0=;
	h=X-UI-Sender-Class:Date:To:Cc:References:Subject:From:
	 In-Reply-To;
	b=bFO8+4/4gHptdTGbyTUMJUz8VTs+QdmFpZpDmwCBbURTT9FnbSpSxHyq5zBD1TVq
	 oa0giAEKkfm/LhJulOq3KXXmdxkCoi6SrJ7TII4HkMxvt5nXv5vloMCFYtTTjiHEt
	 CqQSZPRDYA0yw0NsUzzRk2QF37QJCeghZ+IGZ5AZvtjz0ZSJxwimzYTHq0fHaxjer
	 DFjlMP9M9i09JF5D02bIuzua/kDPVNSo44CpJcgrpOfErZRt+r0Yw5Wm34gm3BXmX
	 uisxTAomaJOuOJ0kLjDQhMfdYABLmXJniERrvEkfdh9Cxh6xAt6ZRsBrbe86XPgTS
	 swap7Vb2ip8SB7oM0w==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.30] ([87.155.225.196]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MXocY-1qluiO1xRE-00YE8T; Fri, 01
 Dec 2023 12:57:40 +0100
Message-ID: <473c4430-39f3-471f-8257-648df743fea5@web.de>
Date: Fri, 1 Dec 2023 12:57:38 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, allen.lkml@gmail.com, conor@kernel.org,
 f.fainelli@gmail.com, jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
 linux@roeck-us.net, lkft-triage@lists.linaro.org, patches@kernelci.org,
 patches@lists.linux.dev, pavel@denx.de, rwarsow@gmx.de, shuah@kernel.org,
 srw@sladewatkins.net, sudipm.mukherjee@gmail.com,
 torvalds@linux-foundation.org, =?UTF-8?B?VG9tw6HFoSBHbG96YXI=?=
 <tglozar@gmail.com>
References: <20231130162140.298098091@linuxfoundation.org>
Subject: Re: [PATCH 6.6 000/112] 6.6.4-rc1 review
Content-Language: en-US
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:vO3kcCo23/2y0qzIqtOculOADMQRLKmDm+YZtmZihAl4BMiGtHC
 2nmYzRlvsE6irpHQyszX5m6y5evydd02VuqwpzDD7rYe8eUJpUp+ejEPQP7J1/XlMDOvGe9
 HKfyAMPoNgzPwNP6KrVBJ8z4tlHspSdaIkXZzw3rntjkGrU8rilvB7C/PqVF5moKQAWTCbw
 +CgKSH3G/PHUdFUf1LH3w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:9cNMZsEruAE=;/mD74C7Rk567QqMZlxlMk8f2ve/
 wIONqcahMui+nQPERBNJV/suGRrvb8rTvyF6xvb1ojiU/uQvfQaGrqMXouw+q0O9AlFhgTIBY
 Kazsyeqo2W9ZQXTMJs/W+TwAW94TF1MdXq/C5AUGJC4V4KiMWeUGAh1R6EOH8BClLmmFA0GzY
 nbSAdVSilrD89nv2vcrh0Dxd+nVlWbi4yodEcRrK2faLRitadodpj3AtyTcNXdqAFxGX79TBj
 +M4uRXnJuz5EUleGVpWb2x9l1z3ANtwwdjlRX0hgzVLrOG9WKZU0j+5HdFraXer7OHJLw7Z1l
 7qgLEUslhwCF0fgWdSy3dsB4tGgslEorse6+4Sm1C4fSFKq3xC/iuDjWq2KbwjAUF6RVSk28+
 c4ClSuWdb2fNOT3U48HdihIRobPXMv1Rifqop+2Ns6VSs1gCnb65GYPz3tAoVzfgadK0ihUV6
 8JVuMfxJ1ufFw52o1rBUOIf3TyKbpszm+r9Hi+8Crn/YSTmcn+nqbjG4eqoSlVAxiOqV2po0t
 LuL58YFfN1KpA/QqshShBhFipoa/aiwwQsLebtCUVFWbCXfWfzOvlNOgIdw0Ge0Zo2TEBhDSH
 GugvsaXxLjNIuSOVImc9eySHVcOJQMfEEjC53F0pTjSWMoEelrcnVTUarvapDrtVN17HlzS8u
 JQvvPcOiCqj1yInKcFOaMZDqBa42byht252Gn+Cs2bcM/X0gtP/83KyDvT+PFvtwoyyM6nfRf
 5+yBQzbfyfg7UiKsBg6On3sOmORf5pbpmrL9PQjpV05Gc0MvkJZSMIR8DmZmIMlPZGDGl6N68
 gIBqfN045fwgnOR0fz+qLSejXJ8mY9i6xIFTwvEmtHxMOlPCWJrycQGV0XHy/VX1M/0rOTCrm
 flDDAaiUEhl7nO7bWb7+emNR8Ttfro+dCC13TL2Zem4mkFKkLwTEPX9yeag97XTdMjzSafj8p
 1iequOByCyL9x750krYxrRMR2O4=

Hi there,

6.6.4-rc1

...cross-built (on amd64 w/gcc-13.2.0) and booted successfully on ia64
(rx2620).

Tested-by: Frank Scheiner <frank.scheiner@web.de>

Cheers,
Frank
