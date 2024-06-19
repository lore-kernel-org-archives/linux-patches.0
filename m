Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BD3125C9;
	Wed, 19 Jun 2024 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718806620; cv=none; b=QcOdutJttFH+YaTLo7fXfKZkgD0DashyjwdCI7E3/rwdOyQthRgC/tcYDJ/1DzXAwSZiKJ4H/PpnsMe0GfxU2I/h5pMeKmowqkGEK8Uo9mNn+FUjamW7sgNpr6rIeMYVvjeoE+PFcPUpyhMy+stv4LNwh4vHaHe+SbZff4hXJgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718806620; c=relaxed/simple;
	bh=U78dG7ay6Z6stYMXeY4z3olLbftB6uTCp+H5K1LJWaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IgaK3PHxRIqRQqAac7PucMXdEQbUyjtHjY9Zjfa+F4MPC25cAn64rzOQtzl1+i9qqn7S2O2P2fxrJz7eIND3IIHh3Z5a5RSw0SvnWh6kLCuSs3skvsLo0GB+rsUQCEJZI5FXMlG0auBSJFGp+DS4xdg9vV0YskyXfk6iVKmnV14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4o80CmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4o80CmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC4FC2BBFC;
	Wed, 19 Jun 2024 14:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718806619;
	bh=U78dG7ay6Z6stYMXeY4z3olLbftB6uTCp+H5K1LJWaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s4o80CmErPUS6TT482NcCiAzSpjAEevN9GVCHhhQ9HOM6CeIY2xJ6iksWwvEDxo/r
	 M5OnsbQLgChrT3b7FMBpcWnk7TKKYz5DygED4NpA1XOsfrj4P2UveZ9lCO+hv2iPo8
	 dhc7swujQ0kWxErYTCuMLwx++cgNYtmC4u86fq30=
Date: Wed, 19 Jun 2024 16:16:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Francois Dugast <francois.dugast@intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.9 073/281] drm/xe: Use ordered WQ for G2H handler
Message-ID: <2024061946-salvaging-tying-a320@gregkh>
References: <20240619125609.836313103@linuxfoundation.org>
 <20240619125612.651602452@linuxfoundation.org>
 <ZnLlMdyrtHEnrWkB@fdugast-desk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnLlMdyrtHEnrWkB@fdugast-desk>

On Wed, Jun 19, 2024 at 04:03:29PM +0200, Francois Dugast wrote:
> On Wed, Jun 19, 2024 at 02:53:52PM +0200, Greg Kroah-Hartman wrote:
> > 6.9-stable review patch.  If anyone has any objections, please let me know.
> 
> Hi Greg,
> 
> This patch seems to be a duplicate and should be dropped.

How are we supposed to be able to determine this?

When you all check in commits into multiple branches, and tag them for
stable: and then they hit Linus's tree, and all hell breaks loose on our
scripts.  "Normally" this tag:

> > (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)

Would help out here, but it doesn't.  Why not, what went wrong?

I'll go drop this, but ugh, what a mess. It makes me dread every drm
patch that gets tagged for stable, and so I postpone taking them until I
am done with everything else and can't ignore them anymore.

Please fix your broken process.

greg k-h
