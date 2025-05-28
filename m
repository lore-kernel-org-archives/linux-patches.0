Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8CD1B6D06
	for <patches@lists.linux.dev>; Wed, 28 May 2025 17:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748454754; cv=none; b=pBEnEw6qXTNEFhjpVYacY2AhlDM0+wwsr3VXct+VbGnXWs6VKz3ntNvZLgcjXOBpwX8xWZY7Y5+4oDz62EivMkOux5GCrJcWKM9Vi2JlpV7I0VE+W8DWjBgfnKQqI62s5vFM7iXRS6NeYbpopxeZol0elrc2M/BMWmke2mulMDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748454754; c=relaxed/simple;
	bh=vWV6pFxU84IGZGUoXRovBE8SqKnsLvakTEWtNwoyHmM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kx4ZLYFjwTLCnOv7L53QT5w2pXqIj35t68EEdsiO9t5ZwiGWT6PNY2G48TeBMM4/HCQqTOem1SomeuUZHSEXdvxh1e/oEsH14L9fJPau8TmHD+Kr+0phiG8lyfRIqsiHJ46ceEqOi2SYcj4bsvTBOreVA2/aIm0eIr5e4VL2TVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aYiaaFsn; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aYiaaFsn"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-32a696ff4deso274781fa.1
        for <patches@lists.linux.dev>; Wed, 28 May 2025 10:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748454751; x=1749059551; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ppv3VDPBQkSzYVgwGTOT8u09rusvnRbmtGkE8XpfbQA=;
        b=aYiaaFsnrFb5twS07BA8G7PqGS2/INUBrRSRJHT5ysWv+ZD1n7D8EyZkxCPJSOKt1x
         lbULD6yb2Gdj6cQKrSbK2KTWq1jpD7OIszWwVbAa6vEelXHAxfKrk1b00h4YLfNbx3yY
         +UP3gZb4hnk4UOh9OhnDjCsz0VptgaLcoRu2nVETuiAWMr0h+J2/h0qS6WJg5leQNk/l
         K5nqK0AvhBTyMVsEJL7GetAJuZE/a4RyeS7jxQhphSHCi/5XPpSirbyCAuHhQjde9xlJ
         eE5Mqn+9ahqF+UIVdlJKWVJN9sVj0V0qq6w4lRcNDRBJPQNLGk2ByMu+6OYI4JUeRJoL
         VlLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748454751; x=1749059551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ppv3VDPBQkSzYVgwGTOT8u09rusvnRbmtGkE8XpfbQA=;
        b=soqoBnHAHI+5J1tiRnrF9oS9b9hxZ6TWdZOiozy/jNzYwiNbsSASit7f8cptglHaDl
         BPm0FHvtH1Y1Qfi1k/X4ynD/7mR6fWY+deljCckQE5+S57bcboVc5PUOgOcwXrlQyR8A
         jcCff5vYJgRJgcZR+nSweZA5nTSU3rDI8gUJCFPSKu4xROvkKoAJDtZC9z/DOAJYJa7P
         ZdL3OMSy7IzG0pnyo2ecZFNgvCTTLwY5GAseiDmVYtzvIhMdlvSWqjlNYXCWP3G0XAfX
         QEMfyHJZMPBAi9xTvuBPSQS5aSr7+Tq2KT8l9JM7znvs7bMCqJKfu3PG64XpmLKrgRP4
         OP2A==
X-Forwarded-Encrypted: i=1; AJvYcCV1LYxnI7MQfA/S1e6HJV/peRnPawg+4sE+Vhepv6CU9LFqHcvl61ASLsBabtyL3XSvnEDPz+h6@lists.linux.dev
X-Gm-Message-State: AOJu0YyZXQ/IE8fgfDfJXKqPZl4UjWS28D9Xs2TZpYWZArVtaDSFRn7R
	vMl2ue/qif5SpaAALHdVH3/0+Y7NrVtuNAkm5plqk0n5/eJUkwJAlKb1nvncsjlXFXSoP1eJ/7H
	f+LUUPqZ8fZakxURdFLKSBLvYZoSE9Q==
X-Gm-Gg: ASbGncukxmeZ0AoQak1apwizHWLNp3d22Mr8ZEuxzdDqnaJ5B1sZ2Is7Lg3WN4twoEi
	etGjfpT/zP9hPEbWnq4/WLTZqK4QED6MNVlqFHMT24JBxWHDEo4+AwBfg8xHPLCtfK9dRDAT2U8
	aF3PXMFwSnt1pztD5d97hssCjRzj6xZ1FvX08UALs4qgh2r1I=
X-Google-Smtp-Source: AGHT+IG5KLdfR+fEOhbik8NTuMW2Ep+S2YOtM3aD25vx0ZaGUqb9CFH02FVAX/Xop5uw6u7nS5/j+BbuqTJo+yqRm44=
X-Received: by 2002:a05:651c:242:b0:32a:81a2:8aa3 with SMTP id
 38308e7fff4ca-32a81a298bbmr3089821fa.23.1748454750453; Wed, 28 May 2025
 10:52:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250527162513.035720581@linuxfoundation.org> <20250527162530.470565771@linuxfoundation.org>
In-Reply-To: <20250527162530.470565771@linuxfoundation.org>
From: Brian Gerst <brgerst@gmail.com>
Date: Wed, 28 May 2025 13:52:16 -0400
X-Gm-Features: AX0GCFusT9QM7HoblA1N2WamyQAgGgwUNJQRzcqUgne__EWwKhBrhNsGvTNbRNY
Message-ID: <CAMzpN2hwSXUybfvcas2X5213V=Ow+nqGqqurC_tjfCdb44aFfg@mail.gmail.com>
Subject: Re: [PATCH 6.14 426/783] x86/boot: Disable stack protector for early
 boot code
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Ingo Molnar <mingo@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2025 at 1:39=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> 6.14-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Brian Gerst <brgerst@gmail.com>
>
> [ Upstream commit a9a76b38aaf577887103e3ebb41d70e6aa5a4b19 ]
>
> On 64-bit, this will prevent crashes when the canary access is changed
> from %gs:40 to %gs:__stack_chk_guard(%rip).  RIP-relative addresses from
> the identity-mapped early boot code will target the wrong address with
> zero-based percpu.  KASLR could then shift that address to an unmapped
> page causing a crash on boot.
>
> This early boot code runs well before user-space is active and does not
> need stack protector enabled.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Link: https://lore.kernel.org/r/20250123190747.745588-4-brgerst@gmail.com
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/x86/kernel/Makefile | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index b43eb7e384eba..84cfa179802c3 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -44,6 +44,8 @@ KCOV_INSTRUMENT_unwind_orc.o                          :=
=3D n
>  KCOV_INSTRUMENT_unwind_frame.o                         :=3D n
>  KCOV_INSTRUMENT_unwind_guess.o                         :=3D n
>
> +CFLAGS_head32.o :=3D -fno-stack-protector
> +CFLAGS_head64.o :=3D -fno-stack-protector
>  CFLAGS_irq.o :=3D -I $(src)/../include/asm/trace
>
>  obj-y                  +=3D head_$(BITS).o
> --
> 2.39.5
>
>
>

This doesn't need to be backported.  It's harmless, but not necessary
without the rest of the stack protector changes.


Brian Gerst
