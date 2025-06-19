Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F79A2397B0;
	Thu, 19 Jun 2025 04:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750305922; cv=none; b=sIHEULDGv0zqqDVbC917GBcOipMI+EwDsEf+dLA6RjNwCVr0Yivly1L5kfxjeM29YazVY2PcHuvGACLcCX1YgIDwH2oqwZEO8p/eS+GtyiGKmPSxt3rtHhBoaUmoQIShzLvr7cCEhNkvZa1rr6/LsVXxItPnwem5i6LYe04sE5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750305922; c=relaxed/simple;
	bh=nQsRX7Hl6wbxPXGtfNN/cHzGO6nX5wRg8eqR5v3TvYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Onqqc3whJ0rqwkMyq3gdPgbB7xZGpTvapZHz52LNlzGYOTOOmcgNs97yC9ADJWaEtX7i0cJ7ZH7GfXh9HQhF0MA5wDB2erjW/pyRjDvcnkVUZHxzE0YG6sHghr48ENAV4GYV0hLf9+ubcMpdZ/jLxC5mAKwbGJxmUEmnR72S/2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auF9s8K3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auF9s8K3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4CDC4CEEA;
	Thu, 19 Jun 2025 04:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750305922;
	bh=nQsRX7Hl6wbxPXGtfNN/cHzGO6nX5wRg8eqR5v3TvYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=auF9s8K3xbP49nXwK+xNXkj8BcbOVkthyXBXrGzYp6C1IGHraqOSubDS9aIzhqlG0
	 H1QimZxUKxGOgObbPpu6y4nhoRiC2u4Y6IeignNjhaoE5FO/JYXhRFHICGfX+LPHp9
	 TkQHLvjue+Tm5ikTeMGKb+WO5DEFpSNp2L3ru21U=
Date: Thu, 19 Jun 2025 06:05:18 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Justin Forbes <jforbes@fedoraproject.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Message-ID: <2025061924-shaky-reunite-7847@gregkh>
References: <20250617152451.485330293@linuxfoundation.org>
 <aFNphCnmG57JMriZ@fedora64.linuxtx.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFNphCnmG57JMriZ@fedora64.linuxtx.org>

On Wed, Jun 18, 2025 at 07:36:04PM -0600, Justin Forbes wrote:
> On Tue, Jun 17, 2025 at 05:15:08PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.15.3 release.
> > There are 780 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> After dropping
> revert-mm-execmem-unify-early-execmem_cache-behaviour.patch:

So does that mean that Linus's tree is also broken as it has this change
in it?

thanks,

greg k-h
