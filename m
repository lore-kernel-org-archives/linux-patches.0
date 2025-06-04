Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBB028E610
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 13:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749043054; cv=none; b=SAkx4x69RiSjdNuUuqrMzg51UfCFeEvMKa55o2z47TdGwVtbMj5eIpJ1LAq/QAKhA6af4XYWJwRWH0r60DYRkpVCLxYk1X+GpLdE0R6QBjn2EPBnG1tp+dy4HquZEIBkNiRx/8B7MmNckh0s4fzkdEahqm0GoQE6iQzKKiBC8sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749043054; c=relaxed/simple;
	bh=SaOK0ZQAUONqSDIxrsA81+VoVcl56Dr4lAUQABuVeC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QIawhf5pUbInMQ1rhv22DZA22B2H45tubLOtNonTxohCE5f/g3QehHLDxtQWX1ErRqnEyLPDsokW4XHKgJPcxOLETGrgE/vlmb0i7APQbmxzAzr2idFx4TQrwdPKvIYr3mBBzPBWqYG7qTaJJ8KjwkRNJ5keUKh3tgsU/7CI0pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=d4V+36Wc; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="d4V+36Wc"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 8DA9E1FE30;
	Wed,  4 Jun 2025 15:17:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1749043048;
	bh=3SyuWV6NHe5fYNpzPQJlhMYrEuX6YZHoeMrEgSPLoms=; h=From:To:Subject;
	b=d4V+36WcZWgIqZjp5dOifiYFJ/gpF9xDjuGqwJMuOYjGOA3QxMbGycj44f8+ybSj7
	 hpLQqg0cwH3oD3bDzEJSn8gvVf3Xt0HSS3Mzx7YG0db1/ihSDTeBPhfYBIusGlZz3i
	 ROz2WxrpDhqQmRdKQee4MatPJ0kFvwmFXO6qRPe2Vhg723ERgdQRL149t8kY9oRzEp
	 0pOosA0g2JH2MdsCwZUVDdFEG8pgh0O2Or9GKasfDm17FfbWWET09F6dDERhSKd0y/
	 C6OAooIyJEEpMjM3bx213xqJygx/KBX37IEFSMO8HEbg5jgGC0sN2q8hNmmM47AVuG
	 E4jHzlMdmJa3Q==
Date: Wed, 4 Jun 2025 15:17:24 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Vitor Soares <ivitro@gmail.com>
Subject: Re: [PATCH 6.12 130/626] wifi: mwifiex: Fix HT40 bandwidth issue.
Message-ID: <20250604131724.GA273097@francesco-nb>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162450.311998747@linuxfoundation.org>
 <20250603203337.GA109929@francesco-nb>
 <2025060408-concur-bubbly-04ea@gregkh>
 <20250604102352.GB31115@francesco-nb>
 <2025060419-gloomily-exclusive-dc3c@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025060419-gloomily-exclusive-dc3c@gregkh>

On Wed, Jun 04, 2025 at 12:36:12PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 04, 2025 at 12:23:52PM +0200, Francesco Dolcini wrote:
> > On Wed, Jun 04, 2025 at 10:39:09AM +0200, Greg Kroah-Hartman wrote:
> > > On Tue, Jun 03, 2025 at 10:33:54PM +0200, Francesco Dolcini wrote:
> > > > Hello Greg, Sasha
> > > > 
> > > > On Tue, May 27, 2025 at 06:20:23PM +0200, Greg Kroah-Hartman wrote:
> > > > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > > > 
> > > > > ------------------
> > > > > 
> > > > > From: Jeff Chen <jeff.chen_1@nxp.com>
> > > > > 
> > > > > [ Upstream commit 4fcfcbe457349267fe048524078e8970807c1a5b ]
> > > > > 
> > > > > This patch addresses an issue where, despite the AP supporting 40MHz
> > > > > bandwidth, the connection was limited to 20MHz. Without this fix,
> > > > > even if the access point supports 40MHz, the bandwidth after
> > > > > connection remains at 20MHz. This issue is not a regression.
> > > > > 
> > > > > Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
> > > > > Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> > > > > Link: https://patch.msgid.link/20250314094238.2097341-1-jeff.chen_1@nxp.com
> > > > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > 
> > > > Can you please drop this patch from any additional stable kernel update?
> > > > It seems that on 6.12.y it introduced a regression, we are currently
> > > > investigating it and we'll eventually send a revert for 6.12.y.
> > > 
> > > This is already in the following released kernels:
> > > 	6.12.31 6.14.9 6.15
> > > I'll be glad to queue up the revert when it hits Linus's tree.  Is that
> > > planned anytime soon?
> > 
> > mainline is not affected, the issues seems specific of the backport on
> > 6.12 (6.14 not tested yet), therefore I do not expect any revert in
> > Linus tree.
> 
> So 6.15 is not an issue either?
> 
> > I am looking into the details now, to be sure about my finding, I'll
> > confirm you in the next few days.
> > 
> > If you prefer to not wait, given that this fix was just improving the
> > performance of a specific use case, you can just revert from 6.12.y and
> > 6.14.y.
> 
> And 6.15?  I'd prefer if you submit the revert as that way it can
> contain the relevant information about why the revert is only needed
> in the stable kernel(s) and not also in Linus's tree.

After more testing I can say that this commit is just broken on
every tree, I'll send a revert to mainline soon, and after that you
should get it like any other fix.

Thanks
Francesco

