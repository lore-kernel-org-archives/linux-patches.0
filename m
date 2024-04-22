Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E5D4CB55
	for <patches@lists.linux.dev>; Mon, 22 Apr 2024 09:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713777959; cv=none; b=jtHvFdunp35gsFfNxHfnSaxnwDxQEqe+7TiAr+QI9CzTn6YGxM3lQ/QemZTDKDXsfssTGzEvv78JXPgAjptnU+F4JvyNz0QNCPeDGV3WKhePNW1JseGBOFTjN2DOqi/puH+pDjyVi9A88vJzJDKjzrOkgkGIllyf/Kdqcu5nMlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713777959; c=relaxed/simple;
	bh=ye+YDeypngJNVRNApH4ApNOV3asObjEsmLgFOfVV0AA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XHQDTcbWV43JhtTIU+DDsYPU72Mjfg7lZx2f5vOeW2Xbu4DXDmwTq4Mq9nE+DeKU872YPtBQbbPA+t0hJaV8Yn0h/CxM7INv/A6tueDgpJCV+IN+ghS+EgiSnee0VoR06goxbhk0/mXogA0hNvMxnf3kzO6KY//lcIbRHZa8Ld0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=35vDoRsW; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="35vDoRsW"
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-7e043f577c5so2173105241.1
        for <patches@lists.linux.dev>; Mon, 22 Apr 2024 02:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713777956; x=1714382756; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u02hciJF/25Uzt60NJ0xbu51k6rfBNzWcPBLcSlUo80=;
        b=35vDoRsWVDjank6D+hv6wvFN3SV7oVaJVa0V26Qc8XSiHZfFgkrBu+z+Iroqy9WREq
         OkJ0EmsaMVHzdWDa9/gpN7oU4xICEeShVPpERYn+PmSpBKVc9rDhFYdYbT0NvbJ1mQHT
         gEutFDvnIV1UuoDuUhMdyUvK8PBzyIU7SuR2ABeVdCpqII03tjozdUCL9E/SteXKX9/u
         dWlPxIjyvSexJ3MLbVkj9X7FjhKQmMnrDX2qQjlxRUlgjp4NJB4kZSfJZYtOOlPTp1Dx
         yZ/m694AgwP/6cz7zkIZM6Dqp7SyIbymVLqLRYTbyiGZ0uNpLPTkgSZAtFvDHr7Rg2Cx
         95EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713777956; x=1714382756;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u02hciJF/25Uzt60NJ0xbu51k6rfBNzWcPBLcSlUo80=;
        b=pXPSnnrzbJ1Np6GqHx/I9s8brUpiRmyfFH/aDM8Vf+32YtoSrnUwTATDvG/E+CkwHQ
         ptG1bOVIzbme6FcO+ABij8JpFV4naCpy9+hrWZVo322Kf/TohFx6REowfW3GoxBriW4j
         p5wNm2EkKSqa5PvalUNc5NzlNtaoi3NcgOx3yfbzXvLGW64b1PPEMUj0xldbtwctlmY7
         EmDGXcnd1GK7jS78yiWzvb4KneBESovUYM1w1G0WqEHm5SPdYiHluLY6QAvm7P2Rqydi
         q5ixFMWq5gubMPm8o8z3QM7zX5KfmHkEg3DklyiTOABGp6BMIlGHxM13pxMoYV3xs4ik
         RCMA==
X-Forwarded-Encrypted: i=1; AJvYcCUCU/SKc2Srx3ijY4VHhPh73hd21lF7+wkzGFgoYY/lvEvXKeNSo7m2NPeNji8UprnKw5FBQyVXy/FsqIRdgGuHY8ZXl8q4XA==
X-Gm-Message-State: AOJu0Yxv7a6jf1XVeqUDnBNYO21HsM7S2xudcUJDrBsfRa/CEIv5ymLx
	FhmsbPhx0GLC4+hP5y38z+gmXkXYQImFCdcxVBNLG8UG/d+TRpr+wWYWC/6U8awGnE65zuHvvfl
	83pi6c5k2zc+O/hr4bvG1mGVXAT5fewvWq8t6
X-Google-Smtp-Source: AGHT+IFzbvs5nDCKVidubFmVhCqyTJZpX1MSVwcFBpjxWlOvQIwOZ8sgogJwUEo36R0OhEd8C3NQ+lrl6rjs+COe24c=
X-Received: by 2002:a05:6122:2008:b0:4d4:34b2:9a89 with SMTP id
 l8-20020a056122200800b004d434b29a89mr13136946vkd.8.1713777956098; Mon, 22 Apr
 2024 02:25:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240422091215.526688-1-ojeda@kernel.org>
In-Reply-To: <20240422091215.526688-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 22 Apr 2024 11:25:45 +0200
Message-ID: <CAH5fLgg=v28bFJE1izZ-WF7uBLcr7D2o6Yr2ihdPAz205MiGGw@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: remove unneeded `@rustc_cfg` to avoid ICE
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nicolas Schier <nicolas@fjasle.eu>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	David Gow <davidgow@google.com>, Brendan Higgins <brendan.higgins@linux.dev>, 
	linux-kbuild@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 22, 2024 at 11:13=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> When KUnit tests are enabled, under very big kernel configurations
> (e.g. `allyesconfig`), we can trigger a `rustdoc` ICE [1]:
>
>       RUSTDOC TK rust/kernel/lib.rs
>     error: the compiler unexpectedly panicked. this is a bug.
>
> The reason is that this build step has a duplicated `@rustc_cfg` argument=
,
> which contains the kernel configuration, and thus a lot of arguments. The
> factor 2 happens to be enough to reach the ICE.
>
> Thus remove the unneeded `@rustc_cfg`. By doing so, we clean up the
> command and workaround the ICE.
>
> The ICE has been fixed in the upcoming Rust 1.79 [2].
>
> Cc: stable@vger.kernel.org
> Fixes: a66d733da801 ("rust: support running Rust documentation tests as K=
Unit ones")
> Link: https://github.com/rust-lang/rust/issues/122722 [1]
> Link: https://github.com/rust-lang/rust/pull/122840 [2]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
