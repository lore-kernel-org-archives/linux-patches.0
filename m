Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1727781AA7
	for <patches@lists.linux.dev>; Wed, 22 May 2024 10:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716372859; cv=none; b=Xrd34fh2oYYHq4l+8lOuSyIpaqdBqHApLvYz458pb6cZJQPa165Gd/Xfp2RVIMaFJ02v2j4TpmAReUQ4K+ocA8ZSVdMf1V5XTTYF9tKprkHc97pYMjOPpBGMCPsjh0zUBDWiCTanTesVVIGttOtjX7boglu3iml0vjcXj9pS0p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716372859; c=relaxed/simple;
	bh=/eBRmVULM/brvA86jKSO8fNKreehpyNAcfaRDoQlPFo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V4v5tu/S4lDS8bZkl3ZiHfB1iftYxKiekTdpPBo9vDhFEMtnMaeCoMdW4jyx6eL1cCdCOMH+I7X+ZIl3SavgTtPDmmFhQiCX9Lc2sqmch++UX6adCOOQTgXqkp9Zr/Eh0EUS/L1ZfJoo75nFPd7aCdpoKEE4SvZVGC+zmbpGgzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CX2I4Kf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CX2I4Kf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6084C4AF10
	for <patches@lists.linux.dev>; Wed, 22 May 2024 10:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716372858;
	bh=/eBRmVULM/brvA86jKSO8fNKreehpyNAcfaRDoQlPFo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CX2I4Kf4iAvhmBBiSFjec2CuY/1jWgpEojlQPfd7rehC4UNfwfJ4/uFyujKb/qpwW
	 UJBE3hKM4A9D6sQliyUlrDE3NnblH4AZ++vinpIFWDHK67OTBuVl83oIBR+kxEYmBH
	 K/jtdUfcJX3zZLCUYPzmZsLYFppDSmGBkDRfaZ31zJ/ReZiF4snmH17PbueOxZszQT
	 lsP9uHzAxEoaqsFPk6axHAWLWOg1Q5Pu+PlEu+JHtOKt1cRznQe5aJ5sOeWuF3cO4y
	 7eewLF0a5uvW6uA2qn290AJIFCpbDHaPSHaoSDYb9w+eXK3ivvAsnBT4y4rcDInVuV
	 y4boZFFywW7/Q==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52449b7aa2bso3626878e87.3
        for <patches@lists.linux.dev>; Wed, 22 May 2024 03:14:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUgLqKq9rX4U8m24+NguvR6NMZBL7ayroYbh+TVL0MD9vl5kPbiCBMy23EnyrtyLCsQu+sLuHTlqhVjFHO9UqJ/MEDTpGQYwA==
X-Gm-Message-State: AOJu0YxPc6eo5aQFwe7j4PA0Bn5xA9kQq103n48mzr20QDkicczzOEs0
	MQIQZoT3K0lKM6tdT4wzudjTiSVZksGN9mgghM3LbuU2w4YF23M/KhoF6w3I4gOkTbq57N7lwyw
	TKCXl5AFnUXvRP8xtjDfTDjrM9cc=
X-Google-Smtp-Source: AGHT+IESHrVpQIUMDI5MQE6vMqT+X/yuGi7iQfYDNfycFqV2CatwL/tSZgkxd/8on83csX676ZIC0dOoNzJVxkq5jzk=
X-Received: by 2002:a05:6512:604:b0:51e:ff32:16a8 with SMTP id
 2adb3069b0e04-526c0e3eec2mr1096444e87.62.1716372857330; Wed, 22 May 2024
 03:14:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240519211235.589325-1-ojeda@kernel.org> <20240519211235.589325-2-ojeda@kernel.org>
 <CAK7LNATPx2wTEM=KDmGtcH8vVTB4suOhh-CUQKP54F8wtPWDiw@mail.gmail.com> <CANiq72mcdtNie=t=HHhZnjQa7gQiDZin+TYP_7Rgi4kL83H2BA@mail.gmail.com>
In-Reply-To: <CANiq72mcdtNie=t=HHhZnjQa7gQiDZin+TYP_7Rgi4kL83H2BA@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Wed, 22 May 2024 19:13:41 +0900
X-Gmail-Original-Message-ID: <CAK7LNASYYYsiZUaA1StD9kWO0WBC0PBPtfY7u32g94WtOPFZgw@mail.gmail.com>
Message-ID: <CAK7LNASYYYsiZUaA1StD9kWO0WBC0PBPtfY7u32g94WtOPFZgw@mail.gmail.com>
Subject: Re: [PATCH 2/3] kbuild: rust: apply `CONFIG_WERROR` to all Rust targets
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas@fjasle.eu>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <benno.lossin@proton.me>, Andreas Hindborg <a.hindborg@samsung.com>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kbuild@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 21, 2024 at 5:05=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Tue, May 21, 2024 at 6:15=E2=80=AFAM Masahiro Yamada <masahiroy@kernel=
.org> wrote:
> >
> > Rust started to do something different from C.
> >
> > KBUILD_HOSTCFLAGS is not affected by any CONFIG option.
> >
> > The reason is because HOSTCC is needed for building Kconfig.
> > If the flags for HOSTCC is changed by a CONFIG option,
> > it would be a chicken-egg problem.
> > Also, some host programs might be compiled even
> > without .config at all. (e.g. scripts/unifdef)
> >
> > I know Rust will not become a part of the core infrastructure
> > of the build system, but IMHO, host programs should not be
> > affected by any CONFIG option.
> >
> > I do not like this patch.
>
> Thanks Masahiro -- yeah, I can see how it makes sense for C host
> programs, and consistency with those may be best, even if it is not
> used for core infrastructure in the case of Rust.
>
> Do you think it would be OK if we do it only for everything else, i.e.
> no host programs?


What does "everything else" mean exactly?


I just noticed that $(rust_common_flags) is passed
not only to RUSTC but also to RUSTDOC.


It seems to be intentional because it explicitly says
"requires kernel .config".


@echo  '  rustdoc   - Generate Rust documentation'
@echo  '     (requires kernel .config)'


This is different from how other "make htmldocs" etc. work.

Why is the .config required for generating documentation?









> That covers most of the Rust things so far and would
> have helped with the warning I linked above (which is why I would like
> to change this -- one can pass the flag manually, of course, but
> having more targets affected by `CONFIG_WERROR` means more developers
> will have it enabled and thus notice earlier).
>
> (I am also thinking whether it could make sense to eventually
> explicitly mark the C host programs that would be exempt from
> `CONFIG_WERROR` so that we could apply it to everything else -- I
> guess it could be easy to get wrong and/or forget when new ones are
> added.)
>
> Cheers,
> Miguel



--=20
Best Regards
Masahiro Yamada
