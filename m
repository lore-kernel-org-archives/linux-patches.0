Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7567038F65B
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 08:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774342760; cv=none; b=TPA2V5L5YhSnrFRq3x0vc5UQQkDCXCODAEfVdq93kMqiz+844rYRA8pEa+AVtwcETFP2BlhXUVDj8GUBv6ZdDzwAH6bOoIyOeCNLyy4aypSqZZE0QosreN/LJP74ywMZoZ9fRkhxxvY3cXrVZAfk9+mdHPhyeRFTfvyPJ2vmdQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774342760; c=relaxed/simple;
	bh=iw1mqH6KuxoHSPE9DgigfqfMRt1d/EqT77y08jgGyCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iINeQ0KEsbEXnVOy2liEhcvtR0LBfNifprYTl+icFPty7HyvQ3ejwmn/DuLhRj/ZPgxkFsEy8Uw0kmhM4+KJRvj8DfJvirNpN/jyeu/ViYq8TzL57T+o4yxehtB4dFg4OPh9Oh57DMV3Ubve1ZSQsx0yyyM1Ba5n+2nPsPgGXNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=TqcuqV+P; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="TqcuqV+P"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id AFCDC1FD05;
	Tue, 24 Mar 2026 09:59:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1774342756;
	bh=uVt/2U0Sk2WPND4zb6BtTMFng2AVXa2eLlAbQkPy8XE=; h=From:To:Subject;
	b=TqcuqV+PZK3wRNoF0qxU/D/qXrJyf1Z0tG06i/iHQNA9j4EQROHQI6Lvhh0U9V/Q6
	 vx5lA+48Z1qJUg+V6d5PoJ7fbviwqRvtj102hV1cWz+iG9f6Tburx6YZt9Gq+inaWr
	 JogMP+WeQbiJX6fE2dUgQ6WGAPOcEJg3/v3BtP5jpFle1D82nYJ6KvCOk1y/5DX+Ng
	 qez2Q0I7ITh61WUBHKAobZmeMMiqFiPlrJDwBuZTarguu3lTj6f3uuGsPoXt6cvXCd
	 dzMCtMk83Ff20gph+pQAMfA90XmOW1o+fodhqI4kmRXQTNIJ+e2YGDoK8Ht0OgNOtV
	 d3T2lAv/lSr/w==
Date: Tue, 24 Mar 2026 09:59:12 +0100
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
Subject: Re: [PATCH 6.6 000/567] 6.6.130-rc1 review
Message-ID: <20260324085912.GA18375@francesco-nb>
References: <20260323134533.749096647@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>

On Mon, Mar 23, 2026 at 02:38:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.130 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Colibri iMX6
 - Apalis iMX6
 - Colibri iMX6ULL
 - Colibri iMX7

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

