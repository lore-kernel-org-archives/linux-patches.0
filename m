Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A53A2DA756
	for <patches@lists.linux.dev>; Fri,  5 Jun 2026 12:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780661989; cv=none; b=sEiSXAHQ4d9LdGTA31BbUEnWS3AyX5BceHRF108/My4QR9xx+1GKIIbXq7O6KqxvzhLyBwmuWpLJ2rm3mZI1EVaxHJHUodE2X+BftSGrL8Kgbx4Pwad9PqS9/Ijg91e+WXKoOvcBNASkcrxtI6B3yJRcmLrZcZ1wfBMUGMdIHJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780661989; c=relaxed/simple;
	bh=fG5cj9E2nMxzrFq+XWzFsnTRtUdYT3n82TzWC2ntc84=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iVFDoUvoPJWuAhKf9aGAZI756XbT+X71kU/cxJZxqNWbDKCsna2zjAfIaZm5vydHtMNVJM+2ZTJtaKLeb7ReoFahPZ5br3YIZGY4R7zq7aZZaUqovhjkqcTnMG6lHqrBZugTchzaBYrDwn10Xs3+hX2D5+c4V9PlbmDLHKIGC5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gOlvsiWN; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gOlvsiWN"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490b2b037d2so16448995e9.3
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 05:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780661987; x=1781266787; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gz+VtwQhYk3ng5JxyiUgLQa8oImJtLVBwaLlzEeVzFo=;
        b=gOlvsiWN7IaSqUbdsD59x4UrZdnjDxSoTQeCuFU2kXTtcdKl8Q42aW51ps8lqs4wdy
         CY/520UwzV0OaT/RsNYR4OEF24ftrJfN9rp+IWmNKsd+LKwpV8R/Un7dlYTLwPba8N6N
         qZIAMOHl7xNT7WDQuPsT/UpiZxgfZvgZnQg6zT5dirImsL0G0mC7vrsvzCCCb7Ng1nqj
         JrhaOhE0lAq5KJNm0N9sDaMNrdIDjrSaZIeN25Y50k7Q9+C/GJP+CMNugzFEER+Anp8N
         LJVXpAUPvpniV97yKdjtSsMZ72G6TwSjx+2bgxGVQYkyFcL60gdIlOPYZJuqD0MTQqId
         VhIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780661987; x=1781266787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gz+VtwQhYk3ng5JxyiUgLQa8oImJtLVBwaLlzEeVzFo=;
        b=ptqJy3DyMlhhEqEU95z+GIiJT/E++yDLk4Bsbx2zoussRH3+N6h/Bt+tiaxsiG9RQz
         9/vLZ0EmhcAnMm+t2uVWhCOAJ3elDoLXtNBwxLGgbTkwGlMx+bJ4hewiSewSy9aZkpEr
         O6Y5davkOfkoTDaInjGGquK+6qPRitmG+gdGdUfgQRf2Tt93maKoBurJyrdk5VOZrTzZ
         yJi3h1Uvns1bXiILL0eLtK4P1f0CfeyB5P6VQUwNUldZjW6rBLtItGB7Wu7VLBSJtm3M
         4FBAO+17j4u2YBc68KSVcROH4jzVP1pqvro8AMB0T7s9s5/fasZ76Voeu9O/iLjyVRyk
         1U6w==
X-Forwarded-Encrypted: i=1; AFNElJ8IHysmpHcBQtm/AjeyIi6FUXYD++ekamZ036gVMCkFazT0YdKYveBxyRnShOnHTka1BJ7JE/AT@lists.linux.dev
X-Gm-Message-State: AOJu0YxloweiVr4LvXcRoUlq7i4+76G9iGaiKzaUv+cMPp79CqLwE0n+
	XNLf/jEjLH+JbGwsrtZ1YCYgdwoy6POXapYqJy1eqvBNfkF6Jvnjpczn
X-Gm-Gg: Acq92OEuvtkLgLVQUsYa8fhO1OcyKEfbJ6arruRHgRzPP1K49PcKDfCGtF258P+O5EW
	Vx0wnAU/MrzgSPb70FxfVm60aZKEQFG0GhfQneuTTMpti79ge9noBvCNUswLjfPxlyDuYbnlKcf
	pknLcavg29+abIxgIjnwP4/0gO2jO65jJUQBDgPLC7ZwEP7ZpADAO3JELEJO3QJd91DlExaO/Cs
	5R9Pb70c9jAyJl0nf08+Udx41VZ/vpz52+sSrwvz1XO78ILQzHiHD7n1N8NP8l9aKRh33UaUdHe
	MIfyF7D/rbKnLvPXfgplXueVN6y+meIQnaG46Hd+jsVivmnMtxBYiqxXgKOGY2GjTiuALpNApfb
	tL4V0ex08QPCiMxgcCiOIjzUeqRPoEm3I6wkPn92TdndrBsCK5U18g4zrNsZ9oKhjU3xfsLRqx5
	eYY93MLtOekySDjBpMM/YIvxrE8sYnuLiPXlwecVsaT75t29E/0nd5fZ5XLmnFhI3biUnfnRr6T
	FXyHzrMjw==
X-Received: by 2002:a05:600c:1d12:b0:490:7227:100 with SMTP id 5b1f17b1804b1-490c26049a0mr52430315e9.18.1780661986468;
        Fri, 05 Jun 2026 05:19:46 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cbfe4sm152016275e9.7.2026.06.05.05.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 05:19:46 -0700 (PDT)
Date: Fri, 5 Jun 2026 13:19:42 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski
 <luto@amacapital.net>, Askar Safin <safinaskar@gmail.com>,
 akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
 david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
 netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de,
 viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260605131942.4584728e@pumpkin>
In-Reply-To: <512d948f-7883-4d8c-b2c5-a777e70ca975@samba.org>
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
	<20260602225426.122258-1-safinaskar@gmail.com>
	<CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
	<CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
	<CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
	<512d948f-7883-4d8c-b2c5-a777e70ca975@samba.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 5 Jun 2026 11:43:45 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> Hi Linus,
> 
> >> Am I understanding correctly that this will completely break zerocopy
> >> sendfile?  
> > 
> > Very much, yes.
> > 
> > And it's worth making it very very clear that ABSOLUTELY NONE of the
> > recent big security bugs were in splice.
> > 
> > They were all in the networking and crypto code that just didn't deal
> > with shared data correctly.
> > 
> > So in that sense, it's a bit sad to discuss castrating splice.
> > 
> > But it's probably still the right thing to at least try.
> > 
> > I've seen very impressive benchmark numbers over the years, but
> > they've often smelled more like benchmarketing than actual real work.
> > 
> > There's also a real possibility that a lot of the sendfile / splice
> > advantage has little to do with zero-copy, and more to do with the
> > cost of mapping and maintaining buffers in user space.
> > 
> > If you are sending file data using plain reads and writes, it's not
> > just the "copy from user space to socket data structures".
> > 
> > There's also the cost of populating user space in the first place:
> > page faults for mmap made *that* historical copy avoidance basically a
> > fairy tale.
> > 
> > And not using mmap means that you have the cost of double caching in
> > the kernel _and_ user space etc.
> > 
> > So sendfile() as a concept (whether you use combinations of splice()
> > system calls or the sendfile system call itsefl) isn't necessarily
> > only about the zero-copy, it's really also about avoiding the user
> > space memory management.  
> 
> I don't think so. Ok, maybe for webservers just serving tiny
> html files, that's true. But for me with Samba it's really the
> copy_to/from_iter() that is the major factor.

Is that copy also doing the ip checksum?
I really can't tell from the code (it does sometimes, even for tcp).
But I can't help feeling that optimisation is well past its sell by date.

-- David

> 
> We can use io_uring with IOSQE_ASYNC in order to offload
> the memcpy cpu wasting to different cores, but it's still
> wasting a lot of resources.
> 
> For the case of filesystem => socket, we can use
> IORING_OP_SENDMSG_ZC and that at least removes the
> copy_from_iter() in the sendmsg path, but the
> IORING_OP_READV of buffers in the sizes up to 8MBytes
> is wasting cpu in copy_to_iter().
> 
> For the case with smbdirect and RDMA offload with 2x200GBit/s links
> changes from only ~33GBytes/s are used (and the server cpu even if using multiple cores)
> is the limit. Without the memcpy waste ~46GByte/s is easily reached
> and the limit is just the network link.
> 
> Maybe another solution could be having a version of
> copy_to/from_iter that uses async_memcpy(), but didn't
> have the time to experiment with that yet. Maybe a new flag
> to preadv2/pwritev2 could control that, so that the
> application can decide what's better.
> 
> But without an alternative please don't kill splice.
> 
> A lot of people are frustrated because they bought hardware
> that is able to handle a lot of throughput, but
> e.g. with the default of smb over tcp they get no
> higher than 3.5GByte/s on a 100GBit/s link that's able
> to handle ~11GBytes/s. And io_uring and splice are
> a key factor to fix that.
> 
> Thanks!
> metze
> 

