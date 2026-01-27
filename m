Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669E5357A26
	for <patches@lists.linux.dev>; Tue, 27 Jan 2026 14:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769524690; cv=none; b=hiY3WpJTVetS8o71B+DWh4zJsIgrxPafe5aTUtwC3qHK/X7HRvnI20TC5i1QKifa2ClKT1RuoBejVY/YsZ7STmMIElz+wtqIleLhKvP+eAwGcpDEfwxcK/7zyvro1A1Ibw2ASM7fEbzkzzl2YuXLwMDqyhQfcetY26K4Qxs2grA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769524690; c=relaxed/simple;
	bh=/Huc7ebUuuPY+O5QSMjOHnPihdsygPxTbc17OjaPudI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GyM9l4ft0n/Ave4iy2Re7IytXgOBJFGe/u2IykYFv9P30dGxt5sKxbPWToCMukyj31h12bm7UBQ2NPZLobVCSudHFkM3K7TvLkf+PfjsdwMkHFM04L5Vqa4HCXjUP2NCqKITpOB7x4YOUQ+w5WbCTh0v16gN6t+VxwYqTwHXWDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EJWCr1Oi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EJWCr1Oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255C8C4AF0B
	for <patches@lists.linux.dev>; Tue, 27 Jan 2026 14:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769524690;
	bh=/Huc7ebUuuPY+O5QSMjOHnPihdsygPxTbc17OjaPudI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EJWCr1Oi0pP9WIJ2i39LOol9ap/lfZKZ2fiyandM+XQCp9p1QgRI/Xh+4STUbKfro
	 GDMx9n4jMcZ14NG7vtSjZ1Tm/INjsDuQL/tN5wZhXMTn5wfD+XAf5ffhRk0UJAjWqW
	 mrglv6DMryLFEAneSPp8M2P9fAEwUeof2iOqrlMj/qLxlX7jx8/dHXV5DDpWxpQwbb
	 4Rk0tXQ4ItJr4ibcq8QJK5Ny3GglM/BYwL90lQYEzOEYUrOisBjATHr6dGOc0s0Hyq
	 uqFKjGbz8BRbS9QOlI4dGHiWluxeLL+Z6RKAF9AFn1UBz/1RaMcMNgEMEg0N0kozvt
	 +dVF7NN+viRdg==
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-45c838069e5so3561095b6e.0
        for <patches@lists.linux.dev>; Tue, 27 Jan 2026 06:38:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVl6UHbwyukEklhyHFz5ljvu6pQr2rHN6uXKxozH8pXxnt2biI+T73ba9Z+Y9D15IlwUqFm2Zw/@lists.linux.dev
X-Gm-Message-State: AOJu0YxUIrqQ2+JyZfN6hgB50tOJVnjokynwjXF7fblBnHtTFlCGmfmh
	+7h4ROg61UdRPnVd1gypeZKPu9SbqkL1rsT95aTJt9Fvv63kesyjTh5wN15xAa5pe5BrVYLaJUs
	l8Xp9xwuOff2v/Kt50/UGhw7033/lhis=
X-Received: by 2002:a05:6808:1310:b0:45c:874b:3d4a with SMTP id
 5614622812f47-45efc50276emr1119220b6e.1.1769524689166; Tue, 27 Jan 2026
 06:38:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260114-ghes-avoid-wflt-clang-older-than-18-v1-1-9c8248bfe4f4@kernel.org>
In-Reply-To: <20260114-ghes-avoid-wflt-clang-older-than-18-v1-1-9c8248bfe4f4@kernel.org>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 27 Jan 2026 15:37:58 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0ju+7U10_nuQMijadeFrVxUWQFYJfUyRvga9qEPdK50_Q@mail.gmail.com>
X-Gm-Features: AZwV_QhVWfAkrO7qybSqqJnJ1Tg8QS5LU98rU2z8KN1v2bcm1AhpEv1pdt_c7rE
Message-ID: <CAJZ5v0ju+7U10_nuQMijadeFrVxUWQFYJfUyRvga9qEPdK50_Q@mail.gmail.com>
Subject: Re: [PATCH] ACPI: APEI: GHES: Disable KASAN instrumentation when
 compile testing with clang < 18
To: Nathan Chancellor <nathan@kernel.org>, Tony Luck <tony.luck@intel.com>, 
	Borislav Petkov <bp@alien8.de>
Cc: Hanjun Guo <guohanjun@huawei.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, 
	Shuai Xue <xueshuai@linux.alibaba.com>, Len Brown <lenb@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-acpi@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2026 at 12:27=E2=80=AFAM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
>
> After a recent innocuous change to drivers/acpi/apei/ghes.c, building
> ARCH=3Darm64 allmodconfig with clang-17 or older (which has both
> CONFIG_KASAN=3Dy and CONFIG_WERROR=3Dy) fails with:
>
>   drivers/acpi/apei/ghes.c:902:13: error: stack frame size (2768) exceeds=
 limit (2048) in 'ghes_do_proc' [-Werror,-Wframe-larger-than]
>     902 | static void ghes_do_proc(struct ghes *ghes,
>         |             ^
>
> A KASAN pass that removes unneeded stack instrumentation, enabled by
> default in clang-18 [1], drastically improves stack usage in this case.
>
> To avoid the warning in the common allmodconfig case when it can break
> the build, disable KASAN for ghes.o when compile testing with clang-17
> and older. Disabling KASAN outright may hide legitimate runtime issues,
> so live with the warning in that case; the user can either increase the
> frame warning limit or disable -Werror, which they should probably do
> when debugging with KASAN anyways.
>
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2148
> Link: https://github.com/llvm/llvm-project/commit/51fbab134560ece663517bf=
1e8c2a30300d08f1a [1]
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/acpi/apei/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/acpi/apei/Makefile b/drivers/acpi/apei/Makefile
> index 2c474e6477e1..346cdf0a0ef9 100644
> --- a/drivers/acpi/apei/Makefile
> +++ b/drivers/acpi/apei/Makefile
> @@ -1,6 +1,10 @@
>  # SPDX-License-Identifier: GPL-2.0
>  obj-$(CONFIG_ACPI_APEI)                +=3D apei.o
>  obj-$(CONFIG_ACPI_APEI_GHES)   +=3D ghes.o
> +# clang versions prior to 18 may blow out the stack with KASAN
> +ifeq ($(CONFIG_COMPILE_TEST)_$(CONFIG_CC_IS_CLANG)_$(call clang-min-vers=
ion, 180000),y_y_)
> +KASAN_SANITIZE_ghes.o :=3D n
> +endif
>  obj-$(CONFIG_ACPI_APEI_EINJ)   +=3D einj.o
>  einj-y                         :=3D einj-core.o
>  einj-$(CONFIG_ACPI_APEI_EINJ_CXL) +=3D einj-cxl.o
>
> ---

I'm inclined to apply this for 6.20/7.0 unless someone has any
particular heartburn related to it.
