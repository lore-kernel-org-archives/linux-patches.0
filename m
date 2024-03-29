Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C935E13B7A0
	for <patches@lists.linux.dev>; Fri, 29 Mar 2024 19:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711741755; cv=none; b=NpFZfbPBWjSFGae7v68MDQ15E2e1/P3tQB/0QahMLyA/F3FonqEJI69SNE0eVxA0PQaj8XX9LnpQo2XQfTCag9k5U7pFYSC9iZdY0oEpcweWTzcFctiI5U5lwwvyAAd6wSLEEz+3mBgf1d/Vwc8KEAxLgQqXf1RONvoQ7di2DcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711741755; c=relaxed/simple;
	bh=sJ+UaoCLh7AzLciVOQ3NMwemWc0ufeeQ/hmoF9nh+m8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gA3V0B6YRS1+DwDSBef8YbIS7a8n2k/Y/vmPidkDz/ChepphggY5mPK8vQ13EkzyXKqa6V15h3IMYay/pL5tjEdDgRO6X5fy+QYvg9iPgbtKngMyipGyM6isq2MGprsHMirZIVHZ3ef/Rctxq6XvjHFDUg1GlIwHgHr42B6GmTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WvL/cOqh; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WvL/cOqh"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2a04ac98cf7so1605646a91.0
        for <patches@lists.linux.dev>; Fri, 29 Mar 2024 12:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711741753; x=1712346553; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJ+UaoCLh7AzLciVOQ3NMwemWc0ufeeQ/hmoF9nh+m8=;
        b=WvL/cOqhYShrfipmg9CCfGH0WIF+FiwJRq9t1o0M+V0Mj14aMeBVjwR7ZWE3L6ahj4
         22qpcJGTXnD1TOsyVKKSwjP+Cv1VTMu21UG71TiQaLa9scFaNsBUM8HTTc4b2STmEhIQ
         Zj7IiKREYsps/GedvYWbXtlBcg3hY8ZR+S6kzmGeQV61R0yr5L+ZYJxOaQf4Ias6Jufx
         W5uDGXA0zVH35Ol+rHUeTpf/nLgWgd7TJdf0yp5gEW+P16/F0Z60a78PTvB/RblevqZH
         2Umx9+fNiednMS4MeaY+iR5QSTMRnG4oNtQc8u2rQRqksXLA5fdYovLiZIV7HFf8qzk5
         vVnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711741753; x=1712346553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJ+UaoCLh7AzLciVOQ3NMwemWc0ufeeQ/hmoF9nh+m8=;
        b=o/nrRMfR16uvycOFQhyVj8VsdQAJOs6sVPI2HMXNpGhFi9t5ZGjfsSRLSKSnZgTZ8n
         CP6+NKSL/QGttV46aZcEkg06EF6RRJ7q43mUzl/GRE3cGP+gVptwTks+7t/ZEwPjHj+9
         7FpIsWTT08eGZCnoMw4F+tdbdBYY5tIJhzTn8xRgu41sWmVs1xWvh4U8vcpYS4DoPLzZ
         syy3cd/oUD/imJ4+DkH9aoUc7Ntk+zfe/Wmpyf7BtLRzHqyFqrFlD+Wkc9TCsgO3BnZ0
         3Eji3xfMeDt7T8/xNaBb8eWLMweggULDJyfAPi60KUsiyNvMxFn2bSLP1E417w+WLQuc
         uL/A==
X-Forwarded-Encrypted: i=1; AJvYcCVxNqWkox/DHOmO56i0Ej+Ra7w3ioz9CN9Yid++aBzFFNV9XOUYETOxEuAsuRK6m9o8L69EIAuG6TPwLFuYnRCNrtr/Xe+dOg==
X-Gm-Message-State: AOJu0Yxo4Q6lSb0dN6pMuKzyOXi6xOtaHrQL9UXfbqFKx4jbI9rkxBIq
	tjLDo0yoC5bw1Kbcz2GKqzM1vpse9KuHpgmxXcQxOzXXIp+nninKXeqy8eS/7BZvlqEHNSFEfhu
	jocrQk/nj2UPARJqum8Quq1gYkEQ=
X-Google-Smtp-Source: AGHT+IHOS/4TcCdBp8AgH2utv2wzrfe7U/6wBTLC8E1hnxWIey6SVgZ3g1TxwoMe1ZNo2sz/IHrk/09TAhBFWFojriE=
X-Received: by 2002:a17:90a:c391:b0:29d:fb99:7dcc with SMTP id
 h17-20020a17090ac39100b0029dfb997dccmr8838505pjt.18.1711741753063; Fri, 29
 Mar 2024 12:49:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240217002622.57322-1-ojeda@kernel.org>
In-Reply-To: <20240217002622.57322-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 29 Mar 2024 20:48:39 +0100
Message-ID: <CANiq72nD4dLDRN09YC+TeFKsjF8Kmh9UyP6Za4g6RRLixjN+Kg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: use `-Zdebuginfo-compression`
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	linux-kbuild@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 17, 2024 at 1:26=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Rust 1.74.0 introduced (unstable) support for the
> `-Zdebuginfo-compression` flag, thus use it.
>
> Link: https://github.com/rust-lang/rust/issues/120953
> Link: https://github.com/rust-lang/rust/pull/115358
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

[ Added note about zstd support in Rust-provided binaries. ]

Applied to `rust-next` -- please feel free to still send reviews or
tested-bys for this one!

Cheers,
Miguel
