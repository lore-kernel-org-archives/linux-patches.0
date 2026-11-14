Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794626391;
	b=cqNv55B+gotK9dLdTVYYIlvkJ0P0Yf1AS3uD70zNsbiIROutTeeuiS9XVOx6aRMXnl28
	 nLZeUJ94HrKLIsAhMZXDly0KAURTWlNJo2ffs4D6imSU1RZ/+FSUgz4P/BcOA7og9+BE/
	 XDP4XeZ9V1mlujMGI0y68uiSOgcAyfW9excEZ28j8jutFlNehZbm0hfRX7NyAz3AW8CIa
	 +5pciPftD1zhZTiRgsZF8DO3uwK0KzPl4l5HxOgJlr/L7EQKWQt59VB0p7xdiv8xkC3nP
	 PnPJoWJI8lwhTUWS4b9QyS8zsqmSic+sS0Ute/H2qTnyd7HK/OkGgItRwZWiA8G8sYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794626391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=FHM/e5uf2eSVlQ7kyM2fyd4SNEwi6bNaKWU2kNh7FPA=;
	b=xs1SQSX+Cn5s4n4qw1Z5+I4yyhbfKOZEjxRTiaLEZ4x7Zx4Gll1Av8fvRhAN3GQ2BXzO
	 jDtnDKQxWwUfeGQbKqxsqsqs9/hPJrwP97xCy7bDVJSoGWp4jrNXF4SzjzGqxRs2iCv0a
	 cP14hrJAgRQSH9koTjXGVjd4Eo7I+kKJA5WkZ0TtqjZO0JmHvu2e2EgwZSAHU/K0EN7Tb
	 atwY6gXX2pRBoqHAQ5qaXheXq3rLVXdZs5esoEeiqXI7yCnk2CAOCY6v3VMPOpMgPHUV3
	 zYZ52qzvtkwAvMlmawlTLaZi/JzFAchD48w9OKTMQgNzZzcTgysTRXLlurnySW23W1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=giD39Nh8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D961606A323;
	Sat, 14 Nov 2026 03:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=giD39Nh8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EBE1F000C5;
	Sat, 14 Nov 2026 03:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794626391;
	bh=FHM/e5uf2eSVlQ7kyM2fyd4SNEwi6bNaKWU2kNh7FPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giD39Nh8WLWpBEfojs5C/SZCwFUs6PAMJqvIYhgfX7PMOL/oLbA/NKNtF+1A2K6O5
	 zgRZViH6ye5VxOLTrMhI3+PaS8zZTrDVENTGLgmaFtVs4YjZXI4C9oWbolXgtCZZqW
	 Kway5HHWhsVZCGXLhF1QeSkKdrfJaoZVnzC6S9mMGc+8sL1/9nn4jwPciqRflu6krw
	 HJoNWlZoAxM3HZ9yhzL6C85eVDsc8LKL7RIKGWpq5hY40VlyQSqiLuNG/7gBPFq8NL
	 WJcgXwMmwZoeCzqYX8vDwfFPU14jL5pIHlQq6vDxo4yC8jmw4HSolH0EX8B2vun5nq
	 GFLTEW8qPOzsw==
From: SJ Park <sj@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	gregkh@linuxfoundation.org,
	4ncienth@gmail.com,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	corbet@lwn.net,
	david@kernel.org,
	jannh@google.com,
	liam@infradead.org,
	ljs@kernel.org,
	mhocko@suse.com,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	rdunlap@infradead.org,
	rppt@kernel.org,
	sashal@kernel.org,
	shakeel.butt@linux.dev,
	stable@vger.kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	linux-mm@kvack.org,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 7.3 463/507] mm/vma: avoid spurious write locks when mm->mm_lock_seq overflows
Date: Fri, 13 Nov 2026 19:19:42 -0800
Message-ID: <20261114031943.192867-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261114003912.82206-1-ojeda@kernel.org>
References: 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 14 Nov 2026 01:39:12 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:

> On Fri, 13 Nov 2026 10:52:47 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > @@ -589,6 +593,16 @@ static inline void vma_end_write_all(struct mm_struct *mm)
> >  {
> >  	mmap_assert_write_locked(mm);
> >  	mm_lock_seqcount_end(mm);
> > +
> > +	/*
> > +	 * VMA seqcounts are not updated on unlock, so once the mm seqcount has
> > +	 * wrapped, any VMA still carrying a sequence number from before the
> > +	 * wrap would satisfy __is_vma_write_locked() when that number comes
> > +	 * round again, and readers would not be excluded. Reset every VMA's
> > +	 * seqcount so that no stale value survives the wrap.
> > +	 */
> > +	if (unlikely(!mm->mm_lock_seq.sequence))
> > +		__mm_reset_vma_seqcounts(mm);
> >  }
> 
> In a UM ~defconfig build with LLVM:
> 
>     In file included from arch/um/kernel/asm-offsets.c:8:
>     In file included from ./include/linux/audit.h:13:
>     In file included from ./include/linux/ptrace.h:10:
>     In file included from ./include/linux/pid_namespace.h:7:
>     In file included from ./include/linux/mm.h:18:
>     ./include/linux/mmap_lock.h:604:20: error: no member named 'mm_lock_seq' in 'struct mm_struct'
>       604 |         if (unlikely(!mm->mm_lock_seq.sequence))
>           |                       ~~  ^
>     ./include/linux/compiler.h:77:42: note: expanded from macro 'unlikely'
>        77 | # define unlikely(x)    __builtin_expect(!!(x), 0)
>           |
> 
> That exists only under `CONFIG_PER_VMA_LOCK` (commit 47e725702b0b ("mm:
> make per-VMA locks available universally") from Dave's series was not
> backported).

I found same thing while running kunit.  I also confirmed both applying commit
47e725702b0b from Dave and reverting this patch fix the problem on my setup.


Thanks,
SJ

[...]
