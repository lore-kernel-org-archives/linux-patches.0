Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5267F3DA7C5;
	Thu,  5 Feb 2026 14:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770300426; cv=none; b=FsXeoja+qBOSKZBSJK81Ss13K/3vkfNzH/Tc1aw2F4vKcHXh1X4J4lhQ2C7rD/7gnX8N0auv7HcfeW/hW3IQLzziSdEH2iUNFAtxtwv/HiqDdHBziFkFRh5Yxwk8gy5O0c3N/h4/uvI46YYaMUak77OGK4rfDB4g3VxGxpuKCck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770300426; c=relaxed/simple;
	bh=7NEGpyQ6Lj6yAwCqq7FQ98oePxaVTsZ4DvuAMrCgyRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ChalNScbbJ1U8z9BYzYoaaZgKLhFYXWFozsTWCDAh1Yeq+Sm7+nlGu1sykSppyFJ5FX8CxAU3IqrpQNBCCE2Yyu/DA8muHg9Wt52RlIYYdKO5rauLY5NDo7S49iXC6AVSVRCTRdrHtosaHv9R4Dqggq6adhjBlvkxM4GLgNsdUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBHW7shd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBHW7shd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2BBC4CEF7;
	Thu,  5 Feb 2026 14:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770300425;
	bh=7NEGpyQ6Lj6yAwCqq7FQ98oePxaVTsZ4DvuAMrCgyRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RBHW7shdL89cRWK+mvuq2qmzyeuAK2Uz2iWMXVacfwszvjgaTXHWdwZE1xIrVfFk8
	 lECSKLEwjOsIjuq8x0bTpWbePK+4FjliqL13U1XAOzakVhaU0jgPRff5erki0Om37e
	 MgDM7IzL5091nveqJWna4IpAbM3n2LtybFHjS8/E=
Date: Thu, 5 Feb 2026 15:07:02 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pimyn Girgis <pimyn@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>,
	Ernesto Martnez Garca <ernesto.martinezgarcia@tugraz.at>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5.15 195/206] mm/kfence: randomize the freelist on
 initialization
Message-ID: <2026020547-synergy-till-6a1f@gregkh>
References: <20260204143858.193781818@linuxfoundation.org>
 <20260204143905.245830999@linuxfoundation.org>
 <20260204184810.GA2715873@ax162>
 <CAJWNTGz0Yd4W3piDT5RFzmmKPhcUaNu0pSEgMOF3U0FmfsyzVA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJWNTGz0Yd4W3piDT5RFzmmKPhcUaNu0pSEgMOF3U0FmfsyzVA@mail.gmail.com>

On Thu, Feb 05, 2026 at 10:13:48AM +0100, Pimyn Girgis wrote:
> On Wed, Feb 4, 2026 at 7:48 PM Nathan Chancellor <nathan@kernel.org> wrote:
> > This introduces a new instance of -Wsometimes-uninitialized, as pointed
> > out by this KernelCI report:
> >
> > https://lore.kernel.org/177022794292.7001.3716577555750776270@22d5995788c3/
> 
> Thanks! I'll be sending a V2 shortly.
> 

Ok, will drop this one for now and wait for the new one for the next -rc
cycle.

thanks,

greg k-h
