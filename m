Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C591D1F37A9;
	Wed, 18 Dec 2024 18:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734546217; cv=none; b=n20im3O+8O9j959IJbjRX3gozyk/R/gQ19POQz7FTY/FhVhaCr+J22/H88Wae70sAnwWnIEfmgsvoh2v/kv6e98oaLnzWP+ap+38KDV6hkIf3n5Zfa0BRMvRQIumCa6JoAsX3CiAE1fOwGaHYZML4R8CTT7ixB3oRE7ucpHbH/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734546217; c=relaxed/simple;
	bh=c6eelvsTAfT5X3Bvf7o8FkL3v/cSWYPHNIXU0zEvr9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tl6SBxQHM8q7GEm2MiYPJa7ohhzuvBD9W95f2aOg5Il3kjnm2jXs59aGsdqos/YZuuIaYuzULuQgwehpdHCiBk9Iu7dTmJOonOmJMe6ZFeCJDstMY+NcMjDL8HIm2IAknSdtFg7JnV6uchMaeBlO25IDpUpugqUpJwQ4dQk+CEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SAy9W0Bg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SAy9W0Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2E3C4CECD;
	Wed, 18 Dec 2024 18:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734546217;
	bh=c6eelvsTAfT5X3Bvf7o8FkL3v/cSWYPHNIXU0zEvr9o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SAy9W0Bg4qqIUGVmO1nEwLMRKyEcrXkH3PUeZvy9IZDboYxSh/bp4NiBnqWnDcdRB
	 AGNmGwzolzSEWZN5k5hwKp50KiN7KoplZcI8soIdh62MJCTGmh0P/deU89A0HP988m
	 1ONgti1RI5X/DsaDF0rmHimjGOk+QvFmRxYV5IelT7H34Uw0GkSg67fRecJF/h2HE3
	 ZVaLdRtq4WxNK2YnN1j/UWl6R1xz1NbNvlpwN/gdp+h+laPdumshxGmf9LfSubjl7n
	 eMBtJ+rOI/9Kd4WeBdwg0iRdbSB9+kUNro5hQIO+7MNfgux+ovJhY4V5V5984UN35j
	 YKmQV2JlPnv/w==
Date: Wed, 18 Dec 2024 11:23:33 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Brian Cain <bcain@quicinc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-hexagon@vger.kernel.org" <linux-hexagon@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] hexagon: Disable constant extender optimization for
 LLVM prior to 19.1.0
Message-ID: <20241218182333.GB2948182@ax162>
References: <20241121-hexagon-disable-constant-expander-pass-v2-1-1a92e9afb0f4@kernel.org>
 <20241217174425.GA2651946@ax162>
 <DS0PR02MB102502302B8074AFA8BB1BAFEB8052@DS0PR02MB10250.namprd02.prod.outlook.com>
 <CH3SPRMB000129CE377EDA52BF102593B8052@CH3SPRMB0001.namprd02.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH3SPRMB000129CE377EDA52BF102593B8052@CH3SPRMB0001.namprd02.prod.outlook.com>

Hi Brian,

On Wed, Dec 18, 2024 at 04:19:23AM +0000, Brian Cain wrote:
> > I'm sorry.  You should not have to send these changes to Linus. I should have
> > carried it in my tree and proposed it to Linus.
> > 
> > I'll do that, if you don't mind.
> 
> I see it's landed.  Sorry, all.  I'll resolve to do a better job here.

As Nick said, no worries, these things happen. If going straight to
Linus gave the impression that you did something wrong or inadequate, I
apologize, as that was not the intention. I seem to recall even recently
him saying that he does not mind applying patches directly from the
mailing list and bypassing the maintainer/subsystem when it fixes an
issue (cannot find the exact message I am thinking of but [1] is also
good). Since this patch is small and limited in scope, I figured it was
not worth any more pings.

That said, consistent ownership of arch/hexagon patches would not be a
bad thing going forward :)

[1]: https://lore.kernel.org/CAHk-=wgQhFPvneqAVXjUZDq=ahpATdgfg6LZ9n07MSSUGkQWuA@mail.gmail.com/

Cheers,
Nathan
