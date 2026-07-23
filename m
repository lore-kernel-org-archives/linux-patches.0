Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E8B3A4F51
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 06:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784786738; cv=none; b=DUoCspBcw6CFSFybGr3T14NExh/Cx+7CvUqOqD4WpTN8wNmIZtVx+gZbXju5mRbu90nkAcc95znzOPRMnOV303rtoZ05ABxSLA3eHj+OL8btxVhov7hkB7J8polbf9M5UN2QCi8UTBgQlXI5yPME5jtTTkdzcuryTD6pYk8Q/ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784786738; c=relaxed/simple;
	bh=LlFyPMixlcaKk5XCW7qJh7mSjsGBkGxx1Dgtma/RbSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlIHmbTVJYmuOex44KIJdc2TnMZxOg81jwCJ//qtG7HURhLZwUYD6JiRjLkHi7uxm4s1nExcIQTbUFgnKtd0FDe3hHpInMNrdWNL1IB3W6VkF2DJLmXFVeK0RBYqQgpkC9auJYSlq4g18blDw3NOFx/4OsKWFfAipzuOXTnAqZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=w6hWq4Qh; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="w6hWq4Qh"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 6A50D1F910;
	Thu, 23 Jul 2026 08:05:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1784786730;
	bh=699/w3T5o7/BM6TFreMj7kYE4isge/A/6YB5rv4CkeA=; h=From:To:Subject;
	b=w6hWq4QhqiZeV/5aM2OS3qDzK+GOUk3w1wfwu1zAcbnLg+VmlUHkgEtrdYRHvSNn8
	 WM3iDbTU+shfxVlEjgomiGs7HLz33DPPx6N5Isi4EYPzOqzo5CpEuca8ktQvGYctRA
	 AfT6wRSLeE0PQXaLR7iqCSKE5jL/QYZ60LzY8ksuP5V0VAFg6TvfOL+JF9yo74f6Da
	 LAwW2Rp7Ce4yxYCSyey1hvb0DVb1+DNr02y9gFYaZHuZdaK3GYvyVPcPc9ZIV7b+qO
	 iJZ5NFXJViMyoNPfCbWeuKBsHRRymwUjuGhEXcL3sfMupRHUAKiNm2iG+cB+2L2bVg
	 3QQHSGJde6Bgg==
Date: Thu, 23 Jul 2026 08:05:25 +0200
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
Subject: Re: [PATCH 6.1 0000/1029] 6.1.178-rc2 review
Message-ID: <20260723060525.GA4905@francesco-nb>
References: <20260722143218.909123637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722143218.909123637@linuxfoundation.org>

On Wed, Jul 22, 2026 at 04:32:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.178 release.
> There are 1029 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

