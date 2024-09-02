Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F2B433B5
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 06:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725259375; cv=none; b=OsEuGpbGJklTB2ebCzd+kdtQRZeCMeHXOY0b8uQ/yUyFWUyztwwyLjnnWg7HWLRypg06HnBjbdxdineDNColOp4xb6PP35k2E9p0EzYC4VIzViCMc5Jkvcva/F+Ds0JFoEKN7VDudSlVUecE/DJyu3cALRobkcwcPmdEE7692VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725259375; c=relaxed/simple;
	bh=YuJhfr/6n8ZUQkW0SqrSgb1QZEMtZXbRPnwl6+57OUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dSP4Fy6+RFGxSeW4VRK+YgLc1xgU6bGDtPe55dss2wbP1D27qiahrWpllmkEr4uUP8ghPkfQFrXTt+0nJOD2GMN4PQgRjrdTlZpa5dXtOaVfSQGMxSnMAa/UWx7saJqQxOZT8zkI6FthQOUkeuaG5vLVn8JeeLPGgkcYSO5mYOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=Mew2LRYE; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="Mew2LRYE"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 4B41A14C1E1;
	Mon,  2 Sep 2024 08:42:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1725259371;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/hMd0tOh3JzV5Ri3bdf1HBQ4Ddkhg2Xw0cqqBCjSIgk=;
	b=Mew2LRYE22O1KE2u2ytocMIJhNYP3QrB/EVLEbbe3IJwri67UJPymA1PUWyXGrhI6tDzQB
	6aF9mLLYOdROMYX9UDFRrdGG3dDwr5Jc1UDSSyBVMOow5KDEREFxejfttibouh9nroI8ja
	2i6rm8Yx1bxdvh3T1frgZT5muWGcEwE6P5pZZ8T0z/g+4xIQi02IGyXzCY4g29BOu/wtDg
	A8kvIhHt1fHlQK0AoLmLZC2Q7kxG8j/6voYu8xDhhvJ8LCclg86Izc4gJmsPUFk7lYrvCc
	PLrOIyJCBiT9aWlmMULozRySXzLIr35l4Mw8Z2lAUuXx+crM7pX3Zf6lEQpkBQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id af1c5266;
	Mon, 2 Sep 2024 06:42:48 +0000 (UTC)
Date: Mon, 2 Sep 2024 15:42:33 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 130/151] Revert "Input: ioc3kbd - convert to
 platform remove callback returning void"
Message-ID: <ZtVeWUa4L3F-EDc2@codewreck.org>
References: <20240901160814.090297276@linuxfoundation.org>
 <20240901160818.998146019@linuxfoundation.org>
 <ZtURsofEb-WmU69f@codewreck.org>
 <2024090259-sultry-cartel-8e0e@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2024090259-sultry-cartel-8e0e@gregkh>

Greg Kroah-Hartman wrote on Mon, Sep 02, 2024 at 08:03:24AM +0200:
> On Mon, Sep 02, 2024 at 10:15:30AM +0900, Dominique Martinet wrote:
> > Greg Kroah-Hartman wrote on Sun, Sep 01, 2024 at 06:18:10PM +0200:
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > > This reverts commit 0096d223f78cb48db1ae8ae9fd56d702896ba8ae which is
> > > commit 150e792dee9ca8416f3d375e48f2f4d7f701fc6b upstream.
> > > 
> > > It breaks the build and shouldn't be here, it was applied to make a
> > > follow-up one apply easier.
> > > 
> > > Reported-by: Dominique Martinet <asmadeus@codewreck.org>
> > 
> > It's a detail but if you fix anything else in this branch I'd appreciate
> > this mail being updated to my work address:
> > Reported-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
> > 
> > (Sorry for the annoyance, just trying to keep the boundary with stable
> > kernel work I do for $job and 9p work on I do on my free time; if you're
> > not updating the patches feel free to leave it that way - thanks for
> > having taken the time to revert the commit in the first place!)
> 
> We can't really change things that are already in the tree, so we just
> copy the commit directly from that, sorry.

This commit isn't in tree yet -- it's a patch specific to the 5.10
branch that doesn't exist anywhere else (not a backport), and 5.10.225
hasn't been tagged yet.

With that said I'll reiterate it's probably not worth the trouble,
just replying because I don't understand where that "already in the
tree" came from.

Thanks,
-- 
Dominique
