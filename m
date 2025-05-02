Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91D4194080;
	Fri,  2 May 2025 18:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746211797; cv=none; b=doa2YIt5mWFHEV5mrPYn3kAzT4+3kvM9aYFKmIJcq9/UX/6UK1/btPQVsWD0fSKY2NQAVk0VoBIrcolo8cP8no2ANxisX79X+7YBOTUBVcogDoWamsIvp8ETZwNkjX2HAH+KzoEM7QcACiKuuFr0UA4oAPSSPJG3qPVilnFvVrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746211797; c=relaxed/simple;
	bh=TAqoh8rRxLj1ScyAlxJ/V1DlCFqEWCFSMj5NSeuxrKk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=fV4nNllynTABtIMOuGigh6jP9js58rDD3XOYgzlXHkriuCy2/kWkvizoxKStY51MssHOD0SyMU8jYoYuA4ftjPRCJJhN9qikLwIaBIAuRgdHfSLO09HJ8qBxwwXALWFa05fB8PQn/ub9GE+kzPmEvgx1qWajRLzzGsVT9e7RgNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VQDO0H3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VQDO0H3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773E1C4CEE4;
	Fri,  2 May 2025 18:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746211797;
	bh=TAqoh8rRxLj1ScyAlxJ/V1DlCFqEWCFSMj5NSeuxrKk=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=VQDO0H3+ygnna3GK2jKuIiJK7tP6zKZGtmUBmwWZjUPSj1qcTq1V4IoDNH6d+VxyR
	 AxRiDAQilneMMHT8pggLVAjYrnMYSuwcaf6XUw5Cxu+tGFSuye+tFbEWcV44p75g86
	 xGFFUx9g81V6mzZQkB5lxuT0LF35PtgrsWbLEK2m51MwdN/IiRVNbPnhXBuBBs0EjN
	 /afOfa9zMYpbqUl9NrpsOS7glmeg484GbYL97GLO867izV4/m2TTrhHqx/+wj17/xJ
	 bo6zd/MprOvhB7tdA+kG+vuhupxhSDnkAFCdWRZ8q75vsLRaMTc6h348T1F52WqnHE
	 kYsumTDiRqp4g==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 02 May 2025 20:49:52 +0200
Message-Id: <D9LWF31GZM92.JYBJGA8BHRZQ@kernel.org>
Cc: "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <benno.lossin@proton.me>, "Andreas Hindborg" <a.hindborg@kernel.org>,
 "Alice Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>,
 "Danilo Krummrich" <dakr@kernel.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
 <stable@vger.kernel.org>
Subject: Re: [PATCH 5/5] rust: clean Rust 1.88.0's
 `clippy::uninlined_format_args` lint
From: "Benno Lossin" <lossin@kernel.org>
To: "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>
X-Mailer: aerc 0.20.1
References: <20250502140237.1659624-1-ojeda@kernel.org>
 <20250502140237.1659624-6-ojeda@kernel.org>
In-Reply-To: <20250502140237.1659624-6-ojeda@kernel.org>

On Fri May 2, 2025 at 4:02 PM CEST, Miguel Ojeda wrote:
> Starting with Rust 1.88.0 (expected 2025-06-26) [1], `rustc` may move
> back the `uninlined_format_args` to `style` from `pedantic` (it was
> there waiting for rust-analyzer suppotr), and thus we will start to see
> lints like:
>
>     warning: variables can be used directly in the `format!` string
>        --> rust/macros/kunit.rs:105:37
>         |
>     105 |         let kunit_wrapper_fn_name =3D format!("kunit_rust_wrapp=
er_{}", test);
>         |                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^^
>         |
>         =3D help: for further information visit https://rust-lang.github.=
io/rust-clippy/master/index.html#uninlined_format_args
>     help: change this to
>         |
>     105 -         let kunit_wrapper_fn_name =3D format!("kunit_rust_wrapp=
er_{}", test);
>     105 +         let kunit_wrapper_fn_name =3D format!("kunit_rust_wrapp=
er_{test}");
>
> There is even a case that is a pure removal:
>
>     warning: variables can be used directly in the `format!` string
>       --> rust/macros/module.rs:51:13
>        |
>     51 |             format!("{field}=3D{content}\0", field =3D field, co=
ntent =3D content)
>        |             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^^^
>        |
>        =3D help: for further information visit https://rust-lang.github.i=
o/rust-clippy/master/index.html#uninlined_format_args
>     help: change this to
>        |
>     51 -             format!("{field}=3D{content}\0", field =3D field, co=
ntent =3D content)
>     51 +             format!("{field}=3D{content}\0")
>
> The lints all seem like nice cleanups, thus just apply them.
>
> We may want to disable `allow-mixed-uninlined-format-args` in the future.
>
> Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned i=
n older LTSs).
> Cc: Benno Lossin <benno.lossin@proton.me>
> Link: https://github.com/rust-lang/rust-clippy/pull/14160 [1]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

For the pin-init modification:=20

Acked-by: Benno Lossin <lossin@kernel.org>

---
Cheers,
Benno

> ---
>  drivers/gpu/nova-core/gpu.rs              |  2 +-
>  rust/kernel/str.rs                        | 46 +++++++++++------------
>  rust/macros/kunit.rs                      | 13 ++-----
>  rust/macros/module.rs                     | 19 +++-------
>  rust/macros/paste.rs                      |  2 +-
>  rust/pin-init/internal/src/pinned_drop.rs |  3 +-
>  6 files changed, 35 insertions(+), 50 deletions(-)
