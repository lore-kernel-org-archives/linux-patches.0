Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCD01E9B12;
	Tue, 26 Aug 2025 14:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.211.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756220321; cv=none; b=XcNuudYFxyckfKbbseg9k2T+t0fWxWWw/0fyXShUKwNqt/bhznagFabOMz+ck0fnSITCaO3QRruNZbJ/TpnAu55TcM1403zo1RHv0ITd5UVBa+EDE7jxs1yA4OS9U5bl+3QUHSaMQhEkfGPbSbHnLaeKioYf9qU/1E64bQyT3xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756220321; c=relaxed/simple;
	bh=/7p3qVxnzBUT5+dHf0l3sxVRzx/+5rfV6fDtWp9eXQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SVaMJ4G8H7t2t4HJBcEW1S4BaMBJDn+XKGGLLzxf+OtjW/QSHt8ajG5da+yaZOL7Wb9hV3pfHgk0ufO5HrcWTl8tQTg6VSofFrCkprb4EGGpilAaozOnIrSjTTx6SDql9ZfK7tYm+g76mskhya/PuDb1nJg0yVXLnj/fi71UwCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.211.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Date: Tue, 26 Aug 2025 16:58:23 +0200
From: Brett Sheffield <bacs@librecast.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org
Subject: Re: [PATCH 6.6 000/587] 6.6.103-rc1 review
Message-ID: <aK3Lj1OouiUqskLh@karahi.gladserv.com>
References: <20250826110952.942403671@linuxfoundation.org>
 <aK2rwEQ5hdOQSlLq@auntie>
 <2025082620-humorous-stinky-bf0e@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025082620-humorous-stinky-bf0e@gregkh>

On 2025-08-26 14:50, Greg Kroah-Hartman wrote:
> On Tue, Aug 26, 2025 at 12:42:40PM +0000, Brett A C Sheffield wrote:
> > Hi Greg,
> > 
> > On 2025-08-26 13:02, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.6.103 release.
> > > There are 587 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 28 Aug 2025 11:08:24 +0000.
> > > Anything received after that time might be too late.
> > 
> > Quick query - should we be backporting a known regression, even if it is in
> > mainline presently, or do we wait until the fix is applied to mainline and
> > *then* backport both patches?
> > 
> > 9e30ecf23b1b ("net: ipv4: fix incorrect MTU in broadcast routes")
> > 
> > introduces a regression which breaks IPv4 broadcast, which stops WOL working
> > (breaking my CI system), among other things:
> > 
> > https://lore.kernel.org/regressions/20250822165231.4353-4-bacs@librecast.net
> > 
> > This regression has *already* been backported to:
> > 
> > - 6.16.3
> > - 6.12.43
> > 
> > so I guess we wait for a fix for these.
> > 
> > However, it is not yet present in the other stable kernels.  The new stable
> > release candidates today would spread the breakage to:
> > 
> > - 6.6.y
> > - 6.1.y
> > - 5.15.y
> > - 5.10.y
> > 
> > Do we revert this patch in today's RCs for now, or keep it for full
> > compatibility with mainline bugliness?
> 
> Is the fix in linux-next yet?  If it's there, I can queue it up
> everywhere, which might be best.

Not yet, but I'll let you know as soon as it is.  I'd suggest dropping
9e30ecf23b1b from 6.6.y 6.1.y 5.15.y 5.10.y and 5.4.y until the fix is
available.

Cheers,

Brett
--
