Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068F219D896
	for <patches@lists.linux.dev>; Tue, 27 Aug 2024 10:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724755173; cv=none; b=BlNNoABisnZ9SW48ZkjQ4JLOTNrhOJYIteHi1EXVA8I8th1k6Fpt9E1ACmC7DzttAEbxFgsfeNjUR6HyPz8PCa3XgQ0S87LpCdCnZ9QYvouz3g30KciSq/CqDJQWVxfDd1jeCgdjhhEvYks5wtNVzjXhWD3nzrzDDGMUxD8Ijtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724755173; c=relaxed/simple;
	bh=Krl2s3CHllIaroW+buwqKSPfUyxcPPJnsqrI9JgGizk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tcgS1+QjFTxGhIqSrIZDkaFnL7WTueDnwUfpsDiEwjVk70s7U0kYBSiiIvEpR5IJojsQQDn3UtoXvZ8m2oi6i98kauLfF4CNEFX+H4QwaQibuzhEsrsqDFNK9/kwUZMoomTtnnTE+v19fXt27hMr5QoTADysd2GLWKWLPYm1yS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kbh4kNGp; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kbh4kNGp"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-429e29933aaso44090975e9.0
        for <patches@lists.linux.dev>; Tue, 27 Aug 2024 03:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724755170; x=1725359970; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xQ/AMf/f0BPD7kSB4wPHV1IGoJvc8aNqKoPFMzaiaSI=;
        b=Kbh4kNGpEErm3C2Sst5olV68m8xOkwFmtS5WoLT1KVB05zkhfOB/ac81JaTwzXMonh
         vH0eIhJG+WLUFHYy+xiGkvsZfdScxR5NEunvFLPREY+Zxbq1laQARDVIQx5pUqUMHHu3
         637bc4AJVASk3vJa8kbP7MtUhkdyfeDA7zyVaPa/cj9XMZyOnBTEey9aYgqYTVnY6C0u
         uem/x2CHhrq6xNjw0Aazn+Qy2WWPksfNzhjzVb+kgfI3x4Vj3/1W5WFeDOy8YtXeRB0H
         Dyche+lzR8pS3seffbrJnHQtYJLUFS8CNY6TTiu/BAN5gB3/7jd792Hl3Kv3vdRG38hp
         0LPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724755170; x=1725359970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xQ/AMf/f0BPD7kSB4wPHV1IGoJvc8aNqKoPFMzaiaSI=;
        b=GkdjgOzsUyVq4A7JQFtkzls6Qr0X+OH7Kt4OBuUItftxiY+7JgYTnUmcsoim+6i4x+
         QqTf4mW6ujeJmxX/Ns4d/RqqRvQcEtmZmMzXnwebFiJCM8izZxh0mr7Tmcvb/Sh7BMCV
         kHaJglZvV85my5JbusMMHPmyxaEqwQzkBhnQxWU6mJiwrM2jacbu6GDHxD/Vudy21Pxe
         F8+TklOHtlNAAk/PPh7wpjRWLIhBLVfTL4gU3eHxt4kVRFDpQD4ae+nOCzcO68MFY+Kw
         psyBAsq8Dcm5VyKHq6XGdtTYWZaLJzw8UIuHhSAkhoSihyqpVo8V+QT7tBXQxAgH8ffh
         1p7A==
X-Forwarded-Encrypted: i=1; AJvYcCVLG/vEabz/5T1N2Gf1Pw7dPWIuKC3Y4RmL4O93wJGpVMnDDjW6kZ1JXjTsIS0OIMlYkFGAR3Q7@lists.linux.dev
X-Gm-Message-State: AOJu0YzmLmX3v/BOELR/ky9N/5Y+4819OO5QkF5coot+JPruC2y1D90M
	e97/DxfE8kbtVL499T8uuJt1m89JuqntUoK6ZZxesVaCv8dkfxY4xCEyMmZbmOZSN99YXgHKYRh
	0rlOIDs8NUfp+HlPBbgGMwvAWwIZRT7vQhFgu
X-Google-Smtp-Source: AGHT+IHZQa+zNFYjSW5F1k/S5mySXKcAJ5QsmY1xuqJWgAZl36ax55MXXxAtLtxRs+kQBknpyHe623QMj1Zwqpe5flA=
X-Received: by 2002:a05:600c:1c95:b0:428:52a:3580 with SMTP id
 5b1f17b1804b1-42acd542433mr89374015e9.3.1724755169961; Tue, 27 Aug 2024
 03:39:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240827100403.376389-1-ojeda@kernel.org>
In-Reply-To: <20240827100403.376389-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 27 Aug 2024 12:39:18 +0200
Message-ID: <CAH5fLghhgWdJHdOR7TYwGADecsqBtOF08+S4v3RimeFsqvdfuw@mail.gmail.com>
Subject: Re: [PATCH] rust: allow `stable_features` lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 12:04=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> Support for several Rust compiler versions started in commit 63b27f4a0074
> ("rust: start supporting several compiler versions"). Since we currently
> need to use a number of unstable features in the kernel, it is a matter
> of time until one gets stabilized and the `stable_features` lint warns.
>
> For instance, the `new_uninit` feature may become stable soon, which
> would give us multiple warnings like the following:
>
>     warning: the feature `new_uninit` has been stable since 1.82.0-dev
>     and no longer requires an attribute to enable
>       --> rust/kernel/lib.rs:17:12
>        |
>     17 | #![feature(new_uninit)]
>        |            ^^^^^^^^^^
>        |
>        =3D note: `#[warn(stable_features)]` on by default
>
> Thus allow the `stable_features` lint to avoid such warnings. This is
> the simplest approach -- we do not have that many cases (and the goal
> is to stop using unstable features anyway) and cleanups can be easily
> done when we decide to update the minimum version.
>
> An alternative would be to conditionally enable them based on the
> compiler version (with the upcoming `RUSTC_VERSION` or maybe with the
> unstable `cfg(version(...))`, but that one apparently will not work for
> the nightly case). However, doing so is more complex and may not work
> well for different nightlies of the same version, unless we do not care
> about older nightlies.
>
> Another alternative is using explicit tests of the feature calling
> `rustc`, but that is also more complex and slower.

You mention a bunch of alternatives, but I agree that this is the best
way forward. It's very simple. Only possible disadvantage could be if
we forget to remove features when raising the MSRV, but I don't think
that's a big risk.

(You could potentially pass -Astable_features only when the Rust
compiler is not the lowest supported version.)

> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
