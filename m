Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3213AD527
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 07:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784272890; cv=none; b=eHX1zj1aeF8Y+ZmFNcymZxahYztppPsom/IQY8fpTNkKwtUgI3C3VoYaijVmIGe9ucCMk/R7qWDzPL+o1rSH8pSK9B1MZDf+ijsbjJJydFbKe9dEWkQeqRfxt1PHh7z1oP/ptTbXbLyBuirY/TlUqK/B3lRb+4kAfA/dUUav3iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784272890; c=relaxed/simple;
	bh=QSkKd6L3/R5xGlFb041ENdAdqR+bZr0FcGvkH7yCuu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kFBdAe3L4heOkRYm0WsYRljlnoOXCPkfYQtfGq9OoHScMb6sC87umOoDxKSVF/7681fifcG54u8HzW4zRMcY9ditsWicengRyUw3zrx+450Ha+yUULyiZIbwxOCxjALhqpXGSkW5jHhLxH7GL+5hqWlElYjizOXOxQ4/Xy99Fnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=GEPiwNao; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="GEPiwNao"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 6012D14C2D6;
	Fri, 17 Jul 2026 09:13:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1784272403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Il2ieanJNJrfHS1elTEpEDjJBDaUtNnDMAU5uF8bFuo=;
	b=GEPiwNaoFVbhrHN4ow8ee8TUgrY6DqFX+07D0AexGqLrEUHg/Edlf6UxeMOVH/rRJYRyoB
	NtinmktlFOYsWubujALKYfIBDPMTOFT6L0gM//4ylRdUWpXW9bvOUhOcb/uMR4iBqCV6/5
	uYLKZ2OwJwZWasmsfKU34q4Zg35qemsyLXsvROzNRVGdpl3KV1M9vyHUn8dWpv9QlkQUj/
	8mRr63IwCmwKFpOcABZPhn3CZuPyRZh/771n8J5P0l4goVaq3+A3IXrlQfWll+oKrH2pOL
	1FlCCu3TlwrfZpls1LIr8wVZ+jIkKIhxvMKkTq/FZJo3WrXB9ElXDfmD2m0fqw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 4be6e309;
	Fri, 17 Jul 2026 07:13:16 +0000 (UTC)
Date: Fri, 17 Jul 2026 16:13:01 +0900
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
Subject: Re: [PATCH 6.12 000/349] 6.12.96-rc1 review
Message-ID: <alnV_eOopvB9Orjp@codewreck.org>
References: <20260716133033.287196923@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>

Greg Kroah-Hartman wrote on Thu, Jul 16, 2026 at 03:28:54PM +0200:
> This is the start of the stable review cycle for the 6.12.96 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.96-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.


Tested 5a3bcd4be3fe ("Linux 6.12.96-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

--
Dominique Martinet
