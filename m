Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676EE173336
	for <patches@lists.linux.dev>; Fri,  5 Apr 2024 19:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712347077; cv=none; b=K7+Z+p+ZQKgv9y4vZ7+uFAb/5lJ4zzkQC7uXhrTgYT9/tXwiuTaLWdqT1TPDep6wtoh2BBWYKz9kwwTapd2C8Q0imyG7adtldi7z/X+pBuwZDCGrHBGOTHjtKd9EBykF3uLiOQuZMwJujJYGm5sOPNBSeTABLzFTTXV98P9X9JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712347077; c=relaxed/simple;
	bh=vcGVlRQz1k/GxZb7T5mm+BvlwaKO6QWZVTPvRp5hpQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LzaMSSFvLOq+EJH4Ua+iBU56ojIN7wIVZb9O4iDEnW4OJH4+OV1kBPlfHmdq04KfSsuH25X5b/+ifCdRgqRZ3NBq1OJhqoxRXPJMWEnHDnXCG1tivkiHoQQDrxSydPdBKI/2nggImQVaA6tiHOlHGxhI0H8TBn5qttDTpKJQXWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fbg1g8M7; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fbg1g8M7"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-516d3a470d5so1544818e87.3
        for <patches@lists.linux.dev>; Fri, 05 Apr 2024 12:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712347074; x=1712951874; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=djSDb4ARr+uYrvgN8eRFQUZSJ4nYLrBVFrRGdM6sRAs=;
        b=fbg1g8M7mv02ixQJU1+a9tF1JnX8xnA4NWGoV1EuXFGJkBsPxWicIBiYflXBe0feZX
         wpdOeMGrR4S76iAk/XNY54Ao8FPAlfQp1EghItxx1uvv5E3XyfoAj5vd09Fn3myfPN7T
         nxnwnNh3qulGZLmWjnDKyLmqF/nQ11ehFeNc0PihkfejiaUvOIuUnJo3KhDbyoCkOS5Y
         lHdRQpppK5ekFHnKvUC5pjEQFBk1VREUbKMEi8unXS54RAgVnOPerozQeL9Q05R30SFU
         I+CvJqjd/Kw0bW58k0WdvVSe6PnnR5OggvB6CF7Bthp8G3fpC7pnKH0JcrUj4mEiR8WS
         sa0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712347074; x=1712951874;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=djSDb4ARr+uYrvgN8eRFQUZSJ4nYLrBVFrRGdM6sRAs=;
        b=Q5PSSd3bu96E4H30VjCPdAQBNRFFbrEeV0iShZ/oQf3AiZi5lY0/SfFe2i6JJ4jS8e
         dwA9V3AYZa5nF4l0ieHXu0wxbbKqxYMatjEUWBty05+FrWuV7Jfr4pFpg//zH7xyCPc6
         h+LLA9WpctaD+Rs+v3FjtQqzZCWFbT7VY3VFDUYMkEMhJBU1JM87b41XXNcY8X09rMMQ
         idsF9VIGV8p0OfWCGtjAnD/NDXlxhzmmzl9ycjFOtPhp4YJutPlZ+A/zL6x3H8QJTQsm
         iWB+kowshkjBPvaKhxTa5hYEiw68KIgTg2IplU4JH7pwbuRTdleqpHmYHK2/Fjg45D8h
         3hAg==
X-Forwarded-Encrypted: i=1; AJvYcCUsRiTUHv0zC2L9Ep5yjXTVnaTw0/mOGLRkyEOxJBTI1z85ahkCa8JDmHBXVbCNdpj0ovCCL9X1PQMNY4s2kmqxsqHhbTFgBQ==
X-Gm-Message-State: AOJu0Yzu1qOi+czjJn9159fgueeSl8Njg8HJrWKVbJhy1PK2D0UA+ezT
	uANk7yVtCC2A9Q+60gNAb01vm8XfygSmBTLdnhgkGkPijXypOeFvPhs1BAsx6mrlZvyWXN+64Gg
	foNvkXQ76d4L08k9JNeE/YTxWwSQK0EWBJJus
X-Google-Smtp-Source: AGHT+IEI5tCV/tLIzJl1zhvmYgYEcOj4a8SU+B1nmDwswy/V0l1zUgcxaVh6wGimoJvL8b/VSgyjgbLEs9K12/PT7hU=
X-Received: by 2002:ac2:55a6:0:b0:513:ca65:8c58 with SMTP id
 y6-20020ac255a6000000b00513ca658c58mr1880055lfg.43.1712347074344; Fri, 05 Apr
 2024 12:57:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240405-ppc-fix-wa-fatal-warnings-clang-v1-1-bdcd969f2ef0@kernel.org>
In-Reply-To: <20240405-ppc-fix-wa-fatal-warnings-clang-v1-1-bdcd969f2ef0@kernel.org>
From: Justin Stitt <justinstitt@google.com>
Date: Fri, 5 Apr 2024 12:57:41 -0700
Message-ID: <CAFhGd8pcaUqH1z=uywHadFUkNUnK_tkoDzf7P5kOqmgEpx5nwg@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Fix fatal warnings flag for LLVM's integrated assembler
To: Nathan Chancellor <nathan@kernel.org>
Cc: mpe@ellerman.id.au, morbo@google.com, ajd@linux.ibm.com, 
	bgray@linux.ibm.com, linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 5, 2024 at 12:31=E2=80=AFPM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> When building with LLVM_IAS=3D1, there is an error because
> '-fatal-warnings' is not recognized as a valid flag:
>
>   clang: error: unsupported argument '-fatal-warnings' to option '-Wa,'
>
> Use the double hyphen version of the flag, '--fatal-warnings', which
> works with both the GNU assembler and LLVM's integrated assembler.
>
> Fixes: 608d4a5ca563 ("powerpc: Error on assembly warnings")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Nice catch.

Reviewed-by: Justin Stitt <justinstitt@google.com>

> ---
>  arch/powerpc/Kbuild | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/powerpc/Kbuild b/arch/powerpc/Kbuild
> index da862e9558bc..571f260b0842 100644
> --- a/arch/powerpc/Kbuild
> +++ b/arch/powerpc/Kbuild
> @@ -1,6 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
> -subdir-ccflags-$(CONFIG_PPC_WERROR) :=3D -Werror -Wa,-fatal-warnings
> -subdir-asflags-$(CONFIG_PPC_WERROR) :=3D -Wa,-fatal-warnings
> +subdir-ccflags-$(CONFIG_PPC_WERROR) :=3D -Werror -Wa,--fatal-warnings
> +subdir-asflags-$(CONFIG_PPC_WERROR) :=3D -Wa,--fatal-warnings
>
>  obj-y +=3D kernel/
>  obj-y +=3D mm/
>
> ---
> base-commit: bfe51886ca544956eb4ff924d1937ac01d0ca9c8
> change-id: 20240405-ppc-fix-wa-fatal-warnings-clang-603f0ebb0133
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
