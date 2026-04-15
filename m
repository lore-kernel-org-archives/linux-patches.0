Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA22732E75A
	for <patches@lists.linux.dev>; Wed, 15 Apr 2026 10:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776247976; cv=pass; b=AiiqO2vr15J61KXVTXoeUJgqUUIeI5k2uUMZLArFA4Om/0CNpby17jisXToqaGFD9/r1Kz7CqDaLFhUK7MjVM7DYZjovMakBMF47UnOIXbcMZdC+DJmyVZJ7iWGLy020MVasUvFUiRt96+Tz5g3VWqP3xIaJ5bfXoWz7jjoQYuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776247976; c=relaxed/simple;
	bh=DdahS6NFA8addLQ15dt8IgNDZQRJvhem7ozkgtNq6no=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E7in6EVi/gf4MjThQtH+bSBcxj5kb9Vd2D/Ft1NEbJ74D/9gaMVfKvPQ94YX1nk2DBKIFkmkdImMXw1rG5mEgRMAY97E2DoVDrCkjkJg/lmfxL0IjLoP5Go7cbtfr3HeaYHCAkPozY403YXt5LxKQBs/gsyNxqbp7s/jVeT/cWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VeU4t5bL; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VeU4t5bL"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50d8e11b948so65572061cf.3
        for <patches@lists.linux.dev>; Wed, 15 Apr 2026 03:12:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776247974; cv=none;
        d=google.com; s=arc-20240605;
        b=K3QN224IJoEM5PqREfBjY6hRTT4t3feuXdmJo2HaZ2v+hJhp7cqdWtVAmX2A0H0Wqy
         UWxLY+ma/K9UjgttA9jrhQsuZgGQy3bennOS/BiFAYTtwppMfbdaXwRrFhPnOZbXv3tG
         oYYGhZKzqlII4iGEEofdbghG7KY3WA6iweL8WkIc0P5CjQpIhb0YBRVdbO8V9jyy8EVg
         t/FeSXoToOSsHGBfIDROVA9alfeavEB8ep/FiN9V4GP66N/UrTR8eWnHHzadnLJKzZE/
         T1GcZCVqSNr2FAkaGBUNXNouWOGI5VKRO8+El/fnMg4iZMv0UteqMD+QSOQGRdI9kDST
         iEjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DuO9FvSZkadUAwRXym27+2dxsKsK31QJ4IEQ9nlRlwE=;
        fh=Ae5u0nVLwrxcEgzLvYaWOJtjdYiaUi67VdYig0+rP5E=;
        b=VLgvkcTeMq98OGSl8YROpG8PuYxmJ3R9XFNBQEvRgo8wsYQfD7jjg3ZPw67l+fSuUQ
         Cr6DeRFXN+F0zhftCQ3uLGW7QwvLswVoAKQJ0OjVAj/TniS/DJ+FHzcY7GQqxV3bKqhg
         eZ71FOLy+uhOyBtD+mdQZXJPaLlxKSelz5fcst1wlG2vdXYY7gIwKG/cKkMkfjB3swvW
         3yZWIGAL4SEjvx413PMNZIg4agqkNwluiT6KfLEZjxI2UsJ9R+gb2u/lINk4nPj/s+B0
         hhmeUwGWvADjO8itkjPmkm6LbnxJD3LRj3Rs/foQ5QjYWWd1MTe+q57ArIDbCE0DTnwr
         UJtw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1776247974; x=1776852774; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DuO9FvSZkadUAwRXym27+2dxsKsK31QJ4IEQ9nlRlwE=;
        b=VeU4t5bLu1ZePlqiLouEavSGag8uOrHyRUWGqY2quVUtZMtc57qO/6MXfD4hUHCcBJ
         yb+VAeIO3UIluIonhKJf9qK+w7WFCjqHMB8FOhjBWduij6wR9D+AaqjJv38+aFkHOn1H
         h+Pl8LfB9IKy3AgIVuB843Pi6NUR794EfSSd233OD01+i4YKKxKOu9E3Ci21bOdnV3+i
         FF8diVozVzji1y+NL0HJ3F8YRNiLAgxjqM8QnhWtvjBB/ZXI54CU6e5+DIuuWHZryn2j
         lG91HeZGkyePmO5ZPq5OiICwZ7GeqgQlLaXkwkZ1oDFej2rklrr+PY3e1fsBckEE4OTW
         V33g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776247974; x=1776852774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DuO9FvSZkadUAwRXym27+2dxsKsK31QJ4IEQ9nlRlwE=;
        b=h/IVWsaO+Pk9GNkVpQhfLfx/0nFVPf6wKTa1ZMaxwKuU2rxYKB0IDkZyZKf97t4laX
         kB64dk6IUOJhOgux4yhL+2BcJKUnO1Gb8yStv08B58P/LvUcsAxpUAhjWDZTra0uCZc9
         2qlsc3w9sSe78Nujl6FwWQiSBBePdsz+J/ljuGPxasaNeUB2ctoqElGzWx+hXtHrDgEi
         mCKhNU2hpV8fR2muny36nmIAiOyD/DBOoyG2GiUJ/UW/3qCJbGhOK8EfqvuEGvh5rY5V
         0PtNtHi2RPgztm7NACbSDaeZgIlpM7vr80mSdFNgxM+guFIfcZ6TpnaNOWoG9Yz0HINZ
         3bVQ==
X-Forwarded-Encrypted: i=1; AFNElJ8WaICTVwrCP3QQs+Q5+WjoJCdpAH5Xej5LOSNX5rI01kIX1xOB5DW1A39YqC2EJsbIi0SZ10NY@lists.linux.dev
X-Gm-Message-State: AOJu0YxhlI+obROq/5JuIPqhmL7TAZxM9XJOiH1JjXDEyl/i4ZnAyAkj
	vJXs6jZHz8QepCfB9+eqfhf5RViPzGtXXbIrr4x3xGwCL3VyAXDFFjQvQIIkCBFJIxkkLFwFELd
	lXjgv0NID4Ln+KO28hkBZeqDXEiTsXa708sBN60/w
X-Gm-Gg: AeBDieur+pJFIyRz9zoXSRqE/QV3DOWTPHU6C2eUqQsbPMB+xxsQwxcqTYWXNAVv/Rj
	Sd9F4XIV7BDgwGM+LoFA+06X0H8tKYqploWWXWX9yCsZfRXczhN3iyrMto1EL74c32wCtvURZC8
	Oqb/ObmYZZOydC/mupxDKRLIGJIL38CdIDTJhbrieF6W1rD8akUx6LDskDa4IktesMQFszxDkLh
	F/9YSF2sWELiFwgc1k3zWzHGFmO3X6BNZkh5lQOrJWuCfLdudCicBHE60BYdBrhQeJoKQNsyTL9
	4TFCANEEcmXQuiXnO2HBF8G4yay7gF4AD+I9Nxb01A83iOBbXzXQ0kmcEmRXLQMFUJdeybhp3SN
	pM+0/BA==
X-Received: by 2002:a05:622a:8f0f:b0:50b:829e:44fe with SMTP id
 d75a77b69052e-50dd5b78300mr203234711cf.37.1776247973752; Wed, 15 Apr 2026
 03:12:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260413155819.042779211@linuxfoundation.org> <39e878af-7418-4538-9e1f-8b62de3d1e3f@nvidia.com>
 <ad30ns8QQDzk0h72@duo.ucw.cz> <CAL0q8a65x5mK2K+X8bY3sPrG8JMhbN7uDMje7JJNvvmzaR_SiQ@mail.gmail.com>
In-Reply-To: <CAL0q8a65x5mK2K+X8bY3sPrG8JMhbN7uDMje7JJNvvmzaR_SiQ@mail.gmail.com>
From: Ben Copeland <ben.copeland@linaro.org>
Date: Wed, 15 Apr 2026 11:12:41 +0100
X-Gm-Features: AQROBzBmv8xSDQo_D9z12jerqYxBHpNQPkITfqnvrSa7GbRNuXRIzFi-Jji2tDU
Message-ID: <CAL0q8a5GS3EijNNBLJmAy_gQKfjGTdbLWQqGcvzYNuATj+rT8Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/491] 5.10.253-rc1 review
To: Pavel Machek <pavel@nabladev.com>
Cc: Jon Hunter <jonathanh@nvidia.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	sr@sladewatkins.com, 
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Apr 2026 at 06:49, Ben Copeland <ben.copeland@linaro.org> wrote:
>
> On Tue, 14 Apr 2026 at 09:03, Pavel Machek <pavel@nabladev.com> wrote:
> >
> > On Mon 2026-04-13 19:52:08, Jon Hunter wrote:
> > > Hi Greg,
> > >
> > > On 13/04/2026 16:54, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.10.253 relea=
se.
> > > > There are 491 patches in this series, all will be posted as a respo=
nse
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > > >
> > > > Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.10.253-rc1.gz
> > > > or in the git tree and branch at:
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.10.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > >
> > > > -------------
> > > > Pseudo-Shortlog of commits:
> > >
> > > ...
> > > > Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> > > >      bus: omap-ocp2scp: Convert to platform remove callback returni=
ng void
> > >
> > >
> > > I am seeing the following build error due to the above change on ARM =
platforms ...
> > >
> > > drivers/bus/omap-ocp2scp.c:95:10: error: 'struct platform_driver' has=
 no member named 'remove_new'; did you mean 'remove'?
> > >    95 |         .remove_new     =3D omap_ocp2scp_remove,
> > >       |          ^~~~~~~~~~
> > >       |          remove
> > > drivers/bus/omap-ocp2scp.c:95:27: error: initialization of 'int (*)(s=
truct platform_device *)' from incompatible pointer type 'void (*)(struct p=
latform_device *)' [-Werror=3Dincompatible-pointer-types]
> > >    95 |         .remove_new     =3D omap_ocp2scp_remove,
> > >       |                           ^~~~~~~~~~~~~~~~~~~
> > >
> >
> > We see that one, too:
> >
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/13=
901155305
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelin=
es/2450043152
> >
> > Best regards,
>
> This was also observed on KernelCI:
>
> https://dashboard.kernelci.org/tree/stable-rc/linux-5.10.y/0abb5988a311f0=
e617615aa4b08c90b3ade85c25?df%7Ca%7Carm=3Dtrue
>
> The two issues:
>
> https://dashboard.kernelci.org/issue/maestro%3A67d434ff5d6b71886d45efe758=
ca00ff45cb969a?iv=3D1
> https://dashboard.kernelci.org/issue/maestro%3Ac970827f049cfd67124148e3c1=
9abe1d4aa8347a?iv=3D1

I bisected it to # first bad commit:
[708f670c8e0849525742cc3a1ce319739fe74c26] bus: omap-ocp2scp: Convert
to platform remove callback returning void

Here is the log:

# bad: [0abb5988a311f0e617615aa4b08c90b3ade85c25] Linux 5.10.253-rc1
# good: [fbb1715e3efa70ec20c5b1f755f3301fd3d042eb] Linux 5.10.252
git bisect start '0abb5988a311' 'v5.10.252'
# bad: [0cbe44da7c41f095b72fb599410d0530ca80a9aa] ASoC: soc-core: move
snd_soc_runtime_set_dai_fmt() to upside
git bisect bad 0cbe44da7c41f095b72fb599410d0530ca80a9aa
# bad: [9b7ae0b9077850af955e1c8c976808feb269cc44] net: Handle
napi_schedule() calls from non-interrupt
git bisect bad 9b7ae0b9077850af955e1c8c976808feb269cc44
# bad: [eb39b81e0f85135e1e5a39b6c7bfbec77e03467b] sh: platform_early:
remove pdev->driver_override check
git bisect bad eb39b81e0f85135e1e5a39b6c7bfbec77e03467b
# bad: [a1ea84bad7500d1e346bf3714850c5a32c4d5c51] net: qrtr: Add GFP
flags parameter to qrtr_alloc_ctrl_packet
git bisect bad a1ea84bad7500d1e346bf3714850c5a32c4d5c51
# bad: [e6613448c424bc28ca19cad1e56295ae101cd9c4] usb: gadget:
dummy_hcd: fix premature URB completion when ZLP follows partial
transfer
git bisect bad e6613448c424bc28ca19cad1e56295ae101cd9c4
# good: [0f8c01ecc1771e45d065f17df934c2bdc4d6a825] drm/tegra: dsi: fix
device leak on probe
git bisect good 0f8c01ecc1771e45d065f17df934c2bdc4d6a825
# bad: [5a490afd6710b438b7fab854128d34e05e60c4bf] can: ucan: Fix
infinite loop from zero-length messages
git bisect bad 5a490afd6710b438b7fab854128d34e05e60c4bf
# bad: [5ec032ae50ff9959dccf12ccf0438c4b03032e2b] can: mcp251x: fix
deadlock in error path of mcp251x_open
git bisect bad 5ec032ae50ff9959dccf12ccf0438c4b03032e2b
# bad: [e2f4d521f05adb048145737f4f87125ab0452f25] scsi: storvsc: Fix
scheduling while atomic on PREEMPT_RT
git bisect bad e2f4d521f05adb048145737f4f87125ab0452f25
# bad: [708f670c8e0849525742cc3a1ce319739fe74c26] bus: omap-ocp2scp:
Convert to platform remove callback returning void
git bisect bad 708f670c8e0849525742cc3a1ce319739fe74c26
# bad: [fd70655e816486140fd3b8d190e98bc0390d756b] clk: tegra:
tegra124-emc: fix device leak on set_rate()
git bisect bad fd70655e816486140fd3b8d190e98bc0390d756b
# bad: [7cea67d4c59e7351b459cef6aa062127a4501923] hwmon: (max16065)
Use READ/WRITE_ONCE to avoid compiler optimization induced race
git bisect bad 7cea67d4c59e7351b459cef6aa062127a4501923
# bad: [efed6d887792cb026aef5fe3b711583b56b8037f] net: arcnet:
com20020-pci: fix support for 2.5Mbit cards
git bisect bad efed6d887792cb026aef5fe3b711583b56b8037f
# bad: [dad08fee3e0e4c9c2103fe7538af96398f7a7567] net: usb: kaweth:
validate USB endpoints
git bisect bad dad08fee3e0e4c9c2103fe7538af96398f7a7567
# bad: [2529a8fc2f31887320b59699da52508055fba791] net: usb: pegasus:
validate USB endpoints
git bisect bad 2529a8fc2f31887320b59699da52508055fba791
# first bad commit: [708f670c8e0849525742cc3a1ce319739fe74c26] bus:
omap-ocp2scp: Convert to platform remove callback returning void


Regards,

Ben


>
> Regards
>
> Ben
>
> >                                                                        =
         Pavel
