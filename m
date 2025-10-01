Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6353D277CB3
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 12:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759321384; cv=none; b=sgb8RwnIPl+3yz1EcCdj0wnJioV2zSU4lLvIw+L5Q6KaSpOsGq9rkNBGzgaGCjGevfeE0Hz9U0U2Z3zzb8bAWphPFljxtVLTk5C98js1ompCV5ya3gu8HKwVsFmpMvg87I7k9qEBDPKC76G4jqKPggVSPns/vqD9hoepBw4n1ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759321384; c=relaxed/simple;
	bh=jm7QjsEYN3o9NREvDIVoGhoSvlRo/JHErcAuGoWOiRs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pFJR+OoFH//zTKeR/07Zb98h8nirreCnI6t5VUv5A5/WSnbk+zk88H4znW7lJJY+7xPppj5vox2NTOzOiovfa9oDUr36bUrOuIkjtTk+FOKoOwUQGIrIg4wAPGAERJd/9MXJPeXMv+BB8CyVwnFPDqEc0nJ3uFFk3+z3eVrOzOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nshw/L0t; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nshw/L0t"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-78af9ebe337so329602b3a.1
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 05:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759321383; x=1759926183; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G6ekdHDmWVv9FcHQZlrQj5iI/vOkg8zYvOska5GK10c=;
        b=nshw/L0tS69NvQ5Of+eIlRP48uKgOLjxA4SL7OtTDBrKzUg/BShrNdhsoTH/rHwJVH
         0vKrNSBQNkGoUUu6URr0F1X5hJqjDkntU/R9BWYPrqpqx6Mdn6f1Zwhr+dZwddLB7+3W
         RjW96rRw69xyKnpbvFdrzlG/ivH72M39iYsH7pZdJz7/mHyBRo0Uh2AACcAv3tPmNl84
         j47XcWu/nnjCb6co7iMcT22vjDULsxLnepDWQstE8YVjCG3ErwHsyEWYz1yCD1yMtYTo
         XrWALsxhawVY9Ex/QlvOJqyxzTknvTjh7fNkBqZGHFvmFU2M4dl0Oe95UyqpDDHes4Ea
         pnUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759321383; x=1759926183;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G6ekdHDmWVv9FcHQZlrQj5iI/vOkg8zYvOska5GK10c=;
        b=I2MqAUkAyC+gK+p27L1aQlLSy2nqlLKELrdJHoz6mV2hH7FlX/7hX89Sx73x7KxfuA
         XfwgdekzBVSiKseLFyHEMwM8P6KsL0pU1RpEDM1BBPU6qjddeTgF8VMhrrZmtUxMuGtH
         n88/JHTvTMUgybkDk/Y9OvvxuAnvgnk8F+vLnIcNysMP0B76D24GRsms9aKIX8P9wGGn
         /LV6y03rGZ2Wk8uaUiC61KUiHbFsvTW4S/5RJWHr67jkvsQqaLYh3EFubDi2qFozKgu9
         uJi4z8XPNjS8q4AxwWqSIrvIlGYHMZCa9E6ELCeuCaYWNJp1yGo5MOj4L2/XxWp/jGyD
         Z9Qg==
X-Forwarded-Encrypted: i=1; AJvYcCU7jJmqZUpPhKdFH4iNvyifqgkCp2odAz4HRjSvsiLoeNFKjl/CnrgTo5ZBiKeTry0s/z/iS/lU@lists.linux.dev
X-Gm-Message-State: AOJu0YxfeHjmjtP8XHlbpB3arDRin7QDaUOjd0GF/HWZOkFuhlCDJeY3
	TL8USYzFNgQzfOFbHzaddenCOzGIyqHUoL4lYgF1vkQegg1YL6JweRqswR3IZL3cg3xNgjAtbWw
	bgorBq99BJ+dQR6vigeDVNZxQ+YBQHXR1ce+yOFoJ0A==
X-Gm-Gg: ASbGncuC7H/cwVnHN8+i7nQN/yHyIFKq5CDRm/rACe+4edf3G3rdaIoYrhxuQrlZ3qV
	VS/Rq+u7+1iw3Hph9qQs9okeLLR/VMTjzF3xOmyI6prOXVIORtR1FDlOqM5bITsE7puGIMApRwW
	ZnwCJv8kLFDcKQrJQo53iMxKIQwzJFRw24IuggXRhmEeIfjrmQAzEiXMBGu2eJVrZLgiyxZ6A0s
	MYjUq3bGzLqb6UAGEcXEgSQ7RYLeaYwfIZBnZIUM1ltoK5D7ZhZQ/x5Gbc9oSD7u7sK7FwGpjaO
	oNMRSjDJDTABiOX18U4g
X-Google-Smtp-Source: AGHT+IG3y0LpyILSJk25wSg4EzJQnje8BCP0qYej1zbXdtuiF/6h3Ys2FwvbgoPmiH3pc5MHl/M3OJoRN2I5jM7mBd8=
X-Received: by 2002:a17:903:1b2c:b0:27e:f018:d2fb with SMTP id
 d9443c01a7336-28e7f27db93mr43354285ad.6.1759321382673; Wed, 01 Oct 2025
 05:23:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250930143822.939301999@linuxfoundation.org> <CA+G9fYvhoeNWOsYMvWRh+BA5dKDkoSRRGBuw5aeFTRzR_ofCvg@mail.gmail.com>
 <2025100105-strewn-waving-35de@gregkh> <aN0aMyU1D3N4WQy4@stanley.mountain>
In-Reply-To: <aN0aMyU1D3N4WQy4@stanley.mountain>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 1 Oct 2025 17:52:51 +0530
X-Gm-Features: AS18NWA6cyT7LVY1PGpPsb3wxOlSJ03i0aRVQJ0RG446XB-O0skidiXBbZlceZU
Message-ID: <CA+G9fYsRCN8f5n4dsbQAq73t7f5pzbHVT5Hp1rxYQzpxqvLWXA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/122] 5.10.245-rc1 review
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org, 
	Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, 
	linux-block <linux-block@vger.kernel.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 1 Oct 2025 at 17:40, Dan Carpenter <dan.carpenter@linaro.org> wrote:
>
> On Wed, Oct 01, 2025 at 12:50:13PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, Oct 01, 2025 at 12:57:27AM +0530, Naresh Kamboju wrote:
> > > On Tue, 30 Sept 2025 at 20:24, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.10.245 release.
> > > > There are 122 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.245-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > The following LTP syscalls failed on stable-rc 5.10.
> > > Noticed on both 5.10.243-rc1 and 5.10.245-rc1
> > >
> > > First seen on 5.10.243-rc1.
> > >
> > >  ltp-syscalls
> > >   - fanotify13
> > >   - fanotify14
> > >   - fanotify15
> > >   - fanotify16
> > >   - fanotify21
> > >   - landlock04
> > >   - ioctl_ficlone02
> > >
> > > Test regression: LTP syscalls fanotify13/14/15/16/21 TBROK: mkfs.vfat
> > > failed with exit code 1

I have re-tested for 12 times and reported test failures are getting
passed 12 times.
However, I will keep monitoring test results.

 - Naresh
