Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD14E12B94
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 06:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764309699; cv=none; b=bvPLBtP7YRQjqlvAQJ4605lpzrJ2O/N2OwMLlm5l6CdlDB03MJzSQkZz5fellyrtD2UiLMjtrhxnfsIEjxQ7FTGYmEE1BsR3udV7GtzhSCj2w6g4JKyDVa9Rgjb+tj9A5/eREJ6qNRoT2VccTXWjiXuiz6mLafkKw52N7pnMDTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764309699; c=relaxed/simple;
	bh=K6RSpQzF4uF/QtlTPVP9+JsM196wIrAYRo7LWxQ867U=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lODMQUwBwU4yCf5TvccZzG2Y6Szkof58idlqL5ac5ZdjuFcip9lRd9holslx419dF6bsf1xiw84iC6k62uGCnk6ixDHTmhr/RuzyhyInKDIXrW6OTYE3E/sZQtu0HWHGcP4BnvDA4j4c7z6z2PXduSmNeUdtiPKA9IRgHLx+IEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 96F4A92009C; Fri, 28 Nov 2025 07:01:36 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 8FB2A92009B;
	Fri, 28 Nov 2025 06:01:36 +0000 (GMT)
Date: Fri, 28 Nov 2025 06:01:36 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: stable@vger.kernel.org, patches@lists.linux.dev, 
    Jiaxun Yang <jiaxun.yang@flygoat.com>, 
    Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 6.17 026/175] MIPS: mm: Prevent a TLB shutdown on initial
 uniquification
In-Reply-To: <20251127144043.919172913@linuxfoundation.org>
Message-ID: <alpine.DEB.2.21.2511280601110.36486@angie.orcam.me.uk>
References: <20251127144042.945669935@linuxfoundation.org> <20251127144043.919172913@linuxfoundation.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 27 Nov 2025, Greg Kroah-Hartman wrote:

> 6.17-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Maciej W. Rozycki <macro@orcam.me.uk>
> 
> commit 9f048fa487409e364cf866c957cf0b0d782ca5a3 upstream.

 So this caused a regression for a subset of systems.  A fix is in review,
so I think this will best be dropped at this point and then cherry-picked
along the fix.  I've arranged for this to happen via patch prerequisites
already.  Please let me know if there's an issue with this approach.

  Maciej
