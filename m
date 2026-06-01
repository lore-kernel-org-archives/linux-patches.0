Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142993D969D;
	Mon,  1 Jun 2026 15:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780326847; cv=none; b=DHxTlqUeJKFjgID0yXj+0sIDcZOBIFA8QeXjDSOqiP3BW7vXzBTERb8sheQNVqUsIGK4f1UpScW39NpqLWaNuQL1XCJ8vVJEimAzQbyoupsHurSPZsEmSdWARH9HpOLHbpMpsa2s+cq2uZ1gQUxH/k5Jpx5kHoYiVgF1MxK0KCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780326847; c=relaxed/simple;
	bh=/r8/hTRf1e3/XR1uKQtd4q2u0FHlFPGXLmPejXqpGnY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i80uyNsDeKPTN9t2I3zGc2FxV9QkihOrDIGMww7fTIm12s5TkzKP2ql022Xs2XXHCh0IVqceEx2A98DvhFDfG+OtVjydH8vsRZflEHwHBrgEpEemgNIXsQVUpY/IKScc1st09aVfEfeC+PEbcYdn4k6EDzRhgjCh4GYfs17NOro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vo34DCva; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vo34DCva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A1D1F00893;
	Mon,  1 Jun 2026 15:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780326845;
	bh=CS2CuwfGJBKf1xi0Ln3qGu+UNc0pZ5QADo7vWgbelcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=vo34DCvazcUboXTAXDfQs4YY62f2L8XMbmNkJoh8hdqo8mezQgiLqRtq/+92VvKq1
	 HDPLamQm5T9APSYJ0r+XC8P+LnizIFfAtVj929hGDNKLO45SRMvwmKo9ZRMN4NXFYk
	 qrA4jaitZk0geUemDe4jKZdBE80PoySkQQuuaQdU=
Date: Mon, 1 Jun 2026 17:13:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueria <victor@mojatatu.com>, patches@lists.linux.dev,
	Manas <ghandatmanas@gmail.com>,
	Rakshit Awasthi <rakshitawasthi17@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.10 211/589] net/sched: sch_red: Replace direct dequeue
 call with peek and qdisc_dequeue_peeked
Message-ID: <2026060148-zodiac-sanctuary-df36@gregkh>
References: <20260530160224.570625122@linuxfoundation.org>
 <20260530160230.510336558@linuxfoundation.org>
 <7e870e1219db98c9e19777eedfa3b0eb41f41235.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e870e1219db98c9e19777eedfa3b0eb41f41235.camel@decadent.org.uk>

On Mon, Jun 01, 2026 at 01:34:44PM +0200, Ben Hutchings wrote:
> On Sat, 2026-05-30 at 18:01 +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Jamal Hadi Salim <jhs@mojatatu.com>
> > 
> > commit 458d5615272d3de535748342eb68ca492343048c upstream.
> > 
> > When red qdisc has children (eg qfq qdisc) whose peek() callback is
> > qdisc_peek_dequeued(), we could get a kernel panic. When the parent of such
> > qdiscs (eg illustrated in patch #3 as tbf) wants to retrieve an skb from
> > its child (red in this case), it will do the following:
> 
> The same bug exists in sch_sfb and was fixed by commit 1b9bc71153b0
> "net/sched: sch_sfb: Replace direct dequeue call with peek and
> qdisc_dequeue_peeked", so please also pick that for stable.

We can for the next round of releases.

thanks,

greg k-h
