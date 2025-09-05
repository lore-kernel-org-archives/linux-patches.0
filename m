Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D55F3002C4
	for <patches@lists.linux.dev>; Fri,  5 Sep 2025 09:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757063866; cv=none; b=a5QzebM9EbDE19cZ5Omy2ipaA6ZdB9upTzbtPXtXSxGoXHbiJAGTY+sVEXC57WU567wDy9PwIcMl/b1A7PQIJzQVRyQzFeUbpaRvXfbIDask68pRAx4/2yMwWwhOP8V49aognCVfW98c0iyG6TqUbCbkrkQm4P+3c1tNo8MIdpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757063866; c=relaxed/simple;
	bh=psuRtuDnLxsx2zTSnT8LTOpiP2Bg5UgPAZ21S5KZ9ME=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RhhHbmb3hIROd5wIBlTun6FG4TEH/ilCAp5Ka0lT/KQPOqcDDeq8aIc013s/Ax5T+qkSj5gwesVq7CnW9ny3es0HA56VUDkQpBr1ZKXreTwuE/5up/sY1Y//eO3RSPPigWtuV2HlQ9ctenfWang05onYr+nwZeOMzBdbse/lCaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EbssaFFq; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EbssaFFq"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-61ded2712f4so3320971a12.1
        for <patches@lists.linux.dev>; Fri, 05 Sep 2025 02:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757063862; x=1757668662; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpYKGDOGRX34/ZVwlfuxW6/l5mMjJNcLqlSvourbEHE=;
        b=EbssaFFqJbqJlgC4OWwGACOu4UD7szewJjErkOM3hgCgpGQYi/5Vhu7ppdee5za2Q5
         tJAGmuyOpUumbLikAT3VNbu1NJy9/Xw1qHzSpgXfWnaRswrw6dh1BGz9LZrs+eDonGYi
         HdIda0dJ1j9LYegF25CV3zwV/7qQLmVJtJY8r03mSYFKsKG01uvb/ec45brKBFtYpJYK
         29/XO89DuYXxv1Mi+fEcB7elT1+4HZ9C6cOnBEPcle20aQFiwzqdcqA6U+XOBqUJNLZS
         wPF+3Rvsezx9qCcJv20TB7Ng2J8NFAhgMes2MuLGgVw4iu85O6RNWHuPzwg2ztUXFSqF
         zAXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063862; x=1757668662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MpYKGDOGRX34/ZVwlfuxW6/l5mMjJNcLqlSvourbEHE=;
        b=sDqSM7VYELK1wITwk1UXISccZR02ejcR8XPkvREtC3haSOLQalVlD65LMISgTeiLIb
         Qe98fLOH0n9g7DWLcuI+55wXCeNgpb7O8YL1bdyMN35VWJkbgb5XNERgeziecTWmaTeJ
         tYXi6oD9kYgyUg+Jtc7WSSpu1qMIOluaYDVxVQjfi2GNpi+3w4mqYnNyf/6L3b7LpR3C
         dftsc+Xj/Ib/AMlH4rr8pQnEKwLDea9pACdtCiNblTjBymEugDtViuYLVKH9TG2SCWD3
         zsbF5fT8nrkuPjO59SRO2NBL7RgK5fPkc60vBBBY0XGv57y5L4vCqy/e3cyuYCGTLcul
         O91w==
X-Forwarded-Encrypted: i=1; AJvYcCXAL8N2Ynk2fcbV3slabHbAIKfXIMgeHpp+zPS9r+uDq2fezhulNsjG6+zvz08w/8UGCmbmp2PR@lists.linux.dev
X-Gm-Message-State: AOJu0YxMu3Fh6sku98bO3RVcslTZOkaIazfJk/q0OfsSIM3CuQMZ7hqP
	gB73XTZDxkGujlQBwnjBWAN4nPeZN+Ttz6+v7U7jF9OKGQjbVA3/ECuZwVKh5tclIvuSIi+0iH7
	f5wvP0N0368d3c+Gz+olffT0x2+PRkMA=
X-Gm-Gg: ASbGncv4cBZBE6zlU93FUd34e60Vxt98tdqFV52bcWVJr4MAMjSDc+QSxjriUNH8dID
	1u55vK9TW9owdbJjSXY/OMwug+6wfjEFPRX7eqW3arPNhvsgDGIyUZ95Gq24zus+PTbNQ6CejWh
	3EAsiRhsLTcsnDQ1oGHLw8HKqVT1I6k/NvtiLk2iH+KWczaSBnChhZ71PfuIURGh1kkYNxQVpwP
	OS0v9M=
X-Google-Smtp-Source: AGHT+IES5bHXVwwaG+UT3PZF9koe60lkGexHaaugyBfBkOCbmGhuG2IpfWaupdbGphiJ7C5ES7/SXREbKVdmWgFyNyY=
X-Received: by 2002:a05:6402:2693:b0:61c:9cd7:e5b3 with SMTP id
 4fb4d7f45d1cf-61d26d8059bmr18837198a12.28.1757063862016; Fri, 05 Sep 2025
 02:17:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250904062215.2362311-1-rdunlap@infradead.org>
 <CAOQ4uxiJibbq_MX3HkNaFb3GXGsZ0nNehk+MNODxXxy_khSwEQ@mail.gmail.com> <2025-09-05-armless-uneaten-venture-denizen-HnoIhR@cyphar.com>
In-Reply-To: <2025-09-05-armless-uneaten-venture-denizen-HnoIhR@cyphar.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 5 Sep 2025 11:17:30 +0200
X-Gm-Features: Ac12FXxQK5szfMOAenSrWFNpnXBYxkFiCvA4oKLkvz9HD9t1tvSGVoQuegPVJgU
Message-ID: <CAOQ4uxjcLDUcfdp72cpQcDQEtZaaR4G+P8oPXL_HbotFirGrKQ@mail.gmail.com>
Subject: Re: [PATCH v3] uapi/linux/fcntl: remove AT_RENAME* macros
To: Aleksa Sarai <cyphar@cyphar.com>, Florian Weimer <fweimer@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, patches@lists.linux.dev, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>, 
	Christian Brauner <brauner@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	David Howells <dhowells@redhat.com>, linux-api@vger.kernel.org, 
	Kees Cook <kees@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 5, 2025 at 7:11=E2=80=AFAM Aleksa Sarai <cyphar@cyphar.com> wro=
te:
>
> On 2025-09-04, Amir Goldstein <amir73il@gmail.com> wrote:
> > On Thu, Sep 4, 2025 at 8:22=E2=80=AFAM Randy Dunlap <rdunlap@infradead.=
org> wrote:
> > >
> > > Don't define the AT_RENAME_* macros at all since the kernel does not
> > > use them nor does the kernel need to provide them for userspace.
> > > Leave them as comments in <uapi/linux/fcntl.h> only as an example.
> > >
> > > The AT_RENAME_* macros have recently been added to glibc's <stdio.h>.
> > > For a kernel allmodconfig build, this made the macros be defined
> > > differently in 2 places (same values but different macro text),
> > > causing build errors/warnings (duplicate definitions) in both
> > > samples/watch_queue/watch_test.c and samples/vfs/test-statx.c.
> > > (<linux/fcntl.h> is included indirecty in both programs above.)
> > >
> > > Fixes: b4fef22c2fb9 ("uapi: explain how per-syscall AT_* flags should=
 be allocated")
> > > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > > ---
> > > Cc: Amir Goldstein <amir73il@gmail.com>
> > > Cc: Jeff Layton <jlayton@kernel.org>
> > > Cc: Chuck Lever <chuck.lever@oracle.com>
> > > Cc: Alexander Aring <alex.aring@gmail.com>
> > > Cc: Josef Bacik <josef@toxicpanda.com>
> > > Cc: Aleksa Sarai <cyphar@cyphar.com>
> > > Cc: Jan Kara <jack@suse.cz>
> > > Cc: Christian Brauner <brauner@kernel.org>
> > > Cc: Matthew Wilcox <willy@infradead.org>
> > > Cc: David Howells <dhowells@redhat.com>
> > > CC: linux-api@vger.kernel.org
> > > To: linux-fsdevel@vger.kernel.org
> > > ---
> > >  include/uapi/linux/fcntl.h |    6 ++++++
> > >  1 file changed, 6 insertions(+)
> > >
> > > --- linux-next-20250819.orig/include/uapi/linux/fcntl.h
> > > +++ linux-next-20250819/include/uapi/linux/fcntl.h
> > > @@ -155,10 +155,16 @@
> > >   * as possible, so we can use them for generic bits in the future if=
 necessary.
> > >   */
> > >
> > > +/*
> > > + * Note: This is an example of how the AT_RENAME_* flags could be de=
fined,
> > > + * but the kernel has no need to define them, so leave them as comme=
nts.
> > > + */
> > >  /* Flags for renameat2(2) (must match legacy RENAME_* flags). */
> > > +/*
> > >  #define AT_RENAME_NOREPLACE    0x0001
> > >  #define AT_RENAME_EXCHANGE     0x0002
> > >  #define AT_RENAME_WHITEOUT     0x0004
> > > +*/
> > >
> >
> > I find this end result a bit odd, but I don't want to suggest another v=
ariant
> > I already proposed one in v2 review [1] that maybe you did not like.
> > It's fine.
> > I'll let Aleksa and Christian chime in to decide on if and how they wan=
t this
> > comment to look or if we should just delete these definitions and be do=
ne with
> > this episode.
>
> For my part, I'm fine with these becoming comments or even removing them
> outright. I think that defining them as AT_* flags would've been useful
> examples of how these flags should be used, but it is what it is.
>
> Then again, AT_EXECVE_CHECK went in and used a higher-level bit despite
> the comments describing that this was unfavourable and what should be
> done instead, so maybe attempting to avoid conflicts is an exercise in
> futility...

That's a bummer :-/
but to be fair, AT_EXECVE_CHECK was merged after v23, so I guess
the patch set started way before this comment and got rebased
after the comment was added, so it was easier to miss it.

>
> If it's too much effort to synchronise them between glibc then it's
> better to just close the book on this whole chapter (even though my
> impression is that glibc made a mistake or two when adding the
> definitions).

Considering that glibc has this fix lined up:
https://inbox.sourceware.org/libc-alpha/lhubjnpv03o.fsf@oldenburg.str.redha=
t.com/

Do we need to do anything at all?

Florian,

I am not that familiar with packaging and distributions of glibc
headers and kernel headers to downstream users.

What are the chances that us removing these definitions from the
current kernel header is going to help any downstream user in the future?

Thanks,
Amir.
