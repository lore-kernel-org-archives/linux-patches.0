Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1438151CD6;
	Tue, 20 Feb 2024 21:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464659; cv=none; b=smp5v3bqO3TSDeWU/4C8e8125V5y4J7hqYOtkbuEK9ImMkxw8BIXfWcLO0p1k0JypCxD6SUlLYLPJJl2LALr4pyNr4L8iXXC1m/DHIkhhu5R2Xk//ek96mMrXno0y2Rg8wK04Qc9khXccGojtQLbmOvGVSeixuz2976aRhbSgPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464659; c=relaxed/simple;
	bh=nPt+h9WIbsSXk5BTCCmXvq3Gq3dxggzRZBMCwBitFvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WhjDDagrgk6K0K5IhiR8mcRr3ldwnfJihuhp4pxmKueUJtpNtfrE4V2mcOv9zAc+oSs7gOwI7tbnEdcRD56pPnebAVbGC3j54yEC72yNTDRRhe0Eq7y+EJSlwdAtUfWqTGELhVLIO2r1/+E2Izp6GOcPwmQhitrfSfYLRsb+0Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=juHQSZ3y; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="juHQSZ3y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6cmqe5fdIWgo+nZk695FfE78Ci8VBBaR9MvGJF1KEbk=; b=juHQSZ3yTAJMsE/0dQZWj4Xwtz
	e3tjGQabCffXKdak9b5ebvltP8aJgfNYmv4F8IyWOw5lrDo1OI+7sumvVvxizQTCR+1DqSlbh6zSi
	NLKeDXlvnkLgYk4bUEs0IDWNZ66dzQq1R0Skfmk7RQh7Op789noyHYgXDa/U/jYRfWgfXebD9DYs4
	4Bb05/oaSSqe23PpWYUMWQhafAqpWQBKZbHtBAzxYYxHFCxUlmVGi1rV+pFgWSlRocDCBoV8kHU0L
	VmvxgEEH/Z883v/XLx+tqsEzZx3YPjil9RVw/td73bYt6GzfzT5+5NKrIfSgO3Jtwg6Ay0ONFfN9C
	5YvqLjnw==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rcXhX-0000000GcKj-0bng;
	Tue, 20 Feb 2024 21:30:55 +0000
Date: Tue, 20 Feb 2024 21:30:55 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>, Guo Xuenan <guoxuenan@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.7 070/309] readahead: avoid multiple marked readahead
 pages
Message-ID: <ZdUaD07Xb2qvH_PA@casper.infradead.org>
References: <20240220205633.096363225@linuxfoundation.org>
 <20240220205635.396911933@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220205635.396911933@linuxfoundation.org>

On Tue, Feb 20, 2024 at 09:53:49PM +0100, Greg Kroah-Hartman wrote:
> 6.7-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jan Kara <jack@suse.cz>
> 
> commit ab4443fe3ca6298663a55c4a70efc6c3ce913ca6 upstream.

ibid
