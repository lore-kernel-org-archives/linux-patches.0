Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830C53D890B;
	Mon,  1 Jun 2026 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780326808; cv=none; b=ZGk3vX6opDNbnhKvRar21H8reeBYqzkp6kGZlJWLYPL1eh8iJDhgO/YsPDuyOxhC8+ndqLsLUbjAtZP6G8J8Fua9UbcUaNuJ+w/O00kz83MyHpaiW7rxJWOxB6tthIdYXAcJ4yY2IAtXj0ghc7uxqeelTxWzcnkmtUtLVI/I3fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780326808; c=relaxed/simple;
	bh=TD6ua6GJtuPKCTXaI1zduZWc/XJ7Gl2TnyWLBYxxQRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tGfrM5IgyPGx/j2lmYqtWXOxBux0Qusw+uUiaarf1XzZEcxMT/Eepv9a9pE59xWN3XDVRG/OW62p0ZkRjLpNHrnkyvt2VLC1v/3ibevH289NnzX62xY8OcKPCbieymNgXplljp4uzb5P2ZMB1KFE6pnZiAsqywdkpRPDGTG1Igk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4hSbOjw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4hSbOjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3680D1F00893;
	Mon,  1 Jun 2026 15:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780326807;
	bh=PbHIkTitXA6BGzmAPIRc4mMQco5WVW7XUxuczu1PXBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i4hSbOjw04knOXzCYWFlCPDfvc0XvAWn5dW1VjvRiCNPQjKSET4J+SyvgefuihB4A
	 lU+eEv27qbEZUYVhJ51KI/gFOX7rLuJN9VGzP3p10JlF6IkERZETQZdCD2SDlOjp7X
	 qKLs+CfycvFef06iyprBgWXr44nzpXF7AvyUgino=
Date: Mon, 1 Jun 2026 17:12:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ricardo Ribalda <ribalda@chromium.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Angel4005 <ooara1337@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Ron Economos <re@w6rz.net>,
	"Pavel Machek (CIP)" <pavel@nabladev.com>,
	Brett A C Sheffield <bacs@librecast.net>,
	Mark Brown <broonie@kernel.org>,
	Peter Schneider <pschneider1968@googlemail.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Vijayendra Suman <vijayendra.suman@oracle.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	"Barry K. Nathan" <barryn@pobox.com>
Subject: Re: [PATCH 5.10 072/589] media: uvcvideo: Use heuristic to find
 stream entity
Message-ID: <2026060104-customs-naturist-7a58@gregkh>
References: <20260530160224.570625122@linuxfoundation.org>
 <20260530160226.496219768@linuxfoundation.org>
 <5e2ac444-451c-4220-8013-0e6382b5f165@pobox.com>
 <136f03aa6f51bdfecc786e5278f5fd03b4a6966e.camel@decadent.org.uk>
 <20260601015021.rc-uvcvideo-heuristic@kernel.org>
 <CANiDSCvh6u6AWnarEtso=zKPD3upEsaJBMOm1x35fHyPMaEMyw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiDSCvh6u6AWnarEtso=zKPD3upEsaJBMOm1x35fHyPMaEMyw@mail.gmail.com>

On Mon, Jun 01, 2026 at 08:41:14AM +0200, Ricardo Ribalda wrote:
> Hi Sasha
> 
> On Mon, 1 Jun 2026 at 04:11, Sasha Levin <sashal@kernel.org> wrote:
> >
> > On Sun, 2026-05-31 at 12:53 +0200, Ben Hutchings wrote:
> > > This doesn't properly fix the problem.  Commit 3d9f32e02c2e "media:
> > > uvcvideo: Create an ID namespace for streaming output terminals" (which
> > > reverts this) needs to be applied on top.
> >
> > Rather than carry the heuristic and then layer the namespace rework on top
> > in 5.10 only, I've dropped this together with its regression source
> > 0e2ee70291e6 ("media: uvcvideo: Mark invalid entities with id
> > UVC_INVALID_ENTITY_ID") from the 5.10 queue. That mirrors what 3d9f32e02c2e
> > does upstream (it reverts the heuristic), and avoids exposing the
> > 0e2ee70291e6 regression that would otherwise enter 5.10 in the same batch.
> 
> Are you going to apply:
> 
> Commit 3d9f32e02c2e "media: uvcvideo: Create an ID namespace for
> streaming output terminals"
> ?

It wasn't planned on.

> We need either that patch or this one: media: uvcvideo: Use heuristic
> to find stream entity

What id is that?

thanks,

greg k-h
