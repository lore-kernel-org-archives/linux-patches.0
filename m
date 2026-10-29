Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793274877;
	b=mrWQg65aUbv97V8L+FmLYTYlQ5F8C6nogC/jETY5PMf2OODTUAbL1+0C8PRVWApai7BR
	 /vm7u08noovUYqrhfJKp93U9N5ePJnQYmqSxu0JKjXwr7eH51CjdB2tD5AMqv3xfZTNSq
	 xVjRk/Hx6JXi4RXVH/rGVOvjwhKF4jMNXlIuCTLUHKw8ibMpW2UGR+n5R/Sh0YnUqDHfr
	 gk5L2ZQJiO7mSEqF2eQH95sYO2fIb0SsTKHzow9FQsHys/Yl1dQOi06Eefa8TbIdm1EDm
	 pi5hfoqljy6OYbsNfDowBzWsYVEd3A/SAo9bsRZO+2NojmeR3JSeotSqLLW7i8kPlfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793274877;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=TYvZH+krm10ZbTtlYRyjVUxceDUs27Kwppx7oXSDd5E=;
	b=aXkqXUHNJtqK1HZt/wOsmbVeKGbIxSdK+vxiALI83OSmqDi/p3FGB7LdV4h8cRCbxCrZ
	 vOJ/wJ3WXza3wth/2CYMShPhgzE5vgIlixqCewycayIdw3Fj8sbZgKQT57gLN8kjajfzo
	 BYEj6ruTLB9GTMKHGzfjDLW1ZDV4l44Wh6ek+B6J/tJuX4PLfAZ78OflzEq9m32lXXZ7V
	 TIke1lDtdnr4nTR3LHbNHwsTED7HOeJU9+1lqlj3dFPrSwHM9u1WfqgSF6PY+ClP4Jnra
	 UqY/nxYN/BovmItLLeIM1JaJBimg0YXnCsEhZe8qNEXS9NAtCMMjiO/g7EatI0jaWZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=XgcLI1D1;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA28606A320;
	Thu, 29 Oct 2026 11:54:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCA28606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=XgcLI1D1
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TYvZH+krm10ZbTtlYRyjVUxceDUs27Kwppx7oXSDd5E=; b=XgcLI1D1JR7rVfx6OeEd8wT/rt
	/eDK9uNpSX7LgYGEEqX32ZOkng5HG7qLvIf4YdS0HLfFT+B/NYtfeTcNv0YqeQ+9vZEcSyGIwgD2O
	Ac9VOWS0HQaePimmEPjLjpA6ue2KHRomDOD0YcMVQV5AMAuYqYd4b21pgB4mArSK9CzgbWnU0g7To
	awqogK7pVoCVlV4dvDTOwBRAkENys7OGI4pvMMntZvvwIXv1XvLcfOf6MUXjfSIFmxhOHW8ztlI26
	I4gy7BOEPD3ra1+v+3CFEhI64oSVHTG6MUElUbDORKCQx0HL9gC0C1JgT+19PkERWgW5Hhn1wRx37
	wuy8EVNg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xMOiC-000000005c2-0rXY;
	Thu, 29 Oct 2026 12:54:28 +0100
Date: Thu, 29 Oct 2026 12:54:28 +0100
From: Phil Sutter <phil@nwl.cc>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 1131/1887] netfilter: nf_tables: Extend
 nft_expr_ops::dump callback parameters
Message-ID: <auMz9PJyYo-7FrTW@orbyte.nwl.cc>
References: <20261028170459.200466217@linuxfoundation.org>
 <20261028170525.140203145@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028170525.140203145@linuxfoundation.org>

Hi,

On Wed, Oct 28, 2026 at 05:53:47PM +0100, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.

Not quite an objection (the "no functional change" still holds IMO), but
I don't get why it is being backported.

> ------------------
> 
> From: Phil Sutter <phil@nwl.cc>
> 
> [ Upstream commit 7d34aa3e03b6a56306296bd98b26c6a1710cd57b ]
> 
> Add a 'reset' flag just like with nft_object_ops::dump. This will be
> useful to reset "anonymous stateful objects", e.g. simple rule counters.
> 
> No functional change intended.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Stable-dep-of: 18014147d3ee ("netfilter: nf_tables: fix dst corruption in same register operation")

I don't see how this commit could require the extra callback parameter.
Is it really just to avoid a context change in nft_byteorder.c?

Cheers, Phil
