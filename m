Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB8B2EB5D1
	for <patches@lists.linux.dev>; Thu, 24 Jul 2025 17:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753379876; cv=none; b=YSCM9gDpbCtz6/mDUWAQEb1B3lnZ8epiJEuwLZbKAbmX1v1NH9orGo+1dseqcXC9iuao4+ZlYA342G00ZxuqqWD5wIAM+mK3fgcIORqieGGAbkNOd4LM9oDtISWnKBcAYanivyxr+1bG1cKp8Ku45PYH3G3AOnk7GDgg2cce6mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753379876; c=relaxed/simple;
	bh=SKzcnYmuoMfWCYOd1dGFE4CApBWuDFnC7AzBLZTYlWQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nl7IP3OFTVojTmrUit6oHCQlTRCeMixiqRTOUW1XyqrgOW/05fDqWoRj90y9lgJeBbgk5NEjjRto8w0zjdOHvIEnprN+gu6Zcqhj2SebiFoth5KjIJsOq5sGAYi807UgPGWJqCuGl9G8s9TgXzRNl6T//MqXHleE+6gYw/gBwO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mV7gZmzr; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mV7gZmzr"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-23c71b21f72so150115ad.2
        for <patches@lists.linux.dev>; Thu, 24 Jul 2025 10:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753379874; x=1753984674; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+8UvJuIn0OPJI+DjMgO3jk5kaVoeuzRgCCA1dECQ/gA=;
        b=mV7gZmzrKuzwT84rGCy23S6va1gDFEWeNY1WsuJ+LgPT93p4dZn4xXxexHcQKyOl4x
         K1t0z0W8ofvIo2dnfN6MDqP1PTo+ugjnLCBEqYMZ4SbSg8qNM2G6XsZ/mFYMAXvBc+Pl
         l3ED2RuK9QvBt8hfHFiUC8uKECub7VTLsWXsKCnsWfkERqkBLYQsdaz4pmQaJ/4O8FBn
         0YmG0o9UbPaXYHa6zN/dZgkReCXAa0GjgHrf1C87LcI5bv/2mVOI8zmgFV/Wb6LzFcMj
         ZnWmjFa56u6wlyj/fBbrTFbMjZCSfEd1TF4MZvAiWvWmqxGW3a6D6lRzmXiMPcuzhaZd
         hbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753379874; x=1753984674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+8UvJuIn0OPJI+DjMgO3jk5kaVoeuzRgCCA1dECQ/gA=;
        b=G23RypV4YiDXX97XjajDFRt+/Sxi5GsOqjDmbvr5ECSC2JLgruO+Tky6wbk/1CCOC3
         6jH41w8d26d+8Qvz8Z1+dosPcoa8vCX7QErDeS5zDFAK9MNbL9mg7JkxZh05R0VK6fjv
         nbOFZSiQ2+0knfQ5cu9zyFGVCXD/picQUgaBofrDOpCleQubTGBGL2azxR+cvMg/x7Ha
         F8F7C7SVAFxJrXdd+QvxcGZdgV9/T8Lb6NF2h2JAppNGMFviaOgIMpb+lQLuEWCqD2AE
         JD4bo8hx9KhYlRRdDjC8ZNDW91lU4HbSbekYIWZzpZ2XeKjp5g3OLDPEiAS5vBdG5Q2W
         h6Qg==
X-Forwarded-Encrypted: i=1; AJvYcCWC0tix5p1jfRAcJWdadUaXoruZrpCfXlEazm4LmKpIJhTcyxkFMqNSnoQKcl76M2iEmOhuUoaK@lists.linux.dev
X-Gm-Message-State: AOJu0Ywmibfml435Z3fIddVMGeLbr3zNFzChpU08E9zJ5EBwWr+Z/gl7
	6aq3pRvly9Zxexff5nO1b7p0iig3A4tavXPGAWxCyzdLfejvNUHFR8fh3CkpP0vkFCKFSARFUC8
	o7hBY1fgRYEItN35LCwh9lGth7gUrDXA=
X-Gm-Gg: ASbGncs+5+WwD33A7CIvGiERn2vtr9HuLV8vaXvhZZJBtEu3IIvZlY7WPffR+0ukUbo
	HLa3wPlPjUrN5xKlVKWH/Vm1HHZo4vt/N3QHoO0EuXmDyzvneSkxIFpzz00ukBYZOYyavusYpUC
	CN3US8k2kuVbgSP3Gj7bfXJsQgNqjwo2M5Hkwf2Zw40ksgc+2fuGTQAf9BvO/BqvdBt13Golfja
	MCapso/
X-Google-Smtp-Source: AGHT+IEAhOyud9kcbqXxowjJUbxNlqWbJT7GJpdyKPEF2m9XE+mf16rjfgmV2MlnEZtVjRLDvU7+lrC48/cD3la2z1c=
X-Received: by 2002:a17:903:1aac:b0:23f:9aae:6f0d with SMTP id
 d9443c01a7336-23f9aae7183mr37615165ad.6.1753379873956; Thu, 24 Jul 2025
 10:57:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250724165441.2105632-1-ojeda@kernel.org> <DBKG6CA32OO0.368N1Y6VMIUTL@kernel.org>
In-Reply-To: <DBKG6CA32OO0.368N1Y6VMIUTL@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 24 Jul 2025 19:57:40 +0200
X-Gm-Features: Ac12FXwN0CMehniS1G7J0FWaHdQIDWYqXa1YTpgsiVMs45pPNA405NE1QlSsAHI
Message-ID: <CANiq72ktx9JsTXN_HTfjGWHxpBh430tkxHE2xL_1BQB2yb16rA@mail.gmail.com>
Subject: Re: [PATCH] drm: nova-drm: fix 32-bit arm build
To: Danilo Krummrich <dakr@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alex Gaynor <alex.gaynor@gmail.com>, nouveau@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 24, 2025 at 7:05=E2=80=AFPM Danilo Krummrich <dakr@kernel.org> =
wrote:
>
> I think I will follow up with a function to perform the conversion in a s=
ingle
> place, but I really like the idea of a special clippy annotation to tell =
clippy
> to not warn about unnecessary into() conversions for a specific type alia=
s, such
> as ResourceSize.
>
> Do we agree that we want something like this? Do we even have a feature r=
equest
> for this already?

I think we should at least ask -- done here:

    https://github.com/rust-lang/rust-clippy/issues/15337

Though, thinking about it, an explicit function may provide value
nevertheless to clearly see where this happens, and it also means that
when we see `into()` we know it cannot be a no-op.

Having said that, regardless of what we do for that lint, giving more
information to the compiler is generally a good idea, even if only for
notes/diagnostics etc.

Cheers,
Miguel
