Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EBB15AED
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 18:00:47 +0000 (UTC)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-992f6d7c7fbso843316466b.3
        for <patches@lists.linux.dev>; Tue, 18 Jul 2023 11:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689703246; x=1692295246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PyN7LRdxuJ3+3m6qyMY/Pn72VV1r0UZI32fa8KhLFbY=;
        b=qG0/1wSnOmHRcShWCFotbPYMGXIVlK+nE2fNftS6Hnjs7APhWfde2eLblRn58gqJcg
         Xg5JiJ3QRA4VSUc1FA2MAJ1Q6VZ+e9GAohGP9+aMiHpmrXArIrsJxQJdVoJQF+omjfqo
         YckPrfZ3z1idGNOr08WkkrgXwb4wqnM4AV6pvpQ+1D18wEpP0aFIOlRyCrIAI97jqs1C
         xKyHZVmmFzHFg/g4GoNsY1kKqQ5a8/OA5FSyR4roa5i8W8MhkkPlI8J3tIUMRBmeqFh6
         D0S7JNHXSEySo1uDJcJVhLa3GcXM6uNtu/N4ta6TLf7IFV8Tbcls23zqgiSwA4ZUQ9a7
         MgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689703246; x=1692295246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PyN7LRdxuJ3+3m6qyMY/Pn72VV1r0UZI32fa8KhLFbY=;
        b=b6bfsNd8M3y6RIjPcKodEK7ZlGOySGiv6uYaOvtKBIt/TumVP1JUGe+/rOW/4njBm6
         LDawf7bzW1v2/eR6FOXhTtEDk1CYbnWj/oy1BV8psqHcrRKoT1WSbOBJVJxo78OGjm62
         9NoDGU8cq8ariiTuMksoAWUiSb8fxAcp8/9T9v1vuiMZtPTTJnnL/Wa9BvJzKK6dMV/p
         aWIfkbKfBqzcAFbrGtfCDba6WcxST0e7TeOIlKG4rFyjDzNPvf+9UFqHSnjArkZqjJ+6
         zrpSEBAquhsVAJxgTZXsJxZjMsosMRB9WoL67/WckuH23+duUQxfD+6TP8/AGvRY2gqK
         Uswg==
X-Gm-Message-State: ABy/qLZ6ixKZAKu7gyYQUKub+9BnTg8Ids5fydRBHupwG0cRej+chCsO
	Ku41GN7iZrkNNASEuvpaAiA=
X-Google-Smtp-Source: APBJJlHuALfP05nJMTIaDtdhR6Sc7rP0zzWHX5XYkV6ZoFC0W1Om+XGykCwePD8QM5XRktKYvRjLYA==
X-Received: by 2002:a17:907:720b:b0:98e:3cef:68ff with SMTP id dr11-20020a170907720b00b0098e3cef68ffmr362435ejc.43.1689703245941;
        Tue, 18 Jul 2023 11:00:45 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id ko1-20020a170907986100b00992e14af9c3sm1282331ejc.143.2023.07.18.11.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 11:00:45 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailauth.nyi.internal (Postfix) with ESMTP id 448F827C0054;
	Tue, 18 Jul 2023 14:00:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 18 Jul 2023 14:00:43 -0400
X-ME-Sender: <xms:SdO2ZGHiNe30w3XA54gEUIwNq-L_kZRh0N6BjvHRBHS3CEbGvaW4LA>
    <xme:SdO2ZHWltoCr-Lopue2uDNfUCy8KD52QKyBdPUQlXW7uqOzlXkUNjnjtS9SJlWKLv
    j8nvAIGJXjo1Ivk-A>
X-ME-Received: <xmr:SdO2ZALpp9spxMmbbfX4ni-yEcN8rEp85jtQBPktBNn3AhIa-CXy5Q-Q1BGOVw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedviedrgeeggdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeejffegieejvddtgfekkefhjeegjeevuedugfehfedtkeffjedtleeiuefh
    vdefgeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhh
    phgvrhhsohhnrghlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunh
    drfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:SdO2ZAFukTBpGc-J96GoU5Tvd0BJkqMTTNoydMwUjv6bEElqmKt3GA>
    <xmx:SdO2ZMWA8Nma3GAn0pTWOH1jy9CGnlB8YCJrIC4uhJ9E-16ltWDk0g>
    <xmx:SdO2ZDNumuv-FMPowJk8KBjIAgT-MI7KWKeg9njwOuFopXmQge8iSg>
    <xmx:StO2ZNsjkQKXwZiy-l0E2qp7sgCNgE_y93HBwchpLgvIHey-h29EaQ>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 18 Jul 2023 14:00:40 -0400 (EDT)
Date: Tue, 18 Jul 2023 11:00:37 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: David Gow <davidgow@google.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <nmi@metaspace.dk>, kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2 0/7] KUnit integration for Rust doctests
Message-ID: <ZLbTRZMjcFNAamit@boqun-archlinux>
References: <20230718052752.1045248-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718052752.1045248-1-ojeda@kernel.org>

On Tue, Jul 18, 2023 at 07:27:45AM +0200, Miguel Ojeda wrote:
[...]
> 
>   - Collected `Reviewed-by`s and `Tested-by`s, except for the main
>     commit due to the substantial changes.

I've applied the series and run the following command:

	./tools/testing/kunit/kunit.py run --make_options LLVM=1 --arch x86_64 --kconfig_add CONFIG_RUST=y	

everything works as expected, and I also tried modifying one of the
`assert!` to trigger it, all looks good to me. Feel free to add:

Tested-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

> 
> Miguel Ojeda (7):
>   kunit: test-bug.h: include `stddef.h` for `NULL`
>   rust: init: make doctests compilable/testable
>   rust: str: make doctests compilable/testable
>   rust: sync: make doctests compilable/testable
>   rust: types: make doctests compilable/testable
>   rust: support running Rust documentation tests as KUnit ones
>   MAINTAINERS: add Rust KUnit files to the KUnit entry
> 
>  MAINTAINERS                       |   2 +
>  include/kunit/test-bug.h          |   2 +
>  lib/Kconfig.debug                 |  13 ++
>  rust/.gitignore                   |   2 +
>  rust/Makefile                     |  29 ++++
>  rust/bindings/bindings_helper.h   |   1 +
>  rust/helpers.c                    |   7 +
>  rust/kernel/init.rs               |  26 +--
>  rust/kernel/kunit.rs              | 163 +++++++++++++++++++
>  rust/kernel/lib.rs                |   2 +
>  rust/kernel/str.rs                |   4 +-
>  rust/kernel/sync/arc.rs           |   9 +-
>  rust/kernel/sync/lock/mutex.rs    |   1 +
> v1: https://lore.kernel.org/rust-for-linux/20230614180837.630180-1-ojeda@kernel.org/
> v2:
> 
>   - Rebased on top of v6.5-rc1, which requires a change from
>     `kunit_do_failed_assertion` to `__kunit_do_failed_assertion` (since
>     the former became a macro) and the addition of a call to
>     `__kunit_abort` (since previously the call was done by the old
>     function which we cannot use anymore since it is a macro). (David)
> 
>   - Added prerequisite patch to KUnit header to include `stddef.h` to
>     support the `KUNIT=y` case. (Reported by Boqun)
> 
>   - Added comment on the purpose of `trait FromErrno`. (Martin asked
>     about it)
> 
>   - Simplify code to use `std::fs::write` instead of `write!`, which
>     improves code size too. (Suggested by Alice)
> 
>   - Fix copy-paste type in docs from "error" to "info" and, to make it
>     proper English, copy the `printk` docs style, i.e. from "info"
>     to "info-level message" -- and same for the "error" one. (Miguel)
> 
>   - Swap `FILE` and `LINE` `static`s to keep the same order as done
>     elsewhere. (Miguel)
> 
>   - Rename config option from `RUST_KERNEL_KUNIT_TEST` to
>     `RUST_KERNEL_DOCTESTS` (and update its title), so that we can use
>     the former for the "normal" (i.e. non-doctests, e.g. `#[test]` ones)
>     tests in the future. (David)
> 
>   - Follow the syntax proposed for declaring test metadata in the KTAP
>     v2 spec, which may also get used for the KUnit test attributes API.
> 
>     Thus, instead of "# Doctest from line {line}", use
>     "# {test_name}.location: {file}.{line}", which ideally will allow to
>     migrate to a KUnit attribute later.
> 
>     This is done in all cases, i.e. when the tests succeeds, because
>     it may be useful for users running KUnit manually, or when passing
>     `--raw_output` to `kunit.py`. (David)
> 
>     David: I used "location" instead of your suggested "line" alone, in
>     order to have both in a single line, which looked nice and closer to
>     the "ASSERTION FAILURE" case/line, since now we do have the original
>     file (please see below).
> 
>   - Figure out the original line. This is done by deploying an anchor
>     so that the difference in lines between the beginning of the test
>     and the assert, in the generated file, can be computed. Then, we
>     offset the line number of the original test, which is given by
>     `rustdoc`. (developed by Boqun)
> 
>   - Figure out the original file. This is done by walking the
>     filesystem, checking directory prefixes to reduce the amount of
>     combinations to check, and it is only done once per file (rather
>     than per test).
> 
>     Ambiguities are detected and reported. It does limit the filenames
>     (module names) we can use, but it is unlikely we will hit it soon
>     and this should be temporary anyway until `rustdoc` provides us
>     with the real path. (Miguel)
> 
>     Tested with both in-tree and `O=` builds, but I would appreciate
>     extra testing on this one, including via the `kunit.py` script.
> 
>   - The three last items combined means that we now see this output even
>     for successful cases:
> 
>         # rust_doctest_kernel_sync_locked_by_rs_0.location: rust/kernel/sync/locked_by.rs:28
>         ok 53 rust_doctest_kernel_sync_locked_by_rs_0
> 
>     Which basically gives the user all the information they need to go
>     back to the source code of the doctest, while keeping them fairly
>     stable for bisection, and while avoiding to require users to write
>     test names manually. (David + Boqun + Miguel)
> 
>     David: from what I saw in v2 of the RFC for the test attributes API,
>     the syntax still contains the test name when it is not a suite, so
>     I followed that, but if you prefer to omit it, please feel free to
>     do so (for me either way it is fine, and if this is the expected
>     attribute syntax, I guess it is worth to follow it to make migration
>     easier later on):
> 
>         # location: rust/kernel/sync/locked_by.rs:28
>         ok 53 rust_doctest_kernel_sync_locked_by_rs_0
>  rust/kernel/sync/lock/spinlock.rs |   1 +
>  rust/kernel/types.rs              |   6 +-
>  scripts/.gitignore                |   2 +
>  scripts/Makefile                  |   4 +
>  scripts/rustdoc_test_builder.rs   |  72 +++++++++
>  scripts/rustdoc_test_gen.rs       | 260 ++++++++++++++++++++++++++++++
>  19 files changed, 591 insertions(+), 15 deletions(-)
>  create mode 100644 rust/kernel/kunit.rs
>  create mode 100644 scripts/rustdoc_test_builder.rs
>  create mode 100644 scripts/rustdoc_test_gen.rs
> 
> 
> base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
> -- 
> 2.41.0
> 
