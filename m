Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C977B53E17
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 23:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706051955; cv=none; b=UWqmOUK/LPAJLVoHe1muOR/tXAF+ns7LXQaCk2qnPjk3akqd+4L5+afXkWCibVrDBjjq68upAnbnlWdodjDoJUo2+h30K+AvuUz2tEI9T4P/Nhop7DuVwirb16YmWwCehmoqpf7IaiZ/2/E72lweDfABOQ9ePzUL3pk6ki9xXBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706051955; c=relaxed/simple;
	bh=+VwJoDdAcHjpAijgpKlaSZGsjG0OlXTFvr8hMYSsBek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cJgnf+jnYpEfuL4ttJ7z+Zzu0YS8qy5otEbxrGMJnNbHIXZeF0HxVpCWH0ksQ8vNWDmPTtMGbs08M7GAKqy15FicDQXGyIqaww+QEXj5FtXNX67d9RQ146ez3U9ygrinNaesEl5I4paJYXM+twmu3sshtyjl4KJ05ZSbgSUltiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VTYCodyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VTYCodyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6395CC43394
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 23:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706051955;
	bh=+VwJoDdAcHjpAijgpKlaSZGsjG0OlXTFvr8hMYSsBek=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VTYCodyjpt4SYEmM1CggnbIWfrsd9NZ88D6tm4/aNZDZypOgth56HudHrrlP61p81
	 JS73HSbDZNP393PrzuKeZc+JPaGc+rdnPjJVU25TLCZ3S5o0o0wFeLmDYLnEUKCQH1
	 d3U+2r9zNZQN7KqLTIFlMgY+shMvpQai/2ZcLcw/K+gtOR73q5oWe1cQol9O8U240R
	 TvnabAI4bG4TCvqUM+fTFBmm+EeGHIeveUZ3zIrFBAICxH0Xs5iQphKZWhRPwXGn0W
	 q3LENysFFGZrqBgsNLAXFv/LJq3+ggNmQ1Qav5pvqi9bDybMfckik8MC4u5DJRrnI0
	 0SDSAm4PaHv5g==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2cd0f4797aaso49051171fa.0
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 15:19:15 -0800 (PST)
X-Gm-Message-State: AOJu0Yw3ZQKCa7lLBxZ/8nUfe5Mp1ojnYjiaRDglia0xOWfSIPfDBI0F
	5WM5QIXYeDOjbOBvZBl2sdAJyev4gZXYdP/sL9Ym4sPsLXxGb9TFM1fcbyE4eGZngqxkMbUvCpe
	zjqmKtHaql43pNdKIDdwVT6ako4w=
X-Google-Smtp-Source: AGHT+IG7Y+xEpGuuYxWnvyFWDnj9KUI41aSWtvsl9lRqQ53L7+ZSW5BGSN8+/ZgfT4wGng0GQFPZM0bpESLEKUCPaiY=
X-Received: by 2002:a05:6512:313a:b0:50e:27a9:167e with SMTP id
 p26-20020a056512313a00b0050e27a9167emr3156188lfd.59.1706051953578; Tue, 23
 Jan 2024 15:19:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <2024012320-coaster-ensnare-237c@gregkh> <20240123213515.7535-1-dan@danm.net>
 <2024012316-phonebook-shrewdly-31f2@gregkh>
In-Reply-To: <2024012316-phonebook-shrewdly-31f2@gregkh>
From: Song Liu <song@kernel.org>
Date: Tue, 23 Jan 2024 15:19:02 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4HETpS_Je62-Ag8o5-JFDwDPnr0_tquGmOcCxo5F9FkQ@mail.gmail.com>
Message-ID: <CAPhsuW4HETpS_Je62-Ag8o5-JFDwDPnr0_tquGmOcCxo5F9FkQ@mail.gmail.com>
Subject: Re: [PATCH 6.7 438/641] md: bypass block throttle for superblock update
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Dan Moulding <dan@danm.net>, junxiao.bi@oracle.com, logang@deltatee.com, 
	patches@lists.linux.dev, stable@vger.kernel.org, yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 2:20=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Tue, Jan 23, 2024 at 02:35:15PM -0700, Dan Moulding wrote:
> > > Or is the regression also in Linus's tree and both of these should be
> > > reverted/dropped in order to keep systems ok until the bug is fixed i=
n
> > > Linus's tree?
> >
> > The regression is in Linus' tree and appeared with commit
> > bed9e27baf52. I was operating under the assumption that the two
> > commits (bed9e27baf52 and d6e035aad6c0) are intended to exist as a
> > pair that should go together (the commit messages led me to believe
> > so).
> >
> > The commit that caused the regression has already appeared in the
> > 6.7.1 release (but without the second commit). Since I thought the two
> > commits are a pair and the regression needs to be reverted, that the
> > second commit should not be backported for 6.7.2 until the issue is
> > properly resolved in Linus' tree.
> >
> > But it sounds like Song Liu is saying that the second commit
> > (d6e035aad6c0) should actually be fine to accept on its own even
> > though the other one needs to be reverted, and is not really dependent
> > on the one that caused the regression [1]. So maybe it's fine to pick
> > it up for 6.7.2.
> >
> > I can say that I have tested 6.7.1 plus just commit d6e035aad6c0 and I
> > cannot reproduce the regression with it. But 6.7.1 plus both commits,
> > I can still reproduce the regression. So bed9e27baf52 definitely needs
> > to be reverted to eliminate the regression.
> >
> > I hope that clears things up some.
>
> Nope, not at all :)
>
> For now, I'm going to keep both commits in the stable trees, as that
> matches what is in Linus's tree as this seems to be hard to reproduce
> and I haven't seen any other reports of issues.  Being in sync with what
> is in Linus's tree is almost always good, that way if a fix happens
> there, we can easily backport it to the stable trees too.
>
> So unless the maintainer(s) say otherwise, I'll just let this be.

Thanks Greg!

Yes, let's keep the tree as-is while we look into this issue. I tried to
reproduce the issue from my side, but haven't hit it yet.

Song
