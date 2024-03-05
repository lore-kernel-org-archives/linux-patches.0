Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FBF50A69
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 09:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709630523; cv=none; b=FuB2Pylc9ARvr5tV/GX5FEoaXD6wSKgdkTnBOpq7kbHXCdUMzcf+h6hhCKjzxYZF81nr0yCpukg1FzQTL7koHutQ8ev24qUwaRiqw66auI1Uc7Fd0Ozy08jH5xsc7fDj9RS9LJqpKNORgGAVaTkdv3fIzjuEb0FWu9p64z9L0aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709630523; c=relaxed/simple;
	bh=ZeNuJPQ+nG9eWeW+uI94bP8CSXc+K94oGgi2JBIGUsE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=claquZGPWBF/4QmxW+d+vpd5y8qhl7tDECLz0zpGj9McFkcTxHF2UHXK71C5vjAxLQV14yqVLx6Zbtka4t3huYnTRLgtzOi3okhG40QBSSnUvn7xaH6Sa1O6nQQXXeY0ApdWLFL+/Mwm+H+KDhtmjq8ZNl/PkymhP4HQq8h/g3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P/Gn+c7w; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P/Gn+c7w"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3c1a172e46bso4250003b6e.3
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 01:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709630521; x=1710235321; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IqYZUusP9B2YtwcxRV+KZs/6sQl0lkghKCYzEJXgvtc=;
        b=P/Gn+c7wUH96z4wrghUNMw1GVSN54lwuJWk0G2wKZLndnOe8BVqIDVpa49Q7cK/u+j
         uHjjoxUNtxV6eMHsxzrzQPU3BkKSXWC//y+p7jjxSBgACuoKjF/w6MoyfW9Od4HvPQy4
         GvmQThiVBiMZGad0bY9tBwWqZVBi6yqFvseq/BPrBzeC1z33HD5WTOiwnEBh71VGDE0Q
         v9gQmBE03vaDdaXAuArVlgi0JE3kAZhOoe8jCiimo4sDf7oAqle+GxV+tif3xnvp8Bx4
         RL5YZZCmTmr0HEZ4bHNYs6aicctVR9Rm9Qyys+ABaK1y1pP6Di1Qo1HOezEplN5CowxV
         IvmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709630521; x=1710235321;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IqYZUusP9B2YtwcxRV+KZs/6sQl0lkghKCYzEJXgvtc=;
        b=jNBGa5vHWxGXRV84YMwMDndhsgf2kRnML4ITi7in9Qp5kEZpN9V2n/zQaM8ZBp12cw
         cWhmFZvGcEJghytOVQ1z7SNqTGzwYbM2qV86//R40YI/eKx1bNtv4nYjpX8pcOtywOIe
         9e55EzOxwG1p+rHL7EvK2vPGcwuLXu7r8uKLk/7g7TUw+hdHfPWZLJeUxYk4Ua1kdjVl
         dST2OGEV6PayxlcTpvpuSb1Lr0IjWjkIGB2WVEFW4D1xc2lkyVynkSgHvOxEU690L6fy
         ujiLmzpAIKyC1l6G0Edhg64LGrKZ6XxipD7C5Ky8FUFEPxXKYX5SoNDD6uHancTO4rlF
         2pHg==
X-Forwarded-Encrypted: i=1; AJvYcCUjRz7Kp9DbQ3tSMfCAnm3lIxGrZnmbrYmNbLbYLhCR4RF4emj8CzCY4d26A5UgVeVqlR/1aiy4EMF6LV+RR2+kG2pe0CrpVw==
X-Gm-Message-State: AOJu0YxkMZeUt4mXoYeOPn7ohofx4lSXYjZvo6caLeB8NtWAll3xYjs5
	1ruPXONPeCbZ//L3nki5O2Nn8NS3XrXIyxrVlsGGd63NlCikVUtP+Gk9Z5r4wXssw998OLs/vK+
	BDviCPqaGNaoaz78MSwi+DO69a80=
X-Google-Smtp-Source: AGHT+IFb5h9idRuSrhk/ddWjyydEiB5p8kHuagvuZ+oVcTP7d8TjvVq+EvFccBn7ki8Ef8WK1CbEx2ys9KLaoX76gsM=
X-Received: by 2002:a05:6870:4f08:b0:221:14e3:7f6e with SMTP id
 xi8-20020a0568704f0800b0022114e37f6emr1365197oab.46.1709630520805; Tue, 05
 Mar 2024 01:22:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240305074649.580820283@linuxfoundation.org> <20240305-arson-panhandle-afa453ccb0aa@wendy>
 <CADo9pHg4teVS7Lt1j+gOt4G9U=dZF9G92AUK=Km6PTdURkc0pg@mail.gmail.com> <20240305-series-flogging-e359bae88efd@wendy>
In-Reply-To: <20240305-series-flogging-e359bae88efd@wendy>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Tue, 5 Mar 2024 10:21:46 +0100
Message-ID: <CADo9pHh6fnOz7d6+WCwkKz6_T4Ahru=0YDuc6q+KNnKYqQ2gBg@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/163] 6.7.9-rc2 review
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

Den tis 5 mars 2024 kl 10:20 skrev Conor Dooley <conor.dooley@microchip.com>:
>
> On Tue, Mar 05, 2024 at 10:07:37AM +0100, Luna Jernberg wrote:
> > Den tis 5 mars 2024 kl 09:32 skrev Conor Dooley <conor.dooley@microchip.com>:
> > >
> > > On Tue, Mar 05, 2024 at 07:58:57AM +0000, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.7.9 release.
> > > > There are 163 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Thu, 07 Mar 2024 07:46:26 +0000.
> > > > Anything received after that time might be too late.
> > >
> > > > Samuel Holland <samuel.holland@sifive.com>
> > > >     riscv: Save/restore envcfg CSR during CPU suspend
> > > >
> > > > Samuel Holland <samuel.holland@sifive.com>
> > > >     riscv: Add a custom ISA extension for the [ms]envcfg CSR
> > >
> > > I left a comment in response to the off-list email about this patch,
> > > I don't think it's gonna work as the number this custom extension has
> > > been given exceeds the max in 6.7/
> > >
> > > Cheers,
> > > Conor.
> > >
> > > >
> > > > Samuel Holland <samuel.holland@sifive.com>
> > > >     riscv: Fix enabling cbo.zero when running in M-mode
> >
> > Works fine on my Arch Linux desktop with model name    : AMD Ryzen 5
> > 5600 6-Core Processor
> > after the Arch Linux manual intervention for new mkinitcpio settings
> > and version in Arch
> >
> > Tested by: Luna Jernberg <droidbittin@gmail.com>
>
> This problem is riscv only, your x86 machine should not be affected
> by it.
>
> Thanks,
> Conor.

Ah alright then i know, did feel like compiling the latest test kernel
anyways, but thanks for the heads up
