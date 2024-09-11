Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E87D18EFC6;
	Wed, 11 Sep 2024 13:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726059823; cv=none; b=mhbctEnmBPNe9ogE9u7rHEIdSRzrUSXZumX2E3CVXpxsvA6EFQ1Sn64Avb7vPL9bRp4cWjQwMmzS5IDfu8tr5e/pviZOxkJtRqMEchykpZ7ItrwHcrCfLM+z9vo9VRroDqOoyuI09ta2hbs9I51gDdEFp7MPbZoLnZdSyP1RXhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726059823; c=relaxed/simple;
	bh=SA5WFFJN4ZIHVycL4iLocpXz1s6IKE1wCxyUUg5Dx50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=smdI2QjtZo6Gv47tZjK22bZj36O/YU/ra3lHMf1fZ+geke3THhv6X6YQmGWYlVszg9Gv3wnkDTkmZhyEcBQQTy9VmTrJbyPL7MAcQVGZY1g4uBKYPlDasf7IIP68JGE/1OV8FG/YTXJqBpIwI6JqhKNn1WaxBiBwVg3X622mTAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wN4yr0/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wN4yr0/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699BAC4CEC7;
	Wed, 11 Sep 2024 13:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726059822;
	bh=SA5WFFJN4ZIHVycL4iLocpXz1s6IKE1wCxyUUg5Dx50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wN4yr0/1YXa0VfPj9Belo9K7wOtKlma5gM1Od/VOoPZ4v95CHbgq/lgep1c6hJIq7
	 987SZn0V0aFyyM0ieUOOKGDUQ97oL3GU74s62g56Fn4Ro7TcVk94mMSbewJDVQGA3i
	 XLmOCCw6pSrFKUdFAiEsIoJlzO93O2m+2grq22Jw=
Date: Wed, 11 Sep 2024 15:03:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux@roeck-us.net
Subject: Re: [PATCH 5.4 000/121] 5.4.284-rc1 review
Message-ID: <2024091134-fanfare-nail-dce8@gregkh>
References: <20240910092545.737864202@linuxfoundation.org>
 <72b133a6-c221-4906-9184-30b4e6ee4260@gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72b133a6-c221-4906-9184-30b4e6ee4260@gmx.de>

On Tue, Sep 10, 2024 at 12:33:51PM +0200, Helge Deller wrote:
> Hi Greg,
> 
> On 9/10/24 11:31, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.284 release.
> > There are 121 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> The upstream commit 73cb4a2d8d7e0259f94046116727084f21e4599f
> ("parisc: Use irq_enter_rcu() to fix warning at kernel/context_tracking.c:367")
> was added in the last stable series to 5.4.283 and v4.19.321.
> 
> Since it breaks the build on parisc [1], could please you add a revert of that
> patch to the current v5.4 and v4.19 series?
> 
> Thanks!
> Helge
> [1] https://lore.kernel.org/lkml/092aa55c-0538-41e5-8ed0-d0a96b06f32e@roeck-us.net/T/#m8657a387ec86f9a2af62380743718f72ef7619b5
> 

Now fixed, sorry for the delay.

greg k-h
