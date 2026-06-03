Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BCF44BCA8
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 09:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780480646; cv=pass; b=D7daHjQNWAkWLjK7l5RIWxjU5ILfAuGyNxp8SJUvpyeUzUgSlT8el8h3DITuVLIbu4Ur6Q2/xR1barITamimhEKr/6fKqckwMoo52eNTNzuKwbSpZObgb6s0/NC76YfCx1KFNNCbDSTc9bDXXyyMSQZk4eqMfq+jxVpnbTdyDfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780480646; c=relaxed/simple;
	bh=ZCqrAxzAA1VkvSHMPbJW9yIvYLlRWu40qg6zjxtnKxA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A2aoGHBYX+ZT3U+MNA+y9fgXCQEPYB+OZLUpHwlFynueRRJPfEeVLLsRAtZXBExmrCnell9F1RDLm2yvycmzkWqhhCaeWUlC241EqBr/sYFtwjaXy7VqVJz5qDP5jooG3dZ7qr0ehrxXNYHhSZXy0UGYV1gkt+hp92H8qxSmc68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=dMRCX6MA; arc=pass smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="dMRCX6MA"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9155183b42cso64734885a.0
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 02:57:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780480643; cv=none;
        d=google.com; s=arc-20240605;
        b=WN6tDU8kcN/9pVJZEAcAXyucY1sI/WFgZJTTMflEF1O0hcHQija+SbkYlR1Mz4gd5O
         eRWJZR1Demop+AkgL85kfE+ru9Ck5Ix4smZLMr8DKEUYIZyCRo4NZQDV3s+KaTbdBV5x
         G8qlRK+haQyg8VZcmts8tJf2GK24js13vbz+UwxO/R6EigsQynRLoIdkm9PJRvES5KF2
         pKOxeUbBtaODSsYcS6xsfOKPEhJIMfFT+QFADFD/Hp026RM5+7uBZOguWhMeJtQdYcoB
         DmXWcYc7B7Xfen6oTnb3Aj92nJIKAX7bpp1RuZan0FAZQo6qsPV3t6isN04NB4m269+t
         u9ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ZCqrAxzAA1VkvSHMPbJW9yIvYLlRWu40qg6zjxtnKxA=;
        fh=I8cDo9Nst8M6CYQtDMLP7aHwjqfIasd7hwoPxI0/Js4=;
        b=cyUqbFOnWjvfHge6SMOZjwWljvRZA+wdMG85Z7s7R5jndLQ5rtxsAbusO9QIQWGFip
         GQGuJ0gT8I2tpUqRu0PrNz+4RaZBNbaCYayweu8XH6jv89XgTOxI85u1xGxHjn1jzXFa
         /QGnbmwa2e6I/OPjIoyT4HK+nhtphJxcmiPL99Wa3ALXF+492waIV4MTYOb5sGF4rAch
         z9XtTXYvGEFTGWdLo/B4/aEmmFpMTDS1MqdDOuo17wFbusFQoFNjp5EsaayDo0NIsaXu
         6ygyfvZ0ghlf55nlcTktVx4OTy1SK5mrwi9knHIeU6lcsg3w9wy2MTG8fCm0pxpGC4Qc
         25jw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1780480643; x=1781085443; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCqrAxzAA1VkvSHMPbJW9yIvYLlRWu40qg6zjxtnKxA=;
        b=dMRCX6MA2ZKnAYmNmqbTbcyWyN6L8zwp6HSIalR9n/7XIHgRHhMe0G0pP8Wo7oGyid
         n2yXRdpeD+oynFzEVvHZekvSoF0HEi3Ey7tv1KgggpCr/eBJzZLtcR0F9EEr7nn+Iq0l
         g7XyDi6/w1MhcnEG182Juuyn9Lmbtl4XrskK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780480643; x=1781085443;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZCqrAxzAA1VkvSHMPbJW9yIvYLlRWu40qg6zjxtnKxA=;
        b=SIrYQoADailYz8snwUanprvf9312tiu0X2swVF3NrZh89xefNXvVMadIu8dcE38Wfo
         nVVC5gmhUm+pQtYNdKfw7vRWkiQ36vQvHVchp3cVyaDVcYMi65gF6mfKYViFrFNSY+tb
         zbC7cInY1ki3Whu24wb73m3nfcsv8F/ruOwcz8xmvGy9oIgyIziLMHN1weGZpcTXhSIp
         WDqHoUGmW3mkysYPm3cVVbyicl0TX+MGPoQtm9w+7lAJ+MgEDSgwrTlTTXNOk2CfZTSZ
         +vhuufUuJXeYjBPz9GDwhTrhkCq4gz2aUMUVh9cufN/jq6c0GcqcqQ0ubFpHZnwGx6pY
         e5GQ==
X-Forwarded-Encrypted: i=1; AFNElJ8flfGMGXQAHdbzqLF5Ga/RKpN0MSIIUhzWYI/VokXdj3lNtFl43GQLI9EGmFtjA4lNnlulJFC+@lists.linux.dev
X-Gm-Message-State: AOJu0YwMhEn+51X/jAqELk8DLapdBFw7j9JuwiP5ChEvx2J1xtD2RBN1
	ponYiocTF1NLKZPGa4Jj3pZkljjVvQDJpNilYu6uEzd46mPqBkJwBg8zVbPrnau6XXEgr5I7g9u
	/H2iKt9fPJ8z5TOfmTBrDAi00xw7+6OadburLKKNPhA==
X-Gm-Gg: Acq92OEl3BKJV9yC6RZzt/2zh4HQW+D+mn908Fc03AX8HeBUG/YH6hfUqV7UgZh1ywM
	GS3VUhssXyLTWMG+J1uMveex4YP5PpfDQDJ1yXyEGTC1KWo3+3w0t9o+zmmgko/paHqNLIAGAXp
	llxLSkfBwMHvDxax40eYTI2I+oMe5k8vVke3rY5HOSmegt5KRoMHzwb+1+w9nrr5dtpWjDUHh60
	uN8vCQHBzNbcL1USqDMv+ELE2ORkbTkA6hvo3Snvewo2wcx+FJoVA/28tMS2A4x+KUUXP1IMh1m
	NeEB/K3rd5yieyLkY7jC1efuxG3XhYCGIbCu3Z+VZjtjY8lSePy165EiYA==
X-Received: by 2002:a05:620a:31a8:b0:915:422c:a0 with SMTP id
 af79cd13be357-9158b6e2074mr292177985a.22.1780480643420; Wed, 03 Jun 2026
 02:57:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com> <20260601173325.GH2636677@ZenIV>
In-Reply-To: <20260601173325.GH2636677@ZenIV>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 3 Jun 2026 11:57:11 +0200
X-Gm-Features: AVHnY4IqQCqMS4qklUMIqRUT1Fpv-SuCQDkhxYBkM9m1uTwHwBhUln17rZFWNU4
Message-ID: <CAJfpegtH-E79D-3UL=pPv-QqJk6C4ODXLLZSAjzQJwSSeqqS-A@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christian Brauner <brauner@kernel.org>, 
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>, 
	Joanne Koong <joannelkoong@gmail.com>, fuse-devel <fuse-devel@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Mon, 1 Jun 2026 at 19:33, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:
>
> > TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
> > a big simplification.
>
> FUSE might be interesting - fuse_dev_splice_read() and its ilk.
> Communications between the kernel and fuse server at least used to
> seriously want that, so that would be one place to look for unhappy
> userland...
>
> splice-related logics in fs/fuse/dev.c is interesting; another place
> like this is kernel/trace/, but I'm less familiar with that one.

[Cc: Joanne, fuse-devel]

I'd favor simplification, but care is needed to not regress performance.

Joanne might be in a better position to say something about relative
performance of various transport modes in fuse.

Thanks,
Miklos
