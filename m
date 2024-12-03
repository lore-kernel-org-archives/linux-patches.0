Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C541DF268
	for <patches@lists.linux.dev>; Tue,  3 Dec 2024 23:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733268396; cv=none; b=keOEH8L2q3SVzdBXjW7ZKGpldl92USFQdj7srRrVynXCBvUCkgzwSiyoigIy+LDul53cN+YOCed3JJDocLhE1PyLI9L1SEmSVnAGkqTOVu0Lyir/owfIZ8k4Y6xg4JCpynaSCHUl7UlApLcAsLeY0uYw3jkkmTZHYmUJb2EvCBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733268396; c=relaxed/simple;
	bh=A+NygRxfATzmDDYl4BW+aoTxyFsALc+e05mYyvBpsWU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZDxxxwjxrH3JAqOOF2Te7KH8gLbBTCQid+radA3Wm1I/Tm7YRJPeo0Z0Jpxc1nAyjdQs5MLHjolpHpUxZNh7puA76sU0quXwHmE1qXyIoePFfO+4n2pBwfo5fMXhCaTA6q+Er63yBBjV15Q7sTbBoI+HKK7YzgsYLPihxGVc1MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jVHe6JlO; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jVHe6JlO"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5d0c098c870so555911a12.1
        for <patches@lists.linux.dev>; Tue, 03 Dec 2024 15:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733268393; x=1733873193; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h0gsOOV1IK0tbYsC9eBpU6WfUiWf0dqVzzhWYdaHF04=;
        b=jVHe6JlOsBZGVHCPGVVrJF01jf4d5x3APBK6/FgjVGy/+bjj6cI4wOLgK6dPp1X1bh
         pc9fl2X0KBTm+c/WrO8Kc5PNQsVEJkwVssl5qfeNhYJbI0j/XFQ4roB2j5vAwUs6x8DO
         1jfJOdeuuzCL/OwAg5ex62/oLu0IBC/QYliZGxhI71FjWFD/gQfE5cl/685XjqFoOmai
         TbAd6ocM6GrNeiUAHIp9BBedzX6+x+vGoYRpnTKWpN8iBWBUyPcZsnOOPApwUdxMSK9C
         sFxpoIFuB0Ud2ewt2jclp8/oq/FjHhvsQE6t3iNJhmfvfCEg7SWJbPFYTttaq07K0HJ9
         KCuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733268393; x=1733873193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h0gsOOV1IK0tbYsC9eBpU6WfUiWf0dqVzzhWYdaHF04=;
        b=YCCcbhoQSKAkzM6e+Njr6f/NMHNEYvM3f1JoUYlze26GgkLM9wB3WMz67Qf7xMEJ1w
         GcCgJyh1Qaz7sAEMPdhNyChnUCtJGNymaWiSNyy1UaFY6BAptaeYuNoXjQrXil2sIbAR
         Yk0gTGFRbGDAwGdI/72HfRL0m/gA+PhTveOT2/POxS5zYwY8HaCIhaa8SSzWHskR/dT4
         dOuZJ+a0yMn5wq96ixtBqQK9/xZ38kSYztqiOtcrjjF8w82nwhfIo62Ma7NGWQItmSzg
         UK+eSQVF7VHynxVQw2S65drjhgvJCB3FbWC32safJUuJ782oh+erPughoXtVmJdTQCp9
         9Cmg==
X-Forwarded-Encrypted: i=1; AJvYcCWCkvpkWUBYdBU36rZotH99eNTaxeIdwM4Cp1mpiUyTvKXJlSIuVaz/VEOQ9DUZpRsz9yCL07fC@lists.linux.dev
X-Gm-Message-State: AOJu0YxYtGMGnNhixBz1qhA71+c/SEYqehvD/GjF2wljGwzUr4Fm5rH5
	mIuEmZTT8zvqex3dHS5ZWQcUpB1e2HmHUtOw4Sq56YZ/TbbvQTo7EWxTcEGFhBT1YkWBs9cql9w
	Z3VTnMIfwQjzQZIxD7gUiBqz7snnUU6lCCmEB
X-Gm-Gg: ASbGncsA+jwgj5N8OijHi9TEtuWkln+X4ionxmHjIGa34lPsgYTpmo3+ji/6lkG+nCK
	fN1tlW6gW18RoanCkM/KksRzSx6GjRq7AiGNcgLOEvGF93UL162P6RqXQTWFC32h6
X-Google-Smtp-Source: AGHT+IG44HltO60JYgYmVvMEo3QlcFo1P0mYiAAGDSp4Skz4zAxbxt9ZfqfNSvUY79c414MNywqlUX98rVVFvuuFn2Y=
X-Received: by 2002:a05:6402:1d49:b0:5d0:e9a8:4c96 with SMTP id
 4fb4d7f45d1cf-5d10c2498d8mr3918350a12.9.1733268392481; Tue, 03 Dec 2024
 15:26:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112184455.855133-1-ojeda@kernel.org> <CAH5fLghFZTG2X_mYE2yGJwPM31NrJdkA-cpZTCYsdghR8YdY8Q@mail.gmail.com>
In-Reply-To: <CAH5fLghFZTG2X_mYE2yGJwPM31NrJdkA-cpZTCYsdghR8YdY8Q@mail.gmail.com>
From: "Hong, Yifan" <elsk@google.com>
Date: Tue, 3 Dec 2024 15:25:56 -0800
Message-ID: <CAABy=s1sEzJZBR6Mt+ujFY_SSbU_OgKDtOs0+bxXQhTo9QZtGA@mail.gmail.com>
Subject: Re: [PATCH v3] kbuild: rust: add PROCMACROLDFLAGS
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 13, 2024 at 5:34=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> w=
rote:
>
> On Tue, Nov 12, 2024 at 7:45=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> w=
rote:
> >
> > From: HONG Yifan <elsk@google.com>
> >
> > These are flags to be passed when linking proc macros for the Rust
> > toolchain. If unset, it defaults to $(KBUILD_HOSTLDFLAGS).
> >
> > This is needed because the list of flags to link hostprogs is not
> > necessarily the same as the list of flags used to link libmacros.so.
> > When we build proc macros, we need the latter, not the former (e.g. whe=
n
> > using a Rust compiler binary linked to a different C library than host
> > programs).
> >
> > To distinguish between the two, introduce this new variable to stand
> > out from KBUILD_HOSTLDFLAGS used to link other host progs.
> >
> > Signed-off-by: HONG Yifan <elsk@google.com>
> > Link: https://lore.kernel.org/r/20241017210430.2401398-2-elsk@google.co=
m
> > [ v3:
> >
> >   - `export`ed the variable. Otherwise it would not be visible in
> >     `rust/Makefile`.
>
> Despite the missing export, the previous version worked for us too.
> I'm not sure why that is.

It happened to pass the build when KBUILD_HOSTLDFLAGS was empty, which
was the case when it was not exported. But that was definitely not the
original intention of this patch. Thanks for catching it! I have
verified that v3 correctly exports the variable to sub-make and still
works for our case.

>
> >   - Removed "additional" from the documentation and commit message,
> >     since this actually replaces the other flags, unlike other cases.
> >
> >   - Added example of use case to documentation and commit message.
> >     Thanks Alice for the details on what Google needs!
> >
> >   - Instead of `HOSTLDFLAGS`, used `KBUILD_HOSTLDFLAGS` as the fallback
> >     to preserve the previous behavior as much as possible, as discussed
> >     with Alice/Yifan. Thus moved the variable down too (currently we
> >     do not modify `KBUILD_HOSTLDFLAGS` elsewhere) and avoided
> >     mentioning `HOSTLDFLAGS` directly in the documentation.
> >
> >   - Fixed documentation header formatting.
> >
> >   - Reworded slightly.
> >
> >          - Miguel ]
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
>
> Tested-by: Alice Ryhl <aliceryhl@google.com>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: HONG Yifan <elsk@google.com>
