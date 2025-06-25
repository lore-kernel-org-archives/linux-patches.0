Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE8235280
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 04:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750826017; cv=none; b=c/YagCzZLin+EahnDKyJatX7miJV/QGzr4gVb3AVUnPhKdwn3psblIgClBnwK3lMfzKhCyHSIN5E/2tbX0ujVms+p0kcsawW0I2tQ/x+IdebjKCE+oHGKNyH3uQhiItH5Q+1YILKzkQryHKHoHX4KqQ3KZvA3RySPgTfMbiwGoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750826017; c=relaxed/simple;
	bh=suGpKOxJrw/x+Qw34YH9Wq5C5aeu6ITuVv0x3tIR8QU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BqkB4JVvTyvpIRFlEsTm4wf5MneTA7iswx0f2HmTqHOzHVn1NThji30e+us2W7gSUxsDj4dgQLOcWu18j8utCh7+apgx5/XgvYwgAS5MkMVO/mhgmDJRiDUYzwqHWzlYhYUCGtpj6JsqGqkldStInhd6F2WQYJs1eHbJx/Pgaz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FleRnr9B; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FleRnr9B"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-234c5b57557so67596525ad.3
        for <patches@lists.linux.dev>; Tue, 24 Jun 2025 21:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750826014; x=1751430814; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+gxLtLJHJekP2m5RDJO4GtXWgXu8wxWquk/PnbuibIg=;
        b=FleRnr9BH6zR53QhZ1fwsTr8QZrd7c64oktMlMzKenuH2InsFSQAqS6w/avpDKDCBn
         5ciBifld3JIuxlFsSbYIz/bttwZTNeF26Y33IYSTQkalek20TrQYIf057URp2qjDFXwq
         HCOE37+jjr/otTEG71xnTwlH54Y5K5m7hgOY10IKqfiwoS/iJwjUoQ9hCBPyjZ9ysWSs
         oqoVd2ZaBrMWyj8wC79wrLzKC8PMleCPQYqLl1uFxa56CaXqbot64PeTko+2TGVPD7Qs
         kkzwfa8XKSrFhwakc9kHCE7lsFEYFRXIM4OFhYodtP6wgfU4P6WcLK0YtW4gLSiKYly+
         9mQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750826014; x=1751430814;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+gxLtLJHJekP2m5RDJO4GtXWgXu8wxWquk/PnbuibIg=;
        b=nSOH0hMQKHaZQHn5TdewMHBxCNvUc0u2KIN5SThb2at4UrD75DnKEums/c+vTHDLZO
         2DgIS9ioSNp9IJgRoj62yRKDn0t6x829nKtSNj1TdFCQuSqornILiXXLweAyrVnewW+T
         SELWWCANmTwolwTUqGVMo/L7hVEW1zIdfSrYorrYZXyJ1SEgBhI2VyevoctP2Gou1s93
         ICr8wLks6nlYAv7Izo1Q/6sf8WfLQa4PJYCrBtgtxoNnpr/38AIj1HAokV2qyyJhuxHl
         yy27MJbwrgIekY2A/frV2kA84Frzw36M5zIc7TpM3VOhFtCmnMWjGfoFnx0AYIjIDSCU
         YM/w==
X-Forwarded-Encrypted: i=1; AJvYcCXPNc2MxX5/QRhRFwCWjHsF1UiaBlKXTwbpuu1PLJla1MAefesZXvN6hOV27S4DIg2xmfZrLa65@lists.linux.dev
X-Gm-Message-State: AOJu0YynDsXaJnvZoaxOYP2C4+cFyG7yBsU3Lve32ZhLW/w03yZij/nA
	Jy1nrJ82Yc+GFuzQtYDo1wdMtaLdfRJFBvyhVD0jF5ebNiCILDcnm1r5I0L88kStXUF504GXdit
	LAi+Ad566jX2n8JQ8mxB6T8VDttJFMvgD46iK5gfoSArgmBHWpxRgPe1KOQ==
X-Gm-Gg: ASbGncsTGi/+mnrJSjHXZNI2LV/F4+njBHHHAQk7Vc+70RmKo2PZgIqWruyrgJ1/30I
	xZSf2BFBcZgfl7jCAFGC0SrUAQo+xXbkC4FxdU3e6zxiIXQgNSnXgUpBYEHY/VVCcmHkESfxxAh
	uuFLTvxUi3/BGuVxd8q4J+Uou4QJdE+ehS/Eqc0U0IBw6m/sZ2xLzvx2CCv7mV2yN6wqCiYEAGc
	vx7
X-Google-Smtp-Source: AGHT+IGtaQJcYYKVhLp/50lPmuB48IV2mPVXAbLY+hiIPV/anQZIZHdY1a23C23NRxSz7f54xc9tE/nROguaPMm8/Tw=
X-Received: by 2002:a17:902:ec91:b0:235:7c6:ebbf with SMTP id
 d9443c01a7336-23824047541mr35763975ad.35.1750826014327; Tue, 24 Jun 2025
 21:33:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250623130611.896514667@linuxfoundation.org> <CA+G9fYvpJjhNDS1Knh0YLeZSXawx-F4LPM-0fMrPiVkyE=yjFw@mail.gmail.com>
 <2025062425-waggle-jaybird-ef83@gregkh>
In-Reply-To: <2025062425-waggle-jaybird-ef83@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 25 Jun 2025 10:03:22 +0530
X-Gm-Features: Ac12FXyd0V9F7KS0Td9Q-UYWV_cQw3EQwUvR1Vc5-PgNTQkt74Bhnhzxgl5WlkY
Message-ID: <CA+G9fYvNTO2kObFG9RcOOAkGrRa7rgTw+5P3gmbfzuodVj6owQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/222] 5.4.295-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	kvmarm@lists.cs.columbia.edu, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
	Julien Thierry <julien.thierry.kdev@gmail.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Russell King <linux@armlinux.org.uk>, Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Andy Gross <agross@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Jun 2025 at 15:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jun 24, 2025 at 12:46:15AM +0530, Naresh Kamboju wrote:
> > On Mon, 23 Jun 2025 at 18:40, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.4.295 release.
> > > There are 222 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Wed, 25 Jun 2025 13:05:50 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.295-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Regressions on arm defconfig builds with gcc-12 and clang failed on
> > the Linux stable-rc 5.4.295-rc1.
> >
> > Regressions found on arm
> > * arm, build
> >   - clang-20-axm55xx_defconfig
> >   - clang-20-defconfig
> >   - clang-20-lkftconfig
> >   - clang-20-lkftconfig-no-kselftest-frag
> >   - clang-nightly-axm55xx_defconfig
> >   - clang-nightly-defconfig
> >   - clang-nightly-lkftconfig
> >   - gcc-12-axm55xx_defconfig
> >   - gcc-12-defconfig
> >   - gcc-12-lkftconfig
> >   - gcc-12-lkftconfig-debug
> >   - gcc-12-lkftconfig-kasan
> >   - gcc-12-lkftconfig-kunit
> >   - gcc-12-lkftconfig-libgpiod
> >   - gcc-12-lkftconfig-no-kselftest-frag
> >   - gcc-12-lkftconfig-perf
> >   - gcc-12-lkftconfig-rcutorture
> >   - gcc-8-axm55xx_defconfig
> >   - gcc-8-defconfig
> >
> > Regression Analysis:
> >  - New regression? Yes
> >  - Reproducibility? Yes
> >
> > Build regression: stable-rc 5.4.295-rc1 arm kvm init.S Error selected
> > processor does not support `eret' in ARM mode
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> >
> > ## Build errors
> > arch/arm/kvm/init.S: Assembler messages:
> > arch/arm/kvm/init.S:109: Error: selected processor does not support
> > `eret' in ARM mode
> > arch/arm/kvm/init.S:116: Error: Banked registers are not available
> > with this architecture. -- `msr ELR_hyp,r1'
> > arch/arm/kvm/init.S:145: Error: selected processor does not support
> > `eret' in ARM mode
> > arch/arm/kvm/init.S:149: Error: selected processor does not support
> > `eret' in ARM mode
> > make[2]: *** [scripts/Makefile.build:345: arch/arm/kvm/init.o] Error 1
> >
> > and
> > /tmp/cc0RDxs9.s: Assembler messages:
> > /tmp/cc0RDxs9.s:45: Error: selected processor does not support `smc
> > #0' in ARM mode
> > /tmp/cc0RDxs9.s:94: Error: selected processor does not support `smc
> > #0' in ARM mode
> > /tmp/cc0RDxs9.s:160: Error: selected processor does not support `smc
> > #0' in ARM mode
> > /tmp/cc0RDxs9.s:296: Error: selected processor does not support `smc
> > #0' in ARM mode
> > make[3]: *** [/builds/linux/scripts/Makefile.build:262:
> > drivers/firmware/qcom_scm-32.o] Error 1
>
> That's odd, both clang and gcc don't like this?  Any chance you can do
> 'git bisect' to track down the offending commit?

The git bisection pointing to,

  kbuild: Update assembler calls to use proper flags and language target
  commit d5c8d6e0fa61401a729e9eb6a9c7077b2d3aebb0 upstream.

- Naresh

>
> thanks,
>
> greg k-h
