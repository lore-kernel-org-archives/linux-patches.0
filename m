Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050AD3C65FA
	for <patches@lists.linux.dev>; Fri,  5 Jun 2026 08:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780647804; cv=none; b=WH+3g5qVav3XY0gyGsIhtHdppSdj2BaJqLuVHcqoWKbAbQVP9x0ETXp0rgvTEn7gZjDV8cpTI/RK+zwKq1knBvwIKgP0ad/REOqkJ9nBaqij+milxFmqvh3wuXnWKjeqD5vz7TvwUIysLMjLfxBhlF2FkA/oEXdETnjI1Plxz4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780647804; c=relaxed/simple;
	bh=eAlKvP2gsEfRQmVOZv1allmZysrFKO1fn5IMvtPZQiI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z6HrV1l8KEsHa/higSKq1/YxJiBpNBQVXa4CWhMhBu2hXBj8SPAz5KyGlfCM3RZMIpzuUzTaNQo2HZ1J35GvzbNw16KrDZnVq1x5ZXgsOLmeTN8aCEwo1cLruoM0wfJomSaHbk+Dc8MA8nznWP+yaB2Q1V5Kg4qEA6u4HyrFFQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZENBaDX0; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZENBaDX0"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-45efb698ef2so773844f8f.3
        for <patches@lists.linux.dev>; Fri, 05 Jun 2026 01:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780647801; x=1781252601; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ncylH/iADc8ME04RgleGvGv2QOfG/3EuEqLEAZ+XWA=;
        b=ZENBaDX0jv5RIMjvMv8PLkTUgG64zghaORa+d7wYbYLV06tLABlqTONGyALYusbnVf
         pKb84cqeO2jHo4Tl/rgVb6lFaS6Wc9xb09xRVP7W+K5yYhjF9sk8Yk/cEB6bpP5f88o3
         C1A6Z3cnB7V+gsFSR3rHH8qpQQ9nLCU7IAF+QRR0F7NlRTiFgor0cHY26NN58BzXhPfR
         x3RrUpSH4LzHp88xjCDAqmZa8bCwzdQOhnxYx0DXfYrqRlaMxkVRlog+4uyGavb6EsLG
         gWykColyYpxWwib+wmVy8mJ54Uc+glxVNfazliB+EmPYcVgr4Wfnx+w7iFzePrfWFxYn
         4klg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780647801; x=1781252601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/ncylH/iADc8ME04RgleGvGv2QOfG/3EuEqLEAZ+XWA=;
        b=LZ9SX7d9b87pNxqcsFSdcrZNLC+sBZdWQkJHbZIObaXhfKsgCtfnpeahm+sHYhgYV1
         0emwnSx2y+e+CRNG13xTWupBLQ7Qjtyv0cVUj1ZRsZX2Ul2LCCzdNgJH4PHoG/XpBcuP
         cD+V5t+xkRy2V8AzdJeJBOT0MKSJEUy4tUROgDct/osH55qvmDPfDfs5uCzacFRDBjW4
         qc766AV6Ct3/P74zW3Yr5my08LXsF31x2VnKz1+jCJPsHAVbYQLQ4jO+OdmbLq4wx2bd
         TvrF5WVX6eX+8N0gpzXz3pvi0mtbnOI4xrbOjBS4wLlWAqcL0N5/hErmdFiZuO8xX75M
         vbRg==
X-Forwarded-Encrypted: i=1; AFNElJ/wDyFBBRh2wWXFU7s50eV9knJRlbBMJ5wglW3xAZbl2atRLVzuMSCdH60kIw9J1hbfca5snd1C@lists.linux.dev
X-Gm-Message-State: AOJu0Yxu3tPeQEkcui6ZrpEW5uRqgdD27aKVXkgj5arxeiZyJLeu7ThU
	lnMHaW73h0f/ehEQQStx+skOc+Tgg22foJ9H6bwrBKcCOjtEsk1aVq7I
X-Gm-Gg: Acq92OE4jihWo6BnKi0q2M7/kQoXW8pNYa+i7XH+1mRxt7rpVKp98VsgzRmv0xXRPyF
	feujcK2kM4KHUP/JVrbyHa89vMvMvrn0oAlnx2wjhHxDK/0gnuy57rcN449bAGjM7kFjD/Dq9Lk
	kmcJMMM4ozn7qanmI0Bo90Yjpv4DzDPdVLb6IdvztA268GhKNnOxwdLV8Gcw6/semvMA7rpaBJu
	Rds3aHaWaW7PfQiahoR37MkESUpz9vpii5Hia/uChRzzqcZFXKmqzuk9Zc1Ve5qLZBm82N/scgC
	yP3uG0URhVKDdPCgyt/FQBUnmpHMStWdVnfs2FlVBoVXrvhwsUKrhLSslk9vfHpemzTR/lyKoJy
	4NEQsYOlDhFVvuz9Zntp9LDhxFMDmx5GXusZRr9HERVyYnavOAaMJqF+A69keuSD0X1tA8ryHtB
	d07Xk9zR9i0qPJmqfYLl6IfiLJEVQPq2fOin1BidQg/iDbwV40DfCg15/iowJE29Ls7TyFI6VgE
	gqX0MF/Ew==
X-Received: by 2002:a05:600c:4fc6:b0:490:51e9:deba with SMTP id 5b1f17b1804b1-490c2615a5cmr34498005e9.27.1780647801274;
        Fri, 05 Jun 2026 01:23:21 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2f67c6sm23925419f8f.16.2026.06.05.01.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 01:23:20 -0700 (PDT)
Date: Fri, 5 Jun 2026 09:23:19 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Askar Safin
 <safinaskar@gmail.com>, metze@samba.org, akpm@linux-foundation.org,
 axboe@kernel.dk, brauner@kernel.org, david@kernel.org, dhowells@redhat.com,
 hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
 patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
 willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260605092319.5a1bba74@pumpkin>
In-Reply-To: <20260605015724.GA520134@ax162>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
	<20260603211736.755139-1-safinaskar@gmail.com>
	<20260604100609.6b37f500@pumpkin>
	<CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
	<20260604183829.63c35fd9@pumpkin>
	<CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
	<20260604223216.73468830@pumpkin>
	<20260605015724.GA520134@ax162>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 Jun 2026 18:57:24 -0700
Nathan Chancellor <nathan@kernel.org> wrote:

> On Thu, Jun 04, 2026 at 10:32:16PM +0100, David Laight wrote:
> > Talking of broken compilers, had you noticed that:
> > struct foo {
> >     int a;
> >     char c[32];
> > };
> > 
> > int b(struct foo *f)
> > {
> >     return __builtin_object_size(f->c, 1);
> > }
> > returns -1 (size unknown/indefinite).
> > You can't use __builtin_object_size() to stop code running off the end
> > of anything referenced by address - even when the size is constant.  
> 
> That is the entire point of using '-fstrict-flex-arrays=3' in the
> kernel:
> 
>   df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3")
>   https://godbolt.org/z/bvfrh7W58
> 
> Without it, all trailing arrays in structures are treated as flexible
> arrays, even those with fixed sizes.
> 

strict-flex-arrays got added in gcc 13.1 and clang 15.0; it isn't supported
by the gcc 12.2 on the debian 12 system I'm building kernels on.
__buitin_object_size() itself is in gcc 4.1.2 and clang 3.0.

Neither are flex arrays mentioned in the gcc docs for __builtin_object_size().

Someone might have used (eg) 'char x[4]' as a flex array to include the
padding, but no one would have used anything that extended the structure.
And the chance of those hitting __builtin_object_size() is even smaller.

-- David

