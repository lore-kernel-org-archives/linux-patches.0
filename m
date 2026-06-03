Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEB14D8DB9
	for <patches@lists.linux.dev>; Wed,  3 Jun 2026 22:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780527239; cv=none; b=ns4n6wOrkEbPdqN9TO2Kf/QZEJIycZN3i7ENTe7fehANXg+GSI6iZHBiRAURMNatHdc8fXaM3GLPrfLqysHJt5lvR/sUDYc8D3iUnvgyXZGoVdsSXuJJ8cJTm++OjsXhjDK7LiDv6elLdz4tFV4hrjJZe5+jEUDqZnKeyqRObZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780527239; c=relaxed/simple;
	bh=R/zZG4ZyrvWUzuSIU5eJSLX1T5t0EJujPTyy2snq0VE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d419+k1r6mc37ErMkudatDPN+sOZyyapYApkeGHJLRmxBH9DizcRiiDsuL+4keUylGC63PRp/W5XcE2gLlWA9FiIIEhR/U4IwEsfxWx9nQNeHVDnBmRe+3e15HO4U2L0gUrekom6pq7w4WOhaeAUEbe8hRTVpR+jX6yW7326Js0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IHa7LCz3; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IHa7LCz3"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c0bd02d97eso844115ad.2
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 15:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780527236; x=1781132036; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d66PsLO70IOujHc9tD5MHey7l/21gIQRZ4eLyqG6j78=;
        b=IHa7LCz3uUCML2QJPQyNnwvfDpFHyZqTe07yQenw8HLDGwFLQsQecTJ/Ac7sUnfUzY
         x4hedYdkV8dpnAzRkom36NbiyljBkK3Qc9xJ1qyqjYjFjMlftxanJrRgC5F9wm//vFxZ
         A+5AQYCpzRsCYCBT50FC5BYyv9obUMxKcvytc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780527236; x=1781132036;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d66PsLO70IOujHc9tD5MHey7l/21gIQRZ4eLyqG6j78=;
        b=PaflnXiijI4DyyjWAls8oCHDJRSxNPvvkjtoFXHQGacHFe1K/ysA0Jr/tVliyc8lnC
         JgCh1odMo0BZ/PsYUNaHywYID1fLsHfzc823KcQGTSMTN2AVPkk+IcX5HpXeNx5cUx5M
         +Zp6lH2P01XllIGNjoMxDEiW14uiE5A82v6QtP5Lhu22HNxbYSajaMmhw2uD36z9+coS
         4Zg8FYZfoPqrSdzE5o5g59YlaANdGDU8XSnrNOXCISxW+PxPKuiSFsskRXfczyDkQBpB
         gYXJ64crWHXCqTvEAwapn2pxfBWXK/Z+owoxUDwoxzFHYektPe82dKT2Cxb1w6e08xt6
         O8pg==
X-Forwarded-Encrypted: i=1; AFNElJ/ZnyANkIoBXd8++EMmpls7fcka6w/uspyIdSGzY65w1PXQk9GYM1TJpLn6LHsH1THoofQRQ/GT@lists.linux.dev
X-Gm-Message-State: AOJu0YwW08+PPKouusozD3eAUHQdrbXZSuUJZZeMxI6q9kxq5B1ylGPW
	SVbC7FMkSQcYpwS3zq22EVTWnHURJGBeAa6ZmhKoqO2nMhzLdV+EP80v3Qb8dkuX2A+d7uFGA9G
	QeaTHVwb2vA==
X-Gm-Gg: Acq92OH0FDFGxCyOt84bNoWvf4VGf2/MKEVT/ZZ7Oz7/sG2kWG3e3bWpQq88w/YpoMu
	uTPenZuFCZR5wO68D98+boh3TyNqfzgQZgSeE8bGnBkg8UTlVNZPMscGxMqtG5uLO8bEm5VcnA1
	J6WuDVLY6vwNWwCiE9S1Z/rCLGEPaZhIeP1GYNEgbag+FmnHIxCTBb9NG8B7tBBdcAAvWdZj4Os
	vQWPQTTfYQ1gzcoM3gjpz6kxS4Z52VIH8TBFeji1lmvqXRwOn9oGHir87XUtPL0ygum9KQF+f+J
	5QxDFkao9lBiIZ6F7zsdDEZA3mnJ0tAtFLE8EgBqsYRMhpHe/lITJxu87DJb+PcE6FdI5mcvNN1
	ulfIwQxLJkppxxEIvGIusfLhWlCK6wG0LeeaUovoKJaBuiJexjrzWxBS/tip8qCufWrv2ZzHEmI
	uhFNy9y1LAsCV0+aeGSq2fplR3MxV9tg8Hz/onucWFZQU49KLNVOUd4PAMNRJs6FlU4R13JF30Y
	L5fo+asms0=
X-Received: by 2002:a17:903:37cf:b0:2c0:cce6:a45e with SMTP id d9443c01a7336-2c1644dcebbmr54162085ad.38.1780527235763;
        Wed, 03 Jun 2026 15:53:55 -0700 (PDT)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com. [209.85.216.53])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f9ed6csm36450205ad.31.2026.06.03.15.53.55
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 15:53:55 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-36b9b15af73so37349a91.0
        for <patches@lists.linux.dev>; Wed, 03 Jun 2026 15:53:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8qAu3ndIbqncleLUjtELF1HDyFX1PFUjwyf4trl8o92p7GVmQ4D774XlOtx9pFJ9zp2UTKbHMw@lists.linux.dev
X-Received: by 2002:a17:90b:4ac7:b0:36b:8873:d96d with SMTP id
 98e67ed59e1d1-36e32b3baefmr4916778a91.11.1780527234968; Wed, 03 Jun 2026
 15:53:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com>
 <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
 <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
 <CAHk-=wgn3QTLj+F+XccE10dXY-UGWN8+fNLEvhsLw+tik9rOmg@mail.gmail.com> <CALCETrXpqPMS487Bm8f8mHe8hv9DzCqoaW4UdoHetzYBUAhYLw@mail.gmail.com>
In-Reply-To: <CALCETrXpqPMS487Bm8f8mHe8hv9DzCqoaW4UdoHetzYBUAhYLw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 15:53:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh5bFj1a7eaGp9sixDg3UXu7xUGfU=YJo+ckpGxGAyhXQ@mail.gmail.com>
X-Gm-Features: AVHnY4JfTnadgKQknxIsZL_Ab3vCkRcYm3kghJCvdkf-q8nXBlQAzmvvhTEK5F8
Message-ID: <CAHk-=wh5bFj1a7eaGp9sixDg3UXu7xUGfU=YJo+ckpGxGAyhXQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jun 2026 at 15:23, Andy Lutomirski <luto@amacapital.net> wrote:
>
> So I'm suspicious that you've possibly make bugs much (MUCH) harder to
> exploit, but the underlying awful code and opportunity for bugs is
> still there.  MSG_SPLICE_PAGES is still around, and there is still
> (AFAICS) no actual coherent description of what it means.

I don't disagree. I've only looked at the filesystem side.

The networking side does some odd stuff too (and I did look at some of
that, and had to be edumacated by Jakub on some of the subtler rules
for what skb data sharing is ok and when it's not - really not my
area).

But at least MSG_SPLICE_PAGES should be kernel-internal only
interface, and once you don't share page cache pages with networking
code I think that kneecaps a lot of the attacks.

So that's really the aim here for me - at least _attempting_ to go
"maybe we can just limit splice enough that it doesn't even *matter*
when networking does something odd and questionable".

And it's entirely possible that the current zero-copy "networking gets
direct access to the page cache folios" is a huge and insurmountable
performance requirement for some loads. So the vmsplice patch - and
_particularly_ my suggested "let's try always copying" patch - may
simply be doomed.

But I'd rather try to simplify the splice code by removing complexity
- and possibly then failing and having to revert it and rethink things
- than not even trying.

Because I think splice() is a *cool* feature. It was always *clever*.
I just don't think it's worth the pain it has cause.

And it's been around for a long long time, and after more than two
decades it's still most definitely not _widely_ used.

So that makes it a failure in my book. Sometimes "clever" just isn't
the right thing.

               Linus
