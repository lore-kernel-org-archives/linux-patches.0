Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06FD8492
	for <patches@lists.linux.dev>; Thu, 20 Apr 2023 13:12:55 +0000 (UTC)
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-4ec816c9d03so555831e87.2
        for <patches@lists.linux.dev>; Thu, 20 Apr 2023 06:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681996374; x=1684588374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D2zHLuZQqv995ZnaTJ8GLCbIdGNJLSCJHtTeZLLgszs=;
        b=rcxPnJyw2eJcMgMizZ9JkG80D9A7zgP84qNx43gP76d52MreGttItft3Exv84l+om1
         XrLk8CGQgZoOlnESaD9zaL87N/BDb+vepvaeX8VY2bh/EPAfx8pxOW9tOtqCjg0f4jRt
         fzacQUaiE7zMRYpjSY1RqYuuwTo4FPooWwNCn+gGNaonBe6dVuNAotpMroAohlt3dfgK
         2UlXM+BFTPAH2vJZHOMcnudQzATLkwwujqBF1yXHXKdJncq/nJT2C+/AZbBFhF7WzVMD
         TZTWiuN+8tM6gR3MN17vXl6TwIaMdnBlhGK9rHjIoVS/xhQqF1nymbBDD18NhnF/WBhk
         jfjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681996374; x=1684588374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D2zHLuZQqv995ZnaTJ8GLCbIdGNJLSCJHtTeZLLgszs=;
        b=AH6Aa5z41kk1ucxU51G5r9B02Vuyl2v5upj1OGsdEiKmTpH41nrQBDFCZgxJHKy257
         yBPmiaOMT/X/Yr4Pgk13z2K4xjHJMRmKbEGEnWooLULGlTWJMILaDJcOaSPWKy7hWq1G
         Ds0+yLzF9aGT5GeaT8pyQhP0WlBdlruKo1R2ykD5ABPtcpe0/bJAE4ZbhljaqmXbM/hq
         8gcNW6h47joyjdG9bzFQGgPEWfX4nVfGeNwE8Pe+uL5C+hPuTNCGpxqVuRJ/R0ufVS1u
         eRXjiIAX9d7b276ur73L4WcaNArk0Y78nEFpSF/k/tmRXxw+arUuq4h/uT2SvagSUfGE
         BL1Q==
X-Gm-Message-State: AAQBX9cxGpX5nJCUyoqjqgyQSmLAlyND7r+gLC21oLRvt2w49tByvEbQ
	aRohLmsZFFVbV8viiiIAqp0v3m7CsS5Y65LnWV0=
X-Google-Smtp-Source: AKy350ZutqwJZvzTeNbJ2LJiZaQbkLDXCebqvFCuOgRt0LR5RBao08S9wHcKpEySpbV/IEqglu7EifuEI24NJ+6eWns=
X-Received: by 2002:ac2:43a9:0:b0:4db:5133:59a6 with SMTP id
 t9-20020ac243a9000000b004db513359a6mr368815lfl.13.1681996373645; Thu, 20 Apr
 2023 06:12:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418214347.324156-1-ojeda@kernel.org>
In-Reply-To: <20230418214347.324156-1-ojeda@kernel.org>
From: Ariel Miculas <ariel.miculas@gmail.com>
Date: Thu, 20 Apr 2023 16:12:42 +0300
Message-ID: <CAPDJoNsG1E25yYM+L_H21vVCt-5S16etx3KMxx8ySZtWMQt4FQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Rust 1.68.2 upgrade
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Josh Stone <jistone@redhat.com>, 
	William Brown <william.brown@suse.com>, Georgy Yakovlev <gyakovlev@gentoo.org>, 
	Jan Alexander Steffens <jan.steffens@gmail.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've applied the patch series, upgraded rustc and built the kernel:

$ rustup override set $(scripts/min-tool-version.sh rustc)
$ rustup component add rust-src # Rust standard library source
$ cargo install --locked --version $(scripts/min-tool-version.sh
bindgen) bindgen
$ make LLVM=3D1 rustavailable
$ grep  RUSTC_VERSION .config
CONFIG_RUSTC_VERSION_TEXT=3D"rustc 1.68.2 (9eb3afe9e 2023-03-27)"
$ make LLVM=3D1 -j$(nproc)

Then I ran the kernel in qemu-system-x86_64, inserted the
rust_minimal.ko kernel module and checked that it behaves as expected.

Tested-by: Ariel Miculas <amiculas@cisco.com>

Cheers,
Ariel

On Wed, Apr 19, 2023 at 12:48=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> This is the first upgrade to the Rust toolchain since the initial Rust
> merge, from 1.62.0 to 1.68.2 (i.e. the latest).
>
> Please see the last patch message for a long explanation of the upgrade,
> the policy for future upgrades and some indications on how to easily
> review this.
>
> The series is based on `rust-next`.
>
> Miguel Ojeda (3):
>   rust: alloc: clarify what is the upstream version
>   rust: arc: fix intra-doc link in `Arc<T>::init`
>   rust: upgrade to Rust 1.68.2
>
>  Documentation/process/changes.rst |   2 +-
>  rust/alloc/README.md              |   3 +
>  rust/alloc/alloc.rs               |  55 ++--
>  rust/alloc/boxed.rs               | 446 ++++++++++++++++++++++++++--
>  rust/alloc/collections/mod.rs     |   5 +-
>  rust/alloc/lib.rs                 |  71 +++--
>  rust/alloc/raw_vec.rs             |  16 +-
>  rust/alloc/slice.rs               | 447 ++++------------------------
>  rust/alloc/vec/drain.rs           |  81 +++++-
>  rust/alloc/vec/drain_filter.rs    |  60 +++-
>  rust/alloc/vec/into_iter.rs       | 125 ++++++--
>  rust/alloc/vec/is_zero.rs         |  96 ++++++-
>  rust/alloc/vec/mod.rs             | 464 +++++++++++++++++++++++-------
>  rust/alloc/vec/set_len_on_drop.rs |   5 +
>  rust/alloc/vec/spec_extend.rs     |  63 +---
>  rust/bindings/lib.rs              |   1 -
>  rust/kernel/build_assert.rs       |   2 +
>  rust/kernel/init.rs               |   5 +
>  rust/kernel/lib.rs                |   4 -
>  rust/kernel/std_vendor.rs         |   2 +
>  rust/kernel/sync/arc.rs           |   2 +-
>  scripts/Makefile.build            |   2 +-
>  scripts/min-tool-version.sh       |   2 +-
>  23 files changed, 1278 insertions(+), 681 deletions(-)
>
> --
> 2.40.0
>
