Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8F622E402
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 08:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741768322; cv=none; b=rnxTZhPCd/xBTZZ3lcPKPU1hK5QhXSVEjRb0gfeEWjyUa+gv9rxoegPF472v+KiPaLU7CxDEt86PSQbBAIreODWutGPMeVj9ePrTiwHGkT5lkcCCQqYR6j3FM+AijFJ2EW92D8TGiG246HSUilvkATc9VOo7CXVuer5e1zRFMVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741768322; c=relaxed/simple;
	bh=NAfCjVndXO74bYIKcdHQSrpGTDZRZDhr2BEsUjDYZz0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ibg5BoH0cXcPnd4bszdpJmwgG3oMFir/8nkQKPtLKSoh9tY1uJ2PqrdeuX+/2Yp5KsoWRnn9feyE7UilESTqJExlTQ6rp6Xstp7QT0aYb06t5VPzUzWEIa7uMw9bp8u5O8ic+R4AYFS4e2JWyCoKIQcGPKWvzrghFeG8f+dql/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYK7tYfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYK7tYfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB07DC4CEED
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 08:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741768321;
	bh=NAfCjVndXO74bYIKcdHQSrpGTDZRZDhr2BEsUjDYZz0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EYK7tYfCJMGAj1zxP5l6eveZXTD1Nb7Yzpuk4t/ysDfUVMdC1GjmhFHC0xitL0XuP
	 mnX5R0H/1ei89f0v4NmHUgevMd1A+wo36kSE9mCZTvqQAyxqC5uVeXqxHqzJ7UgiTB
	 UsJWddXBUX9bZBBMHM46FJ3HKQXe+FEglz6q5S9hz4v7DwP4nDE/00R0kptTytYtZg
	 BLLIwK9ged5+e/CzmDIiJlzUWPNbrmNTROkTsrVR6jKRGSuIf8wv4nJeVPrn9PzNys
	 uAetAkdMq4Dn0vFkN+6hgtdPRgk/7VRCs50ywnbZ+d1NM78jj3WOZmh9I5wnyTr58z
	 Y3ZZ5H1QRgNUA==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-549b12ad16eso896985e87.0
        for <patches@lists.linux.dev>; Wed, 12 Mar 2025 01:32:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWHMnwgarS1MrYqAiUkZw1LWGAF4h6T3GXQn3+dmdEfCYPgklJihrmOOYWKbuhnelo+L04ARgep@lists.linux.dev
X-Gm-Message-State: AOJu0YyUvM1y2frcPLp9aj7iksSFElu54I81RQaoHp+dktWh2uFFi7Ot
	Fzou5XbYW2MqvmQsnEzPban99Q7l0dSgDPUj4rBdyRz224PJmCr9c/gOMfRcZ7YZgD/3Zuega4l
	LhtLa3iTi0MAtnAJE+ep+aVdI7xM=
X-Google-Smtp-Source: AGHT+IEXmTpL31/Mbak7zh7I6TbcjjJCSBSK4LAjO19RFoqX7tJjPWydfU85u1rPpE5yyyMioyqbNWmGyVpDJ6PolyE=
X-Received: by 2002:a05:6512:ad1:b0:547:6733:b5a3 with SMTP id
 2adb3069b0e04-54990e6763fmr7539659e87.28.1741768319963; Wed, 12 Mar 2025
 01:31:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250213142440.609878115@linuxfoundation.org> <20250213142444.044525855@linuxfoundation.org>
 <c4a1af46f7edcdf20274e384ec3b48781a350aaa.camel@infradead.org>
 <2025031203-scoring-overpass-0e1a@gregkh> <CAMj1kXH6oWVkUeU6+JYCuarzc5+AQxfyBzehfmLFRdKXg86qaA@mail.gmail.com>
 <2025031218-cardboard-pushcart-4211@gregkh>
In-Reply-To: <2025031218-cardboard-pushcart-4211@gregkh>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 12 Mar 2025 09:31:47 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG6HRbQG2XJk=-TOZpDsKMAeVZ0=JO=8KLZ0-YFu2v_tw@mail.gmail.com>
X-Gm-Features: AQ5f1Jr4H9d0AToE_7GA6b0fxOMjqq3oCfqiuQflzK7I5f2XSshazIBGeBOpBI8
Message-ID: <CAMj1kXG6HRbQG2XJk=-TOZpDsKMAeVZ0=JO=8KLZ0-YFu2v_tw@mail.gmail.com>
Subject: Re: [EXTERNAL] [PATCH 6.13 089/443] x86/kexec: Allocate PGD for
 x86_64 transition page tables separately
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	Ingo Molnar <mingo@kernel.org>, Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Dave Young <dyoung@redhat.com>, Eric Biederman <ebiederm@xmission.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 12 Mar 2025 at 09:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Mar 12, 2025 at 08:54:52AM +0100, Ard Biesheuvel wrote:
> > On Wed, 12 Mar 2025 at 08:47, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Mar 11, 2025 at 04:45:26PM +0100, David Woodhouse wrote:
> > > > On Thu, 2025-02-13 at 15:24 +0100, Greg Kroah-Hartman wrote:
> > > > > 6.13-stable review patch.  If anyone has any objections, please let me know.
> > > > >
> > > > > ------------------
> > > > >
> > > > > From: David Woodhouse <dwmw@amazon.co.uk>
> > > > >
> > > > > [ Upstream commit 4b5bc2ec9a239bce261ffeafdd63571134102323 ]
> > > > >
> > > > > Now that the following fix:
> > > > >
> > > > >   d0ceea662d45 ("x86/mm: Add _PAGE_NOPTISHADOW bit to avoid updating userspace page tables")
> > > > >
> > > > > stops kernel_ident_mapping_init() from scribbling over the end of a
> > > > > 4KiB PGD by assuming the following 4KiB will be a userspace PGD,
> > > > > there's no good reason for the kexec PGD to be part of a single
> > > > > 8KiB allocation with the control_code_page.
> > > > >
> > > > > ( It's not clear that that was the reason for x86_64 kexec doing it that
> > > > >   way in the first place either; there were no comments to that effect and
> > > > >   it seems to have been the case even before PTI came along. It looks like
> > > > >   it was just a happy accident which prevented memory corruption on kexec. )
> > > > >
> > > > > Either way, it definitely isn't needed now. Just allocate the PGD
> > > > > separately on x86_64, like i386 already does.
> > > >
> > > > No objection (which is just as well given how late I am in replying)
> > > > but I'm just not sure *why*. This doesn't fix a real bug; it's just a
> > > > cleanup.
> > > >
> > > > Does this mean I should have written my original commit message better,
> > > > to make it clearer that this *isn't* a bugfix?
> > >
> > > Yes, that's why it was picked up.
> > >
> >
> > The patch has no fixes: tag and no cc:stable. The burden shouldn't be
> > on the patch author to sprinkle enough of the right keywords over the
> > commit log to convince the bot that this is not a suitable stable
> > candidate, just because it happens to apply without conflicts.
>
> The burden is not there to do that, this came in from the AUTOSEL stuff.

Yeah, that is what I figured. Can we *please* stop doing stupid stuff
like that for arch code, especially arch/x86, which is well looked
after? (In my personal opinion, we should not be using AUTOSEL at all,
but that seems to be a lost battle)

Especially for this patch in particular, which touches the kexec code,
which is easy to break and difficult to fix. Whether the patch applies
without breaking the build is entirely irrelevant (and even that seems
a high bar for stable trees these days). Nobody should be touching any
of that code without actually testing whether or not kexec still
works.

> It was sent to everyone on Jan 26:
>         https://lore.kernel.org/r/20250126150720.961959-3-sashal@kernel.org
> so there was 1 1/2 weeks chance to say something before Sasha committed
> it to the stable queue.  Then it was sent out again here in the -rc
> releases for review, for anyone to object to.
>

There should not be a need for people to object to something that no
actual person ever suggested in the first place.

The only responsible way to use AUTOSEL is to make it opt-in rather
than opt-out. And I object to the idea that it is ok for someone like
Sasha to run a bot that generates lots of emails to lots of people,
and put the burden on everyone else to spend actual time and mental
effort to go over all those patches and decide whether or not they
might the stable candidates, especially without any due diligence
whatsoever regarding whether the resulting kernel still boots and runs
correctly on a system that actually exercises the updated code.
