Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123757E
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 22:40:52 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-d62b9bd5b03so4710566276.1
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 15:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692052852; x=1692657652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ST9EDbMOZFXnqi0vd0YF7UvQtOruYHigj9crRoWalvM=;
        b=D7mNCMah/yau6g6kumYNQvMPHpBreLI/ewr1wb8zCKLZASymha+E57jdh0RvNUFNhn
         jCVbDnpGmsO72u42u4H50tSbbuEprScRweO+JhyWz25t9l5lY2uVbj8vGjJCYS6fLClq
         UdWT6ShQfn1DDmkbjfQCqE90OEczjdNvjufEk7KwoMOjqZGp055QnUQbgL3ofEqh3re+
         a6IFwge0eZN3JM3wxKPh2M59Crnio9UM21RmQu85xegsj9wX6v5jdv9Ew8niPypYs0BN
         MIA9a16gxYEBRM4RUTFbt52sj+jImGKpE33SM7zYWQwNhyTNVWoi8eKk72VQR/+At7ll
         6lPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692052852; x=1692657652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ST9EDbMOZFXnqi0vd0YF7UvQtOruYHigj9crRoWalvM=;
        b=gkn4wxrYCTDkdjmIW77oLMYjogCUaVXAMXOyc+BRdcpGqIU85iOT6ABx7sfNdMnxgm
         14hratqe8qOybWIZT+2cM9xNLzzao85Ft7X8XpD9smbfTqaVmM2CwId1WbCj92/b9CnQ
         xBmsbtg3bYKhsyA/1W+7lA12Dr0h7ukgl7gyeEDf/Ckk5If7DJCbqJJ0UVH73jaZ8xUH
         P0fAv04ozWp9HXp9jz21KoGuZ4a3+/XSALMD/Ca7flrdkrMGplNQdSRApvcPGFjiNE4j
         W1Z36i60hYdHRYsnO9PGCJXxuuPfN80YS4eNXPTzHB8WGmOALaEbMQemKOS9p6+FPjJ6
         /G3A==
X-Gm-Message-State: AOJu0Yzw4jQKtqsh9Xq8R/WmrQSJE4R0wPO42g4qOK3LZxmgJS+IZYRA
	RSPgxUmGah3FUoP8S/BVPbN/Hk/RQ9RXvvBJQuo=
X-Google-Smtp-Source: AGHT+IFBu2vNjExAtBSX0HHSL9CHjFV7NRbjoamH5RTWuOApwfEkFSQnkFsv7Ky9xYSdSsFW0Da05PSwTr9sCVQugVs=
X-Received: by 2002:a5b:24e:0:b0:d0a:353b:b939 with SMTP id
 g14-20020a5b024e000000b00d0a353bb939mr11876763ybp.52.1692052851891; Mon, 14
 Aug 2023 15:40:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230729220317.416771-1-ojeda@kernel.org>
In-Reply-To: <20230729220317.416771-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 15 Aug 2023 00:40:40 +0200
Message-ID: <CANiq72mrzALO3J2VvDntscXwt7Z9KzT4+S8sc_HGc8u8izjyLw@mail.gmail.com>
Subject: Re: [PATCH 1/2] rust: upgrade to Rust 1.71.0
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <a.hindborg@samsung.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 30, 2023 at 12:04=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> This is the second upgrade to the Rust toolchain, from 1.68.2 to 1.71.0
> (i.e. the latest).
>
> See the upgrade policy [1] and the comments on the first upgrade in
> commit 3ed03f4da06e ("rust: upgrade to Rust 1.68.2").
>
> # Unstable features
>
> No unstable features (that we use) were stabilized.
>
> Therefore, the only unstable feature allowed to be used outside
> the `kernel` crate is still `new_uninit`, though other code to be
> upstreamed may increase the list.
>
> Please see [2] for details.
>
> # Required changes
>
> For the upgrade, this patch requires the following changes:
>
>   - Removal of the `__rust_*` allocator functions, together with
>     the addition of the `__rust_no_alloc_shim_is_unstable` static.
>     See [3] for details.
>
>   - Some more compiler builtins added due to `<f{32,64}>::midpoint()`
>     that got added in Rust 1.71 [4].
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
> Link: https://rust-for-linux.com/rust-version-policy [1]
> Link: https://github.com/Rust-for-Linux/linux/issues/2 [2]
> Link: https://github.com/rust-lang/rust/pull/86844 [3]
> Link: https://github.com/rust-lang/rust/pull/92048 [4]
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to `rust-next` -- thanks everyone!

As mentioned earlier, I have moved to 1.71.1 instead that got released
meanwhile, since it does not require any changes w.r.t. this one
except the obvious ones and it is likely the one that people would
like to use/have (so less warnings).

Cheers,
Miguel
