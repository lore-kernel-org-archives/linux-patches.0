Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A2117BC9;
	Sat, 15 Jun 2024 10:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718448792; cv=none; b=YdePMkqxpD4UoYOwV1ngUyrY41pxkb+UoN80v+4BQ1V5mM2n4oLVcN3oqJ4pjjhohX5E3mz40R1r+6nNrZ6Uka87/A6x62E+/GeWS/VFhES11q4dyXSJVHrGsrNAj/Jh/CSMpeayDmMCw75kgcNHtalPVUYLyDaCWaaxEbYVkwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718448792; c=relaxed/simple;
	bh=budOsSDXDvbJZlVC8brpouBlwPcaS4rdQ5g4/xgFAh0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WSUGD+mfl/2aE37m0uTtYIUlwXSdnltXlZ3zZtfSeDMEZpoQPk/jOzXSm2c7+EDSNxj2nltiXAu/pl7D1ZpIjTQbuNH6xbzMp944q+TqOIMbOVCYVBe9vGis3TCrlQIVcVLaK7ttKUUIQF8kXB7EQgiBdlOIGtTLMB0wH/p2huc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcozfuDI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcozfuDI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA544C116B1;
	Sat, 15 Jun 2024 10:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718448791;
	bh=budOsSDXDvbJZlVC8brpouBlwPcaS4rdQ5g4/xgFAh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qcozfuDIUWpP3gBgnBiMDTxFPvTtUsaJ4anteX8HR9hPuxUoDnzt9JX8s+lFwpQg3
	 odHQdwCtdYzZH9LpUhLuBtSA/F7/sAoZJMED8hDJ/b0TNNqX19uy9Cjz8xDxPJZ6s8
	 K4R5TuXC1w1fpAYLnR/4MFTCb1xeWf0NNdK9hW+M=
Date: Sat, 15 Jun 2024 12:53:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 026/213] HSI: omap_ssi_core: Convert to platform
 remove callback returning void
Message-ID: <2024061558-rocklike-ancient-df44@gregkh>
References: <20240613113227.969123070@linuxfoundation.org>
 <20240613113229.004890558@linuxfoundation.org>
 <4yzk2jhrqq2ga5pirjlip56ezhnrdfyn6tpq2i3lhvlp3lahi7@zk4ohcap2lg6>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4yzk2jhrqq2ga5pirjlip56ezhnrdfyn6tpq2i3lhvlp3lahi7@zk4ohcap2lg6>

On Thu, Jun 13, 2024 at 10:14:59PM +0200, Uwe Kleine-König wrote:
> On Thu, Jun 13, 2024 at 01:31:14PM +0200, Greg Kroah-Hartman wrote:
> > 4.19-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > [ Upstream commit 94eabddc24b3ec2d9e0ff77e17722a2afb092155 ]
> > 
> > The .remove() callback for a platform driver returns an int which makes
> > many driver authors wrongly assume it's possible to do error handling by
> > returning an error code. However the value returned is ignored (apart
> > from emitting a warning) and this typically results in resource leaks.
> > 
> > To improve here there is a quest to make the remove callback return
> > void. In the first step of this quest all drivers are converted to
> > .remove_new(), which already returns void. Eventually after all drivers
> > are converted, .remove_new() will be renamed to .remove().
> > 
> > Trivially convert this driver from always returning zero in the remove
> > callback to the void returning variant.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Link: https://lore.kernel.org/r/bc6b1caafa977346b33c1040d0f8e616bc0457bf.1712756364.git.u.kleine-koenig@pengutronix.de
> > Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> It's unclear to me why this patch is included. It doesn't seem to be a
> dependency for a later patch?! Also .remove_new() only exists since v6.3-rc1~106^2~108
> and I'm not aware this was backported, too. So this probably results in
> a build failure. Ditto for patch 27.

Odd, both now dropped.

greg k-h
