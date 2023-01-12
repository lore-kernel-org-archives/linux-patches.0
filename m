Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05EE62F
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 06:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABD9C433F1
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 06:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673503527;
	bh=fLOxnvGzIYVtypNTSZJWVFXieiaShiwicfrgtP+APLw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DxGESJnt1vELtHFm0oai8xXC8+5GbAPNLfHOpcENPziNKxlK90W2cbOPhbr84Aev0
	 qTfu7HNpN16FV0L4ylKrB83qXSiiOryscfQ9Y5rOihmrxDYzrO5tJq80p63L4z7XBp
	 VbBJEzQ1EWIv1HLqqThEqqq0crwwK1P5ZwhcVCbYAmetfANd+Bli5W2ImvqhXBqIJd
	 loh2Mom0NtPjZJhPVNKTkGHG4a7su/GBzIB9pmX0tCL4hfpriS4cVshRCRGSRCTTXi
	 E/NhJeJRik6T7semqkkT3drliY/pvmzpJxsJ6vXhB/X0wwp9uTZ2DIPGQeWY8mMdMr
	 rAuXGnW41lA0g==
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-12c8312131fso17922727fac.4
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 22:05:27 -0800 (PST)
X-Gm-Message-State: AFqh2kqAWifI31dz/c/mGy+9XVKnidc5i3ddSofoMtUcGSrPUiodBwbA
	JToS8g8CBvBh2qE4l96q+CDSuSpm/V+EwJLCb/8=
X-Google-Smtp-Source: AMrXdXsbKuYyiriVmNmlUn+MZXGsK911wAs1ywABFmVdFJDs0JNt8l3m/yUNdw835VfD238fQTzOyibjPL5yrT+RkDE=
X-Received: by 2002:a05:6870:514c:b0:150:7e4a:2f00 with SMTP id
 z12-20020a056870514c00b001507e4a2f00mr2619143oak.194.1673503526768; Wed, 11
 Jan 2023 22:05:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <CANiq72m_+xJYUxrwFc7vNLkuOb6zC-W-wDzXjbPb8Ursqzwiaw@mail.gmail.com>
In-Reply-To: <CANiq72m_+xJYUxrwFc7vNLkuOb6zC-W-wDzXjbPb8Ursqzwiaw@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Thu, 12 Jan 2023 15:04:50 +0900
X-Gmail-Original-Message-ID: <CAK7LNATmRkSU2n6AaeJenE-18gbUd4ZShFNfKysEjyCo4Q-eAA@mail.gmail.com>
Message-ID: <CAK7LNATmRkSU2n6AaeJenE-18gbUd4ZShFNfKysEjyCo4Q-eAA@mail.gmail.com>
Subject: Re: [PATCH 1/6] docs: rust: add paragraph about finding a suitable `libclang`
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nicolas Schier <nicolas@fjasle.eu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Jan 10, 2023 at 6:06 AM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Mon, Jan 9, 2023 at 9:45 PM Miguel Ojeda <ojeda@kernel.org> wrote:
> >
> > +* Or ``LIBCLANG_PATH`` can be pointed to a ``libclang`` shared library
> > +  or to the directoy containing it.
>
> I just noticed the typo here, sorry: directoy -> directory
>
> Masahiro: if you take them, please feel free to correct it.


Yes, I can take this, but the doc change
is independent of the rest, and will not conflict with
any Kbuild changes.

So, you can apply this one to your tree.





>
> Cheers,
> Miguel



--
Best Regards
Masahiro Yamada
