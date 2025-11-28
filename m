Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2491EA7CE
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 06:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764310177; cv=none; b=PGkZ4/0oI3W5+3c7cGFuvar7qgcUGBFQAofAsCbCphbGYh63rVSBhnH+Ve1ltAvJo+VTDmESTM4rGwaN1spp4bC6LMvE5EnQ1BcWAu8n7N3CayoSsPfg4tTS0Qba0pOB3kZKJwY0+QnHV4KprY7azkXc0TyG3sYPTza22v6Jf0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764310177; c=relaxed/simple;
	bh=AMp14WINIiXz4lFUnpjkw+AIMlDjBzt2f1/SWLh6Zs0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Jpz/rRUS1ZvfL0L04s1cWkOxNI6D5xKhs++kLNXB5huuV7GP/gA9iJM+n/gvoipgBsQHcwD50NsbYpUN4c6PSJhvZ+WZYLD4fXdmak1xHnoGgMxKoGiOMu70hxxT8Y+GFf6zFGKNfGKF+Zy73QTDGFdhV/Dk/0BnMNGMqD/O+8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 6F8E092009C; Fri, 28 Nov 2025 07:09:34 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 6D8F092009B;
	Fri, 28 Nov 2025 06:09:34 +0000 (GMT)
Date: Fri, 28 Nov 2025 06:09:34 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: stable@vger.kernel.org, patches@lists.linux.dev, 
    Jiaxun Yang <jiaxun.yang@flygoat.com>, 
    Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 6.6 10/86] MIPS: mm: Prevent a TLB shutdown on initial
 uniquification
In-Reply-To: <20251127144028.191081287@linuxfoundation.org>
Message-ID: <alpine.DEB.2.21.2511280609070.36486@angie.orcam.me.uk>
References: <20251127144027.800761504@linuxfoundation.org> <20251127144028.191081287@linuxfoundation.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 27 Nov 2025, Greg Kroah-Hartman wrote:

> 6.6-stable review patch.  If anyone has any objections, please let me know.
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
