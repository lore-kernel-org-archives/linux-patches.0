Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27787129EF3
	for <patches@lists.linux.dev>; Mon, 18 Dec 2023 13:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a9L11gZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D74BC433D9
	for <patches@lists.linux.dev>; Mon, 18 Dec 2023 13:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702906956;
	bh=lf87cY+sfrIGjZkc0yfpM2ITygYwk1dUMUryBA2JhoY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=a9L11gZ8UROh/ThiFrLMjNPiDbo17oq6krV4C7pe/JzEFp7XMBBKu8V5FSmeg2zRU
	 ZhXgnYteQbbOwn/wHcsBj7EXKtUMtxrRMdqJYLX8cF4CcduKBh4xLjfXapI5lffJmI
	 U0/rSSvID1n4IFT4LOrItWBNm+mKenZ3pdZ2jAVwM7dsnnfC3dbnoS7Znd9pNu4ueE
	 GHAplv3p2RSphWZH9nSjFN0C+Ge2+K8qj1FFAG8QGDdUnbnUqilsVr1+uZ/sPhYfLI
	 wZ4jg5rjikeD5hQADzDYT2Trs0Rv8WYE/wptKEyxcaf6+3Yk9rjRVZk84l0BGSEyYF
	 lC40sp6lJ4/Rw==
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6da5d2c3ec7so1607560a34.2
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 05:42:36 -0800 (PST)
X-Gm-Message-State: AOJu0Yy/b3x2Naw/wubs/rhMuxRXIuNLHRTr/rnF6CGnI+h3ukf4HTnM
	WyGw0GA7oVoGegZLYrH9asR6CI5gRIHqj5tZQx0=
X-Google-Smtp-Source: AGHT+IEax6a8dfMz1OgvnNbIRX/bddzrjFMnk7yxuDXueEFsyquXiEKQlFi+GF6HR8EeIpvU51fp3FHRMi9zqNMBNIE=
X-Received: by 2002:a05:6870:ac0f:b0:203:c9b1:fe8a with SMTP id
 kw15-20020a056870ac0f00b00203c9b1fe8amr1625883oab.12.1702906955958; Mon, 18
 Dec 2023 05:42:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231214222253.116734-1-ojeda@kernel.org> <CABVgOS=LXUzRD-c63sxn0FMfGWvxCPP1t_8nY5Xgk30Y9qMAcw@mail.gmail.com>
 <CANiq72kw326HyrDM0v0mFNu5jfb=eL1a+k-idr-5Vbc6_gmY2A@mail.gmail.com>
 <CAK7LNAQ7A79fMg3Teh7H+NRwnztrNU73s5C_fybUVH+vEX0YeQ@mail.gmail.com> <CANiq72mjSVqLNrdhK6H+X2=9ydwzX3RM2jBf1AwRFngSJ2kQ9Q@mail.gmail.com>
In-Reply-To: <CANiq72mjSVqLNrdhK6H+X2=9ydwzX3RM2jBf1AwRFngSJ2kQ9Q@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Mon, 18 Dec 2023 22:41:59 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQT2y4qGgvr5+GbougTMaq2ZQB=P6aLppB0PudyegpXaw@mail.gmail.com>
Message-ID: <CAK7LNAQT2y4qGgvr5+GbougTMaq2ZQB=P6aLppB0PudyegpXaw@mail.gmail.com>
Subject: Re: [PATCH] kbuild: rust: add `rustupoverride` target
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: David Gow <davidgow@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 18, 2023 at 10:33=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Mon, Dec 18, 2023 at 1:10=E2=80=AFPM Masahiro Yamada <masahiroy@kernel=
.org> wrote:
> >
> > In principle, Kbuild does not require internet connection,
> > or proactively change the system setting.
>
> Yeah, that was what I thought. I agree it can be surprising to have
> Make targets that modify environment/system-level bits (i.e. affecting
> things outside the build).
>
> > Rather, I will manually do this one time for the parent directory:
>
> That can work for many people, yeah. Though I imagine some people may
> want to keep builds (and sources) of different kernel versions in the
> same parent folder (or even other projects). But one can use nested
> overrides too.
>
> > If you want to provide a way for automated settings,
> > you can do it in a script you maintain.
>
> Sounds good. In that case, we can send to the list your patch from the
> `rust` branch if that is OK with you (i.e. I understand you would
> prefer to avoid not just `rustsetup` but also `rustupoverride`).
>
> Thanks Masahiro!
>
> Cheers,
> Miguel


Viresh's v2 was written without relying on this patch.

If that one is better described, that is OK too.





--
Best Regards
Masahiro Yamada
