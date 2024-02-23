Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946EA143C67
	for <patches@lists.linux.dev>; Fri, 23 Feb 2024 18:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708712237; cv=none; b=K7erAbrI7ajePYTXEkaP8kT020pmziXafs030Mp5bFPhNhv21CkhZdXaHI7IeKY1+lqwo36g2gOUcgdzwK06w1uOtepYOdPFWfcCbdWti9lsSIuo03hodAbKhmyl2ooFhjjZOBE0zvgPBq4CgVnBMshpdpfNAIljTO8HCR5vlXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708712237; c=relaxed/simple;
	bh=1TaQyLnLQWa4xzlGMl4VRuz8CCdT4fApVc8elKczvLU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dxLbagMhWCEPVmoBG6h68X59cks3hfKHINuQ9PFm/EV3djhRCVkin9S5UztkmrYYVfNfvOPLUcgc37wL6rWkcLElCfVc5SLoanOC+WM6ha8mvwq6emIr3JHzt3t7qvalPq1HuLyjHlpT+8thbLLel/mGYHNwLZZh4gI9LccadSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PzGS5lJZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PzGS5lJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1472EC433B1
	for <patches@lists.linux.dev>; Fri, 23 Feb 2024 18:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708712237;
	bh=1TaQyLnLQWa4xzlGMl4VRuz8CCdT4fApVc8elKczvLU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PzGS5lJZFKajBhQA28OnjPbLn8f0WYXVCF/WAHYDI7cak3vKJOM3LkRQgJvNlRpag
	 YNWeP7IJoNSbj1T8FLbiI5yfAxrT7QFgWAnuLTajbXYtbLL5W4qEA9TmvnjKfuRVKO
	 1WnOX3VDVhBZws5CuuNSHWXxWT8ku+jXPwb8AH/BuhoasuhE793yagK5Jygu3advXS
	 9ytiKylf1R14hBlHBZS8QKNhqg25kmhDtFBY+9zw+NhZj80ckyJLZI7yE39gWPA4RD
	 hzZop//Po7dRpba0uORnQe5MgpNsJujHfDWaqVgp2Aq8eotXRUvS71jdSyhxdpI/sC
	 kAqqjF57jN4rg==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5101cd91017so1701807e87.2
        for <patches@lists.linux.dev>; Fri, 23 Feb 2024 10:17:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUIKyYdwTK7kRLJLB/j3kKHoi/01/px64p/kN6jQCGyzdUQdjQfnviAsJteKHcJnrUIPBYPczTvAoIG0GhY2mfLcOlpQFpLgg==
X-Gm-Message-State: AOJu0YwH+lV5F5/0Krq6Ap7xW0+fqtOIBXeihPY96+Ak88DCW18jSy1a
	lBuT9DyvdtGMbP8RkVaYetFi1KXfKlgUo7nVEKARDoFIXTVYr8gxtgKmQQofumco7I4N+OI1bCj
	hcaGcjm2Ea/5DIQKMVH3huldtVw==
X-Google-Smtp-Source: AGHT+IFnlf/NYg+53odk3xSf/t++OSDfbNnyCI3vytiLL/BpWyZMCTDy8ukEbtAnd0c2SbNSwHy+1Ji8o9g9IN5a9mg=
X-Received: by 2002:a05:6512:3741:b0:512:acc8:7c36 with SMTP id
 a1-20020a056512374100b00512acc87c36mr307071lfs.58.1708712235214; Fri, 23 Feb
 2024 10:17:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240217010557.2381548-1-sboyd@kernel.org> <20240217010557.2381548-6-sboyd@kernel.org>
 <20240223000317.GA3835346-robh@kernel.org> <20240223102345.GA10274@willie-the-truck>
In-Reply-To: <20240223102345.GA10274@willie-the-truck>
From: Rob Herring <robh@kernel.org>
Date: Fri, 23 Feb 2024 11:17:02 -0700
X-Gmail-Original-Message-ID: <CAL_JsqJSeSHeWV3YJE9n2NuY+s_iE6f7N5C_oguEJn7jTZ20xA@mail.gmail.com>
Message-ID: <CAL_JsqJSeSHeWV3YJE9n2NuY+s_iE6f7N5C_oguEJn7jTZ20xA@mail.gmail.com>
Subject: Re: [PATCH v4 5/7] arm64: Unconditionally call unflatten_device_tree()
To: Will Deacon <will@kernel.org>
Cc: Stephen Boyd <sboyd@kernel.org>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org, 
	devicetree@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 3:23=E2=80=AFAM Will Deacon <will@kernel.org> wrote=
:
>
> On Thu, Feb 22, 2024 at 05:03:17PM -0700, Rob Herring wrote:
> > On Fri, Feb 16, 2024 at 05:05:54PM -0800, Stephen Boyd wrote:
> > > Call this function unconditionally so that we can populate an empty D=
TB
> > > on platforms that don't boot with a firmware provided or builtin DTB.
> > > When ACPI is in use, unflatten_device_tree() ignores the
> > > 'initial_boot_params' pointer so the live DT on those systems won't b=
e
> > > whatever that's pointing to. Similarly, when kexec copies the DT data
> > > the previous kernel to the new one on ACPI systems,
> > > of_kexec_alloc_and_setup_fdt() will ignore the live DT (the empty roo=
t
> > > one) and copy the 'initial_boot_params' data.
> > >
> > > Cc: Rob Herring <robh+dt@kernel.org>
> > > Cc: Frank Rowand <frowand.list@gmail.com>
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Will Deacon <will@kernel.org>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Cc: <linux-arm-kernel@lists.infradead.org>
> > > Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> > > ---
> > >  arch/arm64/kernel/setup.c | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > Catalin, Will, Can I get an ack on this so I can take the series via th=
e
> > DT tree.
>
> Mark had strong pretty strong objections to this in version one:

Yes, I had concerns with it as well.

> https://lore.kernel.org/all/ZaZtbU9hre3YhZam@FVFF77S0Q05N/
>
> and this patch looks the same now as it did then. Did something else
> change?

Yes, that version unflattened the bootloader passed DT. Now within
unflatten_devicetree(), the bootloader DT is ignored if ACPI is
enabled and we unflatten an empty tree. That will prevent the kernel
getting 2 h/w descriptions if/when a platform does such a thing. Also,
kexec still uses the bootloader provided DT as before.

Rob
