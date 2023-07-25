Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6008F63
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 07:14:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1385FC433C7;
	Tue, 25 Jul 2023 07:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690269242;
	bh=+SlG0bjtnJ++zGZ04f+V5JuW4z0BCQ5TYV+oBvqb4eM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K5875Ne7Dm1aZ03mzNapf8TTWNh9FbG5SFBPB8H+y1gDb949yiNdYePGdxN/iHj4L
	 UuQy23nnSgod1iFSOxlim3aqMuAvGCUvECg0ITp5XqqpZazOShU5zEWZaU8gLtL6hY
	 ehaE1lFSKDD/OVFGG35wg6Z7eOMhTLz5gRtr5qnY=
Date: Tue, 25 Jul 2023 09:13:59 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "Alex G." <mr.nuke.me@gmail.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>,
	"Wu, Hersen" <hersenxs.wu@amd.com>, "Li, Roman" <Roman.Li@amd.com>,
	"Wheeler, Daniel" <Daniel.Wheeler@amd.com>,
	"eniac-xw.zhang@hp.com" <eniac-xw.zhang@hp.com>
Subject: Re: [PATCH 6.1 146/223] drm/amd/display: edp do not add non-edid
 timings
Message-ID: <2023072503-subduing-entertain-878c@gregkh>
References: <20230721160520.865493356@linuxfoundation.org>
 <20230721160527.097927704@linuxfoundation.org>
 <18e9e042-12ec-8e09-1225-ca44810e2b82@gmail.com>
 <BL1PR12MB5144A568ECEB3E9E18BA74C4F702A@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB5144A568ECEB3E9E18BA74C4F702A@BL1PR12MB5144.namprd12.prod.outlook.com>

On Mon, Jul 24, 2023 at 07:38:24PM +0000, Deucher, Alexander wrote:
> [AMD Official Use Only - General]
> 
> > -----Original Message-----
> > From: Alex G. <mr.nuke.me@gmail.com>
> > Sent: Monday, July 24, 2023 3:23 PM
> > To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > stable@vger.kernel.org
> > Cc: patches@lists.linux.dev; Limonciello, Mario
> > <Mario.Limonciello@amd.com>; Deucher, Alexander
> > <Alexander.Deucher@amd.com>; Wang, Chao-kai (Stylon)
> > <Stylon.Wang@amd.com>; Wu, Hersen <hersenxs.wu@amd.com>; Li, Roman
> > <Roman.Li@amd.com>; Wheeler, Daniel <Daniel.Wheeler@amd.com>; eniac-
> > xw.zhang@hp.com
> > Subject: Re: [PATCH 6.1 146/223] drm/amd/display: edp do not add non-edid
> > timings
> >
> > Hi Greg,
> >
> > This patch was
> >      * originally added to v6.1.35
> >      * reverted in v6.1.39
> >      * added back in v6.1.40
> >
> > This patch is still reverted in mainline. Was this patch re-added by mistake in
> > v6.1.y stable?
> 
> Yes, this patch should stay reverted.

Where was it reverted in the 6.1.y tree?  And where was it reverted in
Linus's tree?

I think the confusion here is you have the same commit in the tree with
two different commit ids.  So when I see the patches flow by, I applied
just this one to the tree, and I only see it in 6.1.40 with that id,
missing any possible revert of a previous version as the ids don't match
up.

In other words, what am I supposed to do here when you duplicate
commits?  What's the revert of this commit, is it also in the tree
twice?

thanks,

greg k-h
