Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2594C9D
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 07:49:56 +0000 (UTC)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-99c3d3c3db9so108045666b.3
        for <patches@lists.linux.dev>; Wed, 02 Aug 2023 00:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umich.edu; s=google-2016-06-03; t=1690962595; x=1691567395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c0VJhH2Z756QKOs3JZdHMzRvuHXC7tOpXij3aANtcuY=;
        b=Og7ZHsEohQK5gYKe0PKPpZmtqnSLba+zO0Hc3g1vhp26ob/YEsPA/vYuYs3R2k9vAH
         bDjXL+l1tDQUffpFsyketbLsigIqcppC3CsVb/lPXoq+T1stMompu09UbE9sQg6paLTy
         asWZ3r0Dx1vkonGTGf+z7UEV0L8sqaj/BKZRvLudBnQstzPyRpwJ8wBlwwHWTjb9D/td
         X/6rDTbf/Lc3eZpatSdk9916uZHmyk4Ht2zNBjx7LzoHAy8dcSV03yo+1aFyqOFkGzFY
         ybuwytlo28jNOrXG7Qi6duJuU/ZL6cW87OKXS8/4JsFbTdbwnDwnPzCgBIV4mMgjd1bu
         m+gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690962595; x=1691567395;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c0VJhH2Z756QKOs3JZdHMzRvuHXC7tOpXij3aANtcuY=;
        b=OfddXenQROKAFoJSJcQuvwOLwfdeN47Z43cVOKlSdt4C4xX+pHLK8+t1GgZHnvzlIp
         r8CV1EU43fzCU3Cxv3XOJGIFzh91WDR3hpsXCydUOYVh20jGKliSQ2XcqrScC1fcmzjv
         IRhYDOeC2SJnopjIr6pOMuI88bYfJgP248tHWdYn4nddOb8gRJBZYA0n625+fp9H+lK1
         zrKgy0Dn9SPOPK1rqYTQOuzDscQpKE2OB1JDgHeji+EpX1Xsa0qpWCBcChiMWkwHW4Z2
         /YtDaYgvPu9wHDOPpyv0r/AHCbb227HgLYg4GwyBtrK0xwutzC6xJvuhfeZpPtMJG5dC
         ldvA==
X-Gm-Message-State: ABy/qLZdgHe4GtlFdgeqdoehgddCSi6nXEvgVJrpOjnqskGtWMo2jDw7
	Viojy3oDCaSTw7g5caNyZPxQqUxop/xtbCMs74HV1w==
X-Google-Smtp-Source: APBJJlH2YkiZGbYVtxer1W7isty1PVaWaBz7UcC5TW/uFSLk6MRTNTLb52mcEMYXUbNlQNO8Fpo6SQSvROqt/6IYpCQ=
X-Received: by 2002:a17:907:a070:b0:99b:ed18:7a10 with SMTP id
 ia16-20020a170907a07000b0099bed187a10mr3803171ejc.36.1690962595084; Wed, 02
 Aug 2023 00:49:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230729220317.416771-1-ojeda@kernel.org> <20230729220317.416771-2-ojeda@kernel.org>
In-Reply-To: <20230729220317.416771-2-ojeda@kernel.org>
From: Trevor Gross <tmgross@umich.edu>
Date: Wed, 2 Aug 2023 03:49:43 -0400
Message-ID: <CALNs47sn5GT9_VKn-SGb+STFwpbUipoNyU_+ZbpDwzLXUknUUQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] rust: enable `no_mangle_with_rust_abi` Clippy lint
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <a.hindborg@samsung.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 29, 2023 at 6:05=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> Introduced in Rust 1.69.0 [1], this lint prevents forgetting to set
> the C ABI when using `#[no_mangle]` (or thinking it is implied).
>
> For instance, it would have prevented the issue [2] fixed by commit
> c682e4c37d2b ("rust: kernel: Mark rust_fmt_argument as extern "C"").
>
>     error: `#[no_mangle]` set on a function with the default (`Rust`) ABI
>       --> rust/kernel/print.rs:21:1
>        |
>     21 | / unsafe fn rust_fmt_argument(
>     22 | |     buf: *mut c_char,
>     23 | |     end: *mut c_char,
>     24 | |     ptr: *const c_void,
>     25 | | ) -> *mut c_char {
>        | |________________^
>        |
>        =3D help: for further information visit https://rust-lang.github.i=
o/rust-clippy/master/index.html#no_mangle_with_rust_abi
>        =3D note: requested on the command line with `-D clippy::no-mangle=
-with-rust-abi`
>     help: set an ABI
>        |
>     21 | unsafe extern "C" fn rust_fmt_argument(
>        |        ++++++++++
>     help: or explicitly set the default
>        |
>     21 | unsafe extern "Rust" fn rust_fmt_argument(
>        |        +++++++++++++
>
> Thus enable it.
>
> In rare cases, we may need to use the Rust ABI even with `#[no_mangle]`
> (e.g. one case, before 1.71.0, would have been the `__rust_*`
> functions). In those cases, we would need to `#[allow(...)]` the lint,
> since using `extern "Rust"` explicitly (as the compiler suggests)
> currently gets overwritten by `rustfmt` [3].
>
> Link: https://github.com/rust-lang/rust-clippy/issues/10347 [1]
> Link: https://github.com/Rust-for-Linux/linux/pull/967 [2]
> Link: https://github.com/rust-lang/rustfmt/issues/5701 [3]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> [...]

Reviewed-by: Trevor Gross <tmgross@umich.edu>
