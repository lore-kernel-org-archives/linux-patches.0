Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9CD6FD6
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 16:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TTJqlOzBPX6Z6lfFHUBA0hntJ2NYe0aM0CZZgdoJKu8=; b=URtqACva/lTcYYiZuL1O+kwg1y
	QIrPTD0MuF3fUmsS/DKkTPr00LMG668SXNEFAA5HNBZnQr5CObVHs5Mayrjkhxnf/ZAY0dkuL5ZI7
	9gC86eZMhsdQ0UyfbEUa3/gCGwvwYp0rBBMTN1Ct94hqliLmowjZCYSawZCikgjLE7lpdQraexwPr
	Bg0VbchgJ3KWLoqEoTtBkcDKtQY++5jdKqaIUPLarmEBw20ri6/O51TSKqwqs5M41ndEKW2sOJhxe
	wz4xaKIzHHyn1mxRwZmyzZXVTohxvwbtjR+MoXNHI+MYdLwT2x1l+Iqu8IgtREM8F+hbwO/uNrQNv
	EU7x8Seg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pk5cZ-0053kr-12;
	Wed, 05 Apr 2023 16:04:27 +0000
Date: Wed, 5 Apr 2023 09:04:27 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de,
	peterz@infradead.org, song@kernel.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH v2 5/6] debugfs: add debugfs_create_atomic64_t for
 atomic64_t
Message-ID: <ZC2cC+I1KTyD8UcC@bombadil.infradead.org>
References: <20230405022702.753323-1-mcgrof@kernel.org>
 <20230405022702.753323-6-mcgrof@kernel.org>
 <CAHk-=whH+OsAY+9qLc9Hz+-W8u=dvD3NLWHemOQpZPcgZa52fA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whH+OsAY+9qLc9Hz+-W8u=dvD3NLWHemOQpZPcgZa52fA@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Wed, Apr 05, 2023 at 08:26:18AM -0700, Linus Torvalds wrote:
> So I realize why you use atomic64, but I really suspect you'd be
> better off with just the regular "atomic_long".

<-- snip --> 

> So something like
> 
>         debugfs_create_ulong(... &val->counter ..);
> 
> instead of
> 
>         debugfs_create_atomic64(... &val ..);
> 
> Hmm?

We already have debugfs_create_ulong(), it just uses unsigned long
with no atomic_long. I can just use that then.

  Luis
