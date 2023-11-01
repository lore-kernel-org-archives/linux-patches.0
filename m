Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23715C9A
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 07:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="giJuhped"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4a9183bf741so1892532e0c.1
        for <patches@lists.linux.dev>; Wed, 01 Nov 2023 00:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698824627; x=1699429427; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o326kRv6U2+ln56Jt/MYDAHMNlJTSIjb+AyTX5/qVok=;
        b=giJuhpedVy+TNBSP2xNBCsvQOH21B+Sp8t1AalR8nanbu4x4je55kjO3CKdRphUF3a
         2vRUcbV0NDF1/oXozfFezJJEbpt9PCYtTkoSaXiL9Vc7vK4j7TesAkRPvWf+twJfBdbR
         1i5p1BGz1OzbNyA4WizPJqAb8dSOFI0gVQ5Id2Qj0/kdOQabBSQ1e7pbNAa+f90uGXO3
         1mv8kygKadSeWTtXrfR9kmiElmmltqYMxLdVYNEBCTJnH494Krj0EOyvgrxJZMc7RcOH
         HL4PkNV+f7NVfM7DEWBkIIFFtRF8syjUO6DWqy97/ciObRiEU6y92FPyFwWgnlcr9iuU
         wRig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698824627; x=1699429427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o326kRv6U2+ln56Jt/MYDAHMNlJTSIjb+AyTX5/qVok=;
        b=M8edct5qKyitdSPv94oPZA2cg5zrqBO9YxeMSly28UHwjozZ3TNtHqcx/dVZNvdFrv
         pZBTAmdrCU1pNCB1l0fQZ7idD2O6m8IJB+rl7/f+/YodwfEFKYFrz9TQSUqGadSp8tZh
         kXP+XDxJ+qjKsMukEHQGcdQq8O/QZcHhn+lxfzBljOOdUp6QKDLVDn9djtr4hd7TayEc
         J9nn7crMYT+/d5bKgD80LgG0NMmG7dDGPtCF94dN1n3a9fdhOQIWFFlr8OGm5kGueZ9C
         TGDz8Eu++C7LLkTqeortyg4fWJI4DQaxt6R+CRxzakwyCAt9S7ylH3WkMymC6+/GRwlg
         WEBA==
X-Gm-Message-State: AOJu0YyG6kZpogKhAxlsTTGRGl1puZgHqbwFJ7t3YNStL5QbOJuEU6AD
	IMx7UssooiQITtdkDXsQb5b8Wn9ddMuUtb2AYNlk8A==
X-Google-Smtp-Source: AGHT+IFn3LGbnhJgUHon1Qrj2iYMBd9vIZpHUDasLkNig6UIZDiIb8D4aXIR1PweykwfXhCvN8gmudyh11ujhfzYAYM=
X-Received: by 2002:a1f:ab0b:0:b0:4a4:680:bfad with SMTP id
 u11-20020a1fab0b000000b004a40680bfadmr13344693vke.7.1698824627486; Wed, 01
 Nov 2023 00:43:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231031165901.318222981@linuxfoundation.org> <38fbd463-1160-0212-b9d2-6efeaaa6548e@w6rz.net>
In-Reply-To: <38fbd463-1160-0212-b9d2-6efeaaa6548e@w6rz.net>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 1 Nov 2023 13:13:35 +0530
Message-ID: <CA+G9fYtSAX+aPUvUShSvb=LOAsQBEMfxRVAi0CJ-PD+SiQLPwg@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/112] 6.5.10-rc1 review
To: Ron Economos <re@w6rz.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Nov 2023 at 04:21, Ron Economos <re@w6rz.net> wrote:
>
> On 10/31/23 10:00 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.5.10 release.
> > There are 112 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 02 Nov 2023 16:58:38 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.5.10-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.5.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> The build fails on RISC-V.
>
> arch/riscv/mm/hugetlbpage.c: In function =E2=80=98set_huge_pte_at=E2=80=
=99:
> arch/riscv/mm/hugetlbpage.c:188:13: error: =E2=80=98sz=E2=80=99 undeclare=
d (first use in
> this function); did you mean =E2=80=98s8=E2=80=99?
>    188 |         if (sz >=3D PGDIR_SIZE)
>        |             ^~
>        |             s8
> arch/riscv/mm/hugetlbpage.c:188:13: note: each undeclared identifier is
> reported only once for each function it appears in
>
> Caused by commit 16b6f77970f7a690c61de142511c9ac488d83e04
>
> riscv: fix set_huge_pte_at() for NAPOT mappings when a swap entry is set

The above build error was also noticed in our CI system.

> This patch requires mainline commit 62ba41d2761206664a1fdc998051324457da2=
dd6
>
> mm: riscv: fix an unsafe pte read in huge_pte_alloc()
>

Following riscv builds failed as other reported.
riscv:
  * build/clang-nightly-defconfig
  * build/clang-17-lkftconfig
  * build/clang-17-defconfig
  * build/gcc-13-defconfig
  * build/gcc-13-lkftconfig
  * build/gcc-8-defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
