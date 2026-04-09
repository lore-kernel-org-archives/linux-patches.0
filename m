Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA2128E0;
	Thu,  9 Apr 2026 05:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775713292; cv=none; b=UN26hqNtPMWjA8YPycuZF/m6cs7yyNBZu+6NQEl5KffQYqbcRtFUkBilYfLw2iOH2eWQX1+C4y72s9FzNk2BZK0zXxltY1K7MlAPELve5XPfZYkBLMYAH/ZM+ZbSBPhExsJbqDm2FTsbd8Lek7yAtV/rlCjH55tlzfwF5cMJDmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775713292; c=relaxed/simple;
	bh=nGirnteKIO3RjaMYyQUGiDeSJgAys7LoIRU3oePa7oI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZbJoMAZC45pNSxdQjNDHxLwJT2PzU78MFqfvk45CBom0a4kJe3LyRJ4dRfMGAA07fUNtYMHi2bkxSa5OVRyJYPfIhRZH2R0/eN1A6OdOtY3dw12BfbKu/FXdgl0Cz/YBJdOvjAM7vKKX8xasgcM2fwlGE9iz5EPlFB3Vk7U7CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Sizuifu7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Sizuifu7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZLCCyzWYFHEQR7tg/cTuWmU89fPgRi7uYotr+oWPAE0=; b=Sizuifu7Wa8FmNknKdxXPk7do7
	t4vtHx/O+vz6SbNTuNb9CIR59ljLrOkQL+U6J5xGYiiK4ln/eDsiHk76OWvxhzpV7R/VF6Pb2NAk+
	0Wdd8360/FGxZXmw74Rle7EKGgbjD9YIYFwcdNTMJppwbe2Zuwdxu0/CoxHGmwVNyKq5dNhC5J9GB
	lIc8eoc3PCfr6GyTKI7bsLGh58KQn9Zhbi5LM1TJKJhYQlSXr5+uIZH55SISn7cDm96dqa5FXYHfh
	13IXy5fF9xhLpibOb91gdi0gjqRgdKHQyseJ7QNBnTe1ljy85ADQ8eEbmjtQuAONEPj3Y/Jk2S0RM
	TpzuZ9Wg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAi8r-00000009jDH-1p02;
	Thu, 09 Apr 2026 05:41:25 +0000
Date: Wed, 8 Apr 2026 22:41:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Fenghua Yu <fenghuay@nvidia.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"Wieczor-Retman, Maciej" <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>,
	"Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [PATCH v4 1/7] platform/x86/intel/pmt: Export PMT enumeration
 functions as GPL
Message-ID: <adc8BWwX2xZOlO3_@infradead.org>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-2-tony.luck@intel.com>
 <adXiozY7LdDNvAd-@infradead.org>
 <SJ1PR11MB6083ECB77F9AC85C2E8F94F0FC5B2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ1PR11MB6083ECB77F9AC85C2E8F94F0FC5B2@SJ1PR11MB6083.namprd11.prod.outlook.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Apr 08, 2026 at 05:01:54PM +0000, Luck, Tony wrote:
> >> The symbol_get() function requires that objects be GPL licensed.
> >
> > Please don't add new uses of symbol_get, as we've been slowly trying
> > to kill it off.  If you have bidirectional dependencies just add an
> > registration module in the middle to resolve it.
> 
> In my case I have "resctrl" (which is built-in, and likely to stay that way) that
> needs functions from the "pmt_discovery" module to enumerate which
> event counters are present.
> 
> Should I add  EXPORT_SYMBOL_GPL(some registration function) to resctrl
> 
> and have the pmt_discovery code call that to provide pointers to resctrl?

Yes, if your dependency only goes one-way against the normal flow,
that's by far the easiest.  Bonus point for bounding that registration
on an object fitting the natural scope through OF/fwnode/acpi_dev or
whatever fits here.
