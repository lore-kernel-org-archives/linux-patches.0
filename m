Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482651667CD;
	Fri,  9 Aug 2024 22:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723241764; cv=none; b=FR0A+gNB50vw3H9tyjPuKtniHaPfgWbxzqqjyP4HQjvz1sz0f3nFT/JFAQiKNLIjhpfNTtfjBcDSpYXAd8cJuNkkya33KkdDNFlIAKsh7FshQDayVlzphY8/6F8VO6NbqLYJzc+WkAxFqWquyNo2rAtjPVYruklziCXYXhyv8Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723241764; c=relaxed/simple;
	bh=Vyz7mOQSobTax2GI/PV4PZxzi76IZVTiDNoNh8/txbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hu00S4SULewESbMb6VcLJ1d/6qQCP1NGgMVcK4FsseHHmS1nvOf8YbuS9kK1uvNrjUoVLACRNaPz0tQB6MbZVKQ+AYdQjadyjwhFd60Gn06SCAtWvdRIRPSKkURrfzt0Wo4YX8ye8eyKRXHAGDKC94DMNCa6tqPi2SeV94XtUew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WHqSk3hu; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WHqSk3hu"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2d1c1fb5cafso1800675a91.2;
        Fri, 09 Aug 2024 15:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723241762; x=1723846562; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7QajCiM9J1gZRiKmQalSp88+y2PjJcBm2h12qCDW+tY=;
        b=WHqSk3huQTQ4I9ORO7fpe/QD0o589T0ouqqC+0vBW2+Fnfuwf6nnPHKuxqhY1KmWtY
         a8KQAbGBIgLoWKWwBRuLU2cQwR5ZufKh8gAiv2ZaiZ2/IzmHo27qBjpeJr6tH9oOSh9P
         /u4fpFOS35Enwnu3Pv72X3U3nQsbibtULxNN0E5EYjX216H9XZv3oqYlEkztoeGTqX9/
         8FajRX7wBSwVPAkLEUKKXAV2EbzrxQvYP9t3uh6w3IBF/qIJ7VLnZaz4iEEapVeO/rbG
         WIhVEb7qX4HCgVB16XeSEmyseFiDKQDhTIDKMukoYvtGRh9bzmBn/E5YhMzAERZClFGQ
         SP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723241762; x=1723846562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7QajCiM9J1gZRiKmQalSp88+y2PjJcBm2h12qCDW+tY=;
        b=UzvE95bxH5UX0IzX9UgMHm4vCWiiumRQ9CyuOK8F6I398fb5VtcBMURyc+kwZ1jaVP
         BqhgRdzTCgwYHm0IBw8AKj9WUGXPnXv8ANjksYv4FzvyMblWf8uAkAYymEDCjr7gQX+J
         4fej4BEUBpLW+YuttJRMrhQK7VG1J0NHAQa8VBK3UVDTaAbOw8nD1YJ1ichhpIxOy94Z
         9TQsFbmUOu0+RDiDMhwu8CW1r4L8dRS15Vu0q2/DCuUActo9OAsu3NZlt648lbuI/7tx
         L3blASxRRc253uzSilCW7uJSaHfNVHxMqGd/H/RFDxq9PLVV+nRISgcyza9xs/MqX/nG
         KVTA==
X-Forwarded-Encrypted: i=1; AJvYcCVxjzJOF+u1IT6hPYeyoXPvPP//kPHkTofejAW/d/gpNgD6ZJ4ne5PJbV3CTMnGUGy8TbnddDJDMfZCdRy69+W7MxHFphbJ8rus6yqaaoZMJzD0YwWT3dWDVaPTQjY=
X-Gm-Message-State: AOJu0YzLHQ9x7YGJ/VlEUK+xEmz3dwTXK89du7B5VeAGDXXi/xlXR7y1
	6r2iIYOVlkmFD8dbd+uJ+nBuIB9Kq2yYtt+YBNuNDKrVRlD91DsphFLTYNBf3H1fa9WutOt/XSi
	fUadadJPr0yTDyvuBF4ChTnP7yuw=
X-Google-Smtp-Source: AGHT+IGqhAIMpdcPgTvG4Lm0bG1VLto7lgkIz+dlldbt0bpWrxp0o616hdq+TZ0DclexAS+zwSJY7UTJsSeXk+LcnK0=
X-Received: by 2002:a17:90a:b113:b0:2cd:b915:c80b with SMTP id
 98e67ed59e1d1-2d1e8082b97mr3276313a91.27.1723241762470; Fri, 09 Aug 2024
 15:16:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240806144558.114461-1-ojeda@kernel.org>
In-Reply-To: <20240806144558.114461-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 10 Aug 2024 00:15:50 +0200
Message-ID: <CANiq72nH9KZZKtDsMkfosmHpgVjvGM6=yy7fRyNP2NrDFUrkvQ@mail.gmail.com>
Subject: Re: [PATCH] rust: x86: remove `-3dnow{,a}` from target features
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Nikita Popov <github@npopov.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 4:47=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> LLVM 19 is dropping support for 3DNow! in commit f0eb5587ceeb ("Remove
> support for 3DNow!, both intrinsics and builtins. (#96246)"):
>
>     Remove support for 3DNow!, both intrinsics and builtins. (#96246)
>
>     This set of instructions was only supported by AMD chips starting in
>     the K6-2 (introduced 1998), and before the "Bulldozer" family
>     (2011). They were never much used, as they were effectively supersede=
d
>     by the more-widely-implemented SSE (first implemented on the AMD side
>     in Athlon XP in 2001).
>
>     This is being done as a predecessor towards general removal of MMX
>     register usage. Since there is almost no usage of the 3DNow!
>     intrinsics, and no modern hardware even implements them, simple
>     removal seems like the best option.
>
> Thus we should avoid passing these to the backend, since otherwise we
> get a diagnostic about it:
>
>     '-3dnow' is not a recognized feature for this target (ignoring featur=
e)
>     '-3dnowa' is not a recognized feature for this target (ignoring featu=
re)
>
> We could try to disable them only up to LLVM 19 (not the C side one,
> but the one used by `rustc`, which may be built with a range of
> LLVMs). However, to avoid more complexity, we can likely just remove
> them altogether. According to Nikita [2]:
>
> > I don't think it's needed because LLVM should not generate 3dnow
> instructions unless specifically asked to, using intrinsics that Rust
> does not provide in the first place.
>
> Thus do so, like Rust did for one of their builtin targets [3].
>
> For those curious: Clang will warn only about trying to enable them
> (`-m3dnow{,a}`), but not about disabling them (`-mno-3dnow{,a}`), so
> there is no change needed there.
>
> Cc: Nikita Popov <github@npopov.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: x86@kernel.org
> Link: https://github.com/llvm/llvm-project/commit/f0eb5587ceeb641445b64cb=
264c822b4751de04a [1]
> Link: https://github.com/rust-lang/rust/pull/127864#issuecomment-22358987=
60 [2]
> Link: https://github.com/rust-lang/rust/pull/127864 [3]
> Closes: https://github.com/Rust-for-Linux/linux/issues/1094
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-fixes` -- thanks everyone!

(If someone from x86 still wants to take a look / Ack it, please let me kno=
w!)

Cheers,
Miguel
