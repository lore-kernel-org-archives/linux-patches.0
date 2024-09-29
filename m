Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2739343155
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 23:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727653449; cv=none; b=fs0bTNnHSZkulYa6hn2LvgqlWD0/AoB88rWGfy63JK4zzER4S9prj1ix6Hm94F+LpJqhq/PPLRVFY3woI5z8cf+rk1bMOEV8ij89YocDAfuiQDEqlzbz4TTRsW6Bv9vpLYU3BqUXk5IVLsOpLStRf6KKTZlU2afZOBxePTfpBic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727653449; c=relaxed/simple;
	bh=FVrhM8NHC5GS5UTOWegUXKC6RupKovE6Otom9uQ+Jjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oGEzPCQb29t5umPmCOjtjCNbbNtDoqtakH9wVwgpyzmuOLVRpBBE8QtjUjawZtTvcSJ1L2sBaC6GN65A9be0S6e2dBzzGxeJnYx0cCv+o3hKUH0FsmaY4on17Ow90uelL9xaJjS6P86ocJQKGipqOOXXmFYKHVOA5XNVyU7BQew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu; spf=pass smtp.mailfrom=umich.edu; dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b=gU+686P1; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=umich.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=umich.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=umich.edu header.i=@umich.edu header.b="gU+686P1"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6e21b4d7236so31443877b3.2
        for <patches@lists.linux.dev>; Sun, 29 Sep 2024 16:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1727653447; x=1728258247; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tNjCSozQpyjhKHt8noJZBVS5dOtxOJ5KLOb5B891m4w=;
        b=gU+686P16dmqZEUxx2bpX/pWOYqdw1bUkROzu21OZ7P2WTSpaMsReQIxbHxLPnzGnK
         41VUow+19bTbZtaMp+8LO3HtN7FdCdpryY/25SErMegdBXiBOwxzJxiEYmYE0wtC1IQ6
         vLwtnD94bihQUUiSS9Aw7CmtOioPRL/kdUNKhbr6nlypnzMc9jy1d3SOwWhl53OgBJcZ
         +++Poxl34r4bGTjZvBAu2Zm03ar/8u8mVcYvlw8D4LQpTR72yFkO5nUFqukhO1XCj2K4
         ylg1MSTKfDMqyxl1Mw1W59FbUyQF3wC+ns3mKDC8shQJ9zprsF9GAa58S4F8yMR5zRIX
         qR8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727653447; x=1728258247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tNjCSozQpyjhKHt8noJZBVS5dOtxOJ5KLOb5B891m4w=;
        b=Kyxz5s71T7snPblv+oBR2zF25cvx5eJXqy9XmIyXlzhlejEi2+DeMWVv8hf/y/FuHE
         ESHIUBf/mxt2mvXXU+KV3uZncSUYEkPYCafinuf7ot16EGaVk7syl5Mrris9WvscsEez
         et2VA8Il9K5ZvDjRAzR7a7KuXDAZzPwy82agff8gwj5BPLZ2My1nY5GMpdHCyVTprIV5
         uMCquDp3xdHJkSkeKfH0QPHvz8fpNkff5KQkWMdgYQcyWqLMV4x5gH7v/rEHnwGvh/0a
         GdRKgLhvdFXqpEpAceP0765niEYK5dcI1WHLamV4+Ed/bpgSNY+qOzBBTNRAibJMsYOq
         pGVg==
X-Forwarded-Encrypted: i=1; AJvYcCWClMwgSUnFlIoZqTz3XOiEqaASoJzTSvGzQrrVcXcul3FCrBBA29A+eSNncG5Hh5WDODXDJGLU@lists.linux.dev
X-Gm-Message-State: AOJu0YwY1ZoydKvL+H5A9wfLGvsYNG+7/cPkWv7D24C6kSHw6Hfb0uaG
	vu1DAu3tiyQCz6PrCfBd4A30wVQEkc/GyHhg3ntNW3aE9COaTu3EPD3GrAGNGG1OJQp312feVUm
	8uM8vxhOzK9trvpEjvvt1gxoMGGZt6cKQUa2AHg==
X-Google-Smtp-Source: AGHT+IHVbKuHDSIp8LlUP5X8+oAC4L1kn9ulGZiSovJ1012be+27o8GOlOPN94mq1QBLToyjhF5KtnAbvafSANnc8Cs=
X-Received: by 2002:a05:690c:340a:b0:6d3:be51:6d03 with SMTP id
 00721157ae682-6e24757225cmr53231907b3.23.1727653447032; Sun, 29 Sep 2024
 16:44:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240927164414.560906-1-ojeda@kernel.org>
In-Reply-To: <20240927164414.560906-1-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Sun, 29 Sep 2024 19:43:56 -0400
Message-ID: <CALNs47syDKaJcAZ=PF6vWHgSEg-f3m5Tmm_H2C40TfoAtVPezQ@mail.gmail.com>
Subject: Re: [PATCH] rust: kunit: use C-string literals to clean warning
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2024 at 12:44=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Starting with upstream Rust commit a5e3a3f9b6bd ("move
> `manual_c_str_literals` to complexity"), to be released in Rust 1.83.0
> [1], Clippy now warns on `manual_c_str_literals` by default, e.g.:
>
>     error: manually constructing a nul-terminated string
>       --> rust/kernel/kunit.rs:21:13
>        |
>     21 |             b"\x013%pA\0".as_ptr() as _,
>        |             ^^^^^^^^^^^^^ help: use a `c""` literal: `c"\x013%pA=
"`
>        |
>        =3D help: for further information visit https://rust-lang.github.i=
o/rust-clippy/master/index.html#manual_c_str_literals
>        =3D note: `-D clippy::manual-c-str-literals` implied by `-D warnin=
gs`
>        =3D help: to override `-D warnings` add `#[allow(clippy::manual_c_=
str_literals)]`
>
> Apply the suggestion to clean up the warnings.
>
> Link: https://github.com/rust-lang/rust-clippy/pull/13263 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Trevor Gross <tmgross@umich.edu>
