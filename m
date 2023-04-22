Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044BF7F
	for <patches@lists.linux.dev>; Sat, 22 Apr 2023 03:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d/drIpsV3nVkI3AWmke+ca/OYDz5JWaoOhQ63wKz7tg=; b=t5z7h+1lNmQrXDkWpzx1/m5Gej
	XWRSmJq80eCVKtUu4NvPpX0IljSWYYX70YWBIMfZUHqOHWmbJHZyiMNO4Jto8y2JcR/+ANy2OURaN
	xRrA5kySnWRi8l0RD2t5bcv2w9p5OaP9mH5/5Ft4XedWVuOghAF4GAl15lRBazm5bSya8jIMz0VnF
	xXRfnfa9LYquFCqzBffOdnpRk58AlUQSlC24kSiMi5pnzvjuVzHTuHiJNLj4gYhmEoxo9X0uy6X6R
	ggjHKxy1Ctsgv/bs0xuZW8ENhxyLvHPdMSVVlAibXhiM0OZCo1wSlec4K+rzwM/Ve8yqQFI5s2tNN
	qYijGnzg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pq3Yg-00CHMA-1V;
	Sat, 22 Apr 2023 03:05:06 +0000
Date: Fri, 21 Apr 2023 20:05:06 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: hughd@google.com, akpm@linux-foundation.org, brauner@kernel.org,
	djwong@kernel.org, p.raghav@samsung.com, da.gomez@samsung.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, hare@suse.de, kbusch@kernel.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/8] shmem: convert to use folio_test_hwpoison()
Message-ID: <ZENO4vZzmN8lJocK@bombadil.infradead.org>
References: <20230421214400.2836131-1-mcgrof@kernel.org>
 <20230421214400.2836131-3-mcgrof@kernel.org>
 <ZEMRbcHSQqyek8Ov@casper.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEMRbcHSQqyek8Ov@casper.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, Apr 21, 2023 at 11:42:53PM +0100, Matthew Wilcox wrote:
> On Fri, Apr 21, 2023 at 02:43:54PM -0700, Luis Chamberlain wrote:
> > The PageHWPoison() call can be converted over to the respective folio call
> > folio_test_hwpoison(). This introduces no functional changes.
> 
> Um, no.  Nobody should use folio_test_hwpoison(), it's a nonsense.
> 
> Individual pages are hwpoisoned.  You're only testing the head page
> if you use folio_test_hwpoison().  There's folio_has_hwpoisoned() to
> test if _any_ page in the folio is poisoned.  But blindly converting
> PageHWPoison to folio_test_hwpoison() is wrong.

Thanks! I don't see folio_has_hwpoisoned() though.

  Luis
