Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022F55385
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 05:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780BDC433CA
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 05:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1690261286;
	bh=+FyEzIHHHu86QHrIoXwjeeWi+fV/oC+M1YZ91MsjQXQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BnI66cA59lweu/0a+Q3u7Ol/c21g7OcL6K6YkWORXYvQrvrj4qh94ARo/HvjORaMe
	 qTvOs1yXe/Pdpia5RAMtcbWVHN+tOdW39vwGAp775rngcIf+JpNfIN0/VpOUHyon2O
	 CMzMrsFzfNc7Tpmsab8Sy2MM5ufE3IOjmHSUBUcCO/Bq97fwVFpkqFpYx+DDEuVZ1P
	 2ac4U8pBgan/zJ/OGRzjsI3dlcgGMSPPhR++d4+CAb/GAqMxFcwZG3numGUbjCaQUq
	 +sUwSJqOpwNCnmIrYRgRoaRfAdc+cEAKSnm0EMb6kknpf08EpNdbEsGW/QKOZzSX7h
	 kkuLgyreoWyuw==
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-56368c40e8eso3164834eaf.0
        for <patches@lists.linux.dev>; Mon, 24 Jul 2023 22:01:26 -0700 (PDT)
X-Gm-Message-State: ABy/qLYnKZnpFQo/4wXIPM+uzxQpwdyzU9tuABMK0ctYHIf1DEdEb5c6
	gp63Td9HXsOhb1AL0jSdscxV0w38WjZh9qWkuCw=
X-Google-Smtp-Source: APBJJlHNMewixjluZirFDxPtZ/xyBhT/i9rV3VOmKVpLXySF76A/9PjhZyiOUBiUZa72yxWxXdde6eDqTDRyg9svjDM=
X-Received: by 2002:a4a:91d0:0:b0:566:fa3f:82af with SMTP id
 e16-20020a4a91d0000000b00566fa3f82afmr9199256ooh.5.1690261285620; Mon, 24 Jul
 2023 22:01:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230723142128.194339-1-ojeda@kernel.org>
In-Reply-To: <20230723142128.194339-1-ojeda@kernel.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Tue, 25 Jul 2023 14:00:49 +0900
X-Gmail-Original-Message-ID: <CAK7LNAR_CaZ8fJ+fOm9-X83MOtwDa9aavZ5JM6DFOAA00GgULw@mail.gmail.com>
Message-ID: <CAK7LNAR_CaZ8fJ+fOm9-X83MOtwDa9aavZ5JM6DFOAA00GgULw@mail.gmail.com>
Subject: Re: [PATCH v2] kbuild: rust: avoid creating temporary files
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <a.hindborg@samsung.com>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Raphael Nestler <raphael.nestler@gmail.com>, 
	Andrea Righi <andrea.righi@canonical.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 23, 2023 at 11:21=E2=80=AFPM Miguel Ojeda <ojeda@kernel.org> wr=
ote:
>
> `rustc` outputs by default the temporary files (i.e. the ones saved
> by `-Csave-temps`, such as `*.rcgu*` files) in the current working
> directory when `-o` and `--out-dir` are not given (even if
> `--emit=3Dx=3Dpath` is given, i.e. it does not use those for temporaries)=
.
>
> Since out-of-tree modules are compiled from the `linux` tree,
> `rustc` then tries to create them there, which may not be accessible.
>
> Thus pass `--out-dir` explicitly, even if it is just for the temporary
> files.
>
> Similarly, do so for Rust host programs too.
>
> Reported-by: Raphael Nestler <raphael.nestler@gmail.com>
> Closes: https://github.com/Rust-for-Linux/linux/issues/1015
> Reported-by: Andrea Righi <andrea.righi@canonical.com>
> Tested-by: Raphael Nestler <raphael.nestler@gmail.com> # non-hostprogs
> Tested-by: Andrea Righi <andrea.righi@canonical.com> # non-hostprogs
> Fixes: 295d8398c67e ("kbuild: specify output names separately for each em=
ission type from rustc")
> Cc: stable@vger.kernel.org
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
> v2:
>   - Add fix for host programs too (Masahiro).


This is now available in the mainline.

df01b7cfcef08bf3fdcac2909d0e1910781d6bfd





--=20
Best Regards
Masahiro Yamada
