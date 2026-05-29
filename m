Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C95F2C15A5
	for <patches@lists.linux.dev>; Fri, 29 May 2026 03:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780025041; cv=none; b=HjfWWmNuOabbEn+GdBO2ErZoTMrTadIpCEp1eVDwvtsL/4ZrKyp/Bu6OK0aAg4Lg9oDl9akfUCptYSzjIeotKv426rnXO5/U5O0kJe3ujXypdXbuZXAZC7fz7+1DekUFBEaLWuH9AfDGAgC3pkj3qMe8/o/ZJzrCUleFRKyFqPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780025041; c=relaxed/simple;
	bh=YUkUoPBftuWX9HCUCBudk0FhDhp6GzhTSntIlpRXolA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nvAktTuGyNe5nkWeYOlBdBJ6qWndy9/tDul8eNOsc8Qk/CvfnSZsdduuqBF5XMow5VFsiKCz0nTKsLEsodVkh2/QJf7aFD1kg4mriNfmO8IE18rDzyB50A6d2z3rxSIX2ZhvzTzCSB6UzCzKcp7Q7J+2bR0P0iIEVAkQPr7G818=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=a+NQ8Qxz; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="a+NQ8Qxz"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 4D20B14C2D6;
	Fri, 29 May 2026 05:23:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1780025038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gGyzxxYWethV6Gpfku8kke6m2vrxw5sCfsD011CzK8I=;
	b=a+NQ8QxzfXE1qUm0z4plcL1P3IHpAwp2tyXM9TiUdelVxxI4EHxe7JTKlCG5T7qUVCOnJs
	xiUqnl1bg30I5WrUp0x33cw/EjJ//jEaXZpqu7tWH/aqBaY+avbA2gWgRR4Qt97HBY86dd
	KHoL2ccb5i5b2/Z0keSwlUeHs6xDogZYhvKHy8bSRE2q0Qy0AdJLnzac+F13/j78jjanjC
	nRHuUjw+O+JRb3vWj81wIPGtDk46krwQASF3hWm/xJdz+lfdokObQThw3Ds7Kzy6mDvQmZ
	7rI+7qL5Jp7Pm5X7FG0xBJx0l2LaJJssnZl8JUTK4b7zp0QFICeREbqcUN04pA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id a707abcc;
	Fri, 29 May 2026 03:23:51 +0000 (UTC)
Date: Fri, 29 May 2026 12:23:36 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/272] 6.12.92-rc1 review
Message-ID: <ahkGuI6N6Uu_GlOZ@codewreck.org>
References: <20260528194629.379955525@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>

Greg Kroah-Hartman wrote on Thu, May 28, 2026 at 09:46:14PM +0200:
> This is the start of the stable review cycle for the 6.12.92 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 May 2026 19:45:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Tested 97928cc88900 ("Linux 6.12.92-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

-- 
Dominique Martinet
