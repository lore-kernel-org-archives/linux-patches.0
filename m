Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1107312837
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 11:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767786829; cv=none; b=ORgu+JWctXRMt/Fo+CUhWLUbfJTOFYz583rgJbE9pf4Sd0PxjUh5Ri8+B7JFkZ3ut8aL3Xcmj5CPvdS+EdhDC1orZBRZAmmeIiNYU089A7u38Mc39FI5IDifQd5S5qfLpvln/9WOHn+gr0hcIwZXtmYasb6pHnOtei6Y0xzRJxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767786829; c=relaxed/simple;
	bh=o1ltIjtrOA9HPER2D4rGnFOELy54LxjT3d8U4Nor+MY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JrTq5qgimRtCaxRqidIq1q8tU5t+U9B7VRYMjMyoakOijoCiwzo4To7ujRvea0alOEOBTWBp4VqaRg7bTgQAGKMN76ZeSb42ycCYY0xU776RGkTZo2iTH2JsZrPCrx7wVvi9IBX4NjMPdxNIo/sqdCbYea0wWYAioWCAxam2NOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=zNQxaFuO; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="zNQxaFuO"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id D8C931FEB6;
	Wed,  7 Jan 2026 12:53:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1767786817;
	bh=6EpNA0RLT7Xitv6bYEUuPLrpKEKrvJijTdXbr6JK2Zw=; h=From:To:Subject;
	b=zNQxaFuOtHWy+jodt1MRDGjkriy2P4GaNGE02VFx4H5twdbzGO/sU9Y48RO8D1YD1
	 tFeD1JJdoO8px4LSv5SLkoMJ4jItZfhT/0PPdqzxEzOUyd0vNVz6SuGLdTlMPP4Din
	 9Cq9KCrziO51S3tTDhZIw1dt9ZQj32Io3WdXar3goYz94WHvh0PHx1cOC3bev6cFFf
	 JVvtVX8iuV0DdaUBCdySltK8U3FaQqGlTEylc3tgIKCrfeYVDoVNE4oCvxKc69iwAz
	 k9UyV+q/bGwr6s7FAFSd7G9HV6/k4kwtq/PCsFpFDwNrxGwqI2mNqEoOl1ZOg9Ozv3
	 0uQ9N9VII/bgA==
Date: Wed, 7 Jan 2026 12:53:33 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
Message-ID: <20260107115333.GA28907@francesco-nb>
References: <20260106170451.332875001@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>

On Tue, Jan 06, 2026 at 05:56:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.64 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin AM62
 - Verdin iMX8MP
 - Toradex SMARC iMX8MP


Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Francesco

