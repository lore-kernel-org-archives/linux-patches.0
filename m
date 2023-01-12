Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A6279F8
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 17:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20128C433EF;
	Thu, 12 Jan 2023 17:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673543781;
	bh=3bnWEPduZsTwoZhQ+s+9BJcG/wOwJICZoWcN1mmU7uM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jMY3W59b5D875v21/LsMe6rUopf5u1kdYDQs4FyBuwYoDO24ROHV8ABKroOA/5hJa
	 gA/BOV4bF51tBgTiIne7EeIGog+BEsF0DVQj66ZPkcyk23JS/HnWsmLOWxRG3b3+QX
	 pfJD4YKNEdmILqXx56r00Qx3F+k0WhoEfQYqnw6o=
Date: Thu, 12 Jan 2023 18:16:17 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Luben Tuikov <luben.tuikov@amd.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	AMD Graphics <amd-gfx@lists.freedesktop.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 108/148] drm/amdgpu: Fix size validation for
 non-exclusive domains (v4)
Message-ID: <Y8BAYV0Q+YdcGXAK@kroah.com>
References: <20230110180017.145591678@linuxfoundation.org>
 <20230110180020.610387724@linuxfoundation.org>
 <e4b4b0ca-b6e6-70ae-1652-3df71df53ab4@amd.com>
 <Y8A6AC9DrYfO1c4+@kroah.com>
 <ee614df9-390b-1736-c2a3-3157e47f9d6a@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee614df9-390b-1736-c2a3-3157e47f9d6a@amd.com>

On Thu, Jan 12, 2023 at 11:59:06AM -0500, Luben Tuikov wrote:
> On 2023-01-12 11:49, Greg Kroah-Hartman wrote:
> > On Thu, Jan 12, 2023 at 11:25:08AM -0500, Luben Tuikov wrote:
> >> Hi Greg,
> >>
> >> The patch in the link is a Fixes patch of the quoted patch, and should also go in:
> >>
> >> https://lore.kernel.org/all/20230104221935.113400-1-luben.tuikov@amd.com/
> > 
> > Is that in Linus's tree already?  if so, what is the git commit id?
> 
> I just checked, and not yet. Just wanted to give a heads up.
> 
> It does have a Fixes tag, and I hope it would be picked up automatically,
> when it lands in Linus' tree.

That does not always happen if it does not have a "cc: stable@..." tag.
So when it does land in Linus's tree, please let us know the id so we
are sure to pick it up.

thanks,

greg k-h
