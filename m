Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C834F657
	for <patches@lists.linux.dev>; Thu, 15 Jun 2023 23:53:18 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-3f8d2bfed53so1477225e9.1
        for <patches@lists.linux.dev>; Thu, 15 Jun 2023 16:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686873197; x=1689465197;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bEj3U7IxHCvvBpo10zUIb3D2I7q49IzY77219a7cqDs=;
        b=JsMCNPy3ZWp1PKLjStbwtqdFIdwP5reIyvuMxk5lfBCuv0wwbTsOus/TwJ8o+WSSYd
         juab4LOhmLblUSaS/DzahH0w3UA35CSDpy3p0wOPJxNR4EbWHPofST+cLrT1x+8Ryq/6
         0SZqnHVdTPJPI3SKpprydjvr2NSOv9axAKjMRM1dQHd8/P/lsvfE2zeWAmzvKtOt3jR0
         kqCir6jHLC8aGmivi0r6tLu5KxZCXNkTyDGLHbUNbAwIzoLkCqv7I1kAZ9cMgwrEDHhc
         UErQ+riSY8R8Mf5qZfO6elc80911OJwyBrY6Ad6/xQmlMLDoDHY188keBa2gaVIaemDJ
         C4kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686873197; x=1689465197;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bEj3U7IxHCvvBpo10zUIb3D2I7q49IzY77219a7cqDs=;
        b=J9e0fBx32D67bhSlhINY0dyYFYnRjxS5OP/hESEtlaMw9bnQt6eLLccULBI1GL+0RH
         pnJgw7Q9KrQEXPBgTw/9w/G2gFNAmYWxMgpyUimUohLZPBneGWZrR6zBvDIG59UMluWC
         HGPGYJPiFxALxI7nbXUKnwpF84KakwnFlUp4YrMggfhzAxYTpPWu5ZTnmoxHfu+fqUvE
         SLFkg8xdPdoiU8C400e94S9juvEcgvEkk3bzGfLCuuKwyKG8Td7MzA4cYi14TDkAhnDK
         0CllGOuubOR+N4B3ASQUwX62qTPHdqcB+4x2pfBRXiGCAP+IEbnS3M0YLIShzrTQxmCr
         VkMA==
X-Gm-Message-State: AC+VfDwbeVv8caun3FzA0jPrUHxe5tOtuCu4llFw9PgdOjvzd4av3RZ+
	rGbTdCafizCH/Gpf6C1KqBo=
X-Google-Smtp-Source: ACHHUZ7CgS1FS94Crcl6jeATC3GCBXb3cbjUkJExdYjWgDUBHh5S7ipQgpwJpxQZeI1plKoFDNpeJQ==
X-Received: by 2002:a7b:ca4c:0:b0:3f8:d030:862c with SMTP id m12-20020a7bca4c000000b003f8d030862cmr161896wml.20.1686873196733;
        Thu, 15 Jun 2023 16:53:16 -0700 (PDT)
Received: from localhost ([146.70.132.158])
        by smtp.gmail.com with ESMTPSA id u20-20020a05600c211400b003f1958eeadcsm516474wml.17.2023.06.15.16.53.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 16:53:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 16 Jun 2023 01:53:14 +0200
Message-Id: <CTDMN3F1JC2T.XNPVZT2P7OKI@vincent-arch>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <benno.lossin@proton.me>, "Alice Ryhl" <aliceryhl@google.com>, "Andreas
 Hindborg" <nmi@metaspace.dk>, "Philip Li" <philip.li@intel.com>,
 <kunit-dev@googlegroups.com>, <linux-kselftest@vger.kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <patches@lists.linux.dev>
Subject: Re: [PATCH 5/6] rust: support running Rust documentation tests as
 KUnit ones
From: "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To: "Miguel Ojeda" <ojeda@kernel.org>, "David Gow" <davidgow@google.com>,
 "Brendan Higgins" <brendan.higgins@linux.dev>, "Wedson Almeida Filho"
 <wedsonaf@gmail.com>, "Alex Gaynor" <alex.gaynor@gmail.com>
References: <20230614180837.630180-1-ojeda@kernel.org>
 <20230614180837.630180-6-ojeda@kernel.org>
In-Reply-To: <20230614180837.630180-6-ojeda@kernel.org>

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
> The tests are also compiled with Clippy under `CLIPPY=3D1`, just like
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


Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
