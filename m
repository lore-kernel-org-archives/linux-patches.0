Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349CC3FD4;
	Sat,  4 Jan 2025 04:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735963520; cv=none; b=dhnRR0eXX3Rv+wtqEwHrwNK3dK0uTvLZdCTaecxSi/b4tkwd4yuZuObN3kV2QAvp9WY8WlxYwuZCz8Dcrk3xbUH/IREHWVkgEwStG8apZZkl7Ht/OqhZ6zFbQmOKlc2BsCLgiP2enXc7pl5Th+1CP54NvF7xOmDjxcYXicoFn/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735963520; c=relaxed/simple;
	bh=I5lcpf+2196mF8WsSVvfBbsb5tz5HY8Z4ku/ydrbKZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oc42xo4UeQ+91r4udgl8BZOIsjDTXOWWEpWW+PGyVcxWQP4eQMMEIExhQ5SRLH4LADSjC+N6poWM77CxMuA8a5uVYMoAdKc4QrwfKbilj5DFhjSHfgU8NUBvCYTkK1+YwzpOeu3eKNCyo0dVmlvUgVI0pPKWCcoxMOGoLKugCsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hv+on270; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hv+on270"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972D4C4CED1;
	Sat,  4 Jan 2025 04:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735963519;
	bh=I5lcpf+2196mF8WsSVvfBbsb5tz5HY8Z4ku/ydrbKZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hv+on270f6SqIMICtxAdhZoH38MNRqUHN4ORgs1PnZaSI1wAaCKVALck5BeBc4muL
	 xsvQ3QuSZ0SOhelmu7IZr8+CuWxCbVRe9Q/X3ORmKXAXyrpTOilafiyMI26pbeoGdU
	 hyI7qPIRryEQgALYE55PK4L9/bQ2MCN/rYazsuHwej1madGvb4OWCT8KIUPLR66OPC
	 SxPT+wtd7GYdrDfpwiT40I47GlbEO05eDzDsAn5yHP4gG0Y2r83fyr6VYPBbmdNqiY
	 ddpEhENPMsxpw4ciCB4ePXDrSFDlooo7exmQcRoV7Q8qPA5ATwehbmQPYx4W9bFq9W
	 xghbhpGP9dv+Q==
Date: Fri, 3 Jan 2025 20:05:18 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "martin.wilck@suse.com" <martin.wilck@suse.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests] nvme/053: provide time extension alternative
Message-ID: <Z3izfuH1Dd6IQ-jA@bombadil.infradead.org>
References: <20241218111340.3912034-1-mcgrof@kernel.org>
 <53p73kfx7akmecsc3sofrmga7o7m32gg2lp7e44nacxgwarfoo@u74aepo5erqs>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53p73kfx7akmecsc3sofrmga7o7m32gg2lp7e44nacxgwarfoo@u74aepo5erqs>

On Fri, Dec 20, 2024 at 11:37:03AM +0000, Shinichiro Kawasaki wrote:
> 
> Martin, what do you think?

Martin, poke.

  Luis
