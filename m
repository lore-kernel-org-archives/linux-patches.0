Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FB62557A
	for <patches@lists.linux.dev>; Mon, 20 May 2024 09:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716198230; cv=none; b=L6c0Kpf08VIhP1RSxT7kiX3hSQryeI15LKWeqCyUxljEKw7jsTkOcXoDSxG+r+sUlflXyHQwcHufnELK+d/8ZLVDaffEH/LKy9wnAK9Vr6LqZ/aBJgI4xJaF5s8ZFcMCJzzbR6Aaq5zN21cfmfgmlcvbOnoIRkEElJiMK4vmxWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716198230; c=relaxed/simple;
	bh=a55aAxkPuy9VVWAPVnECXqpexCb+FMCFcssmQ8ptOdc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fU1OcbHuRMPa4S2dUELZWvMHI3lLKy5gs+/93cpSBZZHdlx4VZGQjBszlH4SPYF+5OkB1eK5SfDA6pDNNNkt1XW0/QyrCgk3ph8ELslPqM1aSLT2sCfPOYVTDXQkWj6r4ICS0JR3wVuOULrsI09J23k28Hqm7Fq/BnUgUoGvOTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cColID1p; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cColID1p"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-47eef876f2aso394137137.1
        for <patches@lists.linux.dev>; Mon, 20 May 2024 02:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716198228; x=1716803028; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a55aAxkPuy9VVWAPVnECXqpexCb+FMCFcssmQ8ptOdc=;
        b=cColID1plPwabhwgsl8iyM4mMtmYjXBP7S+5lRKCVV7zCDxAkFmO/Om95K6OtYYLIp
         dL9iZYmthBEwVuvU+DOzGfdZoT7v6EhjA//Z/QtbJlqtVfJHnIXCiMVTGlgWtaJfn95M
         QHLbZlXj5yM02Z1JPsCSwRUtRcqr5uDXCePgFogUMrrgKpdrQNP2rgTau3uGJ+HfagGQ
         ZMab8U/HASX5l8poG2AxAKgTYDzTS/MGfaagSPHYMDwl7qhGbZHpfvJ+qCVTbhDSWKPq
         5K+U6eESi2e3IfLpb166/YKjN9O5l8u+ndQjZnF2JT6h6BWUpRP1Kuc74mlSbU0hYtUl
         ePpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716198228; x=1716803028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a55aAxkPuy9VVWAPVnECXqpexCb+FMCFcssmQ8ptOdc=;
        b=ltibpZ3OpIz2GJLTPjlJbbo41/AdPDhTjSbfDdnPqE90qTYKGjtAJbTGcQjcN+gNZI
         Trdk2QablYfjF+qzE9Hm0RtBFGYBd2+ECtP1XOLLxJYwl01yKtAKUsjm4KatWxlw6CtN
         s5UnMntzXDl1ioZpaZaPARCVP+cB94UA5P9XkXERCNGepGHhPb2gh6/ruheqwhCDpwwu
         fietgEtcrRNcoxflrYuv354pNsOJ3qOg+oKFXmnUuwTTf3o/0c33tDNMQPRwegj2cBkl
         kr7NeJofbb3tq+9dquupGICbbfsRQWzjNil8iRZRlfR8Y/Hxa96yZ5rw+oW+jK+QQb4F
         N6MQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkI1AW1gW2hE/AMKneCzdaQezcatOJIapYCcUtXJlZ5JG4yCNdlTIFUacqAIVWh6SL3QZyH+uPY6M7Gsn/A1003jFf9a/6Pg==
X-Gm-Message-State: AOJu0Yytc19DijgHJk/2ucZWOY3pudhl/MSuP5/L4wK9Harf8xyrSYGC
	KR1+l1FW9pbgooT/qOK8JwAj1zCc5gQBG5pV2laD2jfMLW8FE9GhmQavJI0vs5G3mpvuLP5riLo
	bWNJKZgPJO5IgPJgozCUdHA24vbCQLEG9G06X
X-Google-Smtp-Source: AGHT+IEYsiVQ/f6j1ZyTO7lXzbXIXBXS17hKFjw1cVaQYNkhH1gui4IfXyiE6NxbpusBzsiFYL/Tf3yT2rLfKLe14bM=
X-Received: by 2002:a05:6102:148e:b0:486:11ff:65aa with SMTP id
 ada2fe7eead31-48611ff67bdmr12548622137.2.1716198227732; Mon, 20 May 2024
 02:43:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240519211235.589325-1-ojeda@kernel.org> <20240519211235.589325-2-ojeda@kernel.org>
In-Reply-To: <20240519211235.589325-2-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 20 May 2024 11:43:36 +0200
Message-ID: <CAH5fLgg=dGmuY43B52gvgJ3S3qphcYYVB3SycuzZHNB6Rcpb-A@mail.gmail.com>
Subject: Re: [PATCH 2/3] kbuild: rust: apply `CONFIG_WERROR` to all Rust targets
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	linux-kbuild@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 19, 2024 at 11:12=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Make all Rust code (i.e. not just kernel code) respect `CONFIG_WERROR`,
> so that we keep everything warning clean.
>
> In particular, this affects targets in `rust/` (`RUSTDOC H`, `RUSTC TL`,
> `RUSTDOC T`, `RUSTC T` and `RUSTC P`), plus host programs and any others
> we may add later.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
