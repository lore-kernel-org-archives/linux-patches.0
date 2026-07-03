Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031FF3CF208
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 12:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783080539; cv=none; b=CvdkA+D3m8dDHoUPFo8wnAxOuNkysqMsvc6IIY6wmJYAJaN+O25yr5ABAvEqTEt5pqH35+KjMCC5ECE3pF6Vaq8sbGMDShdP+p01lrC6u1++EUqQxF+E9WEcu0zLZ6vCmWZR7eeatg0KJN7rbmpGoFj8Yvq7iMGlRFYzrjZ7RtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783080539; c=relaxed/simple;
	bh=mimUCVNy7SZ06Bn7adLC2TSc03Z4FyZk4qnQUvZassg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gf3zcVJoRooKXhqXWtxOEjR2GZ9w0AoWzRdtb85rWota/cMTh5b2EZ0hv+paOwyvQ6puwQ0E7RvW3B1SZ5/aTwmcabOwlOTsCGNbSZlhDjesyxMce4ZwUOVGScyyzvm17YYMTYkZ32YlfxA73kHXREa+2BY/vJ3CoJYTBrsjxQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=mw46nB81; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="mw46nB81"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id D34DE1FC3F;
	Fri,  3 Jul 2026 14:08:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1783080534;
	bh=fHA0Rya/T2qrpd7gaD15bhfUeQ8Gf4lAY8kugnzXWkQ=; h=From:To:Subject;
	b=mw46nB81Hpu+dPGy6xCYEtUBYx3Z6bZTE4y6M/4JdRWFJdvJwzfutThNsivYU0/ci
	 7r2CsPOWxdDRUldDZHMNaSa6fL+EIDZJBhyh40fNTf5cHC3JlzEor6hmObaDIDrFb9
	 j5n7SxIS7hxHRkVmENzbiQsdZQP5SJK9sr6CQUIzB6AIYtlvt66io0PZtA4qLxxRwU
	 NBKBU+6D58Hvc/GE+7EBgdUDzXIe/l3IRLxntzZIflWCQ78dZSqdn9Plf37gjAt7h+
	 m6zEiMNgWMCeUxnH0kKHZMreBHmAgKCTHQUxdtTFP61v8Q4KqXksTTkv9TgTJYXBF6
	 7B7Y6D38zrZpw==
Date: Fri, 3 Jul 2026 14:08:49 +0200
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
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc2 review
Message-ID: <20260703120849.GA358718@francesco-nb>
References: <20260703072825.068705122@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703072825.068705122@linuxfoundation.org>

On Fri, Jul 03, 2026 at 09:35:48AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.95 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

