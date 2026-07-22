Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A433F351C02;
	Wed, 22 Jul 2026 13:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784727597; cv=none; b=gNPTUmqOIclMBwyyEzdDtqhK5Q5Y3GkxW5DV+Zf++0dlD4oo+gAGDtfjeLZydXGjnf9Jkd03BEdZFB+5XQCOO29H2gRBD5+Husz2R/AppUh9zGI/ZsvwcQSTBxA5CJlpE5XyaClBC+7Fw0am2CZ4W2CidxVJcvjmZa1tJKHbOwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784727597; c=relaxed/simple;
	bh=9ovBGpAGRAAy+eFpmgNum8TFboy86/4jB4OgTOnMw+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H8XeH94qJeB8LudaGoGqiwDIfd77RmD/UZ1UPnRoqNfdmLvRrqHbTCY0d7lqHjO5EElsE6VPeUWEkQeP+nQr3/9YBMj5T/EBGMJwbT6UMOfeuf+/aOitPnk45FfqB1aL8iogGjOrM67F/+i9UZl4W8qACOM1DdHiBNr/oEzgmSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DEDXYl8r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEDXYl8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CA01F000E9;
	Wed, 22 Jul 2026 13:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784727586;
	bh=d8B9T2XktET4VRdMMXw8EWEHTpDynih6bY7MA/xUs+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DEDXYl8rfJoHfRWxQJdWBtahQ5QnA7NKTkaQMlZHbblimdp4rYlWy0KcF3ULFPI8x
	 f5wI9gMn/N7o1v8g/RkH6irwj6Fureizz/EekZsdR7ighSMjbL07txYMePYZHCat+m
	 mM58BpgBg/tctDfFBAq8q4UZjX/4ENwJk2SVbD18=
Date: Wed, 22 Jul 2026 15:39:37 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Robby Cai <robby.cai@nxp.com>,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>, Frank Li <Frank.Li@nxp.com>
Subject: Re: [PATCH 6.12 1118/1276] reset: imx7: Correct polarity of MIPI CSI
 resets on i.MX8MQ
Message-ID: <2026072205-starving-embark-2a39@gregkh>
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152511.013410224@linuxfoundation.org>
 <a64558dcb06d62931e73b638dca077ed4562779c.camel@pengutronix.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a64558dcb06d62931e73b638dca077ed4562779c.camel@pengutronix.de>

On Wed, Jul 22, 2026 at 08:36:59AM +0200, Philipp Zabel wrote:
> On Di, 2026-07-21 at 17:26 +0200, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> This patch also requires 6d79bb8fd2aa ("media: imx8mq-mipi-csi2:
> Explicitly release reset"), but I don't see that in in the list.
> 
> It's there for 6.18-stable, but missing in the 6.12-stable (and 6.6-
> stable) patchsets, I haven't looked at the older ones yet. 7.1-stable
> doesn't need it because the commit is part of v7.1.
> 
> Did we tag this incorrectly?

No, you did it right, I missed it.

But the commit you reference here is not in the 6.18.y tree, so I'll
just drop this one from all older queues as well.

thaks,

greg k-h
