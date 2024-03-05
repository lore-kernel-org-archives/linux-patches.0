Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DADE50272
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 09:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709631332; cv=none; b=JevQCa9kPmmoQR+EX3tHgzzmoaBkAXtIi0LEWdf1UULqh2Qm8al4LkitsegV7KBOP0fnNBTZ0ccJyYw+MylbUUpk5KcMWsDSM+/cd0luyscPvTsmkRBEOzJPNbCB9aVniNCnxjpSdd0ZI5GRbCB51BX24wx7BLaxBAz1VfO6Op4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709631332; c=relaxed/simple;
	bh=DHgXuAEmDJyMyUFnpe8rDA1XSXtYVi585YlAo3AOdD8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dGaiCf/OqXk3++7Gnmk2uVKszxv8c3w35RhZTaEznF614Scp5C/etQ81q1LoZ9L7jjGN97+psEQodfx9VN5A88I0oE0CuQRjRWNSampWgQ58AYmpBMcCTdrhZqLiUjOdjQOzXodcnUzEDHUehT7iLBI7Qjh4GAKnTiuqswi/kSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RL+j3QpU; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RL+j3QpU"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-21e8a740439so2486606fac.1
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 01:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709631330; x=1710236130; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qJ+TMPfkrk6Rwx5VIdBp/wiudj0mwYz48jbgJ44a/7A=;
        b=RL+j3QpUJ+vqG2qNEie8JjMH2S8F5U3F8bfaxzsdvthuKLKQcwZMQnqqfeBPsBXhu+
         RaDrvVct3HpzU84LtKBz6LktANO6PjtsBJbJPNsdIrr9/phLRQw8RzgsGUKI+W7Tw+pc
         BDKE6XGVE4nGm378pQ0KzA6QQzKtRKeuc/BGIzmNf3Kx/yTkB3s5gVoslfQbih3mwJ9c
         7zTRvi/egSx2ROq7wwhgsKPoLCPEb6IbpnL7vLLf0KJrEltFfXfmX/pEX3sav9TInuR1
         woNDYL5fuCdHt7XQyoebsyUO2ms8xrgR/w0baWzgaCQrNPTwoSYO6Xjg8D7MP0wQuMn3
         CUIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709631330; x=1710236130;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qJ+TMPfkrk6Rwx5VIdBp/wiudj0mwYz48jbgJ44a/7A=;
        b=cQ7rkMyA1nvOTgiqsGuetFmkyeIhjL0c6F70zk7GDvJHi9Bj9w0w4SUh4ehwkckiTJ
         CTBsvZqwOC6+g9+1V4PqVSQYxpAx9p3LMIJJd4f7jqOmF9XbIPboSUBZBUKQxajNYaVo
         XraQQYkwdH0zup2sXcllk1SErFqk8OPifucbBTXgH/XZX3WzmJuRBhMGu4JWaLsgWUXJ
         Ky3tXfckXn6BOzyYCagxwRmFz+GwmLdDWNdxnkRoJXnYkXvLZ+VobzGMBKDbnv0BbFUD
         34Kdcya1YlU9k+PKCzqDkpzvZ3If3H42nBvi05Ti0RaGm9gUEEwp2VK0tqxGpDUv1M63
         DnsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxyGOT1WWILh5oL+11Nju8H0r7P38+tag04ystH17qORsK/g068bn1ssmfuuS231OG8CkRMpJVy1qCi0qvZQQhTWDG9w5skQ==
X-Gm-Message-State: AOJu0YwRiTJnb+8MAuqNu5rIHBEpyIzmk71v3YwfvTsrVLLgrOWzzU4Y
	D/TI/U5+p9Ztk1ufsd4vwGlhQelJ6a8k/SvcJ8TKW+jubd3t0Syaxg/yj21QqoXCuIC5gp6q/hS
	sIzjsbJya/vs9+Z2S6UvVqC47YaA=
X-Google-Smtp-Source: AGHT+IGlNVnmjim6uRGqIalPRRaaQMdQU4pii3S6HeqHF8AaGgC1xR+n8J9AEzznZLRAdMikUPRipCOC6dTtwb0mOq0=
X-Received: by 2002:a05:6870:9a08:b0:221:4140:2f33 with SMTP id
 fo8-20020a0568709a0800b0022141402f33mr91294oab.8.1709631330408; Tue, 05 Mar
 2024 01:35:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240305074649.580820283@linuxfoundation.org> <20240305-arson-panhandle-afa453ccb0aa@wendy>
 <CADo9pHg4teVS7Lt1j+gOt4G9U=dZF9G92AUK=Km6PTdURkc0pg@mail.gmail.com>
 <20240305-series-flogging-e359bae88efd@wendy> <CADo9pHh6fnOz7d6+WCwkKz6_T4Ahru=0YDuc6q+KNnKYqQ2gBg@mail.gmail.com>
 <20240305-squeezing-backlit-d952f4503e57@wendy>
In-Reply-To: <20240305-squeezing-backlit-d952f4503e57@wendy>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Tue, 5 Mar 2024 10:35:15 +0100
Message-ID: <CADo9pHhtugqWO19dc7qT+sDruHBP0GR+5Kpd4RXVqb21SA+tmg@mail.gmail.com>
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

Den tis 5 mars 2024 kl 10:34 skrev Conor Dooley <conor.dooley@microchip.com>:
>
> On Tue, Mar 05, 2024 at 10:21:46AM +0100, Luna Jernberg wrote:
> > Den tis 5 mars 2024 kl 10:20 skrev Conor Dooley <conor.dooley@microchip.com>:
> > >
> > > On Tue, Mar 05, 2024 at 10:07:37AM +0100, Luna Jernberg wrote:
> > > > Den tis 5 mars 2024 kl 09:32 skrev Conor Dooley <conor.dooley@microchip.com>:
> > > > >
> > > > > On Tue, Mar 05, 2024 at 07:58:57AM +0000, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 6.7.9 release.
> > > > > > There are 163 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > >
> > > > > > Responses should be made by Thu, 07 Mar 2024 07:46:26 +0000.
> > > > > > Anything received after that time might be too late.
> > > > >
> > > > > > Samuel Holland <samuel.holland@sifive.com>
> > > > > >     riscv: Save/restore envcfg CSR during CPU suspend
> > > > > >
> > > > > > Samuel Holland <samuel.holland@sifive.com>
> > > > > >     riscv: Add a custom ISA extension for the [ms]envcfg CSR
> > > > >
> > > > > I left a comment in response to the off-list email about this patch,
> > > > > I don't think it's gonna work as the number this custom extension has
> > > > > been given exceeds the max in 6.7/
> > > > > >
> > > > > > Samuel Holland <samuel.holland@sifive.com>
> > > > > >     riscv: Fix enabling cbo.zero when running in M-mode
> > > >
> > > > Works fine on my Arch Linux desktop with model name    : AMD Ryzen 5
> > > > 5600 6-Core Processor
> > > > after the Arch Linux manual intervention for new mkinitcpio settings
> > > > and version in Arch
> > > >
> > > > Tested by: Luna Jernberg <droidbittin@gmail.com>
> > >
> > > This problem is riscv only, your x86 machine should not be affected
> > > by it.
> >
> > Ah alright then i know, did feel like compiling the latest test kernel
> > anyways, but thanks for the heads up
>
> Ah, I understand now. You meant to reply saying that you had tested
> 6.7.9-rc2 but you replied to me instead of Greg's original posting which
> confused me into thinking you tried to test these specific patches.
>

Yeah sorry i did reply all in Gmail, maybe should just only have
replied to Greg and the mailinglist sorry for the confusion
