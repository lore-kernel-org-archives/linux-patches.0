Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163D11662EA;
	Tue, 18 Jun 2024 21:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718746358; cv=none; b=m5QT5ZbLsIKaCY2NpfHxwXtD8/Ja3dj6pC7iNy9wVGxYJ2ZdlSAzWBQf9AjQEEi33mc5UoUuVEK5rGZciZQdHcHNCQIs6kAJJPwsLKAbiY1ILA02ncK9f/uPlt6CC+FR203ZgOY4kJkKN1abpgR+bpwporVpKJy0wE1LjdYoKCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718746358; c=relaxed/simple;
	bh=VVcf37s2EfA8gVOeqHWCxz/aViKmRNUtMDu5rG1+UfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L8s2YhBrV5WzA6li7yeX3bBm5RijIUWhe0traLNagMn4x8rUAFqG9GjIqApqfkLt6qw7RMOaPIKvdzUPiTSW1Ip4+3cxSEJGnFEEqLDzIcy2OE/vqvNVaPWnweRcDiqi1Th8KFElLFvFK50XiPDcBcJF7V0AL8MgA82uCnpptPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H6p5vdJj; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H6p5vdJj"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7062bf6d9a1so190514b3a.1;
        Tue, 18 Jun 2024 14:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718746356; x=1719351156; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0F2GFRylmsUf8qCCMvo7ZfErHvVg5KnaNyTwWf+ackU=;
        b=H6p5vdJjP+uBXIT3s0dHu6th9+rSlt1tQPJVA87JUpwMDfPnk32WFBjrC8LnD0zqKX
         H+4DjcFOu8WYV1SBwhFXdZh+D7rwXgYenhul4IW++eDUakMLKKmj9qtq+36Ei4xIg1lG
         XdbOW/RxKMdvkjjvvqnnqEUCv/LYfP7wEYZRAUfrhke+StF0A3G6nGfB2jJfY0pavz6M
         yG2pgFsI5vhCJEnylCOJ3UkecMSJxP4rfKCQCw/GcOZTFt7yBwqIavPY0GiWheibw64w
         KQU4sshG6rbwFfx+lqJAsTjk6ZIEJzruS3cOzTprkjpzyoEZ9+m2R443dXxQORwsrl45
         5XYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718746356; x=1719351156;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0F2GFRylmsUf8qCCMvo7ZfErHvVg5KnaNyTwWf+ackU=;
        b=GWdmFgv3ClSSIeN0yAK+1Utdwc5WbTBhImz3+CAXNrrLeoVk8zJ/umZfRqXSwg3Du5
         cNux+UG2zJ6e/2cyW8lJ3riQzWIEhUXbedczqzyc8K8zjvKl+S4r8psGRAO4xI3Lm8wO
         JW1wGXDJSmo/gxs9L4nEQ+j7cQT655hVQ4gX0ETOzfQNzv9hMQAAswX9CiyULbPdSJmg
         n4L+HH94TbNrHKksUuGVu2tcd7Fth1xYI60uMDd200F8hSbZj3I1orndcuwe5/9ea3Yi
         BkeCketiPiyLucYCZBfZgEFukhO59pm1doJNawrVL0YIzfx5XQxwchBBitUxX767DnlR
         mEIg==
X-Forwarded-Encrypted: i=1; AJvYcCWP6tPnQiCznb7B7UV1Qf2h50mY9JOPjjHISFMIZSaMwGB85PfeXRT/f8YHB+SExcARHEH+L5BvF84aVLYt9Do9W3ogOi9/gCILiiqqTH639HM+cnAp7yL+PVHiAho=
X-Gm-Message-State: AOJu0YyOAb+oYQOH9c2SoVZt7EPwwt9Eo9t9GbkOnzQ+NuQeN4tW9OKh
	0YUtirKLomFz8Z1T4GRL6sOPxzql0yVy8HGVwb50w5orKql59CaqanZxHIdoON4O4Veee/uIdqG
	C/7FrZNs2XeoirtLPJMvuQrPGRRQ=
X-Google-Smtp-Source: AGHT+IFIYnRfv9OexIBisPO8GJODl0YW0GErnOlBNhmoJ+53el0v0LQ+XytbXr/0FiI9zYwRjX6PFplolAaJccvUk80=
X-Received: by 2002:a17:90b:344f:b0:2c2:faf7:67a0 with SMTP id
 98e67ed59e1d1-2c7b5c725a6mr924947a91.16.1718746356201; Tue, 18 Jun 2024
 14:32:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240614-amdgpu-disable-drm-amd-dc-fp-riscv-clang-v1-1-a6d40617dc9b@kernel.org>
 <58253c2e-25a2-48c6-bcd4-5bc3bbe03296@amd.com>
In-Reply-To: <58253c2e-25a2-48c6-bcd4-5bc3bbe03296@amd.com>
From: Alex Deucher <alexdeucher@gmail.com>
Date: Tue, 18 Jun 2024 17:32:24 -0400
Message-ID: <CADnq5_Ox_Ak9XedYNPchxMh-AKuLRG1_V8YqpiEB=ke8130B5A@mail.gmail.com>
Subject: Re: [PATCH] drm/amd/display: Disable CONFIG_DRM_AMD_DC_FP for RISC-V
 with clang
To: Harry Wentland <harry.wentland@amd.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Leo Li <sunpeng.li@amd.com>, 
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Xinhui Pan <Xinhui.Pan@amd.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Samuel Holland <samuel.holland@sifive.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-riscv@lists.infradead.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev, 
	Palmer Dabbelt <palmer@rivosinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied.  Thanks!

Alex

On Tue, Jun 18, 2024 at 10:17=E2=80=AFAM Harry Wentland <harry.wentland@amd=
.com> wrote:
>
>
>
> On 2024-06-14 15:54, Nathan Chancellor wrote:
> > Commit 77acc6b55ae4 ("riscv: add support for kernel-mode FPU") and
> > commit a28e4b672f04 ("drm/amd/display: use ARCH_HAS_KERNEL_FPU_SUPPORT"=
)
> > enabled support for CONFIG_DRM_AMD_DC_FP with RISC-V. Unfortunately,
> > this exposed -Wframe-larger-than warnings (which become fatal with
> > CONFIG_WERROR=3Dy) when building ARCH=3Driscv allmodconfig with clang:
> >
> >   drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn32/display_mode_vba_3=
2.c:58:13: error: stack frame size (2448) exceeds limit (2048) in 'DISPCLKD=
PPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerformanceCalculation' =
[-Werror,-Wframe-larger-than]
> >      58 | static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWat=
ermarksAndPerformanceCalculation(
> >         |             ^
> >   1 error generated.
> >
> > Many functions in this file use a large number of parameters, which mus=
t
> > be passed on the stack at a certain pointer due to register exhaustion,
> > which can cause high stack usage when inlining and issues with stack
> > slot analysis get involved. While the compiler can and should do better
> > (as GCC uses less than half the amount of stack space for the same
> > function), it is not as simple as a fix as adjusting the functions not
> > to take a large number of parameters.
> >
> > Unfortunately, modifying these files to avoid the problem is a difficul=
t
> > to justify approach because any revisions to the files in the kernel
> > tree never make it back to the original source (so copies of the code
> > for newer hardware revisions just reintroduce the issue) and the files
> > are hard to read/modify due to being "gcc-parsable HW gospel, coming
> > straight from HW engineers".
> >
> > Avoid building the problematic code for RISC-V by modifying the existin=
g
> > condition for arm64 that exists for the same reason. Factor out the
> > logical not to make the condition a little more readable naturally.
> >
> > Fixes: a28e4b672f04 ("drm/amd/display: use ARCH_HAS_KERNEL_FPU_SUPPORT"=
)
> > Reported-by: Palmer Dabbelt <palmer@rivosinc.com>
> > Closes: https://lore.kernel.org/20240530145741.7506-2-palmer@rivosinc.c=
om/
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  drivers/gpu/drm/amd/display/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/amd/display/Kconfig b/drivers/gpu/drm/amd/=
display/Kconfig
> > index 5fcd4f778dc3..47b8b49da8a7 100644
> > --- a/drivers/gpu/drm/amd/display/Kconfig
> > +++ b/drivers/gpu/drm/amd/display/Kconfig
> > @@ -8,7 +8,7 @@ config DRM_AMD_DC
> >       depends on BROKEN || !CC_IS_CLANG || ARM64 || RISCV || SPARC64 ||=
 X86_64
> >       select SND_HDA_COMPONENT if SND_HDA_CORE
> >       # !CC_IS_CLANG: https://github.com/ClangBuiltLinux/linux/issues/1=
752
> > -     select DRM_AMD_DC_FP if ARCH_HAS_KERNEL_FPU_SUPPORT && (!ARM64 ||=
 !CC_IS_CLANG)
> > +     select DRM_AMD_DC_FP if ARCH_HAS_KERNEL_FPU_SUPPORT && !(CC_IS_CL=
ANG && (ARM64 || RISCV))
>
> Thanks for also making the logic easier to parse.
>
> Reviewed-by: Harry Wentland <harry.wentland@amd.com>
>
> Harry
>
> >       help
> >         Choose this option if you want to use the new display engine
> >         support for AMDGPU. This adds required support for Vega and
> >
> > ---
> > base-commit: c6c4dd54012551cce5cde408b35468f2c62b0cce
> > change-id: 20240614-amdgpu-disable-drm-amd-dc-fp-riscv-clang-31c84f6b99=
0d
> >
> > Best regards,
>
