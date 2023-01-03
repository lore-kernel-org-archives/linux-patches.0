Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA438F47
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 18:15:54 +0000 (UTC)
Received: by mail-ej1-f44.google.com with SMTP id gh17so76062825ejb.6
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 10:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=miPQO7iyS3ienKf9idBPEEE606/4jeUgjmeR9+HTk7Q=;
        b=ZqEip8pDG0jjqj1ZwdnGcMq6QyiWN5RDnAQHdgahxdX8tRjPBkv7t2J7tyNrq0jnlX
         lsy7PPudtJXMglGFHVeym7Qrr+i1IkTT5uq/ImqVn1eIkVMbgP1wN4Wzumyag5+h1ehl
         pfUSospnNnUzNyQTmoyF86QJQS7fQI/V5PKn69aLGxR6uaik+6SylMppoZFzqhpmjM0b
         MK/RjdLM1RAnzrgDJ47LPGvPqybqffXNuz01JFCYnU5y8Ngl/wxbmSTCwVeL86FQ2Iiw
         gp3OHRLt3zxmHnE7YFLGB9XoI4e5QKw4y28ZiPC/jFfX64AeleVLaoMEwEe/6j9XN09I
         FCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=miPQO7iyS3ienKf9idBPEEE606/4jeUgjmeR9+HTk7Q=;
        b=D0qTiT6fGAZp/F6dSePxYmnTUYEHH5kNT/wgHozv8BTerWlzrFqv+gafqMvTGKmNSZ
         oTXJjmFsmv2KSy1hUjQXUKlSGQH/Ft9Jss++JVCxn5KCDHw77x+yDenCK2oVKwHkG86D
         W3dWWKKc4Sd24q4aJhQB9Mbeu20G7eq4MNqBqOtSquvLUOdy1zeP2kD+24gsaO4HbE5i
         L2X0WDumUHPLTP49FcHgGri7ar6jD+0m78ObAXzh4CqT99p5uoXN3xMoAybx0LkVpDNq
         17/PqsIQRoTyMdvgdTufaoMTuXiUB718AkrQvujlaCTHPKWBj0okoFmeRzqDL+uRltaI
         KzNg==
X-Gm-Message-State: AFqh2ko9SLlJKJJAjptc25ZNzjl8mBDv5dq/rCQxIQeAJZJM0cvi1z6L
	bXqfyjIr73Y3IRt2SLB1lRo=
X-Google-Smtp-Source: AMrXdXuaJ9JajfrxwPkyilr6jRFT1qpJnTZirLCHffgNrq6vaJTpOXjTiVH09Ai1mjZn+dTBYTadnA==
X-Received: by 2002:a17:906:18e2:b0:7c1:4bb:b157 with SMTP id e2-20020a17090618e200b007c104bbb157mr46737681ejf.4.1672769753197;
        Tue, 03 Jan 2023 10:15:53 -0800 (PST)
Received: from gmail.com (1F2EF380.nat.pool.telekom.hu. [31.46.243.128])
        by smtp.gmail.com with ESMTPSA id ky16-20020a170907779000b00826afe264bcsm14372976ejc.194.2023.01.03.10.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 10:15:52 -0800 (PST)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 3 Jan 2023 19:15:50 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	tglx@linutronix.de, linux-crypto@vger.kernel.org,
	linux-api@vger.kernel.org, x86@kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Carlos O'Donell <carlos@redhat.com>,
	Florian Weimer <fweimer@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Jann Horn <jannh@google.com>,
	Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v14 2/7] mm: add VM_DROPPABLE for designating always
 lazily freeable mappings
Message-ID: <Y7Rw1plb/pqPiWgg@gmail.com>
References: <20230101162910.710293-1-Jason@zx2c4.com>
 <20230101162910.710293-3-Jason@zx2c4.com>
 <Y7QIg/hAIk7eZE42@gmail.com>
 <Y7RDQLEvlLM0o4cp@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7RDQLEvlLM0o4cp@zx2c4.com>


* Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> On Tue, Jan 03, 2023 at 11:50:43AM +0100, Ingo Molnar wrote:
> > 
> > * Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > 
> > > The vDSO getrandom() implementation works with a buffer allocated with a
> > > new system call that has certain requirements:
> > > 
> > > - It shouldn't be written to core dumps.
> > >   * Easy: VM_DONTDUMP.
> > > - It should be zeroed on fork.
> > >   * Easy: VM_WIPEONFORK.
> > > 
> > > - It shouldn't be written to swap.
> > >   * Uh-oh: mlock is rlimited.
> > >   * Uh-oh: mlock isn't inherited by forks.
> > > 
> > > - It shouldn't reserve actual memory, but it also shouldn't crash when
> > >   page faulting in memory if none is available
> > >   * Uh-oh: MAP_NORESERVE respects vm.overcommit_memory=2.
> > >   * Uh-oh: VM_NORESERVE means segfaults.
> > > 
> > > It turns out that the vDSO getrandom() function has three really nice
> > > characteristics that we can exploit to solve this problem:
> > > 
> > > 1) Due to being wiped during fork(), the vDSO code is already robust to
> > >    having the contents of the pages it reads zeroed out midway through
> > >    the function's execution.
> > > 
> > > 2) In the absolute worst case of whatever contingency we're coding for,
> > >    we have the option to fallback to the getrandom() syscall, and
> > >    everything is fine.
> > > 
> > > 3) The buffers the function uses are only ever useful for a maximum of
> > >    60 seconds -- a sort of cache, rather than a long term allocation.
> > > 
> > > These characteristics mean that we can introduce VM_DROPPABLE, which
> > > has the following semantics:
> > > 
> > > a) It never is written out to swap.
> > > b) Under memory pressure, mm can just drop the pages (so that they're
> > >    zero when read back again).
> > > c) If there's not enough memory to service a page fault, it's not fatal,
> > >    and no signal is sent. Instead, writes are simply lost.
> > > d) It is inherited by fork.
> > > e) It doesn't count against the mlock budget, since nothing is locked.
> > > 
> > > This is fairly simple to implement, with the one snag that we have to
> > > use 64-bit VM_* flags, but this shouldn't be a problem, since the only
> > > consumers will probably be 64-bit anyway.
> > > 
> > > This way, allocations used by vDSO getrandom() can use:
> > > 
> > >     VM_DROPPABLE | VM_DONTDUMP | VM_WIPEONFORK | VM_NORESERVE
> > > 
> > > And there will be no problem with OOMing, crashing on overcommitment,
> > > using memory when not in use, not wiping on fork(), coredumps, or
> > > writing out to swap.
> > > 
> > > At the moment, rather than skipping writes on OOM, the fault handler
> > > just returns to userspace, and the instruction is retried. This isn't
> > > terrible, but it's not quite what is intended. The actual instruction
> > > skipping has to be implemented arch-by-arch, but so does this whole
> > > vDSO series, so that's fine. The following commit addresses it for x86.
> > 
> > Yeah, so VM_DROPPABLE adds a whole lot of complexity, corner cases, per 
> > arch low level work and rarely tested functionality (seriously, whose 
> > desktop system touches swap these days?), just so we can add a few pages of 
> > per thread vDSO data of a quirky type that in 99.999% of cases won't ever 
> > be 'dropped' from under the functionality that is using it and will thus 
> > bitrot fast?
> 
> It sounds like you've misunderstood the issue.
> 
> Firstly, the arch work is +19 lines (in the vdso branch of random.git).

For a single architecture: x86.

And it's only 19 lines because x86 already happens to have a bunch of 
complexity implemented, such as a safe instruction decoder that allows the 
skipping of an instruction - which relies on thousands of lines of 
complexity.

On an architecture where this isn't present, it would have to be 
implemented to support the instruction-skipping aspect of VM_DROPPABLE.

Even on x86, it's not common today for the software-decoder to be used in 
unprivileged code - primary use was debugging & instrumentation code. So 
your patches bring this piece of complexity to a much larger scope of 
untrusted user-space functionality.

> That's very small and basic. Don't misrepresent it just to make a point.

I'm not misrepresenting anything.

> Secondly, and more importantly, swapping this data is *not* permissible.

I did not suggest to swap it: my suggestion is to just pin these vDSO data 
pages. The per thread memory overhead is infinitesimal on the vast majority 
of the target systems, and the complexity trade-off you are proposing is 
poorly reasoned IMO.

Anyway:

  > Don't misrepresent it just to make a point.
  ...
  > That seems like a ridiculous rhetorical leap.
  ...
  > Did you actually read the commit message?

Frankly, I don't appreciate your condescending discussion style that 
borders on the toxic, and to save time I'm nacking this technical approach 
until both the patch-set and your reaction to constructive review feedback 
improves:

    NAcked-by: Ingo Molnar <mingo@kernel.org>

I think my core point that it would be much simpler to simply pin those 
pages and not introduce rarely-excercised 'discardable memory' semantics in 
Linux is a fair one - so it's straightforward to lift this NAK.

I'll re-evaluate the NACK on every new iteration of this patchset I see.

Thanks,

	Ingo
