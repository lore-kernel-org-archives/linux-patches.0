Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE9A2690D5
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 12:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113730; cv=none; b=d7DlJGfNWcZVp27gDwVXb2UF+YuHMJHTSvbXGyV/pvp8GYaGep4QLKTrjNpyP1yQwFVpTVMxmnU7EmENqVZnp2uHSSBCxbv3XrkQ3+1uVRq+3xkV0csNnI44zRJ/mjtH0BqlJZEN48K5nDMIuPQn3nL8GzVfJcZWo0gy+cagvzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113730; c=relaxed/simple;
	bh=UFixeHLNjdQjTR+kkvlptM4ncETLW9p2OBuXaKgwWbA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a56eTgzSpesvCy7kgHkHzMeZe/lh79rjsQn+pbnwSu/ESKHF8WGUQhVPyOVDDgApRnQ/yIP0744e9OehbxJfGORYYkvmaaPR7cZpfh9a+aD3kNglQfHCrLVzMhJDpu6jJSYtPLvdzKUMA/4EptrjjdLItw02EeVYsFvcRaSNrzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UWty4+QR; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UWty4+QR"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3995ff6b066so2981580f8f.3
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 05:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744113727; x=1744718527; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TaB33ZWJPGuieEub6nK71J8fMj0CB/UDsbyRfDQHdI4=;
        b=UWty4+QRtKnyACLdcx2TTzh28WJgWPUUoYIZv1YtZ9v7+1LsSzBH7DA8DmD6VtwE0L
         vVTab2Stq6UZ47qcnKUQyEel4S9hByTj6DPocrFXPdVIUVZ2KgeNkDP93e/TqvoSNlUJ
         8hOps6gI7uz3sWH0ZD0B0a3tGAsKyIwYApbZF/R6HnreZcjTmWr65u8j8uGBNiQBvYJX
         fVpgzhYR/ZEOCbKq4Zvms+i7jDCqoIHuKLnZUqCEdb4jWGteqvCAT0+WVj0TS9b9nrDT
         5KY93Hg6M+wrU8CkEOt7lpnPNzcxzq7iG/9YPluvSPqK77soiq0pD2y/7X+ggiPpcyN2
         tLYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744113727; x=1744718527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TaB33ZWJPGuieEub6nK71J8fMj0CB/UDsbyRfDQHdI4=;
        b=hLk9g2+H8aTnYoZrhGRyY+SmM2aAvX6N8MAnqh1q8F48RgYSr0tT3TbHQqB2MqIW6j
         GerRDWYkuc+Uf+zjgriDHQPhMW9mD4C0MBDfyOQWSn/Ha5OTStkejCurJf03ERmbdfMe
         Kb+CZfOXl2HADhm+UegKhLJy8szP1m1bIwZguqPb6yjrq8YfhfG0HI6P2ApgZRORewWM
         JZQJL+lVwmqJ7i6mGFJ9AvPfi4DJ0MRtB8FtsPrhRYRndSWJfcLFcNC49Ey1UBDFgcol
         pyXagQGIpWta1lb1/T+TVS/Rb3f9YaOBTeIVeuHBv299s7HnNzKzpr/f6CMkdbdIZ3Mk
         OSYw==
X-Forwarded-Encrypted: i=1; AJvYcCWPF5EbLb486JsYRiGbLKeLWGXaGrkuCRV9IgQrvV15Txfm8nzo9VsLUPtoPZPrM8aaFxDj9I/3@lists.linux.dev
X-Gm-Message-State: AOJu0Yyng5TK9bsbBmaOlRvwzZ4vLtipzcUwMH6SQsURb5YBdhPVrPUG
	zaaFM9eup8aPlKpkAmZ3VWfaK15ZYeV11XvaIXpGZ0IVIzUFIPFFN1onMH8S2OF5OeE4l9uYWNB
	B7bbSUTe0F0OEFX5GNah/X+ph73r3ycLpbVL1
X-Gm-Gg: ASbGncu21QIaYknA9g2mi+iVGAhqmvVCBToKF6OVTh2vt0z82eZbWmjeLH3MHFH9Z20
	Vc8mZPPjwff3uv23GMsqaPFOLAZ8oQ2X7LHCHAJ3syqEvwfJsUw72lQz+F+MVsnjf+RxrGJ6pkM
	/MuQrMhR+zHEdb43/IKxEod2UD3ppY5Fo9HZCe7z79pSiF3zTmtYD+nnG0EM9+6OCb2+8=
X-Google-Smtp-Source: AGHT+IHXn3WJ6YCdSECNM+7ovqF4F6BBSSghd/853rpu4Q9m55dL3x51uqHj8qHREP2y60W+P/vi1GG5MRr/eiKRt0k=
X-Received: by 2002:a5d:6d8e:0:b0:39c:1257:c7a1 with SMTP id
 ffacd0b85a97d-39cba93d0bbmr11770462f8f.57.1744113726698; Tue, 08 Apr 2025
 05:02:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408104828.499967190@linuxfoundation.org> <20250408104830.890872754@linuxfoundation.org>
 <CAH5fLgj6SEKy1-CopXTnaFWK6WFddP+ahccf1_MdabpeCuB87A@mail.gmail.com>
In-Reply-To: <CAH5fLgj6SEKy1-CopXTnaFWK6WFddP+ahccf1_MdabpeCuB87A@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 8 Apr 2025 14:01:54 +0200
X-Gm-Features: ATxdqUFkRj9aDnv5yAULCjRgrblo_P7OU2VhSsBvhEFQYpsjIS9BRcEt53vb5D4
Message-ID: <CAH5fLggOycGwNKXS-=3oO6tSN+mA2YOnJpXBGOOK5pEO6A=qfg@mail.gmail.com>
Subject: Re: [PATCH 6.6 089/268] rust: fix signature of rust_fmt_argument
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Tamir Duberstein <tamird@gmail.com>, Petr Mladek <pmladek@suse.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 1:57=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
> On Tue, Apr 8, 2025 at 1:54=E2=80=AFPM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.6-stable review patch.  If anyone has any objections, please let me k=
now.
> >
> > ------------------
> >
> > From: Alice Ryhl <aliceryhl@google.com>
> >
> > [ Upstream commit 901b3290bd4dc35e613d13abd03c129e754dd3dd ]
> >
> > Without this change, the rest of this series will emit the following
> > error message:
> >
> > error[E0308]: `if` and `else` have incompatible types
> >   --> <linux>/rust/kernel/print.rs:22:22
> >    |
> > 21 | #[export]
> >    | --------- expected because of this
> > 22 | unsafe extern "C" fn rust_fmt_argument(
> >    |                      ^^^^^^^^^^^^^^^^^ expected `u8`, found `i8`
> >    |
> >    =3D note: expected fn item `unsafe extern "C" fn(*mut u8, *mut u8, *=
mut c_void) -> *mut u8 {bindings::rust_fmt_argument}`
> >               found fn item `unsafe extern "C" fn(*mut i8, *mut i8, *co=
nst c_void) -> *mut i8 {print::rust_fmt_argument}`
> >
> > The error may be different depending on the architecture.
> >
> > To fix this, change the void pointer argument to use a const pointer,
> > and change the imports to use crate::ffi instead of core::ffi for
> > integer types.
> >
> > Fixes: 787983da7718 ("vsprintf: add new `%pA` format specifier")
> > Reviewed-by: Tamir Duberstein <tamird@gmail.com>
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > Acked-by: Petr Mladek <pmladek@suse.com>
> > Link: https://lore.kernel.org/r/20250303-export-macro-v3-1-41fbad85a27f=
@google.com
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> > -use core::{
> > +use crate::{
> >      ffi::{c_char, c_void},
>
> I don't think crate::ffi exists on 6.6, so I would think that this
> does not compile.

We probably need to change rust_fmt_argument to use `*mut u8` instead
of *mut c_char` to fix this. Let me know if you want a patch for this.

Alice
