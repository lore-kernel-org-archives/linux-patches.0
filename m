Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFD2226CF8;
	Fri,  4 Jul 2025 12:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751631442; cv=none; b=SVqQKPWji4eSl432ZoxSQj2ThE3YPlU1oqmcyLyqMyd0B7lzSlAltlxqorVhp/r3Mn/ELvZTMaQTSvWwO4Iy7MuvRDl6NAkw0IZMV+I/JF2f/bUihJ8BjJev9jK9vklEXJvA8wS8KV2kMyVMED22NcdwP2Tw7nU6h4zpS/Kz2ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751631442; c=relaxed/simple;
	bh=b6DmQUOnUnxb+8+INRF3vIrQO26qGuTsbK5EYLGcbKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qBQcU3/MOIJsvnx6pxan4q/1WGFH8M9nRhENa2FGbWap+EdDRlgYnh0ZutFm1pqEjnp3su9y/weuwu3vWEd9vHBoRAx1CgZpVgnn1+EpFukaa6ZCf4TXTZOLrX0boMlgSCnPc+6hJXfUOn/Z40A/KkRPlNGtfSfmCBhVhfUDFks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTbUOuqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTbUOuqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACECAC4CEE3;
	Fri,  4 Jul 2025 12:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751631441;
	bh=b6DmQUOnUnxb+8+INRF3vIrQO26qGuTsbK5EYLGcbKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KTbUOuqah6/h6zGuqpk3aManWWqd7i0CuMoaItJLF+hkG/H7+ZLBt2dHAXG+7lmf4
	 MnOr4BqhzTaTT7reBehwQ7hq6XX+HBEiO6YxT0vJv2KkmHxGz1uA2IaBiw9/pdsdIb
	 TtnQBlBWJ4PyrIY2bGLtvjc5kbarEJpJFIjmONbQ=
Date: Fri, 4 Jul 2025 14:17:18 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 212/218] spi: spi-mem: Extend spi-mem operations
 with a per-operation maximum frequency
Message-ID: <2025070449-scruffy-difficult-5852@gregkh>
References: <20250703143955.956569535@linuxfoundation.org>
 <20250703144004.692234510@linuxfoundation.org>
 <mafs04ivs186o.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs04ivs186o.fsf@kernel.org>

On Fri, Jul 04, 2025 at 01:55:59PM +0200, Pratyush Yadav wrote:
> Hi Greg,
> 
> On Thu, Jul 03 2025, Greg Kroah-Hartman wrote:
> 
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> This and patches 213, 214, and 215 seem to be new features. So why are
> they being added to a stable release?

It was to get commit 40369bfe717e ("spi: fsl-qspi: use devm function
instead of driver remove") to apply cleanly.  I'll try removing these to
see if that commit can still apply somehow...

thanks,

greg k-h
