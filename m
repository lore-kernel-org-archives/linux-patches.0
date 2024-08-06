Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEE02BAEF
	for <patches@lists.linux.dev>; Tue,  6 Aug 2024 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722958933; cv=none; b=trsRMybFuPZ++JEYpjD7lRneSQ9w3dJW9i37nv7pYTG3OpxifIf/OIW1HM3mDhhxrUWV+VAz4xpKXST2Tddy+3NOQVOZf5DsbzMQGLC31Z+T5T/VU+k5+1JSb9mcDy2H52cZadP9p/nRxwSxYFgGS24i4KJowrEd64a4QGXS3ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722958933; c=relaxed/simple;
	bh=2F97gembZB7Ph+t8UMlLUN/RaEUIDWcSTRDhoreN85k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ejYg2vZqeQ/lo58L86m8nGICwf6uWtnvyoQzJmcjKE+dEYuay5Sybk05/jSlnbcMgbnLk+mnVKkVeV/WEo3kCyGScntZmzXzZIrWmh12aBPuHxVWJWugGZfmKmuNuJsevOo78+nTHcQmg87TPYcWNZ/ZmFVLLfZtqAc31reWow8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XoT+a34P; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XoT+a34P"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-42816ca797fso5488455e9.2
        for <patches@lists.linux.dev>; Tue, 06 Aug 2024 08:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722958930; x=1723563730; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=THccCsa9d44/a7k4O9weE7Ak3VSX2fq1wLCNhXJEyK4=;
        b=XoT+a34P/S90+ag+Jxz+VlWhV26HuZVwO40l6W4h5lFJFMQoS5n08J2RDNIhvRL+g/
         BOKo1XONmHeiD8CHexvaxBaN1jQPYt/OQ01pqmZQKmLSJrrM8KvIOUVQAkB1XxGMQ+hJ
         G6WoE53PERY/WVBe4UFAm8FqJarpdkIajAcfs1QnxqRPR0pkeaKzcqQQ8u6Yt9XnIbMT
         XJCpZ61i7C0wKNyzwkKm9hwctVkK2qK9lRFzuYFY177cmIRqBDcv+KLOTXmxYFIhh5yy
         eq4blR8AoWzefj6VMrL7tfIa5Uf+/AEHEg7Em2CC0USHl+iqX/RSQFIAeeU4sKIFjow4
         iZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722958930; x=1723563730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=THccCsa9d44/a7k4O9weE7Ak3VSX2fq1wLCNhXJEyK4=;
        b=PT8JrengwpNSD32sVihAdVri0zidGiZcdkT7+2rIW+SlkqPM68EUlOk8BoKgjxXU63
         Hbblj3y1GJiYsAQlib+EkO5BcJdxas9yCU0kLYqmRtP3CXQShPgjPqMvepnyeJk6yha1
         HyDsSK1zdIi7tC7SjmjI0gGVuhgIs7XqC8Pc9MazTDh+XP12KdeJR/fu/SB5ol/8ZYVB
         bxGVz+bY1yygnjLGLlcVmNDIHNHjUx6QKpDaSPmbOWvK1slHYnxgg2CGGZLuGEiGx+uB
         S+YMns1G3ho2ACHTTL/d+3r/2zBwrxv7VUpfp1SbNpzhr9k/NXz8HuSje3zl5uMKqNST
         rSJA==
X-Forwarded-Encrypted: i=1; AJvYcCXAjCASfedkMVt6koV4pKMxxWAxG9MMlfBp5LheqGU74Nf13N8OnHmEr9RLLY7ikkttQEN3hhx4@lists.linux.dev
X-Gm-Message-State: AOJu0YxwUE6xvTz78ADe9qsqPWmjxJ1WXEiOjvbEp8lTZTVmHOw52I1O
	Z/lm5/jegd5pthUBvysMtr9dXYpO5b873mTXIVJRbk+kUT0zWpu/HD+/4MejC+1KsezlH7OJ8kD
	FLe9IAjA9+wf/4OU0THtnp2zOANWL+BKO20Or
X-Google-Smtp-Source: AGHT+IFy1q1xSU6pQqfOY13ZKc31YixugPXTYoG2iOCjOHiY5xXt+yoxINs0iVcTVHkdmSjbDCF8Z08VAJ3+o8YTt88=
X-Received: by 2002:a5d:67d0:0:b0:360:7c4b:58c3 with SMTP id
 ffacd0b85a97d-36bbc17ec0emr11080309f8f.54.1722958929954; Tue, 06 Aug 2024
 08:42:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240806150619.192882-1-ojeda@kernel.org>
In-Reply-To: <20240806150619.192882-1-ojeda@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Tue, 6 Aug 2024 17:41:57 +0200
Message-ID: <CAH5fLgiPS9ByFPU+4GoLUwgH=GTD0xkCp2mi9zvaC6XzLpP03g@mail.gmail.com>
Subject: Re: [PATCH] rust: add intrinsics to fix `-Os` builds
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	rust-for-linux@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 6, 2024 at 5:06=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wrot=
e:
>
> Alice reported [1] that an arm64 build failed with:
>
>     ld.lld: error: undefined symbol: __extendsfdf2
>     >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
>     >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a
>     >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
>     >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a
>
>     ld.lld: error: undefined symbol: __truncdfsf2
>     >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
>     >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a
>
> Rust 1.80.0 or later together with `CONFIG_CC_OPTIMIZE_FOR_SIZE=3Dy`
> is what triggers it.
>
> In addition, x86_64 builds also fail the same way.
>
> Similarly, compiling with Rust 1.82.0 (currently in nightly) makes
> another one appear, possibly due to the LLVM 19 upgrade there:
>
>     ld.lld: error: undefined symbol: __eqdf2
>     >>> referenced by core.20495ea57a9f069d-cgu.0
>     >>>               rust/core.o:(<f64>::next_up) in archive vmlinux.a
>     >>> referenced by core.20495ea57a9f069d-cgu.0
>     >>>               rust/core.o:(<f64>::next_down) in archive vmlinux.a
>
> Gary adds [1]:
>
> > Usually the fix on rustc side is to mark those functions as `#[inline]`
> >
> > All of {midpoint,next_up,next_down} are indeed unstable functions not
> > marked as inline...
>
> Fix all those by adding those intrinsics to our usual workaround.
>
> Cc: Gary Guo <gary@garyguo.net>
> Reported-by: Alice Ryhl <aliceryhl@google.com>
> Closes: https://rust-for-linux.zulipchat.com/#narrow/stream/288089-Genera=
l/topic/v6.2E11-rc1.20doesn't.20build.20for.20arm64/near/455637364
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

This fixes the issue I ran into.

Tested-by: Alice Ryhl <aliceryhl@google.com>
