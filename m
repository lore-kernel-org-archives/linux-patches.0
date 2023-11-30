Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736D1482CB
	for <patches@lists.linux.dev>; Thu, 30 Nov 2023 16:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QFmlCOOY"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-548ae9a5eeaso12046a12.1
        for <patches@lists.linux.dev>; Thu, 30 Nov 2023 08:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701360222; x=1701965022; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WFuAuGzjCwUvtnL2rnJIn7SWhGuOsuybendDSBRJmOk=;
        b=QFmlCOOY/8LSlWaDqC8HLtTeylFJK2jxplTBtZcfQKYSo4CVtfjmUQysohDmtU0qwr
         qyt8guxKbiFDFOi4hNxxLeCAK/knELsS83/91V4iiCBMWHLv2JVcO9fhfcb1TiCvMsCI
         sIqlZYjLiWJgykXnNO2XDLxhniWVoJbyqv5yXg45OrON8t2ebeemQbxI7ThO2mC4ClYm
         c/VIrV5cEHE8s9EdShEZpCnqoc7pcRL0XJcL10fL1JafB2xlAvvTumO/lUeiDqe/JkSS
         riOZBVK+Vq0MCQHcGigGc2IPqI+nUaudwyPYnO2RCcJ2c242DmKpxaRrXmycN/A+DIW6
         hPfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701360222; x=1701965022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WFuAuGzjCwUvtnL2rnJIn7SWhGuOsuybendDSBRJmOk=;
        b=PUwBBLNXKs8OLi9XmdgsWhPFPtnVBL5qaS4JB0+7ENH1LCYuQpdYhjUMeVOu2xQ/Ez
         ijnROwrGkQcrDgyY0WL5L/odO7bNTpP8C8S2lPV35P9/NW3YhcqfaI3NCLRW4tRxF0Mn
         o3Ry627JLVtYyJmpsK/7zLQsjwetsC948hZu7WGCDaHagvPMUFydhddrKSZwccuajG+T
         nW6OG8wBNM0m5DSDQ8VLGblROJLvtoLmQI6RrFAQJOL2G8j0At3XTUkQz2IvYDvnr7t2
         GzglCXqWsMy8KpsSA+UuKEngL6TNTipHwmiMBq9nyeNyk1ZgOvG3x6jgT0GQpAKmDecv
         Ax7Q==
X-Gm-Message-State: AOJu0YyX3iG5Uszh7QpyjWtBQnnxAZosx1NwooUW+kdfG4lJt+GOP++T
	PvsZIPa+5LwdhPFCvY0Xeozvw8uVEyKg/iGg9zYzwQ==
X-Google-Smtp-Source: AGHT+IHkkTRpqYueDGoFPRUw5m2XlmHR5VdjsCOy/vnNZPUFw3AaOJiTeEkVq0ufN8mM54z9zF8WCdY8UT+NTSJXmPc=
X-Received: by 2002:a05:6402:d71:b0:54a:ee8b:7a8c with SMTP id
 ec49-20020a0564020d7100b0054aee8b7a8cmr176202edb.0.1701360221270; Thu, 30 Nov
 2023 08:03:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org>
In-Reply-To: <20231129-riscv-restrict-dwarf5-llvm-v1-0-ec0d368fb538@kernel.org>
From: Fangrui Song <maskray@google.com>
Date: Thu, 30 Nov 2023 08:03:27 -0800
Message-ID: <CAFP8O3KUqhfd1B__MDig1BxAR4bW1KOgGqspnPbm5xEUH9+uxg@mail.gmail.com>
Subject: Re: [PATCH 0/2] RISC-V: Disable DWARF5 with known broken LLVM versions
To: Nathan Chancellor <nathan@kernel.org>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	conor@kernel.org, ndesaulniers@google.com, linux-riscv@lists.infradead.org, 
	llvm@lists.linux.dev, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 29, 2023 at 3:30=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> Hi all,
>
> This series disables DWARF5 for LLVM versions where it is known to be
> broken due to linker relaxation:
>
> https://github.com/llvm/llvm-project/commit/bbc0f99f3bc96f1db16f649fc21dd=
18e5b0918f6
>
> If I understand correctly, it sounds like GNU binutils has a similar
> issue but I am not sure of the status of the fixes and such, so I did
> not bother with checking for it but it should be easy to add if so
> desired.

Using Clang with -fno-integrated-as requires binutils>=3D2.41
https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dcommit;h=3Df1cd8b94e7c=
941c2a9107c1112ab2339916b8efd
"RISC-V: Support subtraction of .uleb128."

Using -fno-integrated-as is less common nowadays, so I agree we do not
bother with checking for it now, if it is too troublesome.

> Cheers,
> Nathan
>
> ---
> Nathan Chancellor (2):
>       riscv: Hoist linker relaxation disabling logic into Kconfig
>       riscv: Restrict DWARF5 when building with LLVM to known working ver=
sions
>
>  arch/riscv/Kconfig  | 14 ++++++++++++++
>  arch/riscv/Makefile |  4 +---
>  lib/Kconfig.debug   |  1 +
>  3 files changed, 16 insertions(+), 3 deletions(-)
> ---
> base-commit: 2cc14f52aeb78ce3f29677c2de1f06c0e91471ab
> change-id: 20231129-riscv-restrict-dwarf5-llvm-a9824bb974cb
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>


--=20
=E5=AE=8B=E6=96=B9=E7=9D=BF
