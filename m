Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D7039A05E
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 08:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776759873; cv=none; b=jMNzAuXrzVBsPx9RmPsewAlCiLla8Qn6jz/VNeGw0VidyAa1/sY37MyLyZwlw1piiCVP28yshKvfMYhBINi+TLu2KEHLH+JrDiTIxqVv5T043ZcCEPYIaT2RYQgt0vCzZBgQi63CP7NI7pwQNLBbtJ4oNaKiKRD59z9wFJvY260=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776759873; c=relaxed/simple;
	bh=FbPPmZgTw9/5ZUwcndsUJdEC8YYoi/DkuMo3uoHizxY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fb0DWznObKF6iDF4SRcdrjvUM+AFARkEJ3IzzgyN+ahlyJeDtwz2uNlNeaYFSvZq6KxUZhNlW2JrofIXXEVllHt7RBcAPU70JFlNvTHAWFHabGVhBomCklKVnCWdWwxNDds3tKG/QkkjBn2pZ18C0peBkZnUfJ386IYcBB3RiGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=CZp56R58; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="CZp56R58"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id 2D5B61FCE7;
	Tue, 21 Apr 2026 10:24:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1776759866;
	bh=FX2hxh9n1k0fxajswXeBZ2dW4/yJGc8BRV29n4k/W64=; h=From:To:Subject;
	b=CZp56R58fPmbZoBrFBixDFuaAEx8bFPDYwKrIbfiBvpRHeCaoiwEZ9zw2R1enl3bc
	 aVca6cYdNGODQLN+pE1vMreCrYMiQX1Vnp/pr5pztzda9DHKyvr/E1XZ2iXtQ15Wnj
	 VCfD+ZOANkYx7HiejTjVRPq6nYi2C29ONxY0EbNET1B0Pzg/8itVt7ZL0rUXW+EBqf
	 mO9tsuSLew/S45N0irsB1pZgKP7gyhtC6uVqXomDDMh4R5+yhMhXiS4Y/bCuNjtYax
	 88NeyF67YFCpyB5pB52sGv1ZNAB2BKnZQuHhp+w7og8YfKPVgcgoV/ZbZRDQVvqpw4
	 Aww6ZxWJz3iiQ==
Date: Tue, 21 Apr 2026 10:24:19 +0200
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
Subject: Re: [PATCH 6.12 000/162] 6.12.83-rc1 review
Message-ID: <20260421082419.GA28066@francesco-nb>
References: <20260420153927.006696811@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>

On Mon, Apr 20, 2026 at 05:40:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.83 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

