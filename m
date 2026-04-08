Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4C43537D4;
	Wed,  8 Apr 2026 05:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775624874; cv=none; b=N3GWXWRf6RNaRODeTrodwWzI0y1gqqGoBiDWZOrcvD6+TkiwqG0BIvbZRP9nIuQ1tatN9copHIFUyTYRyBqK+43zSl5p79SP2ipVxjWJgHTevxmvLLLr7tQ+VOE4q5f5r44eXicd7ECQ13CBywtPAASE2gei4ZrbO1BV7P1sH5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775624874; c=relaxed/simple;
	bh=srLmUvQdvTJDubI7nKXl1g+qVOS/2WR3VVvr42qaZew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Po6xtHNhVJ0smor5L7BwwF3EVJ8Mg20mYnQZtPJvdhKGxyrb9Yulmjl5+JZAkpcNAMsdHY/SqdzjFyWa1LSqK17RHRhBgYIM/GGJbdOtLwfkWUYUHl7Z3sqSrnHNZuB/qJ3i4lmXpFMuIVZbIPHlyXrDU19ATt8X2cnMBA6eMG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2GAe0leo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2GAe0leo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=97+kDSoiuCcJBtYApNDv3NnLQb4wfJSfthVbBjwlPEM=; b=2GAe0leosWfiMDlXC6+OtXbXUy
	xDg2f1HG/pDUhyn1cyxvHdGCdFCf1mnwfIYT1tenkhgeOEScbQHM2e8tP/11SlBL9q0/FrfOVIZdx
	8w9oFx7MnxEQ5fHvthfEbW4YkeoSE4w3+E9SgYJKE6bBUyDfKumRWFEEm9fKVP1/M1dfaDp9ufglv
	hEwp96FMWKK/iArCtRkXcUxwvgYwQZs+v4XQvgLKI+9B6Clhu44X6ZQGGLXsDKcEopTW1kDVYxDzI
	+zc3HeSuDY17pIVkJAm/MuFwNN7ChJ014VbCuEJfXbbQ6nltdNOnCf3bgtl+hCf7MzHPH+NsN6IFL
	kHPRhcDw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAL8l-00000008GnN-18qE;
	Wed, 08 Apr 2026 05:07:47 +0000
Date: Tue, 7 Apr 2026 22:07:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>,
	David E Box <david.e.box@intel.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v4 1/7] platform/x86/intel/pmt: Export PMT enumeration
 functions as GPL
Message-ID: <adXiozY7LdDNvAd-@infradead.org>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-2-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330214322.96686-2-tony.luck@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Mar 30, 2026 at 02:43:16PM -0700, Tony Luck wrote:
> The symbol_get() function requires that objects be GPL licensed.

Please don't add new uses of symbol_get, as we've been slowly trying
to kill it off.  If you have bidirectional dependencies just add an
registration module in the middle to resolve it.

