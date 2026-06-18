Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3593B3290DE
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 06:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781764470; cv=pass; b=Uay8C0N3eZE+qpRyOMgmbyNWXXn5Zc2gSEp/3P3MIRB0ManwEbkb7bjwiItngu4L/RvTqTcjXF7v1sUmdFUbKnj51B9UbhwvqtBhMmuj+iDs0JLd2wBruoRQCOq39DDSx8zzk9F86q3+LALu2e/pS2cfc+zf392G/gLXq/inBvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781764470; c=relaxed/simple;
	bh=3Oo8NBVlLWLPAiABDvAMPw2Gh1H7ACmqAdcOnRERYcA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JcHxRixwyq857pr4H+sFTpNg2r5yFLBFQ3Nhr40Y4U7pNCia1uDWS1O+ls10TDafwuq+RaLB9gA6paKilSzxYlWnfcC5Ap24iAojoBPD3RICk5xvOXhgesQ3q2P0wAkRLhmUSyuAP5RZvMezTJZm1IByDrsKo2YHsgyFP1D3KD8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kRXQ1PhT; arc=pass smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kRXQ1PhT"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7e6cfdc8382so433280a34.2
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 23:34:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781764468; cv=none;
        d=google.com; s=arc-20240605;
        b=lHvRm2nNaoz1le1zTRjSJZBIpUu6PjlF0bl+aDHAurjaJQK8YPfTthDh8ejD1KIt89
         glK+1lacoCU7qL5p9fac9T7YZEICrgnaVRnSXpuFt6AH0bl4/QDugr7QGu6CCorLZaXY
         SKccfyicwQ/mcMfwKL8EAcqtm8Er5HYgG0n7jvBbQzexhnxd7lmLw2USaQFd6sxS3oUU
         jOMJ+jIzCEG7/GZYoSilp2hbe6bJ11o5YwR5czrKpJLvSStrhRItw2EVp9UedjF7ZvGY
         vT8LQczcXacS+0ZvBb/EKX9lp7Yighn/9Tj4uyK49Ca5Ykh+fuBL1lpQ4KOLoGVsRJc1
         eo+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3Oo8NBVlLWLPAiABDvAMPw2Gh1H7ACmqAdcOnRERYcA=;
        fh=KZ8pdJLOBlavaZBNAyY6MmI0lGZiGHgrwtMjknBiW5g=;
        b=RxVwxRALtMdRX+u7bU1lRtV4D53GpKkCa82KQGvfHTck3a9i4Zcd8rVklcIFmoPOhn
         uqOOamYUrMUbsXwFlR06o8KVIi9c4O8hbPt5nFKfXgB23R26hGTQRO7vN6dZkYvNvM5N
         alsiYLrsdMLMjQnu1wRsQdhdoviC8VOltpYNVDCALk8upep4IVGPPDoaazMCQYJGwXYE
         2mFgg2xZOd3O/VBLJsKhqxq09T2Q2sbezk0UnDEoJ+OldlQj9pjyVkIxqMp4Z4A7DuRV
         vF5bvM1YvItDt+EWpvKNnCyBCtYxQMJmkJTtmJiIhYfpOnp4bTyenPps5SyTp7cWYpYQ
         ZJZg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781764468; x=1782369268; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Oo8NBVlLWLPAiABDvAMPw2Gh1H7ACmqAdcOnRERYcA=;
        b=kRXQ1PhTg1H707w6ZBJiJkUpTKC6+ayo72wyUrLb8IwMCp6nbOOt1ApZs0fOiYxeqz
         lAb3nLHtzGUSrF4WJ8DqZ77SdrMTDJ5KDeYcp9VgVlTnhCufdpTvoU+0O4SfXRiRoScx
         qRgY1s+lSwUu5sQXKC5qOjDx2rKO8zgR//7q6fnToPZTAaGnh+yKLGRfPlwH+eDY2hMp
         ZRbnWFaX3F3jVllU7dWiIm6bBSE25WsxufoB5YSZ04pRV9bL22cB8Xbni/lOSZcKvPb1
         coiUBRzBspYzhRfDZb5RSCEhJm+l6L+56Fkz79+WP2vHOq8WrvQn7DQOFeq3CDSUI8VC
         gKkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781764468; x=1782369268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3Oo8NBVlLWLPAiABDvAMPw2Gh1H7ACmqAdcOnRERYcA=;
        b=Pbwh1OKZSmkuLTuHUd10F859IlfhjMROxVL2Zj3H53PfO95gumGFhj7MaNi2hAu2ls
         k2ICtz0frMPTe1CoEiXHvTXGTXfIkOg68ZWTNhYGCADZRrOUlLCpUN5Ok1ChWPi2cVMG
         1ggY1+VnTDJY9s5dFDc9FviQ4zNvrDR95MxvtA2bz/Mu0JBZbJb7kRj1nNsTyq3K5rVb
         BWh7Z93G5zwppPYQCACdIFvGy0uWNhBQDA3FQmckvGctv+kUXikhViEHhFsowh8ar13h
         VIKS6U84e0fQrzSMb6FciaQNX5M6lm1Wv/6ueEDIZ9uXKSuxGTV3RgZEyUT1tj8jZtY1
         eZtg==
X-Forwarded-Encrypted: i=1; AFNElJ/fqtZeH8YTXM9Ow3EMCYIOyLMgpRjdDrd7zMnozt+bvIwVGGuDP0GHXdN6lUlphufqiiwJByw3@lists.linux.dev
X-Gm-Message-State: AOJu0YyZQhj4ieO12DC8A0nra33JHqmeIFMxI69te5sKqnwNRg6TV72B
	DpGEQCjDVIN5hIXO0D1Lgm/LZ1JnoBqhAs+iqwb/Miz4M8JXKdGOf0Evtp61TwxX5uqMUwhQ5kb
	UOqe9NMiJ0eGzoKQMVuuJel4M+4vDZao=
X-Gm-Gg: Acq92OEqEcmHrKf9FN55eBeoe4BO8Qtlrwz8m+vsyZqoiKS9raSvNc5vDgBcHsYGELV
	v8xMU9BxRIeB2/4Pvst+ij0M0gaTyZxx9cuR/fqxdhPpRcH7okDhTSBcQP63ZTcqRJVlZyqsHrJ
	Io79WuYC4qSTc9XTdgU1apbGGlHfcPI98r6fzwvPNgB5Jl/zWSQKT12Mf1VarAh/9LpoBfA7uVb
	cpV+74l3koUUn+DCQOknTfDgmMov2h40Zt51+JcTa2IT1db+Wt1YC4TULT5mqJwAoTWwZw=
X-Received: by 2002:a05:6830:6d50:b0:7dc:2f4f:17b4 with SMTP id
 46e09a7af769-7e90b3dd22emr6348498a34.21.1781764468073; Wed, 17 Jun 2026
 23:34:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <83f05c55-efba-4bf5-abfe-d2ab0819e904@packett.cool>
 <CAJnrk1Y9egYizkx1H9K0cqxSYuB+7vLvQbV7Tf4C5eHFqnnC-A@mail.gmail.com>
 <20260617-attest-gewechselt-tragik-7ed473860051@brauner> <CANaxB-zK5q=Xw6UZTmeFtXsDZjUsPkFk=p485m-wtNTBnf4hgg@mail.gmail.com>
In-Reply-To: <CANaxB-zK5q=Xw6UZTmeFtXsDZjUsPkFk=p485m-wtNTBnf4hgg@mail.gmail.com>
From: Andrei Vagin <avagin@gmail.com>
Date: Wed, 17 Jun 2026 23:34:16 -0700
X-Gm-Features: AVVi8CdkTtlsRp3whjFCRdKN_CHwplubM07nLp2T3ItfxHiU3lLc-EI912kwpts
Message-ID: <CANaxB-xVCP5HSUNwphFrKPdW0Qh1pA33A6npac60WArkZMFt7w@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Christian Brauner <brauner@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, Val Packett <val@packett.cool>, 
	Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Steven Rostedt <rostedt@goodmis.org>, fuse-devel <fuse-devel@lists.linux.dev>, 
	Bernd Schubert <bernd@bsbernd.com>, Aleksandr Mikhalitsyn <alexander@mihalicyn.com>, 
	"criu@lists.linux.dev" <criu@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 17, 2026 at 12:57=E2=80=AFPM Andrei Vagin <avagin@gmail.com> wr=
ote:
>
> On Wed, Jun 17, 2026 at 4:08=E2=80=AFAM Christian Brauner <brauner@kernel=
.org> wrote:
> >
> > > After this patch, step b) is a straight copy which means step d)'s
> > > fixup doesn't modify what's in the pipe. This could be fixed up in
> > > libfuse to not depend on modify-after-vmsplice, but I don't think thi=
s
> > > helps for applications using already-released libfuse versions. I
> > > think this patch needs to be reverted.
> >
> > Note, nothing was merged. I deliberately kept in -next though for a lon=
g
> > time to see how quickly we'd see regressions.
>
> The bait worked. CRIU wins a prize in this lottery.
>
> The CRIU fifo test fails with this change. The problem is that vmsplice
> with SPLICE_F_NONBLOCK to a fifo file descriptor fails with -EOPNOTSUPP.

Actually, this change introduces a performance and functional
regression for CRIU.

Here is a brief overview of how CRIU currently dumps memory pages:

CRIU injects a parasite code blob into the target process's address
space. The parasite invokes vmsplice() with the SPLICE_F_GIFT flag to
pin physical pages directly inside a pipe without copying them. The main
CRIU process then takes over from outside the target context, calling
splice() on the other end of the pipe to stream the data directly into
checkpoint image files or a remote network socket.

I ran a simple test that creates an anonymous mapping and touches every
page within it:
Without this patch, CRIU takes 9 seconds to dump the test process.
With this patch, It takes 18 seconds...

Plus, it obviously introduces some memory overhead.

If these changes are merged, we will need to completely rework the
memory dumping mechanism in CRIU. Using vmsplice() in this proposed form
no longer makes any sense for our architecture...

Thanks,
Andrei
