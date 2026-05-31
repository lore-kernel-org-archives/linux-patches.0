Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353F328C2BF
	for <patches@lists.linux.dev>; Sun, 31 May 2026 21:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780262505; cv=pass; b=aLQA0ulG/Z8rooh+SL7EfMMT+LGLBAkQ52sU3btlNB1DLJxDbhN6eK7DG0An9F1j4+eY5dvcXFcRAWoeDF/8ewUAi7qgu06tclc2jDk55dnkjpVdVQJyq7UhpOZj/FvSfs40HhuoOHR+9gYEptBd3VNZGiAhYC1b6hhErLkYPbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780262505; c=relaxed/simple;
	bh=HK+FQZK/X2670pSoGvJT+eXxMm/YbYUTBbsmMo4Pt1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b+286nYQCZn0I0xUImLC534e1M38mTds7uKIyflGxP8atP4e8aJsMConasSjM1R2XSAFZ/izU3mFYMMmhrJZZ51u4g1dSmvfFGxgQJaCHm/jIzcxH/onRu3nGcqoheI1poGD3YYqa/pZnWEBI39Tjdri+pztUOKGah02/1LO69k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bA0gSciL; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bA0gSciL"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bec449d0af2so75944466b.2
        for <patches@lists.linux.dev>; Sun, 31 May 2026 14:21:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780262502; cv=none;
        d=google.com; s=arc-20240605;
        b=bmGnhCBS++SaOZA/QIQmIu2S581QLJy3A7Rl/QlxIxdtZ7JXsP8hfKdNY4UJig+noH
         BBcVv7HDbWkkD8JldRF4WY23C4g5iXCg/wmxYHZmSpwTC2nVPJAp7EEAUI8/p5gero1y
         0tDnXjQL5s5hZlkldjwys2FUKsN1Qf7OoGt/CiHcCOcG1x2LpdVKgnBfFklbQCTyMxcP
         IeBkjtBtamgnx5dimP9OAAFZspXNzGeEtg9obD7f2w+cs/7ES+bmQ+zbxCFEFEjAUedE
         +y0nQAJgalqljhLkXr+Rlae83Eo/NpD7+4E9Z0NuZ+dNqMmj3/vkuMigAwisfGXKZFVE
         l7AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HK+FQZK/X2670pSoGvJT+eXxMm/YbYUTBbsmMo4Pt1U=;
        fh=ZI/nAac0O25iPNDehBQE8h3Yp39iJK+646yfyQGV7As=;
        b=e86B5MnbNxmZ9WAhkFpthWT10ccS2+jv1hDgBNw3XVz/iSlXw/il03ywBKjt9/wqwN
         JnES2W58fPN23nn6Gk/b5lLq32DBN9TVPc18ufkILwb0JUxNAR9ExXcU9xlHgRiVE8HO
         VNSYRmotXZi9KPZHIKt0ka2WUMggKPZEvaUk7X3hHcVFyxR5td7SxPGlRNs5aFSeCBun
         XY1kmMGjsCz/pN7KaKRLIH91AsabkUwFsEFZDJX9ecpzkipbb7wsv31zMQzqSXTC0F3l
         EqU9tZa6hWdN9rZICqJwlbC2vCmXde5mt7rGkBefaGJGVuSVBmwdSvwVxVrkf3b5V4Xq
         YrYg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780262502; x=1780867302; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HK+FQZK/X2670pSoGvJT+eXxMm/YbYUTBbsmMo4Pt1U=;
        b=bA0gSciLpvOC/6iGKeT4KnLa9B+UUlVySQo5woUmiGz7B55CmVUgKHNinHWNQHH1SY
         srH26HXDH7utwSz/u0FxZvD5bwbTjC37S/UzMPM+n7OjQUytrhVjVl8aTo9XAf8VsAjm
         tEWwywq2oNb5mDqkMYhC4kqtBx/LOYdtYq7i2+iTkr6pyXa7KCtZUyzglz25Rmw6Lqwd
         zIm1AtsqnDAn3+3nZ9B0CO/m/+fu0sfelezBFK8oiEPsYeptLy+a9rba+ss4jY8/tbpz
         uD92OPRfQP6kO9sD89eISQVdGc17zZZbT/M2fFyIzzHJWiI+xLXpPqEYSRblqme26phk
         TckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780262502; x=1780867302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HK+FQZK/X2670pSoGvJT+eXxMm/YbYUTBbsmMo4Pt1U=;
        b=aBTZaeAkZ5HVrKkRUukDjU+pKATw3Cm0TnsUs6zMqfeuYJbyHirftzozLMWXDD+aEN
         GC6ovbXrgQt8EaHsvXIMbsjWDNsNLjCBLOv2l1it7oEsyEYk6w6e3j1yerkqV9JMLpe7
         r2miqCm00gUdLODej1qyl0BK1ak7cTEq3uRaJwghBiJ+Eam/izpRFzl4H0UzzwMCvQ9B
         SupawjEcgA1znvbj51OS9HWsdrPJtqL4dXcY5pmyIlELk2GEi3TBPZW/DN3I+YwoDaqX
         ovwjUNreWzrj5pgNl38Jfragr9LK1vfZm4Ufn9vPCTC34+W46KNxzUumdaWsdD7Pbsng
         pcyw==
X-Forwarded-Encrypted: i=1; AFNElJ9nDm4A2dZm99AA8jPIlJ6N0edSRDxSzzkqskGHpV/Q9xJVjpd/3ry6Tp8fw+LdsYzG2O2c2lHl@lists.linux.dev
X-Gm-Message-State: AOJu0YzlE/Vv2J7kiVSTp757ngOsCu4BjOHURmMW9cSarHz/V9QNA1BW
	8Lc1i2HOFSWxp13ZhAShV5yPT2Wegm6eY4JSjDUzzFYS/3uZQvgTuGLeADeCVSiholDHGGO+8Fu
	5YfVjiFdBji4O83/OwuKZd4NcGlG7/uY=
X-Gm-Gg: Acq92OGFTQMm+09cgtt53AcOok5CvSVGuvdbBhoDfuyKpeBhdHkvKN+V75IjeJsziCO
	YUxbYiUr159zbKioHrWgjSq14BCYr3z2mScj05xR4Xj597wtkpjbj8RyfSyE8H4gMlhEn4/bIPU
	UVS93WvVLRBWPa5E2zW99t6rYFxsHZ3LpjTtya52vxXTyGXnUpvWKsdhpyY91UNnVbjJk0HPAdV
	Djyw9PteRgRQ34xT3FejFqFjaJGof5o8QJl0WsXfxqw61Z66e1CdcCDd/52RJH0mDiBBn2a9kHj
	YpzteznNcEjT4Fn/csDz4S/tcvEc
X-Received: by 2002:a17:907:d02:b0:be2:dd37:facd with SMTP id
 a640c23a62f3a-beab4339068mr455362966b.20.1780262502221; Sun, 31 May 2026
 14:21:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com> <ahv16ogY8Zx3Rtox@pedro-suse.lan>
In-Reply-To: <ahv16ogY8Zx3Rtox@pedro-suse.lan>
From: Askar Safin <safinaskar@gmail.com>
Date: Mon, 1 Jun 2026 00:21:06 +0300
X-Gm-Features: AVHnY4IV40jpJJDRQFbdKVprCBGPqL0nWYb_1HSlt6FzSI1F6gq0u1bXknLpLA8
Message-ID: <CAPnZJGD5QR5jrNMAem7FjMRTtw+Ue+jm7Dc2Kp8Lcjj+9TDw_Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Pedro Falcato <pfalcato@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 31, 2026 at 11:54=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> w=
rote:
> So, you took an ongoing discussion with an ongoing RFC patchset, and you
> decided to reimplement part of the idea on your own, as a concurrent patc=
hset.

Yes. But I propose an alternative solution to this problem.

Brauner said in discussion for your patchset:
"So I'm not very likely to pick this up as is".
So, I decided to submit another solution.

Pedro, I'm not trying to insult you.

Other kernel developers will decide which of these two solutions they like =
more.

Many people in discussion of your patchset said how they
dislike splice/vmsplice, and especially vmsplice.
Hellwig said "vmsplice is the worst".
Brauner, Hellwig, Horn said that they dislike vmsplice.
They said that vmsplice in its current form should not
be used, and that it is broken.

Despite all these problems nobody managed to fix
vmsplice in all these years.
So I propose just to effectively remove it.

You may think that I just saw a recent discussion and decided
to jump in. No. splice/vmsplice is my topic of interest for many
years. You can verify this by searching "f:Askar splice"
on lore.kernel.org . I simply decided that given
recent vulnerabilities now is the perfect time to solve
all these vmsplice problems once and for all.

I explained my position here:
https://lore.kernel.org/all/20260523204100.553125-1-safinaskar@gmail.com/ .
Nobody answered, so I just posted this patchset.

If my patchset is applied, then I will try to deal
with splice-pagecache-to-pipe somehow,
probably by removing it, too. :) I decided first
to deal with vmsplice, because it seems to be
easier problem.

> > vmsplice(fd, vec, vlen, vmsplice_flags) will
> > be equivalent to preadv2(fd, vec, vlen, -1, rw_flags) if you have
> > readable pipe and to pwritev2(fd, vec, vlen, -1, rw_flags) if you have
> > writable pipe.
>
> This does not work. https://codesearch.debian.net/search?q=3Dvmsplice%28&=
literal=3D1
> There are users.

Yes, they are. But my solution is compatible. vmsplice is simply performanc=
e
optimization. vmsplice will work just as before, but slower.
And, most importantly, vmsplice design problems will be gone
(nobody managed to fix them anyway for all these years).

--=20
Askar Safin
