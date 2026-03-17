Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC9B396B7D;
	Tue, 17 Mar 2026 08:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773736941; cv=none; b=a7FvBwlOYC6gc1xXzHnvty1+efIVrT/Xy04JAUCXRsK5iCu/xm38Fr5cFIpiXn+dXAgC4mfddDrsJOMwgsOASxjEOUKDe5PDmE4/kjBEpxHzkCKnyG+qCV4nGhbV02Pfsf23H8KqqN6AO7uclAiPDLOn3Lj0gBY3tVUiUeJlI/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773736941; c=relaxed/simple;
	bh=sjP2kUUv/ebsFWd0HXbv/74udIp3imRLZB7s841aAsE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gXulQu9m7TC0TePeKa9Nm1ojUMklK69cMsXJd4WydsYMiqt6zgHnsXftjsUsC/l4cyGMsbWRdWFwXCxI8X3b6qfRyyy/v6MaiVhIgXuaVkk63+BLfLf/dAm+QSVePv8y6Rc8q0P1V73+FuD6k/GlQysM6c9U9au8Nal1sFcVJPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=haZfJrLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="haZfJrLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF175C19425;
	Tue, 17 Mar 2026 08:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773736940;
	bh=sjP2kUUv/ebsFWd0HXbv/74udIp3imRLZB7s841aAsE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=haZfJrLwEcd2jNdOOzbE2T3kAK6kpT0Bzs2AIuf2VB1sHBSdUwtungxubXKz/VpqS
	 UCwKGWdbfC9M4bG7N1PyRaiQCeiX0hmfQsYH2dSc5scA6+kzjh+tK336DKstaq4dx5
	 g8XWVMP6xRPdbQ2Kgt8+UeqP49a30GqDbi+JRIiDyw7daG5ZZUMSIBgZVh1w/IGj3u
	 Y0vw/RWadAqP8fq38d5XQTWQsBkW/XvBoSXHut3k7QRBxJm3ay+MO324mW9NPLc5GL
	 eAWZfOoGHJVJgT443GDgSY/BprQ8VJIfBWvVgGjugmCEvzcXBDkdSZ4391O8T0O8n5
	 kJeczJXlssy2Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Alex
 Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross
 <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, Nick Desaulniers
 <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin
 Stitt <justinstitt@google.com>, llvm@lists.linux.dev,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev, Aaron Ballman
 <aaron@aaronballman.com>, Bill Wendling <isanbard@gmail.com>, Cole
 Nixon <nixontcole@gmail.com>, Connor Kuehl <cipkuehl@gmail.com>, Fangrui
 Song <i@maskray.me>, James Foster <jafosterja@gmail.com>, Jeff
 Takahashi <jeffrey.takahashi@gmail.com>, Jordan Cantrell
 <jordan.cantrell@mail.com>, Matthew Maurer <mmaurer@google.com>, Nikk
 Forbus <nicholas.forbus@gmail.com>, Qing Zhao <qing.zhao@oracle.com>, Sami
 Tolvanen <samitolvanen@google.com>, Tim Pugh <nwtpugh@gmail.com>, Kees
 Cook <kees@kernel.org>
Subject: Re: [RFC PATCH] rust: allow Clang-native `RANDSTRUCT` configs
In-Reply-To: <20241119185747.862544-1-ojeda@kernel.org>
References: <GYMB6vN7uKNVSwQPEtPg0kZPHUkxHQbQe3ZIUqOGZm8ZGwCUE6-iRxJdUQ5xB_qV2bLZVauIZtAGbK1iduefTw==@protonmail.internalid>
 <20241119185747.862544-1-ojeda@kernel.org>
Date: Tue, 17 Mar 2026 09:42:04 +0100
Message-ID: <871phisv8j.fsf@t14s.mail-host-address-is-not-set>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

"Miguel Ojeda" <ojeda@kernel.org> writes:

> The kernel supports `RANDSTRUCT_FULL` with Clang 16+, and `bindgen`
> (which uses `libclang` under the hood) inherits the information, so the
> generated bindings look correct.
>
> For instance, running:
>
>     bindgen x.h -- -frandomize-layout-seed=100
>
> with:
>
>     struct S1 {
>         int a;
>         int b;
>     };
>
>     struct S2 {
>         int a;
>         int b;
>     } __attribute__((randomize_layout));
>
>     struct S3 {
>         void (*a)(void);
>         void (*b)(void);
>     };
>
>     struct S4 {
>         void (*a)(void);
>         void (*b)(void);
>     } __attribute__((no_randomize_layout));
>
> may swap `S2`'s and `S3`'s members, but not `S1`'s nor `S4`'s:
>
>     pub struct S1 {
>         pub a: ::std::os::raw::c_int,
>         pub b: ::std::os::raw::c_int,
>     }
>
>     pub struct S2 {
>         pub b: ::std::os::raw::c_int,
>         pub a: ::std::os::raw::c_int,
>     }
>
>     pub struct S3 {
>         pub b: ::std::option::Option<unsafe extern "C" fn()>,
>         pub a: ::std::option::Option<unsafe extern "C" fn()>,
>     }
>
>     pub struct S4 {
>         pub a: ::std::option::Option<unsafe extern "C" fn()>,
>         pub b: ::std::option::Option<unsafe extern "C" fn()>,
>     }
>
> Thus allow those configurations by requiring a Clang compiler to use
> `RANDSTRUCT`. In addition, remove the `!GCC_PLUGIN_RANDSTRUCT` check
> since it is not needed.
>
> A simpler alternative would be to remove the `!RANDSTRUCT` check (keeping
> the `!GCC_PLUGIN_RANDSTRUCT` one). However, if in the future GCC starts
> supporting `RANDSTRUCT` natively, it would be likely that it would not
> work unless GCC and Clang agree on the exact semantics of the flag. And,
> as far as I can see, so far the randomization in Clang does not seem to be
> guaranteed to remain stable across versions or platforms, i.e. only for a
> given compiler Clang binary, given it is not documented and that LLVM's
> `HEAD` has the revert in place for the expected field names in the test
> (LLVM commit 8dbc6b560055 ("Revert "[randstruct] Check final randomized
> layout ordering"")) [1][2]. And the GCC plugin definitely does not match,
> e.g. its RNG is different (`std::mt19937` vs Bob Jenkins').
>
> And given it is not supposed to be guaranteed to remain stable across
> versions, it is a good idea to match the Clang and `bindgen`'s
> `libclang` versions -- we already have a warning for that in
> `scripts/rust_is_available.sh`. In the future, it would also be good to
> have a build test to double-check layouts do actually match (but that
> is true regardless of this particular feature).
>
> Finally, make a required small change to take into account the anonymous
> struct used in `randomized_struct_fields_*` in `struct task_struct`.
>
> Cc: Aaron Ballman <aaron@aaronballman.com>
> Cc: Bill Wendling <isanbard@gmail.com>
> Cc: Cole Nixon <nixontcole@gmail.com>
> Cc: Connor Kuehl <cipkuehl@gmail.com>
> Cc: Fangrui Song <i@maskray.me>
> Cc: James Foster <jafosterja@gmail.com>
> Cc: Jeff Takahashi <jeffrey.takahashi@gmail.com>
> Cc: Jordan Cantrell <jordan.cantrell@mail.com>
> Cc: Justin Stitt <justinstitt@google.com>
> Cc: Matthew Maurer <mmaurer@google.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nikk Forbus <nicholas.forbus@gmail.com>
> Cc: Qing Zhao <qing.zhao@oracle.com>
> Cc: Sami Tolvanen <samitolvanen@google.com>
> Cc: Tim Pugh <nwtpugh@gmail.com>
> Link: https://reviews.llvm.org/D121556
> Link: https://github.com/llvm/llvm-project/commit/8dbc6b560055ff5068ff45b550482ba62c36b5a5 [1]
> Link: https://reviews.llvm.org/D124199 [2]
> Reviewed-by: Kees Cook <kees@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>


Tested-by: Andreas Hindborg <a.hindborg@kernel.org>

Tested with the rust null block driver patch series [1]. I did a
few functional verification tests and a set of performance tests.

For the rnull driver, enabling randstruct with this patch gives no
statistically significant change to the average performance of the set
of 120 workloads that we publish on [2]. Individual configurations see
around 10% change in throughput, both directions.

Best regards,
Andreas Hindborg

[1] https://lore.kernel.org/rust-for-linux/20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org/
[2] https://rust-for-linux.com/null-block-driver

