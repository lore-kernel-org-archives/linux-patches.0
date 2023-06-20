Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3E21C13
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 05:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5ADEC433C9
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 05:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687238076;
	bh=tSbgfbEMjBLEEAVbj8xv8hBno3G6UMoqv4nf2rzY0Sk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=B/T7whBDgSg6+gTU5UDlslJtGxe8VnLqm06Ps8gQFPYfT64sVfZiJ1GpnXudwQfPU
	 rI4DfVK7WHYQY1WLiPrpfUBK1it7BCjsVv8ATRg9cPUYf6zVU2fKBe993I5O/smvRs
	 cBIfeuvuwTCd/X+axBoQjcjdIzCrCzUeP0Nr1AQ9wpmBMFBVQ0aqFgV5QgUEIEvZrt
	 p7zjZANNd3YdkQiWn/6vTwDKxT1QlEErmqvxFuvUULPbV7QPtY8m9hA8z3zw1Krp3q
	 yaI6+JyL3e7u+kuXD3ZZ6BY2MJNhScsl8HGBrLDbaAVHkxhCfbGA/weaD7rFvE9YBm
	 OfxcC+JS0IMHQ==
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6b2c3ec38f0so2593738a34.1
        for <patches@lists.linux.dev>; Mon, 19 Jun 2023 22:14:36 -0700 (PDT)
X-Gm-Message-State: AC+VfDyfKMcuVesCkE9mGn4L/I+mGCbfEU1N3H2K6G/GUqAml4ZCPcuM
	OSKVYlbxHS8Ty9Z3btW4enD1yNgtn/5wLXG28PI=
X-Google-Smtp-Source: ACHHUZ4TedQEyOyNlDl9ckn5WcHyeii1NIgJKE20on5yzLcd9430oT16nGeQYx8F1v6pTgoENP3b5CfK9ueKxwplFpk=
X-Received: by 2002:a9d:6d86:0:b0:6b5:92e9:98cb with SMTP id
 x6-20020a9d6d86000000b006b592e998cbmr757411otp.29.1687238075964; Mon, 19 Jun
 2023 22:14:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230616001631.463536-1-ojeda@kernel.org>
In-Reply-To: <20230616001631.463536-1-ojeda@kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Tue, 20 Jun 2023 14:13:59 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQnFe8eTGcbh9zxy0eF4HiMbyFzU1vXQ92exFecdAFmxA@mail.gmail.com>
Message-ID: <CAK7LNAQnFe8eTGcbh9zxy0eF4HiMbyFzU1vXQ92exFecdAFmxA@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] `scripts/rust_is_available.sh` improvements
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <nmi@metaspace.dk>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16, 2023 at 9:16=E2=80=AFAM Miguel Ojeda <ojeda@kernel.org> wro=
te:
>
> This is the patch series to improve `scripts/rust_is_available.sh`.
>
> The major addition in v2 is the test suite in the last commit. I added
> it because I wanted to have a proper way to test any further changes to
> it (such as the suggested `set --` idea to avoid forking by Masahiro),
> and so that adding new checks was easier to justify too (i.e. vs. the
> added complexity).
>
> In addition, there are also a few new checks in the script, to cover for
> even some more cases, which hopefully make problematic setups easier to
> identify and solve by users building the kernel. For instance, running
> the script externally gives:
>
>     $ scripts/rust_is_available.sh
>     ***
>     *** Environment variable 'RUSTC' is not set.
>     ***
>     *** This script is intended to be called from Kbuild.
>     *** Please use the 'rustavailable' target to call it instead.
>     *** Otherwise, the results may not be meaningful.
>     ***
>     *** Please see Documentation/rust/quick-start.rst for details
>     *** on how to set up the Rust support.
>     ***
>
> I also changed it to avoid setting `-e` as Masahiro suggested.
> Similarly, I now check for `$RUSTC`, `$BINDGEN` and `$CC`, instead of
> `$MAKEFLAGS`, as he also suggested (but I gave it their own error
> message rather than use the `${CC?: is not set}` approach. This goes in
> line with the reasons outlined above, i.e. trying to give users a clear
> error of what step exactly failed).
>
> In the test suite I included previously problematic compiler version
> strings we got reports for. The test suite covers all current branches
> in the script, and we should keep it that way in the future.
>
> The patch series also include Masahiro's patch to remove the `-v`
> option, as well as Russell's patch for supporting multiple arguments
> in `$CC`.
>
> All in all, this should solve all the issues we got so far (unless I
> have missed something) and improve things further with the new checks
> plus the test suite to hopefully have an easier time in the future.
>
> Testers for this one are appreciated, especially if you have uncommon or
> custom setups for building the kernel.
>
> This could go through either the Kbuild or the Rust tree.


Please feel free to apply it to the Rust tree.
Perhaps I may add minor comments, but it is up to you.





Best Regards
Masahiro Yamada
