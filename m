Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178DCA20
	for <patches@lists.linux.dev>; Sun, 15 Jan 2023 02:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEC9C433D2
	for <patches@lists.linux.dev>; Sun, 15 Jan 2023 02:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673750932;
	bh=kgaY6jbQpeo2Rmou/wW3RuGDXgok5CczcJfarE0vI8Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sBL5XlTf28rpF3PCr8Re4z/72+iDc+0PDzJNRTWB1UTOHsChRGH+zBWkn0tqJWCfd
	 8K+McSv0Us+qyBMhCT4GtYopGHU98GMEeFAtWuBTwuo/POF8lESXYSef8jcwyWGbZC
	 DxTft7d1pbfC8wTvxJG8VbqFEPUIKwD5QEhQ2lIrIFIKSOhdOFzqdIaQgG0v1X8ZK0
	 ec3iNFqyMP3cgOueOfSaeUyD6Ov4gPh17cv0x4jon4byxvNBrY4lrCAbRzQeQ+zXYJ
	 6TFoO0Bu39U4KoFaGniq2loG7g/3+ZPU9a0me3oPEc1i2HE9g26AM/UKYjWOG6mM8f
	 2V+ucnScA+MKA==
Received: by mail-oi1-f179.google.com with SMTP id r205so20670453oib.9
        for <patches@lists.linux.dev>; Sat, 14 Jan 2023 18:48:52 -0800 (PST)
X-Gm-Message-State: AFqh2kqAExScjTPRJeW3aQDDXYWi2CagHpuQrMjkaDa6ULBTMiZzcHRL
	ndgTxkGeUQJxc6qjEZXQy7oaBUs+6rvy+p3XrDg=
X-Google-Smtp-Source: AMrXdXsm9gUnwpvlhutyPpDTsOvXTiSoz/kxV5XIxQNp8ZH6wuffaVTW/E19Fs510l1dx+TMHxotrQpBFbYtyjei9Rg=
X-Received: by 2002:aca:3755:0:b0:35e:7c55:b015 with SMTP id
 e82-20020aca3755000000b0035e7c55b015mr5439109oia.287.1673750931973; Sat, 14
 Jan 2023 18:48:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <20230109204520.539080-6-ojeda@kernel.org>
 <CAK7LNAQYk6s11MASRHW6oxtkqF00EJVqhHOP=5rynWt-QDUsXw@mail.gmail.com> <CANiq72kyUr9PGYqHTsNzYn0_cyuYA0vAxHLC08ivxKo5XvOESg@mail.gmail.com>
In-Reply-To: <CANiq72kyUr9PGYqHTsNzYn0_cyuYA0vAxHLC08ivxKo5XvOESg@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sun, 15 Jan 2023 11:48:15 +0900
X-Gmail-Original-Message-ID: <CAK7LNASawny3wSTvjB8-CZJ2Mw8UnB0C4k5-X8yC8TyrmsM8RQ@mail.gmail.com>
Message-ID: <CAK7LNASawny3wSTvjB8-CZJ2Mw8UnB0C4k5-X8yC8TyrmsM8RQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] kbuild: rust_is_available: normalize version matching
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, Jan 14, 2023 at 8:15 AM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Thu, Jan 12, 2023 at 7:23 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> >
> > Maybe, your purpose is to use sed consistently, but
> > perhaps you can avoid forking sed if you know the
> > format of the first line.
>
> The most unknown format would be the one of the libclang check, where
> there may be other lines before the one we are interested in. However,
> the pattern expansion would still match newlines, right?
>
> > BTW, what is missing here is, you do not check if
> > ${RUSTC} is really rustc.
> >
> > I can fool this script to print
> > "arithmetic expression: expecting primary: "100000 *  + 100 *  + "
>
> We can test if nothing was printed by `sed` for that (or do it with
> shell builtins).
>
> Having said that, I would say fooling the script on purpose is an more
> of an oddity compared to the case `MAKEFLAGS` attempts to cover
> (please see my reply on the other patch). So if we cover this, then I
> would say we should really cover the other one.



get_canonical_version() in scripts/as-version.sh has
a little more trick to avoid
"arithmetic expression: expecting primary: "100000 *  + 100 *  + "
but it is up to you.




> Cheers,
> Miguel



-- 
Best Regards
Masahiro Yamada
