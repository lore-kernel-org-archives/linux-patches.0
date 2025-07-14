Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5406F58210
	for <patches@lists.linux.dev>; Mon, 14 Jul 2025 19:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752522984; cv=none; b=PyLWHuTlqb/N+4C4tKnxJEn98a69lNGmOGLUwUEQ7d4Ta5YPPjlOmEVnlTbmV9AwoE6q0/2BB7qnpnmcoIsr/R6cvXysGxCI1TTCz6o1qdWyQZ0uz1wMi3eyDEZsG0rUeNB9LbZv0kKNpVhEq6ZKwiD42B03YNEMxkbMyJCDoPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752522984; c=relaxed/simple;
	bh=msrTOzkx3nVfxEF+cyCWrsAAKGHytXv//zdlie3Ckr4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O55xWZUgHCUdEJRl8k9jAFMSyHSrUvfILJO8DxoL9euaT+HhHUJO7VgIXX11hBu3GrtqDkpV8bwuffhPSPI61oOVYD4gKkUxY+gkFnCGGT7ZcCEVgYEtD7Q9oD3AzQfmxby2QFLk3yBlZ1lCSjRiBbAHGDTao11q2xZ/G+5zv9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lVy7jsH4; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lVy7jsH4"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-23636167b30so42957415ad.1
        for <patches@lists.linux.dev>; Mon, 14 Jul 2025 12:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1752522982; x=1753127782; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R8l3TuLeGRC12/isQU6yAP3w/Lelz62KKBJILK/IPuM=;
        b=lVy7jsH4EiBv3TVVFe2V67/p66hlJyGAkft5ynMQvwX3AbfUTvFn+Pa+D9jlSMRK0L
         ++M9dWzU0bypKo+zRq0pjS5oqduKc1rUvS3rKiCvZl5dF+euO4CO5IdCh/tY5UrKkmCa
         qS6RMpIkVcSxRELi9KH7E8kmAlsQUR6uUVJkJXE7vOgCq6cnnjmoBH22Mx6za7mAR3tB
         krcRLc++5yOTosbUhtdFiSpSuDxa71Rtho1hPhiHMb9LoCOt/zSfr3ZPXJz7+0M8BFhp
         DhV7Zk7A55PjXq2CV0vptHXY6/wZzqQQvNZgl98AvZNBGaiNQjVs3/HjhzrL4J7Qh/dS
         13KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752522982; x=1753127782;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R8l3TuLeGRC12/isQU6yAP3w/Lelz62KKBJILK/IPuM=;
        b=q7k/2hj1gulUZRmlj5Gl5fJHB/5S6nPfQVtryB6wIeQL34exVsYFQXJB6zRbqlnxtQ
         36jeFKlCl1/WXqAOvVCiZa5Vy7in6kLiby+2buHAEToD9aKVFBoXjnhhSjrtaZAc0UuB
         YgIjL9Grtnu+OYWPOcGT3hw7NAVvM3IP+4pfU8uvIPSy1APsH3K4V6GYNE9blZk+d/cF
         cGIyec1+ThEH+ovfUo+dEHocGZT7R+l76zp7OjfyNmuw0x+oANFuFKubcWWoH1/Qej96
         clpnH+P4t7XPOCj4bJZk6s0MlmiXwhwVGuJY4QfSYITbj8aQtZs9PEGoik2p2bOv8wqN
         F3DA==
X-Forwarded-Encrypted: i=1; AJvYcCUntHRj0WDW7j7DjuwnzPZBSKYsNZKOXOrP7hkF7Nd+endU3tZVYhx/IZNwWHmeX0zJV0TjAD0l@lists.linux.dev
X-Gm-Message-State: AOJu0YzTEYGXrQ9hlgB/ldpeISTdPwK6VTy2xdCdEmIq5DcHANjHshHP
	+zxvD32+GBao/eVjX2NyvU+crWGhNKgQZFAju/tYIsrOQ5VMZxQsE32sTSjLY5cLjExBDr6Ycfe
	+Mb6XIUNIz0WKlNdHBUlmtiHT/VAg9o4=
X-Gm-Gg: ASbGncvuE4SodchPkHpW7p7InQwwnxBOktUS8dYIvVuHdVye/NI4omKvYwt1XD6+kXG
	kYSUlqUcG4SzXAp2O5WiK3Tx7ou3p6MAY1FjQCAtUO/nGwP+EEu+qCsCh9fPYCqIt2WDpF+VBqG
	Mwq/NwY35N2N95HpXZwLt+2B4GXStkqOw0T0wIV0fM/VU9QJii5s8BN8URVW1bC/dwl0XFMGrBF
	RrxU6cSO5XNkkl6LqRkmZZzehtKyPOd8cKXqWmO
X-Google-Smtp-Source: AGHT+IEKcPO2dj8iuRmnxnt2knjE9fyHOUuiEh14mnU8le4Tje5sE5O+cSpiQaZ8gk8V5vL7ks0Ktg/2wNRtqQYal+I=
X-Received: by 2002:a17:902:e805:b0:234:c2e7:a0e4 with SMTP id
 d9443c01a7336-23dede2f317mr186119465ad.3.1752522982432; Mon, 14 Jul 2025
 12:56:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250623130632.993849527@linuxfoundation.org> <70823da1-a24d-4694-bf8a-68ca7f85e8a3@roeck-us.net>
 <CAFBinCD8MKFbqzG2ge5PFgU74bgZVhmCwCXt+1UK8b=QDndVuw@mail.gmail.com> <2025071238-decency-backboard-09dd@gregkh>
In-Reply-To: <2025071238-decency-backboard-09dd@gregkh>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Mon, 14 Jul 2025 21:56:11 +0200
X-Gm-Features: Ac12FXyfcdIioMVTiQL-1AbAhQ1x9Xhcwx1gMDfemUjWBrxju3vhXDvvescNI1M
Message-ID: <CAFBinCANe9oajzfZ_OGHoA-TtGC-CQdOm_O5TG8ke8m_NNE5NQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Sat, Jul 12, 2025 at 2:37=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jul 08, 2025 at 06:05:14PM +0200, Martin Blumenstingl wrote:
> > Hi Guenter,
> >
> > On Mon, Jul 7, 2025 at 8:05=E2=80=AFPM Guenter Roeck <linux@roeck-us.ne=
t> wrote:
> > >
> > > On Mon, Jun 23, 2025 at 03:02:24PM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.15.186 relea=
se.
> > > > There are 411 patches in this series, all will be posted as a respo=
nse
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > > >
> > > > Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > ...
> > > > Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > > >     drm/meson: use unsigned long long / Hz for frequency types
> > > >
> > >
> > > This patch triggers:
> > >
> > > Building arm:allmodconfig ... failed
> > > --------------
> > > Error log:
> > > drivers/gpu/drm/meson/meson_vclk.c:399:17: error: this decimal consta=
nt is unsigned only in ISO C90 [-Werror]
> > >   399 |                 .pll_freq =3D 2970000000,
> > >
> > > and other similar problems. This is with gcc 13.4.0.
> > Sorry to hear that this is causing issues.
> > Are you only seeing this with the backport on top of 5.15 or also on
> > top of mainline or -next?
> >
> > If it's only for 5.15 then personally I'd be happy with just skipping
> > this patch (and the ones that depend on it).
>
> It's already merged, and I see these errors in the Android build reports
> now.  I think they've just disabled the driver entirely to get around it =
:(
Can you confirm that only 5.15 is affected - or do you also see
problems with other stable versions?

> > 5.15 is scheduled to be sunset in 16 months and I am not aware of many
> > people running Amlogic SoCs with mainline 5.15.
>
> Great, can we send a "CONFIG_BROKEN" patch for this then?
In my own words: you're asking for a patch for the next 5.15 release
which adds "depends on BROKEN" to the meson drm driver. Is this
correct?


Best regards,
Martin
