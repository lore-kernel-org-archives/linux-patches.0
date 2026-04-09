Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08AE3624AE
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 07:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775720358; cv=none; b=TaI4vhshi+iwFDXWC75Z1Iuxnoa2bKrfglSzgOEcvEyAdEUeQnUo5aki6iFB0K2dFWKV0cMo0ITT7sraNLqGMRsAUZrThnitJYWUgxrFihtjkwBYIXa+z0BMzjmIXINmB8mLmDMZAONhi9CgNqUktwQovlwv+exojulK2N7xOFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775720358; c=relaxed/simple;
	bh=F7grfUxDl0Smhz6ILiN0GOMWr2XyWizg3ABEXWjs5RU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XAHkUn7psloZEQ4WwzuakISbcGbmsRnh4Eu9DCTrf9x3ZgKDaNOzCxI3jolVN3rVIpTkPCKj/T5qfmRZLA73k9WjwWRS1exzallb9XExhRvNBu3ZfOPj0pzxnZ7wV8KfY1Cex+HO+JJI9UApIiyqqjvfmDjigZ4l0E5hkednuQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=DPrq0HbP; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="DPrq0HbP"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id 7ABCE1FCF6;
	Thu,  9 Apr 2026 09:39:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1775720354;
	bh=VXTl/pRoCs7YR/bR1XvPfkJAARXczV24XgoFAaXhugg=; h=From:To:Subject;
	b=DPrq0HbPvByMBmEQwm7UStr4etnc7KLwsUHTtsovhPj5EjfXLCnwWSo5IvwFiHAfU
	 HO4ORX+TIZrsP3TsPD9VXk4DphyAgol4R0VAqKhoDdku80kC2r84xlqItw4Dv7W2E0
	 Adg1DaNJgalNp8XxqNNP+upLpoAT3M9WiAmxsxSGpqZDBY8kmd/2klDVyKcplYUaYZ
	 DCiA4XV2JClZP3hhBWYsAzQXWT1VB2xdMZDep2Njbeu1XF1hKfqiy61d4Uwk1EofU+
	 Kw1kdTZaWthZI2AV1+fOsU2/3kYELckLFkLbuv6MHVNLyFHhdwi1tDirUwAe5VMi07
	 802QxzPMW81SA==
Date: Thu, 9 Apr 2026 09:39:09 +0200
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
Subject: Re: [PATCH 6.6 000/160] 6.6.134-rc1 review
Message-ID: <20260409073909.GA32276@francesco-nb>
References: <20260408175913.177092714@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>

On Wed, Apr 08, 2026 at 08:01:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.134 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

