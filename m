Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B414748AE00
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 17:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780594714; cv=none; b=YNRxWu5JR17mK6o956ylh5FA8OdmXNH+xzDblGrgr7aHUrpsg3245suGQFTIzKTcf/mcUZDxBV1tiZJMC1uIeU1nfpcLr0DuJ4E9oZqlc2EDEiAKjGROS5fXVbS1QXtt0ulfvnMeFtPxbdpr+72XOhqNRJrzKw5urGnYrp9LpQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780594714; c=relaxed/simple;
	bh=v2KH0A+T/5unV0mAelk5zB+47zjGgz9MT7jM30vb1s0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWU9M70b7mEQBDT4xPiK/iHzHOdvscj+B9mYzLimHbWff5jxj1t7DMr6JrQTiTfoOFB1cAw2p65feNSdwn2etpCoW66rlqGC+HI4ibFmC3vQXJ5u9rE/gdz+xH+RH2Ua/2hiXoZNsYHmbbNVRfwuic5K6O/7JNy1xK5gdmfkg4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HP5Jyc51; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HP5Jyc51"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490b12270b3so6531855e9.1
        for <patches@lists.linux.dev>; Thu, 04 Jun 2026 10:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780594711; x=1781199511; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aDxRgk4KLva6cv7jp07s/JuZGm0Suw+6/YbYX6FRPfQ=;
        b=HP5Jyc51S0triCv3j/+oLKoHPDR/HX6BHPEVmIvSBI34dIZ3bSLmQGm6scqfeRthPL
         Pq5uW0EbhfmcKUOUU37tlh2feif+jQF4PF/TgBdIAbpz0XEf2JwZ9ruLC/x5+VRgg6Mw
         QpTaTH064iPDWFTooCplzocsk1ldaA/9Lgzlg2EQzp8AcWZGj5ZKbYaF3AN9L7F69f/v
         E1OoqVLMkIUzm2Aq2aigzrrNK5mYeoR+MUNZuosMQYxraazQaSorrMFWGu9RZ2xP1mGL
         /R2qdkcyI/13whfxMfK0EUnCzcF3QmHhICrCig3zYk3D1dtlDtdXNhnjknplm70FbcaA
         364g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780594711; x=1781199511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aDxRgk4KLva6cv7jp07s/JuZGm0Suw+6/YbYX6FRPfQ=;
        b=GP26tZ0L9djoqjWG88KkD4kh8m72T9l5VftbjSUQBRZsCv++wdGz8sEwnWAgwLhaZK
         g8Wvdu5CeIVsukSWm7/xeXs6vGJVITofydwCgNAkIj69FFEZ+xHs6ttGl2KD22L4Vv8k
         4ojKvFo9G25SOul15u/t0XTtXC/iVc1joRmoxReVAOqJAYRE/w5vFhVn+KdQfGoshc4e
         atDnNxTEwB7dwQfgfVkMAh3xi2MLu9suTFw6e4ZN6v02FsdUzUnrvQN45deMsoelW1sv
         MZJ1wRmepEgGAdYHAqaYV6D3wRoBV2jI6Gr2kB2lEAFf7iWL0cXbeRaMvIGqRvRKG2Wm
         QcjQ==
X-Forwarded-Encrypted: i=1; AFNElJ/iDHZp6PiHGu9BM+9piiezz1q6uh+Um8pf5EQ1UVbDn3Iue1khN2uQzZNSM6K8I2enrjSxUuu9@lists.linux.dev
X-Gm-Message-State: AOJu0YzK0hUb2d+pIcLHICpyKDHATNZvhbGVswvBgDQ10ivDO3DO1mbj
	dQj/Y3cX8aNcswOWCUYfaaI+aElYuByGNKfr1+jCd5brSr5zCociLDZF
X-Gm-Gg: Acq92OEgRPF/dbWwU29KWmrgg1MrJZJviA6lLgiLSad3GW4Okbdu3RUba9Ap+rPXrDf
	pFQu7hom0yfTaPY4EPZgbaUCFXcikOyvv8lxDyZNhGmm/X69WJ8pjF012ikB4eBljoPt+onnnPO
	FcXCBeApHdEIaMoDRjjVV2CaQzgiTn990mM9MA4rHpRZ4MBD4qs5IxxE/uFHPA4KfCNwt9aCGZb
	585NUfYihFHImhNX1Rq9c2hLIz9bBhOTKQEJF98Oz6EJ0bbk2z1UaiBFlzxvMPI+WVcFzQYGIs6
	Fg12TncfRVl65raFyYeFzR04ylmONh0H3b0xJFIYsHO0pd8buSE89Jy5OygU0lfh844boIR3jwL
	9xUTa/DzTcmm0faZKQYB66XZe1YfWo8G2DYlF1X5uVBMRDd7FLdb3atUF2nuto+d/iqzaUz348a
	nadJ74z6wYr4gYTlHZniCt+AI1V1/GKACKk2efUAjKPmxZy7elfLNxmrg9HG8LffQ6pqihCJc=
X-Received: by 2002:a05:600c:1c13:b0:490:b642:ce29 with SMTP id 5b1f17b1804b1-490b642cea1mr153777325e9.8.1780594710934;
        Thu, 04 Jun 2026 10:38:30 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3cc140sm105657875e9.9.2026.06.04.10.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 10:38:30 -0700 (PDT)
Date: Thu, 4 Jun 2026 18:38:29 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Askar Safin <safinaskar@gmail.com>, metze@samba.org,
 akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
 david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
 netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de,
 viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260604183829.63c35fd9@pumpkin>
In-Reply-To: <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
	<20260603211736.755139-1-safinaskar@gmail.com>
	<20260604100609.6b37f500@pumpkin>
	<CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 4 Jun 2026 07:17:10 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 4 Jun 2026 at 02:06, David Laight <david.laight.linux@gmail.com> wrote:
> >
> > Something needs to ensure that the high 32bits of the fd get masked off
> > on 64bit systems.  
> 
> That something already exists: CLASS(fd, f)(fd);
> 
> It ignores the top bits, because 'fdget()' takes an 'unsigned int'.
> 
> We have been a bit random in how we declare the system calls in
> general, and we mix 'unsigned int' and 'int' and 'unsigned long'
> pretty much randomly when it comes to file descriptor arguments to
> system calls.
> 
> fs/read_write.c in particular uses all three cases with no real logic to it all:
> 
>   SYSCALL_DEFINE3(lseek, unsigned int, fd, ..
>   SYSCALL_DEFINE3(readv, unsigned long, fd, ..
>   SYSCALL_DEFINE4(sendfile, int, out_fd, ..
> 
> but then anything that uses fdget() (through one of the helper classes
> or not) will simply not care.
> 
> Does it make sense? Is it pretty? Nope. Does it matter? Also nope.

I know it has mattered elsewhere, and is easy to get wrong because
'mostly it works'.

At least u32/u64 is reasonably sane - the called function has to ignore
the high bits (at least on x86).

Bool is another matter entirely, (IIRC from a couple of weeks ago)
gcc will assume that the low 8 bits of the parameter register are
either 0 or 1 and clang assumes that the low 32 bits are 0 or 1.
You can't even check with 'if ((u32)bool_param > 1) error()' because
the compiler 'knows' it can't be false.
It all dumps you down one of the UB 'rabbit holes'.

-- David

> 
>                   Linus

