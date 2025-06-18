Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCA22F198F;
	Wed, 18 Jun 2025 16:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750263574; cv=none; b=BGkAo96HB4QDbZvDeSpSPq2qAa6NJos0UCHt3r8TDGGKHcF0l55OSPy0XMda0zXbg/r8Tamt/DfYNG7bExy2nK+T7hO6dOjPkO58A6mmA+GWTHHY0c1sZ0s/LvZzAFWe5E8a6yRczuWQfEWFIDmLhilgpJt/SQXjzXx1j9YifFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750263574; c=relaxed/simple;
	bh=syhFbGgEObu4TOaoxP9tpPZtN+UBv/r1Z8al1qx2G0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kd61j3ZbpKeuJoNizKWZ0e35Rte7LL7vats9SaTasaNevQwB0Sg6IgRXPoKemB88Q3GjMjrauDb12yyj91ih1dcaUAcwy34EuI9GDkkp/+cgQIZ0xeUpiddDgzHMa3JXUuDUc9ugHkSNI4smyTmoffKX5XPx4w+jWhG53bDZL3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=TFszi2pG; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="TFszi2pG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=3UluqgWAu/lwV8xeEZHVSPQLQFvvrdw80mnEo1qNNf0=; b=TFszi2pGTCXwWivG
	P1zZ67tPKNGs7sAHOWRvG/ml+UKl7siAxbB5hLvJ4HrenbHungz1QAfxDfjI0uZV6IeCiwavHgKL2
	zqUzyv6HqFManyDP+wvnXovpqVsd6BCJ4GzYMO5XTX3aI209vVSliU++iVitUpsdTz+QhGp3y0/po
	xg+Yj/fsIAh5sFmeYrm9EOIB9gpHtuifSh8q/6hgAUmLzF4Y/AcBdX6KyoOtmvM/YvKO1KD2C3wjo
	OSem7erDgZYimYtHWErAI94LJSRoRL+iYdQ+u+m7yy3FImR6TkGMxWn+jbP2u+ZSy/J1lyMbSfgJs
	AnfaQDbn54KuidUQIQ==;
Received: from dg by mx.treblig.org with local (Exim 4.96)
	(envelope-from <dg@treblig.org>)
	id 1uRvVS-00ARGe-2b;
	Wed, 18 Jun 2025 16:19:22 +0000
Date: Wed, 18 Jun 2025 16:19:22 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>, perex@perex.cz, tiwai@suse.com,
	yuehaibing@huawei.com, linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.15 101/110] ALSA: seq: Remove unused
 snd_seq_queue_client_leave_cells
Message-ID: <aFLnChz3gg_tZg9j@gallifrey>
References: <20250601232435.3507697-1-sashal@kernel.org>
 <20250601232435.3507697-101-sashal@kernel.org>
 <aDznZgej_QbaalP0@gallifrey>
 <aFLXcQc6Wg41gPSJ@lappy>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <aFLXcQc6Wg41gPSJ@lappy>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.1.0-34-amd64 (x86_64)
X-Uptime: 16:18:36 up 52 days, 32 min,  1 user,  load average: 0.05, 0.02,
 0.00
User-Agent: Mutt/2.2.12 (2023-09-09)

* Sasha Levin (sashal@kernel.org) wrote:
> On Sun, Jun 01, 2025 at 11:51:02PM +0000, Dr. David Alan Gilbert wrote:
> > * Sasha Levin (sashal@kernel.org) wrote:
> > 
> > Hi Sasha,
> > 
> > > From: "Dr. David Alan Gilbert" <linux@treblig.org>
> > > 
> > > [ Upstream commit 81ea9e92941091bb3178d49e63b13bf4df2ee46b ]
> > > 
> > > The last use of snd_seq_queue_client_leave_cells() was removed in 2018
> > > by
> > > commit 85d59b57be59 ("ALSA: seq: Remove superfluous
> > > snd_seq_queue_client_leave_cells() call")
> > > 
> > > Remove it.
> > > 
> > > Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> > > Signed-off-by: Takashi Iwai <tiwai@suse.de>
> > > Link: https://patch.msgid.link/20250502235219.1000429-4-linux@treblig.org
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > > 
> > > NO This commit should not be backported to stable kernel trees for
> > > several reasons:
> > 
> > I'd agree with that big fat NO - unless it makes your life easier backporting
> > a big pile of other stuff.
> > I'm a bit curious about:
> >  a) How it got picked up by autosel - I'm quite careful not to include
> >     'fixes' tags to avoid them getting picked up.
> 
> autosel does it's analysis based on LLMs rather than just commit tags.

To be fair the bot's conclusions were right; give it a treat.

> >  b) Given it's got a big fat no, why is it posted here?
> 
> I was trying to be too smart :)
> 
> My scripts got confused by the "YES" later on in the explanation.

Ah, OK.

> Now dropped!

Thanks.

Dave

> -- 
> Thanks,
> Sasha
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
