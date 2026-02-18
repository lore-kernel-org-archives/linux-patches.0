Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF75D2FDC3C
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 13:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771419660; cv=none; b=aXeaSRakRboQCuXiXGEEO4/lkI0TTkgpKWUMmUsUrRjBjEx1mGSqOvhXL9Sz/lOh54rePnByzm7iaY8KFFa9DjR27jIuoceqUVPuYvML9o0GBfx7+MAyMyFFmJHyvwO/e528UFkz1Gch2Y0mcb6kx1GIrj+TpV5HXeWrPL+1X4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771419660; c=relaxed/simple;
	bh=+ZAYQBfpiJrawGTa5s1xCFQiv1Ei0YajxwjNi4xGMgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxyRAg/FohLYPpyrQFo4k4vIdoqf26IklbuhXmsNkgEqfW+HyD96OUtlw05eck/0wAdJGwXDD+2x7hkAKCy7Tw/BRxbSsJZoMS+QqGgyZuU0qI/ehkwIn4gm4AG/yDkW3C7c8Pxiqj3+27XTTXzSUbMz54R9HdyMlOCq0WkA8dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=LhYRgaqq; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="LhYRgaqq"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 62FDD1FC2F;
	Wed, 18 Feb 2026 14:00:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1771419658;
	bh=y04Gn/KHwYw25qaEpBuGATv0T3KlBX02x2xxwIuT8Dk=; h=From:To:Subject;
	b=LhYRgaqq+nzH2WNXGoys17rZjc7nrJ6yFwv4QghaoBgzpSUR0PWwrAe6Sovl6pfSn
	 wiTJp3j3+23xcOouHsJ9Twch3LUpdtdSB/zRaCZM4YMGnw8EFb0ZpeJo5MK26lrC8h
	 5V7VqBz6pNb2jGBJJvNbNxifmwGwTbnb4EyobY9Gj70TOxMEmI7yrnKLQWGpGcmxA2
	 aRggYOfgcdZ299RcnkQ5gJ+ZnoQRu1trgcmDHV7/JnlvGZv0eQrFIOqsIp1RuQ8ErO
	 bmT4G6TCS+z207UBmEkQbrMgnekuM8PmUiHHIt9GnNLH01gXvbAWn4pmb14fvbAcnP
	 Y6Bdj7o6CuH4g==
Date: Wed, 18 Feb 2026 14:00:54 +0100
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
Subject: Re: [PATCH 6.6 00/39] 6.6.127-rc1 review
Message-ID: <20260218130054.GA93819@francesco-nb>
References: <20260217200004.221651386@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>

On Tue, Feb 17, 2026 at 09:30:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.127 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Colibri iMX6
 - Apalis iMX6
 - Colibri iMX6ULL
 - Colibri iMX7

(For the record: something strange - a freeze during hardware video
 decode test - happened on some colibri imx6, but it's not something
 systematic. And I see no reason for these patches to be the root cause
 of it)

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

