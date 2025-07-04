Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011842E36E7;
	Fri,  4 Jul 2025 16:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751647390; cv=none; b=kBxrZj5eu06sGaQU8gnnyn11/hZd+nmZqeVu8r6oi0LLki5paLDuG844JpVmK6PDn/DEwezsT9sV5fMOi1EMaqBb6EHHX3YRAJL1HcKK+0R/VYtmcgkKKS5HrWvcXJEFt5TNcEBuFVmQe2tFaQRr2WO2/LcT8HfVti60eCWqY0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751647390; c=relaxed/simple;
	bh=4qoTOIwb2Ll+YmW6erKwLALL2nw11zW1PeP14pgP/Xs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GCLY3aF0+Ng1urkhxf5sGmsQBdeghMc1WhpEaniLxGHNiNvHpRTVXy2g4YSPTECNkS0+UQyAaOxhh4riZLde8Lg4hWaVQt9fast4HWoEPSyfL+m9ZPo10WrNJis/+y0DxuN0M73RvabJVz3EN7V5sMFWzNOQDqtHy0yZ6Lg+/tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afLu0Vsl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afLu0Vsl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5D5DC4CEE3;
	Fri,  4 Jul 2025 16:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751647389;
	bh=4qoTOIwb2Ll+YmW6erKwLALL2nw11zW1PeP14pgP/Xs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=afLu0VslGJv7PPphYIsD2MxOmCvNTdXzx2L4ebspd4c++lQ9wbPscsBRFoyJf9oU4
	 4b7P3miACn4IbRXfgAMtsOaSM/ez/yErO0Qv7AHOTThqWbt2f+2yV46f9BuApVv/iz
	 4qOocp18UC+R0Tte601u6YOn1pfsGn43XcoX+/As=
Date: Fri, 4 Jul 2025 18:43:06 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 212/218] spi: spi-mem: Extend spi-mem operations
 with a per-operation maximum frequency
Message-ID: <2025070400-reshuffle-unreached-d650@gregkh>
References: <20250703143955.956569535@linuxfoundation.org>
 <20250703144004.692234510@linuxfoundation.org>
 <mafs04ivs186o.fsf@kernel.org>
 <2025070449-scruffy-difficult-5852@gregkh>
 <0e8c4016-3584-4db6-badb-0d6d0dc66dbe@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e8c4016-3584-4db6-badb-0d6d0dc66dbe@sirena.org.uk>

On Fri, Jul 04, 2025 at 03:39:05PM +0100, Mark Brown wrote:
> On Fri, Jul 04, 2025 at 02:17:18PM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Jul 04, 2025 at 01:55:59PM +0200, Pratyush Yadav wrote:
> > > On Thu, Jul 03 2025, Greg Kroah-Hartman wrote:
> 
> > > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> > > This and patches 213, 214, and 215 seem to be new features. So why are
> > > they being added to a stable release?
> 
> > It was to get commit 40369bfe717e ("spi: fsl-qspi: use devm function
> > instead of driver remove") to apply cleanly.  I'll try removing these to
> > see if that commit can still apply somehow...
> 
> It feels like if this is important for stable it's much safer to do a
> specific backport rather than pull in new feature enablement?

I've already dropped them, thanks!
