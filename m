Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A0019F13B
	for <patches@lists.linux.dev>; Mon, 14 Apr 2025 08:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744620423; cv=none; b=CBa4ElwCJDm6YpasuLJ4ThnzUEBpPSZA+2Y0c6sG6L3GtfwA19pBAy7hQ37AV8cbAEZyJCqi3Ox67cStbJ7wbx1SOL4rFq5SB9eGECod+aaLkk/xNcjXN7oZ9kQ2GggL7L71uU3CO3lqAQOUZBIPMRv0oAsqsmI3ER4k9U3HoQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744620423; c=relaxed/simple;
	bh=SCP/PwSChNMVWttCxouuAEa4tawnRcR8a7lMxmBepnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EWCN/NbFta2xwZI0kLKW1Ddyea3Ow8qBlZl5wi2LfxEVO67ZhFNYc2d1yp4CCZUChBPb4d0PFjjiaOSHrQ4gLkEQsFN2giYkMum/hs3dgStbpP5xjpXnIfNhnC+WYRV2g/4IROla0MRO+eAQ9FPuHNDPKrPCYgdGPdYr8ZZxwtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1tOcg/R2; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1tOcg/R2"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-39129fc51f8so3452941f8f.0
        for <patches@lists.linux.dev>; Mon, 14 Apr 2025 01:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744620420; x=1745225220; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LwKDG6W8xKNbvB/TbUCZDLywQu+/SySWZsszpHukAAE=;
        b=1tOcg/R2oUTz9zHLURK479h+PwpCuCzQPi/E2SKVjkdj9PKIdUWkSYPN07oThLWOT8
         H+z+8DaITbDSJCNfoxZCtL6bQhFMpZ4WdYwgIV4x4bxmVUZT7/IiwGyWaTpDhrosu7PG
         Pu6eL27DQrHMLaRwFKTk9oNMp1Jb2Jj6IulK3c70PzLB4ZdD3qLcrOPuZHA/qKVb+8Qw
         Vtpdis4UNa1RCq4jnMtUjHg9638oQb0wi6siEZ3f+ZmkH4qTaCVH+180FrbjHbe5zBHQ
         Ti8RcGHOU56BLCU14HEglDD2BsNcQIjGMDSUCqIah0OGggX5i5ZkyBrRY+yKGTJnBfek
         SIQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744620420; x=1745225220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LwKDG6W8xKNbvB/TbUCZDLywQu+/SySWZsszpHukAAE=;
        b=aJWcXhzrrG+IzF+UxfUeq+sr23D1hlvwog5DzYfjLbCyZP6FqkZutZwktDnvVs8NaK
         l1wwZ0hAOL6EiCWX1dCH8/X9QbsTjs8Zk95oFyYP5dQvcuSd01M/d1FcQQK8Y69zo/Kd
         /4P6unpgqknL2BF0YKRZC175hF+Zs8HnuG3gXMM3HmL0ZD7FjvAnWfZdBxJ5O8dnRWno
         VWd2W33eXBUYQE3KYEvL8kq5Jhws7AZokzemzCTw66pdu8c0BWWaVei+of07wXbQ1xZ2
         ghWXYz9v0uuYaeq0kVDUhO11L/hcnh5f91VlCiykOUMAGY2V5oDN5sA3/y9BgDwBu13L
         x41A==
X-Forwarded-Encrypted: i=1; AJvYcCUrBU/8CUs1cCR1lpPurHLH4QbyAa0HFdWXYecU58fofT+GZgSzJxEQwbZMPuT87FoRZdYs/xN6@lists.linux.dev
X-Gm-Message-State: AOJu0YyDx4WNkQiB98jjvZ2mtYtkZj/oYIzYH7mfugHPE/hH/Yx52Ybn
	NmlvzRENLUtcY6DzHO1IrigWUP1hziVFoILrghAFKQ9GdevtLtb+VgBffSVEFY0NxfVWkAvuQ3Y
	NSt3F8BEznwp+Uh2Bgn6/gAul8KzsuwlVGvAo
X-Gm-Gg: ASbGncvkKL6pBSCnee26Yt4W/TSe2vmYcKD2cCfL83jkhgLsOx0X5LCW7WpSwmsdzC4
	qtpNiSiVFZ1R5j3tb3kQD+s0uTCZ+sUC3rTEQ6Ktma2YGjHlX0Q7DRkySKy6lYp6mjdQ05p1vhN
	fmfkPFkfvkeB1JeIqX3M8GmPF0MvF3JCpHC5VMJzxYGnciYVoUBkg=
X-Google-Smtp-Source: AGHT+IHEvx7P61rJOTRerZ+a8pvfaZkJuUtapqSU6YjMcCwnJs4bOGlMqLM40z3t5trwgLUElMG5/bn+P/Y27+nuXxE=
X-Received: by 2002:a5d:5f96:0:b0:391:ba6:c069 with SMTP id
 ffacd0b85a97d-39eaaebeb38mr10081675f8f.44.1744620418562; Mon, 14 Apr 2025
 01:46:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250413005650.1745894-1-ojeda@kernel.org>
In-Reply-To: <20250413005650.1745894-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 14 Apr 2025 10:46:46 +0200
X-Gm-Features: ATxdqUFTqJD6mmtLs5eNUuwhMNICFoxmw1G3Dh5Cn8tAVPlsl1viiSVgUFcLSxk
Message-ID: <CAH5fLgiF0kZdOYaQi18_LTNx6Onq-5PBomA=bwS0m0z+C0wtvg@mail.gmail.com>
Subject: Re: [PATCH] rust: add C FFI types to the prelude
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 13, 2025 at 2:57=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Rust kernel code is supposed to use the custom mapping of C FFI types,
> i.e. those from the `ffi` crate, rather than the ones coming from `core`.
>
> Thus, to minimize mistakes and to simplify the code everywhere, just
> provide them in the `kernel` prelude and ask in the Coding Guidelines
> to use them directly, i.e. as a single segment path.
>
> After this lands, we can start cleaning up the existing users.
>
> Ideally, we would use something like Clippy's `disallowed-types` to
> prevent the use of the `core` ones, but that one sees through aliases.
>
> Link: https://lore.kernel.org/rust-for-linux/CANiq72kc4gzfieD-FjuWfELRDXX=
D2vLgPv4wqk3nt4pjdPQ=3Dqg@mail.gmail.com/
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Yes please!

>  Documentation/rust/coding-guidelines.rst | 17 +++++++++++++++++
>  rust/kernel/prelude.rs                   |  5 +++++
>  2 files changed, 22 insertions(+)
>
> diff --git a/Documentation/rust/coding-guidelines.rst b/Documentation/rus=
t/coding-guidelines.rst
> index 27f2a7bb5a4a..d0bf0b3a058a 100644
> --- a/Documentation/rust/coding-guidelines.rst
> +++ b/Documentation/rust/coding-guidelines.rst
> @@ -191,6 +191,23 @@ or:
>         /// [`struct mutex`]: srctree/include/linux/mutex.h
>
>
> +C FFI types
> +-----------
> +
> +Rust kernel code does not use the C FFI types (such as ``c_char``) from
> +``core::ffi::*``. Instead, a custom mapping that matches properly the C =
types
> +used in the kernel is provided in the prelude, i.e. ``kernel::prelude::*=
``.
> +
> +These types (aliases) should generally be referred directly by their ide=
ntifier,
> +i.e. as a single segment path. For instance:
> +
> +.. code-block:: rust
> +
> +       fn f(p: *const c_char) -> c_int {
> +           // ...
> +       }

I wonder if it would make more sense to rephrase this section to first
say that rfl has type aliases for the C integer types called c_int and
so on, then mention that they are available in the prelude, and then
at the end of the section have a note that we don't use the type
aliases from core::ffi. I think focusing on how to use C integer
types, rather than technical details about how they are defined, is
more relevant for a reader who is just looking for coding guidelines.

Alice
