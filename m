Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB8C2E0B59
	for <patches@lists.linux.dev>; Sun, 14 Dec 2025 01:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765675432; cv=none; b=jAlI5lol0Yz7OGcYriJlkAnJcvBJPiA8/f1PLZsjUZ6NS0qcaD0VFfLxEdvnMTN4Ug1P8BRkRzYJK9i1DFiL7iQ5GPhJJVt83nl0K1gF1YKrh7OckhrYwXNYHs2CUruqn9vJ4uOEEZF9FvIpsmt3k2kXgJw3WHOKJ4q3qulQzXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765675432; c=relaxed/simple;
	bh=GiyI2wrxHNxbI6dYeRsPW1sazjsvEU0Uazlgs5PB2bo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uVZBK+NAl+UrnTHqlto9FnzSxHcQdW/rcBhOKIeqz/XfVQwJ0WRP/pJQqH7P9PZyKiaU2hW/QL+PZS2GRuKvLaqaIV1CbukwkPco9F42YX+VpBz4JaFjHjprDPk0G06lKKFhvjJCFqAo/mwWmkNBF0cfY6bpY+mg47hVN8Ifmps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OzKELoP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OzKELoP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124AFC19424
	for <patches@lists.linux.dev>; Sun, 14 Dec 2025 01:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765675432;
	bh=GiyI2wrxHNxbI6dYeRsPW1sazjsvEU0Uazlgs5PB2bo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OzKELoP3xHH7u1ijLkX3bZC6R/MoqPpQ+9roenpeCXcGYD0LhfZoprBRQyhbwZHFl
	 NbnK/vQ2qBqT0UYRLYidHP+NCWedgvMGRCJAE2X1b9IlmL6SjgEv+0hZRvlB5KRsU4
	 y/WLeHw2jaOe0g3dR9alFrcoLT+Z0btG+ATGv3tTyCepGr+smnBSNDeORP2mOg0eVg
	 K6R7K0y2ecL+nW7+dG5n+IdagJu+8iWLNaJj9iGg8zM18MIq3mr1MQsTKJ7Hn6X1dY
	 VnqOMLdnZewDSE7piUOWmjecxD0VmE6AGBbR0AEcRXNnn5BfoktH3VNhX+4X2tMCjn
	 /X3K1gq8qXuKA==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so4734085a12.2
        for <patches@lists.linux.dev>; Sat, 13 Dec 2025 17:23:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV9jql/PRY6VRUJDOplJlRVBz1Vl2AP48J7p2Nomazo+bt+mZFP46R2L31ttjDtXYBjihOMstrG@lists.linux.dev
X-Gm-Message-State: AOJu0Yyb1igiDXCQK0xj8nFYQxdkHZuZVbWJSF/wVChZATGZ2hygu6Cn
	Svb/zfFjKzrgkD4NfjhQtdTtmAFh8gp616yFuQ3xeR3F8yGzeNJ6876TZkCuPEfCyKZOgjWLqDW
	nIt9pUA7xoZiZOCjYQg52QlTZx2uSk9Q=
X-Google-Smtp-Source: AGHT+IFjIQS/7W0XyLT8qXY9tC3vgaxbp8f0nrh+HrLnWZv5ZI+yPJY2JQMQw+URLnV7MzMIgLyLz4bmDVFpi2hpCIc=
X-Received: by 2002:a17:907:7fa3:b0:b7c:fe7c:e37f with SMTP id
 a640c23a62f3a-b7d23a540d3mr734991266b.18.1765675430495; Sat, 13 Dec 2025
 17:23:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072948.125620687@linuxfoundation.org> <35e3347a-198f-4143-b094-2d0feb8d6d50@roeck-us.net>
In-Reply-To: <35e3347a-198f-4143-b094-2d0feb8d6d50@roeck-us.net>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 14 Dec 2025 09:24:02 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4tiTBqd7mUphq58KdUtvro9HPxZmComr6ku1Mcw6=+9g@mail.gmail.com>
X-Gm-Features: AQt7F2qPiIAWNB6dRD6h_fQatP_E57R9qswZPlB9b3pbQHt0xF0aw_U5cacdOVs
Message-ID: <CAAhV-H4tiTBqd7mUphq58KdUtvro9HPxZmComr6ku1Mcw6=+9g@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 14, 2025 at 12:31=E2=80=AFAM Guenter Roeck <linux@roeck-us.net>=
 wrote:
>
> On 12/9/25 23:29, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.62 release.
> > There are 49 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 12 Dec 2025 07:29:38 +0000.
> > Anything received after that time might be too late.
> >
> ...
> > Huacai Chen <chenhuacai@kernel.org>
> >      LoongArch: Mask all interrupts during kexec/kdump
> >
>
> This results in:
>
> Building loongarch:defconfig ... failed
> --------------
> Error log:
> arch/loongarch/kernel/machine_kexec.c: In function 'machine_crash_shutdow=
n':
> arch/loongarch/kernel/machine_kexec.c:252:9: error: implicit declaration =
of function 'machine_kexec_mask_interrupts' [-Wimplicit-function-declaratio=
n]
>    252 |         machine_kexec_mask_interrupts();
>
> ... because  there is no loongarch specific version of machine_kexec_mask=
_interrupts()
> in v6.12.y, and the function was generalized only with commit bad6722e478=
f5 ("kexec:
> Consolidate machine_kexec_mask_interrupts() implementation") in v6.14.
https://lore.kernel.org/loongarch/20251213094950.1068951-1-chenhuacai@loong=
son.cn/T/#u

Huacai
>
> Guenter
>
