Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B27F45FFA7
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 18:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788200160; cv=none; b=MkzN76bKtJZkDt27HFl/D5uDzOxuUL9cmEDenBW0N+4ZbufHnAkJsThyEsM1q4+/yVbi58CHNHHBF2j4gs2ggGTiLB8nzAaMPVckc1APsj5gqmpWFzRTOe8eyFbBHs0kdweIkfkqCYvr580N7HzR4iSbdUZuKuexUI6Elz9HhBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788200160; c=relaxed/simple;
	bh=6ehLjiWbn9QAPPuVQZvIPbWphJSz5JnpQn8Ko+ndaKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rn6rtngTGyi3amXC0SyiRaRqQ4uST+HZ9eOHoJnYCyzUkJ/JDkFL1Zt24mM2p23p18DHlKMihlKTadWyPapDNUeRdrHK1rFeVjT6dBtJYhJaLc3yHFt+ieeXJ8flqtkA0W0LTVulV/oMamQcf3Pz0p7WinsECgOpIfImV+4r7r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=ZT0YSSvc; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="ZT0YSSvc"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 876FA21E5D;
	Mon, 31 Aug 2026 20:15:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1788200157;
	bh=CjBQBtgXdZMeKJGXXRCl/ut1ypHvjslBrnTtfGTjdH0=; h=From:To:Subject;
	b=ZT0YSSvcFKA6jJRPPSxlLDQ+i55NP30E9chmIOPTGmLphSXWi8yWxAqsSevpArRox
	 8ax5s2SabApvoGls8QMMS4jRQhBPwiY/MbyRcG0De7bRWO030yy0Lf2GKfdffx1Hmi
	 yBSPVE2kXey5eD7IK7ulvjRT9pVM2vJUEnDPwAEiQQeWGO6ZpVD3AmlIIdyK0RT6vn
	 f6HZiWf1CKx314aO4IcTYPHc5K4lyEKfK/2g+1CLmxtUCaKC2ZBLEJgVGfukbuvQ8m
	 zrDmb9NU1i81tyFE6Zp1XB0CGGpJpBRflcARpFCjMvUCiX+P7ul8K/SbfB9IBa7CXw
	 8sIaRZF/38tWA==
Date: Mon, 31 Aug 2026 20:15:54 +0200
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
Subject: Re: [PATCH 6.1 00/92] 6.1.187-rc1 review
Message-ID: <20260831181554.GB124452@francesco-nb>
References: <20260831133359.482388899@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>

On Mon, Aug 31, 2026 at 03:33:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.187 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

