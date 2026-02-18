Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB5F31B10F
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 12:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771419041; cv=none; b=ja9OS0ViofQElqDvCMB/21dI1pQNL8s79IFTZ51lpfo1URWvTyMRjGH1gBX1qa2Gbw3xT37/q0IXWSDTyaYkwGFHLs6dmt5BEeoKFmaJGgpj0dV2X2Wm4MS5DclnqpSDSTG+B4S0I1i+rLqstcjFRItSY9PMYnu6XoE7itZ7gXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771419041; c=relaxed/simple;
	bh=joV75nZy/dUKvGJNhO3qZ8u2dUmVZXHTBbK0GiOq8ts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OGFyZxfGXL+dZvK2QgDsXTv67yN9omDrFiSTVRAa+fpf7Xz39AiCYcnWoeniijlZ677CAiT5qzOI3w7ongb5umpuzUC2XW2cbRUumq4zXyC7iEIj36oMAfWAxmttbCvyp+d9CJkKm0P4LVanyoj5DKDaSasLPXOqc0cQyu+WCyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=GHPt59/b; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="GHPt59/b"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 2507B1F952;
	Wed, 18 Feb 2026 13:44:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1771418646;
	bh=ceeNkt4Jqy0bSQ54PkCpY6TYVZ59k2Cc+x31v4lu2Ww=; h=From:To:Subject;
	b=GHPt59/b3NCKCGJJpHxjmXDicEO6Hi24Kn/QTvlNGVTOpskzNpDwbgSzSyO890p8t
	 8ibZwmTmQMOFZLhnCjwpIqI/RBFE3CoZtMjp+1NaDANEWpfP48tGMRg6XjLh/O6VyC
	 hYnVZCFnqkyAgQwGZy8jX17RR3WkW4UrgPaHjGol2sfxkFDKFclHBeIZMHG3LCHPnw
	 toFcy0BoiV4yRv04WWj7jnIpmmAT0kwYYoLUW31yzheGA42zk2hvfRBz5mOCHzgQ0a
	 86ppEGryw8swIg0Hx35hhyHf3xCiw4bqtRhOc7IyBpjoxL5fWQEoFFO29tVhBV7HsQ
	 hBcBqZvcw6q/g==
Date: Wed, 18 Feb 2026 13:44:02 +0100
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
Subject: Re: [PATCH 6.1 00/64] 6.1.164-rc1 review
Message-ID: <20260218124402.GA91358@francesco-nb>
References: <20260217200007.505931165@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>

On Tue, Feb 17, 2026 at 09:30:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Verdin iMX8MP
 - Colibri iMX6
 - Colibri iMX6ULL
 - Colibri iMX7
 - Apalis iMX6

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

