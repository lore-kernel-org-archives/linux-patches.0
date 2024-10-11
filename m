Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9301F4FA8;
	Fri, 11 Oct 2024 04:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728621632; cv=none; b=sevC0uNbjVHAEmHLTQGKQMD+GQTDqThXdecCcZXG1HlBavVeC9R2Ibi8LtCRpf9Sunaa/LVEzzPOQb78KpylMZ33ZHRA1g33t9QZ2+kzxLGJCbB4Uu3ZXQKWoWmK0khibakOq7D+IS3MXq8o60I4Abxx2PefpK5MyaMpbXCNQQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728621632; c=relaxed/simple;
	bh=+YNhMZek5Cz1sAZjYXSGYefXwdTMR4QEkx1Ja9qinY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gexVrcbwMP30tQHRGjq22Y+ir+bCW0bJLiifLPnDoeSRBs/RI4gkwfsa0SjSKFj+ejXG+/uSHnMCbuc9HZN/bNLttEQnN5CC2u98hKVBHwsUr4lqLH5BFbdRfB/odwxXpz/vUr5S+jwQPXICKn5X3y5hUxrypHjXf17KH0qBGCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGH9c/JL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGH9c/JL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A93C4CEC7;
	Fri, 11 Oct 2024 04:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728621631;
	bh=+YNhMZek5Cz1sAZjYXSGYefXwdTMR4QEkx1Ja9qinY4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oGH9c/JLfzIi7LmCgnJLvUXXe/AHcCTYPvTAi8AAHbqJS74+frLLux3QBUM7WjiiX
	 pfxkHm/07UVlZ5ZSNzEcHs2nzUetktCVT77TpJIcHam9wtWScy1ACq507EPiCYSS+N
	 uKEThi7/6A9Le9bM9ESZtSDzgzY160fy+pHjJkO4=
Date: Fri, 11 Oct 2024 06:27:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wei Fang <wei.fang@nxp.com>
Cc: =?iso-8859-1?B?Q3Pza+Fz?= Bence <csokas.bence@prolan.hu>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Paolo Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 028/386] net: fec: Restart PPS after link state change
Message-ID: <2024101126-pointer-broiling-298f@gregkh>
References: <20241008115629.309157387@linuxfoundation.org>
 <20241008115630.584472371@linuxfoundation.org>
 <1af647ce-69e4-4f86-b0a5-6ac76ec25d12@prolan.hu>
 <2024101033-primate-hacking-6d3c@gregkh>
 <PAXPR04MB8510F6DD068CE335D6D7202188792@PAXPR04MB8510.eurprd04.prod.outlook.com>
 <2024101158-amid-unselfish-8bd7@gregkh>
 <PAXPR04MB8510550283CD0BBF5BD351E488792@PAXPR04MB8510.eurprd04.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PAXPR04MB8510550283CD0BBF5BD351E488792@PAXPR04MB8510.eurprd04.prod.outlook.com>

On Fri, Oct 11, 2024 at 03:34:57AM +0000, Wei Fang wrote:
> > > >
> > > > Great, we can pick it up once it hits Linus's tree, please let us
> > > > know when that happens.
> > > >
> > >
> > > Hi Greg,
> > >
> > > The patch has been applied to Linus's tree, thanks.
> > 
> > What is the git id of the commit?
> 
> The commit is 6be063071a45 ("net: fec: don't save PTP state if PTP is unsupported")
> 

Thanks, now queued up.

greg k-h
