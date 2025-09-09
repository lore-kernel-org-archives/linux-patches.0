Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F10343D8E
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757427513; cv=none; b=XnHYOSnRFVdJtvNoM0R4PL3KePkUs+yXKCYHvuZwUipIbXV3XExui2pawNNWviLNpRicZBjT0sWOPyy6T3XTuiVzozUe5xjjLbW+g4t6YFrayeLXGjrWKqt2HajFV2n7GTNoEt0+XzWGRufBahIe4Cac2DHdXU4dfkwpRWguQC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757427513; c=relaxed/simple;
	bh=VwaGSalmTnd9X03Tr6wOBFfCuOTcCNXRJiR2HIPuqsc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RUM6sptS0iN1pOD/QpSM48dudoz9SAqkEILZGL5l5MhjPZBxh1eLYIFukLwH0Jnn1hJB2x9eBwW5NuN2nx+/Dn0e6YwO9RcvHzHNzVCr1AAP0UWJA8/wfGWpuCPpP/pCc4glOcYmXiMeUtVTXC9El2XxprWjoB6Q9GFwhZHLntg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XzDLZCQe; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XzDLZCQe"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24b21006804so60966695ad.3
        for <patches@lists.linux.dev>; Tue, 09 Sep 2025 07:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757427510; x=1758032310; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zoeLKoDwjK6xqBtfTeAvIy0pYPkAc80c1vYBt2cZKrE=;
        b=XzDLZCQeCl9Kizc0q6ve/HPglwkKVaQzy3Mk8fALNfrLv3+9q8odDaGfU84twG9U4o
         LQ8rsKpONsV7z1rT2DeG8Y8fH8LS3WGWeDAqXD8BWRiSmU/oukETDnILpjQxu9ujBnww
         WxMvbVm0G6ax/qv4+P9BqXSRmR3UA+ktvPLcIK1N22ngVQ+pFOd0KKWHTekTa4dqOPN2
         jNnx/5mXEqoq+Q5E+vd4XJi13uIEVsPPRYprIhRCir9hi4GEICYEp9AdP5mjqRbhyPj1
         WxRHBNR4h7k2KG05c7gIkbkAbDI4UVB0oX8xOIyKWiwvZqvOPBFvzjYlpgEhzbZfDPIT
         2EPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757427510; x=1758032310;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zoeLKoDwjK6xqBtfTeAvIy0pYPkAc80c1vYBt2cZKrE=;
        b=Pi49hehFx5oIg3+sv6wshratVw/Eg0LmjYFb90SUGiRoUYP8saVT20f078Vkzj4QWt
         zIi3GY1ji93o1qr0HVV4GRns5sEj+zv+oU+Alr00qY5pF2i6/yUf1H2xtoUh+tq/jICJ
         b1GKk4noKst8gnpszIJtLnUAgymO5kOHwyoCuTJV/z8/rNx6zGNAgNpsMtjwMQqGqsFQ
         3tVioKwGdFtLsb3Hp6LV7KPJ4iAiCAN9JPmTaY0GgD/7YwWK0acWsS0m9yNmLR4u6jSB
         f4n3pzlynsHE3e2eVY4koTcxJXj8U/T7KrSwyQMRyioOM27j+dCy3Sp80O6VDzb0Lbsq
         EWEA==
X-Forwarded-Encrypted: i=1; AJvYcCV47AapN587X9pHtfOAzkLQl3FtOHbuZSl4SHHRiiQf7/lT9d/aadMZHzGcJDmCWxwmwzW066WD@lists.linux.dev
X-Gm-Message-State: AOJu0YwkpbXtviZEIUNk0UGeMmsnK/h4OC+rONE9VoDMKieHSBBAH0vZ
	mkaI3D1RCR83p8trItXs4EXiiFKaSO+F+AlnP9U19xRJkCuAiVQ4iaqNS/ZQOB1NzWIjpR1Xmrc
	ml4VUYrchnwQM5BAIbImJyIIqTShrPe8yp2nRwHcriA==
X-Gm-Gg: ASbGnct2/GPpr4P/DeF5gDfboT+Po9jOtIOiWM7FZ/0jtLUsYqROt8aNgMUhvOOigWG
	GUGYjKM9vM6h7tkDYLfWGWG2UDPK7cart7iEVBCJRAXLbWaqEkWBYX46u6clvcljD15wPtGlfxU
	Bt8p7oVinCHfHBYVK34z90KEJZfD87xykwKJq/ZO1ZHVE9UbUV4tMMv8QCD2NfIIkLhcf094lcQ
	uqPJZsYWTWA+Mrtir2EvZ6c675N1aKzO8IlE8UX+FpD2Mfb9qsqJmyVQohGTSKq70efuSz87pMo
	G2Ctvdw=
X-Google-Smtp-Source: AGHT+IHh4HOPmijlA/45Ds82kWFJee3dfMdyV+TppiDj9iodQ/RUx1HwiEqgdvNxgEwgPGcnXfLB9BNxwH16jvQOjmI=
X-Received: by 2002:a17:902:f78f:b0:248:ff5a:b768 with SMTP id
 d9443c01a7336-2516f05021amr131781565ad.10.1757427510278; Tue, 09 Sep 2025
 07:18:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250907195603.394640159@linuxfoundation.org> <CA+G9fYvQw_pdKz73GRytQas+ysZzRRu7u3dRHMcOhutvcE4rHA@mail.gmail.com>
 <2025090948-excuse-rebate-e496@gregkh>
In-Reply-To: <2025090948-excuse-rebate-e496@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 9 Sep 2025 19:48:18 +0530
X-Gm-Features: AS18NWC7gkmQdU-chaPVM86yKMvcaA9k41BDjODWDxD3Fa_J7L_tblddsNpoFN4
Message-ID: <CA+G9fYvXsG1veoK-i93J2BgymNauvOU_FpO6d7BhUBnMkuZVCA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/64] 5.15.192-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, 
	Anders Roxell <anders.roxell@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 Sept 2025 at 15:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Sep 08, 2025 at 11:54:56PM +0530, Naresh Kamboju wrote:
> > On Mon, 8 Sept 2025 at 01:43, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.15.192 release.
> > > There are 64 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.192-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > While building Linux stable-rc 5.15.192-rc1 the arm64 allyesconfig
> > builds failed.
> >
> > * arm64, build
> >   - gcc-12-allyesconfig
> >
> > Regression Analysis:
> > - New regression? yes
> > - Reproducibility? yes
> >
> > Build regression: stable-rc 5.15.192-rc1 arm64 allyesconfig
> > qede_main.c:199:35: error: initialization of void from incompatible
> > pointer
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > ### build log
> > drivers/net/ethernet/qlogic/qede/qede_main.c:199:35: error:
> > initialization of 'void (*)(void *, u16,  u16)' {aka 'void (*)(void *,
> > short unsigned int,  short unsigned int)'} from incompatible pointer
> > type 'void (*)(void *, void *, u8)' {aka 'void (*)(void *, void *,
> > unsigned char)'} [-Werror=incompatible-pointer-types]
> >   199 |                 .arfs_filter_op = qede_arfs_filter_op,
> >       |                                   ^~~~~~~~~~~~~~~~~~~
> >
> > This was reported on the Linux next-20250428 tag,
> > https://lore.kernel.org/all/CA+G9fYs+7-Jut2PM1Z8fXOkBaBuGt0WwTUvU=4cu2O8iQdwUYw@mail.gmail.com/
>
> Odd, I can't reproduce this here, and nothing has changed in this driver
> at all for this -rc cycle.  I see no one responded to the linux-next
> issue either, so any hints?

Please ignore this allyesconfig build failure for now on 5.15 and 5.10.
Seems like it is my local builder issue.

 - Naresh
