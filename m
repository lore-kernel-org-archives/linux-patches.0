Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AFA7B
	for <patches@lists.linux.dev>; Sun, 16 Apr 2023 06:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3S2OOnJJ8beQt9IJrgqG2y+T0Oivm/faajqfKrVbumQ=; b=pcz9RqNqYSB4GSZ2YJL1uvq4xJ
	ssb58CLFAEtw81Rh6EiicB3PCWTtavS/EpV50BfW+W+AMlDiPFvx+H7AraQFjl89ABDxhF/zViGTm
	DZOcE13/EKgMq1duxT3w6kG3kJQUv5csC7edSTBesWvWmW31ggxL2U4QXiGWFp/xtpuFZ+sORdE0z
	pjB/RN38m6FN+Po4gObhsSTnSg9LCaQ7Z/lUD5VcDpdQzqU4/oPot+SIwWA/E9Cn4xe6Rs/vfFTJ3
	ziKiIib3dxU3GShZFtVaXhDduJ3SC96gc34eY0IoiNgDbEUaIBsMAIsDILQuAbTd76V8tpMWiLFKN
	pBEpmt+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pnvUi-00DCX2-2h;
	Sun, 16 Apr 2023 06:04:12 +0000
Date: Sat, 15 Apr 2023 23:04:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: david@redhat.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, petr.pavlu@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org, rafael@kernel.org,
	christophe.leroy@csgroup.eu, tglx@linutronix.de,
	peterz@infradead.org, song@kernel.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com
Subject: Re: [RFC 2/2] kread: avoid duplicates
Message-ID: <ZDuP3OCzN3x4NxRZ@infradead.org>
References: <20230414052840.1994456-1-mcgrof@kernel.org>
 <20230414052840.1994456-3-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414052840.1994456-3-mcgrof@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Apr 13, 2023 at 10:28:40PM -0700, Luis Chamberlain wrote:
> With this we run into 0 wasted virtual memory bytes.

Avoid what duplicates?
