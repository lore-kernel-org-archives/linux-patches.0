Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DB12EB5D5
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 13:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755092481; cv=none; b=FDzdS49+jhH8EHgD/mprYtTVkBkEQh0YfWc40T83eW8eCn1QW3rZzLbS9jR14ZlYgpugkcDWf+8dOIR+azqWWzai+N/Q5A835RF5y+iW+7ydLCz9/NulXQOc+f9hCUg7G9MeRHvB1+ZgXw+Grt+gbmkJHwhGrL2IKiezZiaU38Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755092481; c=relaxed/simple;
	bh=cAR2FPV/ROme89E5VHNey3/dlly2/gqFm0nN2kQt4sg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Xe7qDeJVTZtDYVG8yXaSpVB0LKJJNOfhdZtjOLsUk5xTnEZ6FfmYrOD5I1DJbQNZCNi1ReDdU37OqceW0bTRMcRWGvfrB048RqMb+1w9GtLchtLbh9ujvtoJDzSIUa/yXpN/VL8kbKpDheNWsSZmHh/tBjlBs22Qg3zPBhKEh44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UomoZAmG; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UomoZAmG"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b422863dda0so4665256a12.3
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 06:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755092477; x=1755697277; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BuoYHGYkCh033zSzlMciRVTnS9J8QMWvk5NZ+OdGx/A=;
        b=UomoZAmGmaSxVlbfGO0jN7Or/NFGMR3P9ulq2tttJinURMS8ah4nvsuMPoJ3MIt2Yz
         WKqftZR4VV4HmhpKUM2DMKNVsffxZqqWQUCOqiuzoSH68ZadUC2Tu5BndN1fk2sdxqw6
         O99KIBWeOGC1VjC6kTgLgfC5bVANqxTO8S6CrzcyMi2SOeNG9a6WN2GvvsO9lrztWpyo
         Zsagv5cnM4LReIGSQNxbd1Pxz3WD1NeswlqP/cTcGMmWcNvfI56cRd8lVNQmTMcTPfsy
         cemV8yiXJ9doOmq9j5NrOUFO9HWxr2SvEPJB68rEhC6PaW7b8i1xCK8yPJf8rWpa5r5J
         Qd6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755092477; x=1755697277;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BuoYHGYkCh033zSzlMciRVTnS9J8QMWvk5NZ+OdGx/A=;
        b=NuJiEr0yTBCpAhiRkA6Ze1OaVBPe4DEQ1X/eMCevDHJNfx5Wm719oI6hl8IZ5BHt9e
         ge9uK7Ry5Vo6I+w6FhO+Gbx69h6BvGIu3A5G/EYFCwWg9ZisMsWOZEbXkoeVbScVF/Vq
         4FaKAikmCeuYDSqvzCMh9Yx5W4/CpFH0PIRVXX0/y8PanFEL2xZfOpGot3EAIauI3GBi
         Lrn8Xib7DZnfIueEjQyXyBSoRy+Rn6txZKjDPdj9xjy7PkBAZx+J25mdlYWQtASEwZlO
         8aLMxre8rHYtrKLyt7lV2lX5CQStz7PsKez1yj6BiX6uOWC+7mGnn/kCFbtNYRdGGYeb
         mjAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkcETbRpP+rhzdBl9SUdgS3PvNiiPYU/9pwhtm6OIkzzqvaaZMXtgWVq/omJiM/tHdq0zyZdBD@lists.linux.dev
X-Gm-Message-State: AOJu0YyvFGiBIqKIf5fG8JreDyDa14Nq0pO4rHj+GNxsu487Ts1XDA05
	gBk9w5hv9PII1lo71LdPGZjrUMAgeMU1NUBlRXUHzkp60nnLNC4vCXEcMOaPzwY1HOYCjbz6sN5
	b10oGD/ccihGz8eYnxW8a0zYvPxgF6iB+yrHORhBwow==
X-Gm-Gg: ASbGnctNfEnLXztC6/WECGak+WBLHHHofIGwZ9MSJdMlrUJz3M53OfmRAZSMqlGe9QG
	2FW4lyGVbpTQiT25TwAqqLdpkz9mIZ4APUANydHYVVLLF2jx4lv2WlBZVDrvSuxwbXMOiEsyKq1
	tcMf+R+R30iVpsRFYWwTKc245Xta9LwidMDPCuhPjT1ZKDGPcvrAuePZ/NN5YAR+zxx13rmBL1N
	PvpKd+rwtAZlDIBFQmM66zo4WVg6z8Z/64qVTfz
X-Google-Smtp-Source: AGHT+IHJ5NorMBOk/mMmvjq4NxC90d+IjwHZjpyxn70pQloc6AgGTp1y/wa+zMeluJYPNCBvRdh21gvKSjV030UR2Pk=
X-Received: by 2002:a17:902:f785:b0:23f:e51b:2189 with SMTP id
 d9443c01a7336-2430d0f9a4bmr54705775ad.17.1755092476818; Wed, 13 Aug 2025
 06:41:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250812173419.303046420@linuxfoundation.org> <CA+G9fYtBnCSa2zkaCn-oZKYz8jz5FZj0HS7DjSfMeamq3AXqNg@mail.gmail.com>
 <bf9ccc7d-036d-46eb-85a1-b46317e2d556@sirena.org.uk>
In-Reply-To: <bf9ccc7d-036d-46eb-85a1-b46317e2d556@sirena.org.uk>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 13 Aug 2025 19:11:05 +0530
X-Gm-Features: Ac12FXxKeYVh06szquTrecWrS7rqGYyi8ckXtXfcapehmWdAEuqul8ZUWvjf2tw
Message-ID: <CA+G9fYtjAWpeFfb3DesEY8y6aOefkLOVBE=zxsROWLzP_V_iDg@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Naresh Kamboju <naresh.kamboju@linaro.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, achill@achill.org, 
	qemu-devel@nongnu.org, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>, 
	LTP List <ltp@lists.linux.it>, chrubis <chrubis@suse.cz>, Petr Vorel <pvorel@suse.cz>, 
	Ian Rogers <irogers@google.com>, linux-perf-users@vger.kernel.org, 
	Zhang Yi <yi.zhang@huaweicloud.com>, Joseph Qi <jiangqi903@gmail.com>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 13 Aug 2025 at 18:21, Mark Brown <broonie@kernel.org> wrote:
>
> On Wed, Aug 13, 2025 at 05:46:26PM +0530, Naresh Kamboju wrote:
> > On Tue, 12 Aug 2025 at 23:57, Greg Kroah-Hartman
>
> > The following list of LTP syscalls failure noticed on qemu-arm64 with
> > stable-rc 6.16.1-rc1 with CONFIG_ARM64_64K_PAGES=y build configuration.
> >
> > Most failures report ENOSPC (28) or mkswap errors, which may be related
> > to disk space handling in the 64K page configuration on qemu-arm64.
> >
> > The issue is reproducible on multiple runs.
> >
> > * qemu-arm64, ltp-syscalls - 64K page size test failures list,
> >
> >   - fallocate04
> >   - fallocate05
> >   - fdatasync03
> >   - fsync01
> >   - fsync04
> >   - ioctl_fiemap01
> >   - swapoff01
> >   - swapoff02
> >   - swapon01
> >   - swapon02
> >   - swapon03
> >   - sync01
> >   - sync_file_range02
> >   - syncfs01

These test failures are not seen on Linus tree v6.16 or v6.15.

>
> I'm also seeing epoll_ctl04 failing on Raspberry Pi 4, there's a bisect
> still running but I suspect given the error message:

Right !
LTP syscalls epoll_ctl04 test is failing on Linux mainline as well
with this error on LKFT CI system on several platforms.

>
> epoll_ctl04.c:59: TFAIL: epoll_ctl(..., EPOLL_CTL_ADD, ...) with number of nesting is 5 expected EINVAL: ELOOP (40)
>
> that it might be:
>
> # bad: [b47ce23d38c737a2f84af2b18c5e6b6e09e4932d] eventpoll: Fix semi-unbounded recursion
>
> which already got tested, or something adjacent.

A patch has been proposed to update the LTP test case to align with
recent changes in the Linux kernel code.

[LTP] [PATCH] syscalls/epoll_ctl04: add ELOOP to expected errnos

-https://lore.kernel.org/ltp/39ee7abdee12e22074b40d46775d69d37725b932.1754386027.git.jstancek@redhat.com/

- Naresh
