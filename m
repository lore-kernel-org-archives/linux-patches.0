Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315C434E779
	for <patches@lists.linux.dev>; Thu, 21 May 2026 05:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779340563; cv=none; b=KhQLanNPW1p0XPkCIbraN5cC5+18miYOx9Wd9LtIAGEqr/+eH39iZsMPzY/5m1irsEs2Hmen+tcUCBmYpnlK2DUtjS2WtdNQj0e6A2saCVvzGnlkRei0K8YtitPZW8yC0CugtFlbt/HcqNeyGNA/42GxmDY3nWMpsSRq0fXdfXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779340563; c=relaxed/simple;
	bh=xu6/Ife+f7ulcrWcMzqCN5gxmm1vEk0RkjyqW1vhLz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cbHszw3c0KGngeBvqGMdOfGhcRIxXRQ7eefXVPxbN4pDyMOacRhdNfoGGX9KuPzp6pM1vz+f1DsMz8ShAzSFmpYo/d6MeuT7yXSgxSUcp7g0JCz8WgMCCIdi2/BMDbzpGzbmXPhkOQ4zVFMsogh9BODPxuEE4PuWgHcdESZE9RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=s87ro0NW; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="s87ro0NW"
Received: from francesco-nb (93-38-208-55.ip72.fastwebnet.it [93.38.208.55])
	by mail11.truemail.it (Postfix) with ESMTPA id 09E751F8CB;
	Thu, 21 May 2026 07:15:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1779340551;
	bh=yM+hmUNIWAWHzgXKdsdcb55LNHpy0cU8nxP/m8f1bcI=; h=From:To:Subject;
	b=s87ro0NW1XyOLt/uCE0d5AUD8cWDyRO8svZzmgb0T8Zh1Zp9a3QVD/l9AQvoeOUTX
	 7bhlitYboUrpuAHhcCcAW/11VSd1GDvcbG77Ccuf8fqrkKgnCUVC4PPyP5qgs9pTvc
	 ELI36fW0KmG7FZTp5AKVe0VcxWLx1yCuHMFGpirNXmPes4kO6CtAinh1Vmle/goClK
	 f9Nhi2PfN/ckB/XD++8rkMm/3N4PXp6mSwt3Ahvm0Vhy7OMKk1VXRs+LeW2+s879oC
	 73zgVSy5bZET3/5u/B8Gderr1Alti2oQjei7Cl1Z8f+hHJlFdYhveh/mMfokjC5++/
	 9S6CScNYOMFDg==
Date: Thu, 21 May 2026 07:15:42 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/508] 6.6.141-rc1 review
Message-ID: <20260521051542.GA6866@francesco-nb>
References: <20260520162058.573354582@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>

On Wed, May 20, 2026 at 06:17:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.141 release.
> There are 508 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

