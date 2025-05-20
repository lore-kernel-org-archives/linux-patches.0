Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AAF26C390
	for <patches@lists.linux.dev>; Tue, 20 May 2025 19:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747769046; cv=none; b=kl1yStSRXb7vmv4riKdVtbInvIu0Yd8xmlJVfRoZQQC2v8VPZ60Ps2taApgqVevgg03QU88GR9nQt2+wDPtoqp+WqN0Ps1OU+gjiCpw2tIDl8jbtcPx+K51llMjDelkbk9dKV7uM7aJGgykOK2/gSB+uiOUL8HBaxEAr+J1P3Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747769046; c=relaxed/simple;
	bh=L1J2+f/o6ewoklc+hKFnSACjTFC2/ANmUYvlgy5NJjg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ep55eN6lYHUr8OkrANfiYLroZCltICU3R0ChsP8HAi8l5suLUkcJfgAYnKrfoRgC7tivS/3v5+7Bog6Xr/VtIB0LHl2NLpNV1OdHpot58mPnLy5rDAWyn5I9uJlA5qFnttCcFswAFCDbChdd2HsSzcg9/z9hbec7q87i8CqTuiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SbPy+9ZM; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SbPy+9ZM"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-54d6f933152so9161582e87.1
        for <patches@lists.linux.dev>; Tue, 20 May 2025 12:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747769043; x=1748373843; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d6XdgS84YDQPuRuy9Jq0oBvxTqOH5n4daq0yM54SeO0=;
        b=SbPy+9ZM+fx1aapiz23647GFsLjfizbBt9GZd4RZu0lGt72KQUa2mvKY+Ibwk2fP9t
         BOBgYkPcaditTY4R/e1fjknvxt3IutSX5Vl2pMY5FPFJ5v8NBI6Q46c5CAQLAL19f5tN
         da2RoXFsYY554mvxgjERECQTfJIneSzx5YdesGKAtU7IbpEEnk9zWNnXBzdGF03fihmd
         HXUeb1UZntag8q/oCVRl5+Bb+i5qrYyr9yCZYdi5qpuPIo1UJ+Q4JowVO4cGCQ1ThxTT
         IjCG1gOyeSj30g/GsNzonUcJ9HNQDLx6YkMLAi/sh4sIf+ed5NxJyq5TpiCZjUlYmr1q
         oAtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747769043; x=1748373843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d6XdgS84YDQPuRuy9Jq0oBvxTqOH5n4daq0yM54SeO0=;
        b=LlaDy0jVSk+X2gGvltiQojdUPbKnDI18qn8pwrzI0b71F2Iyy5UH7A1en1ctfY5HQw
         u0Qt88lrTHYbEQ6XMb9tVtI8fqkyCj34vNBi8Vl8yn1PrphvDibq+ggjbM20zCttG1fB
         gVv6kffiAkACYUM+tJzUAtNR66B4dLpSov08JD8QxssRPAhM5KxuV+0yMI3teSvM+oaU
         6Zo/oJch4WAVQsvZCH9UuhG2Mfbj+ucjPo5QCg5I4V1LqqMwHNoCfynP52QGog6MeyGP
         XlMGadZEYn/JFuCrrRV70vGRdFqPHFFfCk8SeqMdNrhHpGtisgPMmHu2iVxSxV5fKYjZ
         +nHA==
X-Forwarded-Encrypted: i=1; AJvYcCUioPo4Mb/x4RJObC3ZUl7YgXmYdiiqqla/slS+DUgLaf7S0nywsd0Ahaw4DnLd4Dv9UihXwBTY@lists.linux.dev
X-Gm-Message-State: AOJu0Yyw+LdBIhMkOMVgP+f/a+iVUu23jf9szbS/dd3KAqTv7HEn1VLz
	NV0HF1xSWWh3n7DGhHU6feFrq0biyIuGZrNgPYzjmUH7073rUe9TUxD7JunlChFuS8vTTN9hH89
	ORPtdeYgnUBeA6aMQ/VeEmSBX3YTB1Ac=
X-Gm-Gg: ASbGncuHzzKxCm3FIUL+z2FsEAbi/HC0Vo/gBQesFl2EIZC7CZVQxInMmSNtHA+sbMm
	+sJtA6+o6mhUOEPSNANz1jvwTJWtXBi8v4tGDANs4Oz5F1rTv/bBIrNZBkkqjbeZVmXQT4QxH0L
	XdO9Kab6+Vccl1yTEdB3n5P43FZWwHgOODp06nSX4TiyjcHbWOpZTDwcsuF0adGinfbesbBF1PW
	1fO
X-Google-Smtp-Source: AGHT+IFz3JlmJoyJ1wap0ojoWn4Wrko8mlIC7Ep/pg5OlmQk3tTzNnmLB3I17P8W6HKbwMRLn0gUghgOlCmTVzkS+jg=
X-Received: by 2002:a05:6512:3e17:b0:54d:6dd3:614f with SMTP id
 2adb3069b0e04-550e97cbca5mr5277052e87.21.1747769042589; Tue, 20 May 2025
 12:24:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520192034.889415-1-ojeda@kernel.org>
In-Reply-To: <20250520192034.889415-1-ojeda@kernel.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Tue, 20 May 2025 15:23:26 -0400
X-Gm-Features: AX0GCFuaLSbZQ1hVvU1lb2VxUKLxVWKNlDMNxG3qmRXP7Db0x4G0ZVJV-F0CVHo
Message-ID: <CAJ-ks9=4DJdbUBiy_45wWPviOs48NEK1DmeqWnDaFSpkoda_GQ@mail.gmail.com>
Subject: Re: [PATCH] rust: kbuild: rebuild if `.clippy.toml` changes
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2025 at 3:20=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> We rarely modify `.clippy.toml`, but currently we do not rebuild if that
> happens, thus it is easy to miss possible changes in lints.
>
> Thus rebuild in case of changes.
>
> Cc: stable@vger.kernel.org
> Reported-by: Tamir Duberstein <tamird@gmail.com>
> Closes: https://github.com/Rust-for-Linux/linux/issues/1151
> Fixes: 7d56786edcbd ("rust: introduce `.clippy.toml`")
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/Makefile | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

It is possible to do this only if CLIPPY=3D1?
