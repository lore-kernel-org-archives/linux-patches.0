Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEBF2FA5B
	for <patches@lists.linux.dev>; Thu, 20 Jul 2023 18:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DD8C433D9
	for <patches@lists.linux.dev>; Thu, 20 Jul 2023 18:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689878106;
	bh=81m5ZIcvfNL0FEFJ3Nuqam7BZthequgHa1BosBTrhVw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eR20BcHuZY0XWxQd8OtfDbxHXKUyGrqY6D71W9u8tdWPnfELSbHVV1tBRaP9lmxDg
	 tiMLZnjMzSW4HatYlHq00xWkjjIi73SBzYbDiDfowPta/b1gLCTzwbAJ3u+wrD+ZlG
	 Riuzp/GE5I3Bejkjezf/ewhZgeugbFtAT97csbHzTUTEFuHdRzCdutM5oUYK2IdTPH
	 4tDocR27uLB7HJjf7h1N1XMsTDpmH9d/DosiRegxbZdcndZnVQfMX32uAu6jSMInkt
	 lzuf3gvPWO8EnAdnWODZdOy9UK9ERf23QSDC8KbK54VPBqtojTS9xeMFOAJRK3wNd7
	 WC8KATBqWYxog==
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3a38953c928so802557b6e.1
        for <patches@lists.linux.dev>; Thu, 20 Jul 2023 11:35:06 -0700 (PDT)
X-Gm-Message-State: ABy/qLZ9IJIkhUVlko5EavZP69FV1tI+s5ELvbf0Bp9gmF3H03tMJ87N
	SB/nbwQVUS5AEX3nbYzyHfDkfV2cPZmhOyxlMKI=
X-Google-Smtp-Source: APBJJlHKVWn9kDYcjOUOHIW70le7sgGdHBkr9p1Ep42APR+8uWupNFlwMZpme2w+wFD7onPJrRcdfhAUjJJ/+Q0LkTw=
X-Received: by 2002:a05:6808:19a9:b0:3a3:baf8:5b8a with SMTP id
 bj41-20020a05680819a900b003a3baf85b8amr450324oib.13.1689878106023; Thu, 20
 Jul 2023 11:35:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718055235.1050223-1-ojeda@kernel.org> <CAK7LNAQ-hjW_19fjA+E-bQCrXcVPdN4-GvzAnEnYzna5KRVXew@mail.gmail.com>
 <CANiq72kZjOGvRKoRxtgG=2DhJnMJK9TCQtTmeef_B=nLcLQD6g@mail.gmail.com>
In-Reply-To: <CANiq72kZjOGvRKoRxtgG=2DhJnMJK9TCQtTmeef_B=nLcLQD6g@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Fri, 21 Jul 2023 03:34:29 +0900
X-Gmail-Original-Message-ID: <CAK7LNASqumGb0xvSa8n4Heasz9BKxgk4mvzNXsfFhZE1G+Bxbg@mail.gmail.com>
Message-ID: <CAK7LNASqumGb0xvSa8n4Heasz9BKxgk4mvzNXsfFhZE1G+Bxbg@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: avoid creating temporary files
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nicolas Schier <nicolas@fjasle.eu>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, 
	Andreas Hindborg <a.hindborg@samsung.com>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Raphael Nestler <raphael.nestler@gmail.com>, 
	Andrea Righi <andrea.righi@canonical.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 21, 2023 at 2:30=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Thu, Jul 20, 2023 at 7:18=E2=80=AFPM Masahiro Yamada <masahiroy@kernel=
.org> wrote:
> >
> > Applied to linux-kbuild/fixes. Thanks.
> >
> > I believe this is a fix, so I will include it
> > in my next pull request.
>
> Thanks Masahiro! Yeah, it can be considered a fix. By the way, in case yo=
u want:
>
>     Fixes: 2f7ab1267dc9 ("Kbuild: add Rust support")


Maybe, the following was a breakage.


commit 295d8398c67e314d99bb070f38883f83fe94a97a
Author: Masahiro Yamada <masahiroy@kernel.org>
Date:   Sat Jan 7 18:18:15 2023 +0900

    kbuild: specify output names separately for each emission type from rus=
tc




Before that, rust_common_cmd had --out-dir.


BTW, do we also need to fix scripts/Makefile.host
in case the external module Makefile creates host programs?







> I guess it can be also considered a feature (e.g. "supporting more
> setups"), but having the temporaries created where they were was
> unintentional.





--=20
Best Regards
Masahiro Yamada
