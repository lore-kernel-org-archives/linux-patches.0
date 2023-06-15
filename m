Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 372F1360
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 00:19:49 +0000 (UTC)
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-3f9e9e9d06fso1329361cf.0
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 17:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686788389; x=1689380389;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xG3BQaVfAInEtWzfz6GXM6niKI5YlCC6tXwHa1+aR1g=;
        b=2ITOJAE/ABayc+Y2PogEH0Hjt6JukQ9FFLmtYDRk4okZw3JvlxVe2biDOgSJC25VyP
         Zv1W45DbtWljd8SqUYNquUmQU8on9p3ONIobsum/xUFMZ0H7EquKO4/JKvXpY0KtcaSa
         +h7/qfF3OxH0aeRmO/N4wosAXGZt4eNumz+U3OoNuxO4ETOzXhS3EIF30XS3itV8Lt/h
         t356yx31sFMOcljjWpszAWIjy+ug1zp6vlntHxIj/UeNrmCMW41DcD7BS3i6gaoBKW43
         S05KvcdMnZHV1shPPFOTEFGe04QDrYX6IrNo9iE1b/jxa9A28xfIVthbygGzPsp3lsGA
         ufdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686788389; x=1689380389;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xG3BQaVfAInEtWzfz6GXM6niKI5YlCC6tXwHa1+aR1g=;
        b=mCACeLxjs+57eWGeIEx6L7bd1Tp7k//6TIewQDZNHEqw8ZqY0QIOG4uewf7XhAsxz5
         G4n5iPiViC+fI2Eo/ADiT7SjZyoq4fVcurOF2Jy+cKPmWH5N08x7LLqvlAu7519ZJkcu
         HjyHkOq9mHY4ZM+2hw5XLZlxXAwJLrETqVpQrFsugUHSK5QTH9hjaMb5fHdg0Gc9mQXQ
         +p522KEfb2BA78uFwsfzmEYmOX4EPA64OKDPvQzZ9dCzRiIHJOb3GMW+g+hHZTXti0+w
         pAaIYMUNlpH0AMDR63e7Xo8I3MyVhfj/TB3X/UQgikwtQ3r0A49jmZ+w9Sh+7cgkDknY
         emHQ==
X-Gm-Message-State: AC+VfDz1GWw1QEM75qBvZaL4fRRdfZApoOasFteWyEPZdY+6uFNaKadF
	Sc/+s0MLcgaPnQ4Ca/sAc5f1fwhEON9Q56q/pNYIxQ==
X-Google-Smtp-Source: ACHHUZ77T/z/r+sF+BnKA4y7X04c478y3LUwdhEcRCBhZC8/mj36lgn53z6yIHdRAN9zaDTaoUu+j6yVI9Jh5mICta8=
X-Received: by 2002:ad4:5aa8:0:b0:62e:d9db:c788 with SMTP id
 u8-20020ad45aa8000000b0062ed9dbc788mr3622770qvg.3.1686788388738; Wed, 14 Jun
 2023 17:19:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230614180837.630180-1-ojeda@kernel.org> <20230614180837.630180-6-ojeda@kernel.org>
In-Reply-To: <20230614180837.630180-6-ojeda@kernel.org>
From: Matt Gilbride <mattgilbride@google.com>
Date: Wed, 14 Jun 2023 20:19:37 -0400
Message-ID: <CABVGRkcnKX3Sb=LgUHz+E0XPxvemkuO+StAq4xxDY2xSaAt0GQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] rust: support running Rust documentation tests as
 KUnit ones
To: Miguel Ojeda <ojeda@kernel.org>
Cc: David Gow <davidgow@google.com>, Brendan Higgins <brendan.higgins@linux.dev>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <nmi@metaspace.dk>, Philip Li <philip.li@intel.com>, kunit-dev@googlegroups.com, 
	linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

> Rust has documentation tests: these are typically examples of
> usage of any item (e.g. function, struct, module...).
>
> They are very convenient because they are just written
> alongside the documentation. For instance:
>
>     /// Sums two numbers.
>     ///
>     /// ```
>     /// assert_eq!(mymod::f(10, 20), 30);
>     /// ```
>     pub fn f(a: i32, b: i32) -> i32 {
>         a + b
>     }
>
> In userspace, the tests are collected and run via `rustdoc`.
> Using the tool as-is would be useful already, since it allows
> to compile-test most tests (thus enforcing they are kept
> in sync with the code they document) and run those that do not
> depend on in-kernel APIs.
>
> However, by transforming the tests into a KUnit test suite,
> they can also be run inside the kernel. Moreover, the tests
> get to be compiled as other Rust kernel objects instead of
> targeting userspace.
>
> On top of that, the integration with KUnit means the Rust
> support gets to reuse the existing testing facilities. For
> instance, the kernel log would look like:
>
>     KTAP version 1
>     1..1
>         KTAP version 1
>         # Subtest: rust_doctests_kernel
>         1..59
>         # Doctest from line 13
>         ok 1 rust_doctest_kernel_build_assert_rs_0
>         # Doctest from line 56
>         ok 2 rust_doctest_kernel_build_assert_rs_1
>         # Doctest from line 122
>         ok 3 rust_doctest_kernel_init_rs_0
>         ...
>         # Doctest from line 150
>         ok 59 rust_doctest_kernel_types_rs_2
>     # rust_doctests_kernel: pass:59 fail:0 skip:0 total:59
>     # Totals: pass:59 fail:0 skip:0 total:59
>     ok 1 rust_doctests_kernel
>
> Therefore, add support for running Rust documentation tests
> in KUnit. Some other notes about the current implementation
> and support follow.
>
> The transformation is performed by a couple scripts written
> as Rust hostprogs.
>
> Tests using the `?` operator are also supported as usual, e.g.:
>
>     /// ```
>     /// # use kernel::{spawn_work_item, workqueue};
>     /// spawn_work_item!(workqueue::system(), || pr_info!("x"))?;
>     /// # Ok::<(), Error>(())
>     /// ```
>
> The tests are also compiled with Clippy under `CLIPPY=1`, just like
> normal code, thus also benefitting from extra linting.
>
> The names of the tests are currently automatically generated.
> This allows to reduce the burden for documentation writers,
> while keeping them fairly stable for bisection. This is an
> improvement over the `rustdoc`-generated names, which include
> the line number; but ideally we would like to get `rustdoc` to
> provide the Rust item path and a number (for multiple examples
> in a single documented Rust item).
>
> In order for developers to easily see from which original line
> a failed doctests came from, a KTAP diagnostic line is printed
> to the log. In the future, we may be able to use a proper KUnit
> facility to append this sort of information instead.
>
> A notable difference from KUnit C tests is that the Rust tests
> appear to assert using the usual `assert!` and `assert_eq!`
> macros from the Rust standard library (`core`). We provide
> a custom version that forwards the call to KUnit instead.
> Importantly, these macros do not require passing context,
> unlike the KUnit C ones (i.e. `struct kunit *`). This makes
> them easier to use, and readers of the documentation do not need
> to care about which testing framework is used. In addition, it
> may allow us to test third-party code more easily in the future.
>
> However, a current limitation is that KUnit does not support
> assertions in other tasks. Thus we presently simply print an
> error to the kernel log if an assertion actually failed. This
> should be revisited to properly fail the test, perhaps saving
> the context somewhere else, or letting KUnit handle it.
>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Tested-by: Matt Gilbride <mattgilbride@google.com>
