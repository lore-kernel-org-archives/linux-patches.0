Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD4A4692
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 08:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZlasvkMq"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-50325ce89e9so5460064e87.0
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 01:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696841393; x=1697446193; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jo6aI4gZvvCpMFiUGs+gs/M6BlZphmb01wWlOsiDfrc=;
        b=ZlasvkMqYb04eJKqoZzsz4Pwq5f7JW+9maZnNt0r3mVy7lWHwBIrT+rrr3A1tCEbxh
         CvgyvmF156i/KJSGMS9Li1ZvqKXs3d58H7VVBGQPO7BQ6xHI8M7vDgHC94dTD8gNI7lq
         zluLYAX96s4lUkusmJ8lwCqgC/VxjAtB6VgX2lZhzFI6KhPyqAwESW6nTExC2Y4aTPFf
         BBr4uQ5/oim5qE90ZZxWKwgsXY/0LOrd1Y8Ya82FLMEBOmjxRdUJKUDeG6oh8KXpI6/O
         TThJ95Imq1Uhy89rJM+AQotGvOSj1RDqQJQu56hflTDaTzF6c2lZf8t0+CbrIL7dAKqM
         Jkqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696841393; x=1697446193;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jo6aI4gZvvCpMFiUGs+gs/M6BlZphmb01wWlOsiDfrc=;
        b=HsdSL3meob25hY+O0Vf09yHFDIQWVVrDppNEl3f9cwr0yep4aB25Qv1+cyMnjqhMMB
         0fwKH3yaD4VlWhTPsZcThiAYO5j2bsjeWXxz5AVTBw8se+5B0UIsOtK3bcABvv6fQeMw
         AO0MuxFYVc6++ckLjbWdrVKAp4Nc2mXxfFacVlL/PLXJT3riHXPznAas5pwe/tjccZGK
         PIse58hXKlExDjrdN9q777KTPh7i14As5BF4WUA9vl0uMsTMYREkdVnzOJ7DvYEBzfb7
         eJhEuo/vRdH0EKKB5ItDw4wlQ9oOUwg+gp9rRkvSkS9xMe2SGjB6O0gIcjZ2Z325JGNP
         oO2A==
X-Gm-Message-State: AOJu0Yxa0Clkw7xr07SAvL6icigar0oa6unWE8XfHRPbGfazQIJZs9Wv
	ezwGv3gdbjxs7Shp0Tls2eQ=
X-Google-Smtp-Source: AGHT+IH1y1lLyCexGC0VNVkJhwZly2dg4RHXFhz+DgANrRNwfMwSA+OcjLwrQHPclRFcs+DB3BPN1g==
X-Received: by 2002:a2e:97d2:0:b0:2bc:ed75:1ba with SMTP id m18-20020a2e97d2000000b002bced7501bamr12695953ljj.16.1696841393368;
        Mon, 09 Oct 2023 01:49:53 -0700 (PDT)
Received: from localhost ([146.70.182.19])
        by smtp.gmail.com with ESMTPSA id u4-20020a2e9f04000000b002bcd94f9714sm1947547ljk.126.2023.10.09.01.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 01:49:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 09 Oct 2023 10:49:51 +0200
Message-Id: <CW3S2LWWUVG7.2STK9HS3VBQFR@gmail.com>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <benno.lossin@proton.me>, "Andreas Hindborg" <a.hindborg@samsung.com>,
 "Alice Ryhl" <aliceryhl@google.com>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, "Jonathan
 Corbet" <corbet@lwn.net>, <workflows@vger.kernel.org>,
 <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 3/3] rust: upgrade to Rust 1.73.0
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Wedson Almeida Filho"
 <wedsonaf@gmail.com>, "Alex Gaynor" <alex.gaynor@gmail.com>
X-Mailer: aerc 0.15.2-211-g37d5fc691aff
References: <20231005210556.466856-1-ojeda@kernel.org>
 <20231005210556.466856-4-ojeda@kernel.org>
In-Reply-To: <20231005210556.466856-4-ojeda@kernel.org>

> The vast majority of changes are due to our `alloc` fork being upgraded
> at once.

Ah this is annoying sometimes :/

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
730-2023-10-05 [1]
> Link: https://rust-for-linux.com/rust-version-policy [2]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [3]
> Link: https://github.com/rust-lang/compiler-team/issues/596 [4]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  Documentation/process/changes.rst |  2 +-
>  rust/alloc/alloc.rs               | 22 --------------
>  rust/alloc/boxed.rs               | 48 ++++++++++++++++++++-----------
>  rust/alloc/lib.rs                 |  5 ++--
>  rust/alloc/raw_vec.rs             | 30 ++++++++++++-------
>  rust/alloc/vec/mod.rs             |  4 +--
>  rust/alloc/vec/spec_extend.rs     |  8 +++---
>  rust/compiler_builtins.rs         |  1 +
>  scripts/min-tool-version.sh       |  2 +-
>  9 files changed, 63 insertions(+), 59 deletions(-)
>
> diff --git a/Documentation/process/changes.rst b/Documentation/process/ch=
anges.rst
> index 731cc104c56f..bb96ca0f774b 100644
> --- a/Documentation/process/changes.rst

Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
