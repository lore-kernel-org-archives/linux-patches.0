Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD9C1DFFA
	for <patches@lists.linux.dev>; Mon, 25 Dec 2023 16:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UnPDGunn"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ccabfd9762so22417461fa.1
        for <patches@lists.linux.dev>; Mon, 25 Dec 2023 08:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703522450; x=1704127250; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fyrs7Ll9Q+iAmpgy0m3tgYOMDYlC9HxJOdfyP/9chm8=;
        b=UnPDGunnXJLxqT18HG3gD+TefunYqzWE9/Pu/ldepU8CJlG/L+P4IGmPgvBbW/Sb7P
         81hOmBG+BRmZx0TbrMYotSxHnGd9+s0um9HeBK8eUzFO0+KXB97AzQERABLXoevNpAjl
         zmM7tNC4Brtsbb8OkQmKU5auKNJ27BAHE4JlykoREbYQsxYmFYu0xj/T/cNM3OQdjl6y
         VnDqClsqO748uhs0NJ9XBIuq1MxKWeIF631Xb4Q+VAhJFDotkAMEYfmpOAbCyrs+xy+h
         1L+1cHdU3xOMGEL9433J1ANd9gAHRwWbslhUvVxSxjHl2D1/jnEKi3ANPib6/A1K6Uiq
         Pl+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703522450; x=1704127250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fyrs7Ll9Q+iAmpgy0m3tgYOMDYlC9HxJOdfyP/9chm8=;
        b=doPn8c5Aiq/Knsny0+7zwIdeUmSdL5BrVxbs8uy6EC2KkRW4vEp9EJ0HmJSWj3Wh6L
         XESOU3pX2TxwDsPTrTqVpDukXQAps+WXH7xHJ4Odq7/0AU0/xGdGa2hjXWZ9eBu6apri
         7oaI5bwWathopPyLY6Q3SqMSVvIc1n6v1A2WHM4aqwfHR7frKH1A7Mas4eOe66g2Vd4C
         zjljHboYcPZiOO2z9wzKv5Ap5V/MOpNGt6VmqbVozq+gjUHBBLUhrXCcoGySXGG9EWgI
         O4BHr5Libkn96z4kmauz8KUjxUqb3UJOpQ/Ee7nLNSeDeSlfxc1PkWwS3sOV05fGif8H
         ZJuQ==
X-Gm-Message-State: AOJu0YxHKpcKBrtT/o2a5YnF1G3Bqbe8fxbRz6Ch5PUK2woN+pf8gERr
	s/i5VWFVI5Pd6rSRhzuOCDvCWsrkmrPfSyedA0A=
X-Google-Smtp-Source: AGHT+IEEhAZtmtduwuOGDbra3s0u0PIh9UM9Ey7Xgh800PGovD5L2RU6Qk1YDYxCcp5ownM2AxWmguWNYO2n212nc5M=
X-Received: by 2002:a2e:8742:0:b0:2cc:7a8e:1846 with SMTP id
 q2-20020a2e8742000000b002cc7a8e1846mr3167817ljj.17.1703522449790; Mon, 25 Dec
 2023 08:40:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231224172128.271447-1-ojeda@kernel.org>
In-Reply-To: <20231224172128.271447-1-ojeda@kernel.org>
From: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Date: Mon, 25 Dec 2023 17:40:36 +0100
Message-ID: <CAKy8djQQaR9WGv1gon49QBVGMZmg-9o75EDan0q4ohgKonnFpQ@mail.gmail.com>
Subject: Re: [PATCH] rust: upgrade to Rust 1.75.0
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

   Vincent.


On Sun, Dec 24, 2023 at 6:22=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This is the next upgrade to the Rust toolchain, from 1.74.1 to 1.75.0
> (i.e. the latest) [1].
>
> See the upgrade policy [2] and the comments on the first upgrade in
> commit 3ed03f4da06e ("rust: upgrade to Rust 1.68.2").
>
> # Unstable features
>
> The `const_maybe_uninit_zeroed` unstable feature [3] was stabilized in
> Rust 1.75.0, which we were using in the PHYLIB abstractions.
>
> The only unstable features allowed to be used outside the `kernel` crate
> are still `new_uninit,offset_of`, though other code to be upstreamed
> may increase the list.
>
> Please see [4] for details.
>
> # Other improvements
>
> Rust 1.75.0 stabilized `pointer_byte_offsets` [5] which we could
> potentially use as an alternative for `ptr_metadata` in the future.
>
> # Required changes
>
> For this upgrade, no changes were required (i.e. on our side).
>
> # `alloc` upgrade and reviewing
>
> The vast majority of changes are due to our `alloc` fork being upgraded
> at once.
>
> There are two kinds of changes to be aware of: the ones coming from
> upstream, which we should follow as closely as possible, and the updates
> needed in our added fallible APIs to keep them matching the newer
> infallible APIs coming from upstream.
>
> Instead of taking a look at the diff of this patch, an alternative
> approach is reviewing a diff of the changes between upstream `alloc` and
> the kernel's. This allows to easily inspect the kernel additions only,
> especially to check if the fallible methods we already have still match
> the infallible ones in the new version coming from upstream.
>
> Another approach is reviewing the changes introduced in the additions in
> the kernel fork between the two versions. This is useful to spot
> potentially unintended changes to our additions.
>
> To apply these approaches, one may follow steps similar to the following
> to generate a pair of patches that show the differences between upstream
> Rust and the kernel (for the subset of `alloc` we use) before and after
> applying this patch:
>
>     # Get the difference with respect to the old version.
>     git -C rust checkout $(linux/scripts/min-tool-version.sh rustc)
>     git -C linux ls-tree -r --name-only HEAD -- rust/alloc |
>         cut -d/ -f3- |
>         grep -Fv README.md |
>         xargs -IPATH cp rust/library/alloc/src/PATH linux/rust/alloc/PATH
>     git -C linux diff --patch-with-stat --summary -R > old.patch
>     git -C linux restore rust/alloc
>
>     # Apply this patch.
>     git -C linux am rust-upgrade.patch
>
>     # Get the difference with respect to the new version.
>     git -C rust checkout $(linux/scripts/min-tool-version.sh rustc)
>     git -C linux ls-tree -r --name-only HEAD -- rust/alloc |
>         cut -d/ -f3- |
>         grep -Fv README.md |
>         xargs -IPATH cp rust/library/alloc/src/PATH linux/rust/alloc/PATH
>     git -C linux diff --patch-with-stat --summary -R > new.patch
>     git -C linux restore rust/alloc
>
> Now one may check the `new.patch` to take a look at the additions (first
> approach) or at the difference between those two patches (second
> approach). For the latter, a side-by-side tool is recommended.
>
> Link: https://github.com/rust-lang/rust/blob/stable/RELEASES.md#version-1=
750-2023-12-28 [1]
> Link: https://rust-for-linux.com/rust-version-policy [2]
> Link: https://github.com/rust-lang/rust/issues/91850 [3]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [4]
> Link: https://github.com/rust-lang/rust/issues/96283 [5]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---


Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
