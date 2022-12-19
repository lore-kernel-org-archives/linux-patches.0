Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD0910EF
	for <patches@lists.linux.dev>; Mon, 19 Dec 2022 10:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B0BC433D2;
	Mon, 19 Dec 2022 10:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1671444997;
	bh=9oSB6wA8J0Fzx083OD1V1hloA8OfjH0qFSMJ7us/7WY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CtINC5s/cgbuu3HFa9IFKokcpDAxtvkkrFG7lq+neuxtRFk12UkcOMDgCZnPTwjfz
	 inoU3m51/gfUPKIvL4yUCrkVcQm7kMv6mrE7B6meG1zwbAouCj91yewXH+pzCSIAxM
	 EqMVqA2yzGwiB9/FZtyx0WyY13p3PBSMyWuYs96g=
Date: Mon, 19 Dec 2022 11:16:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 11/14] net: fec: dont reset irq coalesce settings to
 defaults on "ip link up"
Message-ID: <Y6A6AZRYm4Yq3cIz@kroah.com>
References: <20221215172906.338769943@linuxfoundation.org>
 <20221215172907.210669704@linuxfoundation.org>
 <6314ea2f-61f7-2c5a-86d3-1158b80bd5d4@rasmusvillemoes.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6314ea2f-61f7-2c5a-86d3-1158b80bd5d4@rasmusvillemoes.dk>

On Fri, Dec 16, 2022 at 10:13:48AM +0100, Rasmus Villemoes wrote:
> On 15/12/2022 19.10, Greg Kroah-Hartman wrote:
> > From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> > 
> > [ Upstream commit df727d4547de568302b0ed15b0d4e8a469bdb456 ]
> 
> You should not take this unless you at the same time also take
> 
> commit 7e6303567ce3ca506e4a2704e4baa86f1d8bde02
> Author: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Date:   Mon Dec 5 21:46:04 2022 +0100
> 
>     net: fec: properly guard irq coalesce setup
> 
> which
> 
>     Fixes: df727d4547de (net: fec: don't reset irq coalesce settings to
> defaults on "ip link up")
> 
> The same of course applies to the 6.0.y series.
> 
> I don't know if your scripts already do this and it just somehow failed
> here, but it would probably be a good idea to always check if there is
> already a Fixes for a commit that gets chosen for -stable.

Ick, sorry, I thought I did run my "are there fixes for the queue"
script, but it looks like I did not at all, thank you for catching this!
I've now queued it up.

greg k-h
