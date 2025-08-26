Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D616280327
	for <patches@lists.linux.dev>; Tue, 26 Aug 2025 17:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756228375; cv=none; b=L3SMxVnVghkSFXR1+5zi3qboaifGRIbmowCrElgfh8TQunyl2AMx81S1QRFSCuQ0zxvRwkZeXZhFYYuByOvIPgzZieb6OYucLP6bZFQkpX0i//MbJDKJkXGfX7WFPtVs/TLKlFdoEBEMMV+FaKYqTIL5qp33y2ZG7aozv3Nyej8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756228375; c=relaxed/simple;
	bh=Wl6hEAcjBCw0wkEsxYb8Q2g8em736QyR8FGC2G9x+0A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C++7vPqXtcF/gEyl+Ru6fz2zHD8tm/RQn31mN3UzrktpwzmfCmvTZUKif/vyITTyffKzvq9tHgRDsm+NUa83WHbLgHZ0k6jy4mumXMyz1UHPoI+HpzxwC1/XFhRTMONfbxE/1SteXEaM7p3/mMD0DG6F85pVk9ao+3KqHDso8No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r1Oyl45b; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r1Oyl45b"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-afcb7a16441so929487966b.2
        for <patches@lists.linux.dev>; Tue, 26 Aug 2025 10:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756228372; x=1756833172; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kmiQEbEAvOozmFqw9ji6oPoxgyycKFjBNvTezQZX36M=;
        b=r1Oyl45bXUEK7sUpYAN1u6Aw6KXwkUYMDHVUIe8B1d3jRsEno1eYX0YhG9yPd+RA4E
         a6SmigWwXlODap1M6XiAZ8+ovau/B5RZIgvdVTyd01fT016DhLJzxorNMjq5sFEtKpwI
         j27tuEFOb5yEeIzgaTScFc9khfjA2AbZve3tSsZEdheJwzaL4WSRhGlG7l2LkDRjvWV9
         jg3sMTLsZj+YKNWTUCwimQ/wCInziTrKg0HPiXSYUu4fHldr/KhhSe6oOBavNj5ShLSb
         2xwddd6QFWi6NBu2LYR8cPc8OogbjA7HOLlThxTuO7Cr6e1JirDtnupi79Q4MRZKp0jn
         Sq+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756228372; x=1756833172;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kmiQEbEAvOozmFqw9ji6oPoxgyycKFjBNvTezQZX36M=;
        b=Ix82FaebLLECM61Fvqx3SDGgI5imcmt/x2NuHVZTqNxor+EUIKfTWACqt+0Lce/zRk
         sa7ap8KfWHJ+MKmJjjPK6hEVAufHnC21ySaLGa/4RzycaRvd2HIeOxHToFXcUf6ulS1g
         lO7HSdFQvQ15kHanfNUii24lgdshrYG3UcMqtx6xpJCiiq/vTrcpph39h+p5F9e6aIEr
         X2Cngs/vt5j73nqa5zo3E6UYXiOnR5UXj1KOvXCKLkMu7oyIAF/S+ROGUAMLopvVi2yD
         D9MEvPOPHLhOk57RVN5QItf2UmMLmXVhkJeb1A93z3Fm+c3tcHFt+wBIJc1uEQDnALuA
         uZ+A==
X-Forwarded-Encrypted: i=1; AJvYcCUh/tDPmqsu0RhUbJJLRovaiYqWiH0xuE+r2vbv3a97FHzKTrXMFbE4+uc+bu8ssYSYPGo1VcAw@lists.linux.dev
X-Gm-Message-State: AOJu0Yz67fqCjTHCKOxsPPpZn8dkDSrzSo9XY5M6r7HzYZara2garQPj
	VzvOairV4hjXRr2RYsjXsvFLVhJWuq7pl7pj3gF7rhcM2jbjzrfcmXP3588k963PDoqLVSr2zZ3
	eKoX11Rz8UVZKjy8GXEZOv6uZfr12uDxDb+pqLpyVcQ==
X-Gm-Gg: ASbGncs6PYpYlI6bKvCKSidRyXiUk1kHQvvd5WgHQYXWRGOWCWgbObT9IAVklo/DSrg
	chBLtWRjtGswpb2av+kBzFUbjPOUb/aC5xJRcfGX7cQI4e4nG7jLnK/jzn1RxolUm837oWK+/gr
	8VTrZ5iyVarxYVSVyyJ1/pegD+Ay6WCffDTAhWr+vh20TvZmjRPhcaSdFwGhH5Oi2jh702sgDyd
	sDI1pltrDsODdpb0H533gMcDsZzprkh54BEpSE=
X-Google-Smtp-Source: AGHT+IFDZvNaU3eL+sPBd2g+8ckgsa/t5Cv1DlJOj7IrzVfzrcw4klg/uE7e1fiMAWwe/BWU80WL1sKNP8AidkFE6Go=
X-Received: by 2002:a17:907:3f0c:b0:af9:a2a9:b5f8 with SMTP id
 a640c23a62f3a-afe28fc1d5dmr1553038066b.18.1756228371757; Tue, 26 Aug 2025
 10:12:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250818124458.334548733@linuxfoundation.org> <CA+G9fYt5sknJ3jbebYZrqMRhbcLZKLCvTDHfg5feNnOpj-j9Wg@mail.gmail.com>
 <CA+G9fYt6SAsPo6TvfgtnDWHPHO2q7xfppGbCaW0JxpL50zqWew@mail.gmail.com>
 <CACMJSeu_DTVK=XtvaSD3Fj3aTXBJ5d-MpQMuysJYEFBNwznDqQ@mail.gmail.com>
 <2025081931-chump-uncurled-656b@gregkh> <CACMJSesMDcUM+bvmT76m2s05a+-T7NxGQwe72yS03zkEJ-KzCw@mail.gmail.com>
 <2025082612-energetic-lair-ee26@gregkh>
In-Reply-To: <2025082612-energetic-lair-ee26@gregkh>
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Date: Tue, 26 Aug 2025 19:12:40 +0200
X-Gm-Features: Ac12FXxkgjfxjtCqgbWi4lcdhlWZDxk1sUygzZJ-Vm9DflOQJnoV5kzUn5n4oQw
Message-ID: <CACMJSeshuCMDiKWBKYD9OB5QvZugkz-87EEu-yi2g+7UF+WUJg@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/515] 6.15.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	Ben Copeland <benjamin.copeland@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Bjorn Andersson <andersson@kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, srinivas.kandagatla@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 26 Aug 2025 at 16:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Aug 26, 2025 at 02:06:04PM +0200, Bartosz Golaszewski wrote:
> > On Tue, 19 Aug 2025 at 13:52, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Aug 19, 2025 at 01:30:46PM +0200, Bartosz Golaszewski wrote:
> > > > On Tue, 19 Aug 2025 at 12:02, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > > > >
> > > > > On Tue, 19 Aug 2025 at 00:18, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > > > > >
> > > > > >
> > > > > > Boot regression: stable-rc 6.15.11-rc1 arm64 Qualcomm Dragonboard 410c
> > > > > > Unable to handle kernel NULL pointer dereference
> > > > > > qcom_scm_shm_bridge_enable
> > > > >
> > > > > I have reverted the following patch and the regression got fixed.
> > > > >
> > > > > firmware: qcom: scm: initialize tzmem before marking SCM as available
> > > > >     [ Upstream commit 87be3e7a2d0030cda6314d2ec96b37991f636ccd ]
> > > > >
> > > >
> > > > Hi! I'm on vacation, I will look into this next week. I expect there
> > > > to be a fix on top of this commit.
> > >
> > > Ok, I'll go and drop this one from the queues now, thanks.
> > >
> > > greg k-h
> >
> > Hi!
> >
> > The issue was caused by only picking up commit 7ab36b51c6bee
> > ("firmware: qcom: scm: request the waitqueue irq *after* initializing
> > SCM") into stable, while the following four must be applied instead:
> >
> > 23972da96e1ee ("firmware: qcom: scm: remove unused arguments from SHM
> > bridge routines")
> > dc3f4e75c54c1 ("firmware: qcom: scm: take struct device as argument in
> > SHM bridge enable")
> > 87be3e7a2d003 ("firmware: qcom: scm: initialize tzmem before marking
> > SCM as available")
> > 7ab36b51c6bee ("firmware: qcom: scm: request the waitqueue irq *after*
> > initializing SCM")
>
> 6.15.y is long end-of-life, so is anything still to be done here?
>

The same applies to all other branches for which Naresh reported an
issue: 6.12, 6.15 and 6.16. I think only 6.16 is still relevant.

Bartosz
