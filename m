Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F13CA12B94
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 06:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.133.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764309665; cv=none; b=cdwCzrDWB+69259Js7XIaOil4XS756ylJ0HedSM8WFilPAnS0SQ1X3M5IsQ8h7gu3RbJwcj1/PiNUFwAErT1UQqIlbf6tUVE5MBMb84Bv1Z4nzTZKtaq0+xOXr/23oAAkp6xLxqDtmHtkVhFARWbzjGM7sXPqB4voMS8lCSIbAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764309665; c=relaxed/simple;
	bh=ltlkzy516r4FUVTyg0/TB/DQALsNmgE2kdYHipLwYvk=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=J7cCuhb3pRSGC0cBgECpoLd73Pu7XjJTKLtjVJ+YPFgHkOc9R8BYw/jLd2cmZRy3WzT0+ad1lAG1q59xHjX77o2NDAtnNSBS7LPnWYVCZsqnqGqm8q32b5O79GvUBhTh5YItjrBq8unb5NShCW8ztkmwCNgm8NpYlvSd8R7UaB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk; spf=none smtp.mailfrom=orcam.me.uk; arc=none smtp.client-ip=78.133.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=orcam.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=orcam.me.uk
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 51F8492009C; Fri, 28 Nov 2025 07:01:01 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 4CB8392009B;
	Fri, 28 Nov 2025 06:01:01 +0000 (GMT)
Date: Fri, 28 Nov 2025 06:01:01 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: stable@vger.kernel.org, patches@lists.linux.dev, 
    Jiaxun Yang <jiaxun.yang@flygoat.com>, 
    Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 6.12 017/112] MIPS: mm: Prevent a TLB shutdown on initial
 uniquification
In-Reply-To: <20251127144033.363768060@linuxfoundation.org>
Message-ID: <alpine.DEB.2.21.2511280558130.36486@angie.orcam.me.uk>
References: <20251127144032.705323598@linuxfoundation.org> <20251127144033.363768060@linuxfoundation.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 27 Nov 2025, Greg Kroah-Hartman wrote:

> 6.12-stable review patch.  If anyone has any objections, please let me know.
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
