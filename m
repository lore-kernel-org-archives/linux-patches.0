Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2261C17ED
	for <patches@lists.linux.dev>; Thu, 20 Apr 2023 03:23:26 +0000 (UTC)
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-3ef33a83ff1so883891cf.1
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 20:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681961006; x=1684553006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=adX5pTpCGut2wVqn2rN7BfLycw+2K2wX215Yvm2Skj0=;
        b=kN5PYjRolVrzo8OdzXjG2rOObhk9NXqlw5+diqgNyC2lFH+mHjybp2OrGa8qxslDst
         DS6tzZKsYIX5JPMeMRj5vjJqmGTs5k1w6JyB6k+F6baS1FdhHaEs5Qm47/kAH9y6GL2z
         CCjDdQvrrz7iH1bKXrbaj95wakTU1WL6x3HjKOrDmTkRvsUhU9c2KQjWe8yBpt+Dut8p
         0noJ6Y3HC8HmyWAEF8wQuuMvYAiRpOGFoFJ+sJ1zsQmY5Fk1GBLChxhLWF8YcUz7S5wL
         /HijpkFN/AxMBFCbKacgAXlmHb5sH1iTP2t9xSKHKuSNNXAbJJqMylw/FiHN3IzrAURw
         9EiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681961006; x=1684553006;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=adX5pTpCGut2wVqn2rN7BfLycw+2K2wX215Yvm2Skj0=;
        b=SdVzokniGkBYYnT2ukYdrcOLLnPHMe45NlNTpMUWuODwA6vfm8yXekxGSVNl/levdp
         dqwh7gimKRNhbT7j9u96aWysPbaUUTjqHz3lDL94xXaMC+mgK7mKjz3NkJS4k2FcUGyH
         jsoP1s7ovXleMPxuGMrVok8dJdSN3qIyJcYVK5lX3KhEInEGKDDsZFJzgoNQQ0KG733O
         8TnLaSCfaddD3d/YP3ztms0CnrIoStTJ+1IbWoC1wATHhSIw0ZVGzwnwkQc6BjmnKoqj
         ycWDgaMTJZMxga89049MRmmC4uAAEm7TzzRQvUi1JwVTzQW1DTukGfe+4PO5ppAg4rYJ
         cKsA==
X-Gm-Message-State: AAQBX9eegoMyy+bekmBInKrGE+9OhetMSNDyw9IHY6fs7Hb6yO/wd7xN
	bOvPqBmNxaZowxXEZUKKQvA=
X-Google-Smtp-Source: AKy350aWroSwDmcbYQlKlOqteeglmMI/KFEwoMZCeXscp4drJ7QNHYwvApYy9mDszjXeHjptfUZPGQ==
X-Received: by 2002:ac8:5f86:0:b0:3e6:3ba9:3c8d with SMTP id j6-20020ac85f86000000b003e63ba93c8dmr1285459qta.13.1681961005879;
        Wed, 19 Apr 2023 20:23:25 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id m8-20020ac84448000000b003ec47cc3613sm199905qtn.85.2023.04.19.20.23.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 20:23:25 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailauth.nyi.internal (Postfix) with ESMTP id B79EA27C0054;
	Wed, 19 Apr 2023 23:23:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 19 Apr 2023 23:23:24 -0400
X-ME-Sender: <xms:LLBAZFPRcqepmUcS0jeaIyNE4UVu1tikgQGj8zb1cuFW_X0x5Mwawg>
    <xme:LLBAZH_Oba4SUNRw87mNp4PpuxE0Mjx76Khqh4JNNnb6LakV8KsrFYigzOK3oqgtt
    KJJ0vuHHaGz5_QXuQ>
X-ME-Received: <xmr:LLBAZEReu2KuDj8YdVPSkyuiopHjytxBHMnarLKxRdgvUWXOSMHP3avW3Vn4aA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedtuddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueeviedu
    ffeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdei
    gedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfih
    igmhgvrdhnrghmvg
X-ME-Proxy: <xmx:LLBAZBunC4RgYkjvCJm8TfMS5nZZdXIvMpE-agTozO6MvBi0AmOCdA>
    <xmx:LLBAZNcsQGQ3MLPiJP4ZtGzcP1GUvrAKg4g4VgNSejSSm_m5AM7r2A>
    <xmx:LLBAZN3dtqCXWKUqBbSf-sUZZey272HecYmAHvxlBFI_wM0c57-GOw>
    <xmx:LLBAZL18FVj0cmNgxoJvYsYBxzGLkJa6YQn1-Yo-AD_h22GMclj1PA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Apr 2023 23:23:23 -0400 (EDT)
Date: Wed, 19 Apr 2023 20:23:01 -0700
From: Boqun Feng <boqun.feng@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Josh Stone <jistone@redhat.com>,
	William Brown <william.brown@suse.com>,
	Georgy Yakovlev <gyakovlev@gentoo.org>,
	Jan Alexander Steffens <jan.steffens@gmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 0/3] Rust 1.68.2 upgrade
Message-ID: <ZECwFUyUt77E/5MO@boqun-archlinux>
References: <20230418214347.324156-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418214347.324156-1-ojeda@kernel.org>

On Tue, Apr 18, 2023 at 11:43:44PM +0200, Miguel Ojeda wrote:
> This is the first upgrade to the Rust toolchain since the initial Rust
> merge, from 1.62.0 to 1.68.2 (i.e. the latest).
> 
> Please see the last patch message for a long explanation of the upgrade,
> the policy for future upgrades and some indications on how to easily
> review this.
> 
> The series is based on `rust-next`.
> 

Works on my machine ;-)

Tested-by: Boqun Feng <boqun.feng@gmail.com>

Regards,
Boqun

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
