Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C459C13C690
	for <patches@lists.linux.dev>; Tue,  6 Aug 2024 23:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987999; cv=none; b=PSaljqhL5FIiJoK6QjssL7Nox3XixWh5f2Je4PzPbVx4+Jl+sRj1LD2keaW6aXDB67l7yh0Mdw5v3HXEctlUsW89oA2q77i2Dl2vR6IqoyoopO8PiQaBQW5ycIFioQVPq24okjDse+p0INL9viB8+p/l6GX5AhREgHATjk3mzHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987999; c=relaxed/simple;
	bh=Nxt4/uhwOXAaUpQmH3K0cMnBkKacb++XEiN9uDo6iXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nJYbraccMioPgQU6dBxHegOVETzx/1JYT+9oYpYy/ci2aLqcvgQvg00Ez4vcsCbd06bbOyogaB8iWScjmwtneNFIkjbc5datyLYi9tCk2yYm2IELwSK0L3loR6XAGY3e8zEJF+peR2wNqyJakpo7ynHRKM+jmrVVP2UFvB39Oe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KwZ6UVzi; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KwZ6UVzi"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7bd16405aa7so553593a12.3
        for <patches@lists.linux.dev>; Tue, 06 Aug 2024 16:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722987997; x=1723592797; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nxt4/uhwOXAaUpQmH3K0cMnBkKacb++XEiN9uDo6iXc=;
        b=KwZ6UVziU8MOPRIc3uYK/2lsvRblp5r5lprW0fL2NNeXpcYvFOaoNaDFVLETx2ZDmm
         gL8AQ0n8jC1xpFmDzxCWNXuCeg6VdR67JIcrV3q6F9oMqGmRPqHCR7xhENB8qYDKiNgj
         AFDD510aG8T0HtESkw1oFydwhbR7KDIOucW1wq3YfxNcisAu7MHGKJZ0oeGe0GdmBB2q
         CcVgDZ85o0rOef20dPsbTmdqIBSQ7p3DqUqG/M7GdD9HoMNWh8vZqRYqpzc6BOpRjYFh
         GMctqQY2lyxTdOJx+edOPCuouepGA5u69u3hasaV0j8DkiCOXrR2Dnmb9/D1vqTpFD4C
         OXSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722987997; x=1723592797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nxt4/uhwOXAaUpQmH3K0cMnBkKacb++XEiN9uDo6iXc=;
        b=XSaOVAqMY89OKluHlJGxhv7K3oFxOOJxO+NARc1/llJTcL8L6peSUndQWAdFuEUHyU
         yu5Z8W4jlggyzhRuZE6MGdLmbWO5eOFIjvBlTIMJYDnAAdt56vRkNM0g7lU6Q6VjAZ1h
         KfkWGWJix2SbbRGUnPkQi2gkSNWyBoRXwvTYmH06riYFVHtAudq+/gaCYxT6wdgsQ/wg
         1WGNqCUd/Kb2qO+tDNnwPRFFVnupDjIp7GntxHw9QzkQJZ/xMzIfsiWoEM2oAQ7i/QhN
         oIJqdXs0TlcFazOm4AS29h8IPgu+pZHl4KJzi3OaM9V8Iz846CqNeQZQe41DPaVTr+5U
         63ew==
X-Forwarded-Encrypted: i=1; AJvYcCWiB+utemz2y0AdVtRARKpKwLFaVE0HIsXFvL3zOgzHBPOUHA5x/J9rtB4ECOYTVyo6IJbe+K5a+EPxtWJD7K1wA4iYm8/Z3Q==
X-Gm-Message-State: AOJu0YyAdLrtuOAz9rKdjsVscUB/L9haG9wlGXlWzPxPr1KgJhypJHOD
	pEf5xHGv+MlAchS2r4aAakVfTccEXE6rD8xd6fIxI/42OY/kHnis/FRAR56lKXrRN4HHr0gLsT/
	Isx6k3sv/YtkI0rWkBpY9yblmZ7I=
X-Google-Smtp-Source: AGHT+IGreoqXB2qMOm+fSZsrYLRie0H0PHRwoixFKL2kUWCknXKLMoQQwbr7ACBTms88XDe5GA410mg8A+Vx3KxPo4w=
X-Received: by 2002:a05:6a20:4a29:b0:1c6:bc33:3ac2 with SMTP id
 adf61e73a8af0-1c6bc333f1dmr6976173637.3.1722987996759; Tue, 06 Aug 2024
 16:46:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240806233559.246705-1-ojeda@kernel.org>
In-Reply-To: <20240806233559.246705-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 7 Aug 2024 01:46:25 +0200
Message-ID: <CANiq72nHfibkDWMbLh9hwY-pTEjau_kHLFEMnVN2vm2VZnTH3Q@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust-analyzer: mark `rust_is_available.sh`
 invocation as recursive
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nicolas@fjasle.eu>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 7, 2024 at 1:36=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Otherwise, we get a warning from `rustc`. Thus fix it.

To be clear, this happens (only) when calling `make` with parallel
jobs, e.g. `-j8`.

Which does not really matter for that target, but nevertheless, some
of us call `make` with jobs enabled most of the time.

Cheers,
Miguel
