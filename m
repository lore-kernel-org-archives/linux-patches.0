Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336C2EEA8
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 21:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768512766; cv=none; b=AoJBM7Bs5hXim5apbJEABhmuvof7/SyJFGCocEhMF6P73bBf4Y2vwefyMyo4tcYXy+gP4Qb33Mx/rtsIvWcMGGc8rF/hgg4adtCsPkzgCDQEOqK8EpxxKYrNCHxFd1N0IeTQoVshxEDP6vJWtYDsQSZchZOAB4f74TOdjioSbE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768512766; c=relaxed/simple;
	bh=YpMQkAeCDrWrgSqpy+2va8SZhAXP0e61ZESHDN/Y4sE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gSsR+g4M10hdiIu4tLBEDWI6FnRvbsWTQwJDAb8iZ/AKhN6huFnrMgFgH1f2EYLOe3Q6KA84065jKpIVTANx/BrVHIoyfYnqh6nxxD8bESX26sP0Bw6NpfstnkAAFLDGy0GG16DzPfX5zYA7JHzAgfo1fwwjBZIMGYkxP6v6nzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=Yw4N3Bo4; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="Yw4N3Bo4"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 34BD21FABE;
	Thu, 15 Jan 2026 22:32:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1768512760;
	bh=VK//cfxG7B3WldQa+H7SAt8NidJas+0fQX2kLYuXwbk=; h=From:To:Subject;
	b=Yw4N3Bo46XBZjqwWDCMEctjR3xox9OwZi8qlOpx8PoxUEbMtRJqKXail3Saju8Koy
	 nHTYuFEaxyTscNKhm44y3gqgw1ARvIQFs4NLNOcLiHCYaJxLj42EjLHnEoutL3R2ay
	 UqJqVApSJjgLuLAkWZv7Y5qTr4uxyWp3me1ZCDY0ulCfUS34MXdpaDsXRf54VYbL+N
	 V1WK+/O3T2GXqPnY5XMMvOvRIDo2rO0jyzEYFxn5fXjnJiYY0/rOdNjHjW/DkcL5Pg
	 u+kdKsLMdQNc7kTKUdvT9MeyPUToc0j5NaWqLvPcwDE5Vla+fsuioCz08nDiC68lsq
	 DAirKIwCByHog==
Date: Thu, 15 Jan 2026 22:32:36 +0100
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
Subject: Re: [PATCH 6.6 00/88] 6.6.121-rc1 review
Message-ID: <20260115213236.GA219657@francesco-nb>
References: <20260115164146.312481509@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>

On Thu, Jan 15, 2026 at 05:47:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.121 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Colibri iMX6
 - Apalis iMX6
 - Colibri iMX6ULL
 - Colibri iMX7


Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

