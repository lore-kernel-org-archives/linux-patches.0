Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923C82104
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 10:50:47 +0000 (UTC)
Received: by mail-ej1-f54.google.com with SMTP id t17so72579688eju.1
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 02:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IkatKLJ3qYUKGORjBOFQcSqkI25EQPSR3fb3zK2nRZ4=;
        b=iWv5WTf9UYUuf08z/VB2JfMIE2Vf/mX8RiJQCXh8o+R7kTpPjQtiY2DfPkxIsy3e1a
         iYO78jxMxb/OWEJRoxhW7QA2CNeEs0/XBRslGsuvgpHq64xTuBJaw6IK2ibAz6FRMsmy
         WZbjY0u9VFC8NSi/DIETtu1jzJeNtxZ8fxsUjj7Rv88UjLTQxBF2VB3lrJOibB6qUNSX
         JHgikcIgm8z7OMovght+ngiurPmA08t6bWkotxpNQYwiC8kv+MQGPgOCTVita7HptoHA
         9EKMQA4GqgNQ16jP5+TuW/P71kBjHVzwAAP3DQjwPVt2WfqO4oJUi4qCrpz0M9r3UyUM
         Q32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IkatKLJ3qYUKGORjBOFQcSqkI25EQPSR3fb3zK2nRZ4=;
        b=1a/c1tUFeI3VE0s0Rb6tLlbsPdaqe+c6mNlIlyFC31O3rYghLX2DzVfF2fpUGSDDTL
         RzlmrfZC9dZhMtCRJqwxLmHkW+eM+jWOpzKUFknf0CqL2pIPX2gsLSIIEpeeM9ryPcd9
         3f34VOmdnb1EOdsccjhwDCiq7wCnjOzb5cheTDgPdDbHa7kll67YAEDKopcuWfGQZ1YE
         9A04Y2/sjjrHcHQWfei2pqYMurQiC10xENPboTbEnZNXWyJ6TG2Np8cEHEbbjzz6ZckF
         LjiwTu9/eqgLaq5VqOXAtGTKaMVdo0wUUB4Xgda8M0cF7/5/o+CcMMWtBoPS7692pVvY
         XhmQ==
X-Gm-Message-State: AFqh2kpO6BZA5ssvAn7qdWOsDhEr8gNHcNl75TGSlcXO202fOEl+cejM
	5Zgy/T2jGANB+GTNkqLZvcM=
X-Google-Smtp-Source: AMrXdXsqrbLRQvWkdEnkoyrRn7PkXm7IBeuwAzwJNn66HH7AqMNyRJOiDOPxeMEZTTvwvguSTVcNMw==
X-Received: by 2002:a17:906:7fc2:b0:838:9c66:cd2f with SMTP id r2-20020a1709067fc200b008389c66cd2fmr35132067ejs.74.1672743045865;
        Tue, 03 Jan 2023 02:50:45 -0800 (PST)
Received: from gmail.com (1F2EF380.nat.pool.telekom.hu. [31.46.243.128])
        by smtp.gmail.com with ESMTPSA id jg34-20020a170907972200b0084cb8589523sm3545273ejc.139.2023.01.03.02.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 02:50:45 -0800 (PST)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Tue, 3 Jan 2023 11:50:43 +0100
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
Message-ID: <Y7QIg/hAIk7eZE42@gmail.com>
References: <20230101162910.710293-1-Jason@zx2c4.com>
 <20230101162910.710293-3-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230101162910.710293-3-Jason@zx2c4.com>


* Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> The vDSO getrandom() implementation works with a buffer allocated with a
> new system call that has certain requirements:
> 
> - It shouldn't be written to core dumps.
>   * Easy: VM_DONTDUMP.
> - It should be zeroed on fork.
>   * Easy: VM_WIPEONFORK.
> 
> - It shouldn't be written to swap.
>   * Uh-oh: mlock is rlimited.
>   * Uh-oh: mlock isn't inherited by forks.
> 
> - It shouldn't reserve actual memory, but it also shouldn't crash when
>   page faulting in memory if none is available
>   * Uh-oh: MAP_NORESERVE respects vm.overcommit_memory=2.
>   * Uh-oh: VM_NORESERVE means segfaults.
> 
> It turns out that the vDSO getrandom() function has three really nice
> characteristics that we can exploit to solve this problem:
> 
> 1) Due to being wiped during fork(), the vDSO code is already robust to
>    having the contents of the pages it reads zeroed out midway through
>    the function's execution.
> 
> 2) In the absolute worst case of whatever contingency we're coding for,
>    we have the option to fallback to the getrandom() syscall, and
>    everything is fine.
> 
> 3) The buffers the function uses are only ever useful for a maximum of
>    60 seconds -- a sort of cache, rather than a long term allocation.
> 
> These characteristics mean that we can introduce VM_DROPPABLE, which
> has the following semantics:
> 
> a) It never is written out to swap.
> b) Under memory pressure, mm can just drop the pages (so that they're
>    zero when read back again).
> c) If there's not enough memory to service a page fault, it's not fatal,
>    and no signal is sent. Instead, writes are simply lost.
> d) It is inherited by fork.
> e) It doesn't count against the mlock budget, since nothing is locked.
> 
> This is fairly simple to implement, with the one snag that we have to
> use 64-bit VM_* flags, but this shouldn't be a problem, since the only
> consumers will probably be 64-bit anyway.
> 
> This way, allocations used by vDSO getrandom() can use:
> 
>     VM_DROPPABLE | VM_DONTDUMP | VM_WIPEONFORK | VM_NORESERVE
> 
> And there will be no problem with OOMing, crashing on overcommitment,
> using memory when not in use, not wiping on fork(), coredumps, or
> writing out to swap.
> 
> At the moment, rather than skipping writes on OOM, the fault handler
> just returns to userspace, and the instruction is retried. This isn't
> terrible, but it's not quite what is intended. The actual instruction
> skipping has to be implemented arch-by-arch, but so does this whole
> vDSO series, so that's fine. The following commit addresses it for x86.

Yeah, so VM_DROPPABLE adds a whole lot of complexity, corner cases, per 
arch low level work and rarely tested functionality (seriously, whose 
desktop system touches swap these days?), just so we can add a few pages of 
per thread vDSO data of a quirky type that in 99.999% of cases won't ever 
be 'dropped' from under the functionality that is using it and will thus 
bitrot fast?

The maintainability baby is being thrown out with the bath water IMO ...

And we want to add more complexity to a facility people desperately want to 
trust *more*? [RNG]

What's wrong with making mlock() more usable? Or just saying that "yeah, 
the vDSO can allocate a few more permanent pages outside of existing 
rlimits & mlock budgets"?

The rest of the series looks fine to me, but this special one of a kind 
VM_DROPPABLE is just way over-engineered cornercase functionality that 
pushes us well past the maintenance_overhead<->complexity trade-off sweet spot ...

Thanks,

	Ingo
