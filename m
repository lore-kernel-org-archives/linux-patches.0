Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE61194C68;
	Fri,  7 Jun 2024 15:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717774001; cv=none; b=L6Xng9PQNtZEIjOojPD3w7W7KGSfYbSpSveigErbkKefa1xOywTy7FrX2AJFnYYIE03WBuIIso3D2y6uOts9qNoB6ItmNyl8hvNb1fdGH697CRaGrxrVtDkbtAp1IQOnTht4KLZ9g/u78F9RFseXHuof4AwOy7da8DfflhCn8C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717774001; c=relaxed/simple;
	bh=8+yz8txegIVBzkQTC/GZbBiXztzwz6WO/h0GuPcssIU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rnGGm/YoCZuqZHIhdXDHJNeOtXeHDyQd5TuUasyyWHOueyHBw1eMrmtN0YBUN6gIizMB4TReLHufIVHtkdcK+oVhD0R1nsZDpT0oWavombjBhdmCgju5x9RLAJ7ynjZrL+hc72btnv22SxgVxCbyKcVtgNIMaOXdcPjWdXF8GOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fm5Ng/wK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fm5Ng/wK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C58C2BBFC;
	Fri,  7 Jun 2024 15:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717774001;
	bh=8+yz8txegIVBzkQTC/GZbBiXztzwz6WO/h0GuPcssIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fm5Ng/wKhLmoEpSCbjYm9Z9VeOyc11TogJwBZTa+5ooJoryvRzTAmQIMjDnT8uVPf
	 k8vqc7ZQl2JaEmq8vdDQ3/DSM+vBe354tLhrkLYfkOVUsqBwGa4rIkRThxAC8cmJPT
	 4kE3UDv9ZGc7mI14NtdzHFT+tXWQUoMvYCpl8UKo=
Date: Fri, 7 Jun 2024 17:26:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Conor Dooley <conor@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/744] 6.6.33-rc1 review
Message-ID: <2024060756-graveyard-shifter-ba74@gregkh>
References: <20240606131732.440653204@linuxfoundation.org>
 <20240607-footnote-script-3a1537265b4a@spud>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607-footnote-script-3a1537265b4a@spud>

On Fri, Jun 07, 2024 at 04:23:47PM +0100, Conor Dooley wrote:
> On Thu, Jun 06, 2024 at 03:54:32PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.33 release.
> > There are 744 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Tested-by: Conor Dooley <conor.dooley@microchip.com>
> 
> btw, I requested a backport of a riscv patch to fix some userspace
> tools, but I didn't see it here.
> https://lore.kernel.org/stable/20240530-disparity-deafening-dcbb9e2f1647@spud/
> Were you just too busy travelling etc?

Yes, I have been on the road for the past 2 weeks in meetings and
training full-time with almost no time to catch up with requests like
this.  You aren't alone, my backlog is big :(

I'll catch up on it next week as I will be home then.

thanks,

greg k-h
