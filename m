Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D882C749A
	for <patches@lists.linux.dev>; Wed,  5 Apr 2023 19:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oxyebGN4w9Tc2bUcUmGtLbWmMd7cSv90tfCn7BeaNE4=; b=bylkG3luwr4nDuqdrcTmlfI+IL
	IwkxblxNXhMeSPF7vjlklPRQBNqK90YVcnKYN+VzRZ+Lb77rq0Aw+y6atIGqqbdPrZNbul0bieJHZ
	4cvINOtWp2iddJixjhz5WvyJ1F0IrWsyrOwsRqzdyJ8hAWT515k/6eWze/g2Y16wVLKZ1MPH7QHIh
	lZL+WOjZ0F0KHwJLoQ+54NgXqbsHeDlIsq+zf1rKDUlpugnMvP4qBKM+VVFWw3ZCSY0Sv/7Xjn+6n
	VODGc34U2klGE/zQmMiCKdRWrdb+Ydh0vYs1zlW7MI3pqv3vltzx7GWURHtp/AaU4idrGRZ886lG0
	Tmk62b6A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pk9ER-005YBk-20;
	Wed, 05 Apr 2023 19:55:47 +0000
Date: Wed, 5 Apr 2023 12:55:47 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: patches@lists.linux.dev, linux-modules@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, pmladek@suse.com,
	petr.pavlu@suse.com, prarit@redhat.com,
	torvalds@linux-foundation.org, gregkh@linuxfoundation.org,
	rafael@kernel.org, christophe.leroy@csgroup.eu, tglx@linutronix.de,
	peterz@infradead.org, song@kernel.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com
Subject: Re: [PATCH v2 2/6] module: move finished_loading()
Message-ID: <ZC3SQ5GcRiP6iky3@bombadil.infradead.org>
References: <20230405022702.753323-1-mcgrof@kernel.org>
 <20230405022702.753323-3-mcgrof@kernel.org>
 <d6f6f4a5-2b6d-d3d6-0806-8c41ac5dcdf0@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6f6f4a5-2b6d-d3d6-0806-8c41ac5dcdf0@redhat.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Wed, Apr 05, 2023 at 07:06:35PM +0200, David Hildenbrand wrote:
> On 05.04.23 04:26, Luis Chamberlain wrote:
> > This has no functional change, just moves a routine earlier
> > as we'll make use of it next.
> > 
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> 
> I'd simply squash into #3, as that's short enough that the move doesn't add
> significant noise. Anyhow:

I'll fold that, thanks.

> Reviewed-by: David Hildenbrand <david@redhat.com>

What would be *really* nice, if you can, is an output of the new module
debugfs stats on your big system. It would be nice to also see the stats
if you revert the patch "module: avoid allocation if module is already present
and ready".

The delta between those stats should give us a more realistic analysis
of probable savings due to that patch on virtual memory on bootup on a
large system. In particular the delta between "Virtual mem wasted bytes".

  Luis
