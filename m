Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E632B273FC
	for <patches@lists.linux.dev>; Thu, 16 May 2024 23:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715900901; cv=none; b=ZVFIRgLga5GuKqwyREZ14KRfm3aterATYucTBL1NkKbZBplMyvFmRJRa2rBEOjZ/1kKSQcAUGWECfrF/KhrwM6lwkrmzxNcv1QvVzWwQ5ZvKHIee8/OQDQwF2FQ35tUFSnM80/fl3Hs5Ty7VPUe1Rg/3B76km6IS8fEXlZ9waBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715900901; c=relaxed/simple;
	bh=EP942SqgqU+2g95deuGJUqyAMQDCgoYsK8UTO8Gxpcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ov6QYzjdk43i+H3v7s0wCneus9CafyY3P9bG330HHCXFkwvIWTzF0LyFOZMIFkUFHxDipGevgjURyx2P1PXC7oiYz+qC4hKIGxk4QR8HB7sx+znfmTD4ONoBwzE0C+J+HlTUV8G5mcbEzXkqiTQNQB/f5Ao+uPQATPj4208vkMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AUlDf7Lq; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AUlDf7Lq"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4df5676b06fso31587e0c.1
        for <patches@lists.linux.dev>; Thu, 16 May 2024 16:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715900899; x=1716505699; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gak+/oovP81PfogPpqJsHd/1CwWJ9r/ylbJlVjZgFRo=;
        b=AUlDf7LqVpVphba2YCU8W8N3XI12RuMFR1sZEnmUwY8qqXSXm0ElSRbzrBZdf2WfaI
         vNv+gw7gYpFVQhwKX890D3wgU3WVmdLCoOoyoXQ1bVnKoSaS51O5oXyE/6wjo/MGkIK5
         GQNg5j61wks7eKngVMG1FVU1LSFuHfw4ctz9UhJoClJy44lAmb8ZAJc9/xfCQveFVG4J
         MtvaT+pyMud4CGegxBJhDdvvX8YAUUPdmDLq0G9mlpzEMpCx9d/dtPWTyWoEUyAyGJiN
         Gh1HL3VZGH39qiN8UL/zBJDUTHHg/3sm67W5Ut74UEG2G2uGJUUp1kezG8exA5yffxJ8
         u79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715900899; x=1716505699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gak+/oovP81PfogPpqJsHd/1CwWJ9r/ylbJlVjZgFRo=;
        b=RljUTKnH1b8RrexDrTbrKaNdfMV+kPsP+2xy6r3g+ynas628uNx0WDW1Lkze76QOAB
         zwJVvt7+eIVBI0KfCWGxjyIgVLs1jBWVKanSZxrFI6uG83Qkgoh48oX9Ti/lqQx79Ku6
         budiOn6kA15XglOyugVbH3Vwb24Ftrb8hOso9wdmiRpDFETwqqZJL8zkk7asaik2JBXf
         rtzG///xtmZsSpyaKDm4SkjN6CPW3LdFlHRFE+3Dvc/oPavxGGUQXas65Aqmfp3LtdBE
         H327IeB+mu7F+U59iKBKG4t0uchE2hLcqKwGjvZtZbR5yRBMs0ul6RSlxDXjPbCNRKo0
         LZTg==
X-Forwarded-Encrypted: i=1; AJvYcCX9A6Ji2GR4FW359scD9UGiIXnEfqkqgfgxJA6T/JBMxcpXgpkcFOqh5ylu+ONHNOM3CpJCpHyIrMF6qjTYEagj/dbbM9T/4g==
X-Gm-Message-State: AOJu0YwAwS/61zimO7eaQxlQuLYUOhetQ8IwEjkP750SSED/BzdRi4oq
	wW6NuN7jkIsHFKCzVRBIbrVJn4xs1xiRtvEzy50BPSRFmvcUXxsRkhadsOxBh6VL+LzKXVDJuhx
	xWZsCq+pFtCpjogVUJyGF7CZfc1HSah3zsV5a
X-Google-Smtp-Source: AGHT+IFMgTb54aBiq7xBfnDGVVGoTPJD2NkwNvHCirLNFVItNElpLuHUDLgn7UWhCRx47d2b9REE8C02r6/bHnLb5WM=
X-Received: by 2002:a05:6102:3e26:b0:47b:b8a7:7ddc with SMTP id
 ada2fe7eead31-48077eb4acdmr25780377137.30.1715900898508; Thu, 16 May 2024
 16:08:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240516-x86-boot-fix-clang-implicit-fallthrough-v1-1-04dc320ca07c@kernel.org>
In-Reply-To: <20240516-x86-boot-fix-clang-implicit-fallthrough-v1-1-04dc320ca07c@kernel.org>
From: Justin Stitt <justinstitt@google.com>
Date: Thu, 16 May 2024 16:08:06 -0700
Message-ID: <CAFhGd8oAunv=+xT84hC2hCp3F-=Oy_gvK08eRmD6nk9xwCvWzQ@mail.gmail.com>
Subject: Re: [PATCH] x86/boot: Address clang -Wimplicit-fallthrough in vsprintf()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Bill Wendling <morbo@google.com>, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2024 at 7:03=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> After enabling -Wimplicit-fallthrough for the x86 boot code, clang
> warns:
>
>   arch/x86/boot/printf.c:257:3: warning: unannotated fall-through between=
 switch labels [-Wimplicit-fallthrough]
>     257 |                 case 'u':
>         |                 ^
>
> Clang is a little more pedantic than GCC, which does not warn when
> falling through to a case that is just break or return. Clang's version
> is more in line with the kernel's own stance in deprecated.rst, which
> states that all switch/case blocks must end in either break,
> fallthrough, continue, goto, or return. Add the missing break to silence
> the warning.
>
> Fixes: dd0716c2b877 ("x86/boot: Add a fallthrough annotation")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202405162054.ryP73vy1-lkp@i=
ntel.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Seems simple enough.

Acked-by: Justin Stitt <justinstitt@google.com>

> ---
>  arch/x86/boot/printf.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/boot/printf.c b/arch/x86/boot/printf.c
> index c0ec1dc355ab..51dc14b714f6 100644
> --- a/arch/x86/boot/printf.c
> +++ b/arch/x86/boot/printf.c
> @@ -254,6 +254,8 @@ int vsprintf(char *buf, const char *fmt, va_list args=
)
>                 case 'd':
>                 case 'i':
>                         flags |=3D SIGN;
> +                       break;
> +
>                 case 'u':
>                         break;
>
>
> ---
> base-commit: dd0716c2b87792ebea30864e7ad1df461d4c1525
> change-id: 20240516-x86-boot-fix-clang-implicit-fallthrough-fc5c9bb19765
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
