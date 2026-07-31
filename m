Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D433B583A
	for <patches@lists.linux.dev>; Fri, 31 Jul 2026 17:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785519495; cv=none; b=Qy0kGL5FBhi7HC/SdiyLtkhG1wsPsdeQ7q2EEnA7YnHKZAvjhVT9+/t+4nkv+zKFAmDk35XLH0++bq0+GyUdQcVHUj4rkon8HMP5LWwZ1csGm3uGYip3lqU+XQXh0sCW/Mx5Qhjre0QvnYfJyLUGqrETaWMV+UNAWTl6tYcueMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785519495; c=relaxed/simple;
	bh=SP1t/meSCf1UwuWkhLU3WAH0N8ahxwGLn3zz+i1J4Qw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HWwqvaKDrCeWJexWLgXotlss/zjVGB7eRBBr+NJDXh1wLN+ne7/A9rHOv7G2KlPNVqPgWzzgFsxNKuI284+7EZFTjYHOtmhvxrOmrKTonalbSqd5PHvH0Jcx3J8U/H3v0beGEfmI3LA5Z9PRR7Ax1YTTlILCTTP7dCou3B4NS4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b=pYKJ0q6Z; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=frank.scheiner@web.de header.b="pYKJ0q6Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1785519482; x=1786124282; i=frank.scheiner@web.de;
	bh=qRhfvb0OBEN+JpNXDdflrzzJ0QPp3DM/77vWD28FQdc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=pYKJ0q6ZSq/1t0WeeVG1UDOZMQ9EY0MsA8maXGDMOvjE7TaJmrGJhZXXqPlYyfG0
	 hc5JT/iF7L+nBsde2vQjbvxZxab9HitU95iwzC4F3sUY5mv3wGn4LqK91knHcATQC
	 STwRgbJ/cCAHha0PWbiOhiMmUiPGPCimLbiq1M0K+52HluqrDrAovei81OG5C3PSa
	 NB3/WaGjmN4JXElmOUpjqUoknzFn41TDWPx+HvZhiQkeAR1n+bkfv5NbnQtC4yFqr
	 jNBEmQh4j4cQL6mbAj01lCEM6lKmSMNJ3hQxZ6curpGiXPj2CqobX1RUH7evdMDBL
	 uOdZ9GNcqx8ni2zRoQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MnX5T-1xFK1s4Alx-00ewuk; Fri, 31
 Jul 2026 19:38:02 +0200
Message-ID: <e2abbb8e-e222-49d5-bc58-6b5328490ac6@web.de>
Date: Fri, 31 Jul 2026 19:37:59 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/484] 6.6.148-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com, cc@epic-linux.org
References: <20260730141423.392222816@linuxfoundation.org>
From: Frank Scheiner <frank.scheiner@web.de>
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:FEYUekhiUTkdRUPQP4RPpnr8Ry1LQUNUDFGd2/97EIkFIPinsnZ
 ftDcCFtnoni022J+1Yz5g4+OkHFrSRk1Sq5/BQiRGplRitMMq3yXMbMr3ZR6RwawrjlzhR0
 4sxQbJK+4XvKFUTZPtYLQzglyj+RvCd+sTrqOpZK7axBGA2qOYPVzu9pmuZJvAPu0Awka4b
 quBkr7TVYFNp9OBNItw4A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:mNjMo79OPj8=;4FwpeExWd9fS23rGm981dmu817/
 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
 QeSAd4wM7Yuqvl1EJ4JbpEnRKujEw8j1NA==

On 30.07.26 16:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.148 release.
> There are 484 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Sat, 01 Aug 2026 14:13:41 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.14=
8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.gi=
t linux-6.6.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

I didn't notice earlier, but we now seem to have a mirrored version of
the build problem described for 6.6.145-rc2 ([1]) earlier:

from: https://github.com/linux-ia64/linux-stable-rc/actions/runs/306081725=
60/job/91087240301#step:8:3099
```
drivers/cpufreq/ia64-acpi-cpufreq.c:327:27: error: initialization of 'int =
(*)(struct cpufreq_policy *)' from incompatible pointer type 'void (*)(str=
uct cpufreq_policy *)' [-Wincompatible-pointer-types]
  327 |         .exit           =3D acpi_cpufreq_cpu_exit,
      |                           ^~~~~~~~~~~~~~~~~~~~~
drivers/cpufreq/ia64-acpi-cpufreq.c:327:27: note: (near initialization for=
 'acpi_cpufreq_driver.exit')
make[6]: *** [scripts/Makefile.build:243: drivers/cpufreq/ia64-acpi-cpufre=
q.o] Error 1
make[5]: *** [scripts/Makefile.build:480: drivers/cpufreq] Error 2
make[5]: *** Waiting for unfinished jobs....
```

[1]: https://lore.kernel.org/stable/88255dcb-acac-4a74-a086-b686aaf15eca@w=
eb.de/

Looking into the released 6.6.145 ([2]) the patch "cpufreq: Make
cpufreq_driver->exit() return void" ([3]) that created the original
problem for the ia64 buld in 6.6.145-rc1 and -rc2 was gone in the
released 6.6.145.

[2]: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.g=
it/commit/?id=3D01f5e56c58488ddef1a0a7bc2102bab9cf0031f9

[3]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3Db4b1ddc9dfe997a5f492fa3a36487f8e7a5de30d

Hence the patch which replays that change also for ia64 needs to go now,
too.

Short of an upstream commit for this patch, I can only point you to the
patch in:

* linux-stable-rc:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
/commit/?h=3Dlinux-6.6.y&id=3Dbb51b626b5a8ef349b11876572540f19ad4d5030

* stable:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=
=3Dlinux-6.6.y&id=3Dbb51b626b5a8ef349b11876572540f19ad4d5030

* stable-queue:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/co=
mmit/?id=3D8b7e20cd309ee12f5916f0fa96569fcd0484551f

..., you decide what you prefer. HTH.

Cheers,
Frank

P.S.
Would the patch from us have been dropped automatically with [3] if ours
had contained a `Fixes: b4b1ddc9dfe997a5f492fa3a36487f8e7a5de30d
("cpufreq: Make cpufreq_driver->exit() return void")` tag maybe?

