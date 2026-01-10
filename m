Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AE62701D1
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 08:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768033693; cv=none; b=WXNZBG13mLDQgm1UYxz4G2hEpMumA7b6Av/7tmEUo7szXbzQzf/uhQ0RstQhsE6iexMD2r3BliJhdSZfYFXA627drwA6aXS9uSErwkrcOQf6CCIDlR5OMGYp6tFqgtMgV3jtePXfWpvYm76TeFUamQN5kGUt953Iy6wZVWMDnPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768033693; c=relaxed/simple;
	bh=HwLZonKz7nJ3UUbNpNFO4EoIf+B9rbQIDyoEC27m7Xk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HQRYZ/9NsfQI/CNDQI8Gw5lRSQsk5DO3fNTQ+2rNENHuFgWUp1UxZNu2Ht+XRvRK1q+XyKcyn/bMMJN5/dCkV32lVPQYXFoeF07l6mDj/e0KQhM7asffs3F9UjDrxks91ulTERuN21tugOj2rDenwWYPGHiAzZNk4F9Dq0KXm1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=UkBxrGpZ; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="UkBxrGpZ"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id 05F451FD2A;
	Sat, 10 Jan 2026 09:27:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1768033679;
	bh=ShPRI67AbE26NL/1MenZzWb5NWggzAqwuEKvsTb2/qM=; h=From:To:Subject;
	b=UkBxrGpZYn7VrnmRXIpCs76CHp+0IHYSBYboKWfiVuA28UWFB1ZaKqoOdohtoMUK8
	 2FsJMBu2a6dnk3NlDhYUVHd8cfUcyhYmq6Q9ZVBJzsR1qxDgZxEIabgV1fEEkXNOtI
	 M7KmNANaPXZbiT5Z1xrZqkjcSS/Fryn1eXmeD7GGHawN1UhdOSyZHsh52UImEhxtX0
	 mJ2gQc3RXUknWyxdxcPI5MPVhwkOCrN5lEV6dfgHabDvl915IqJgZmhp3S767EseUi
	 Wur91RthiuRuvzg/gStepZ+Ht1UA7EUhi2WBL1VecMJJvO4+opl6b5lSRkiNaejD+4
	 +7wgb6C+1KR6g==
Date: Sat, 10 Jan 2026 09:27:54 +0100
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
Subject: Re: [PATCH 6.6 000/737] 6.6.120-rc1 review
Message-ID: <20260110082754.GA4914@francesco-nb>
References: <20260109112133.973195406@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>

On Fri, Jan 09, 2026 at 12:32:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.120 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Colibri iMX6
 - Apalis iMX6
 - Colibri iMX6ULL
 - Colibri iMX7


Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

