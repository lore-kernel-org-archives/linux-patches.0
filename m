Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 645563B1009
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 07:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787729659; cv=none; b=ZO5LSHVxULOHh8N+2PUWOOYW+gLhKwVolkb47PbvmVPNplUomw/yGNC0YcbMB8t9+53uoMNPxhas+z/aZfba5caT2ejxWjSTg7KSMC6uWJa7r44n9+QJpSvENSDUL4EDGepwRTMZCjHTYZtvB1+5gH3d4cpCkZUUJcuD8ao2Prg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787729659; c=relaxed/simple;
	bh=8QEIL6GEFOcTB57Bets2NfXTStj3vBKH4c1nmRMUY98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8F9Mk5xcAS1XU94WWXOnE13sunmbvFB5asseQYFgo5J9tzXd809CL0kxFumg7RnJfWGLxNXQXWvohUMV/KsyhqkqAAu343ad0GEwFPqfMScxsHc2kudO6ZDiYCW3SwwC5wVzj0bXtfBgosdj+KZCCupfRjmYfSx49r3Zmw5eJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=XlWqfTwH; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="XlWqfTwH"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 5DD9F14C2DF;
	Wed, 26 Aug 2026 09:34:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1787729653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rRaP3WQlQi74d1tQ55JFvBOUzd7aIcOgzubFccuRcnQ=;
	b=XlWqfTwHeMh7s9noGm7rE2Z9li43Trxh92i4I8+vWRQ2gQkInOuhJaqCesqTKB7SOr0f8X
	diyr5odkWKxLfXjfyJ6AKa6IMj0sCDSEM7/BTPHZUdiD5E4tTDfjfpNEr75u5oeYhSsq9E
	DtV/2kJiOnTMa3QG5zIdwCrmDYlG/ZqztDPNEJoSJoXZNUhKBCJN11f/5Zv5aCyABwpzGL
	FE8DUivFXDYo7zUymeOw7CwonLfB4Z/8sO9QXrYxWTaHsu2vlOY5WL4DCS7wCwwCvyEXlT
	DOOoLWPwqQy0dGUy9Rrk9KYweKOdTm66Ejo3yo0d2v2FAlnTUHsozWq+1B1fyw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id bcfed3ad;
	Wed, 26 Aug 2026 07:34:06 +0000 (UTC)
Date: Wed, 26 Aug 2026 16:33:51 +0900
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
Subject: Re: [PATCH 6.12 00/77] 6.12.106-rc1 review
Message-ID: <ao6W37yu-rUQween@codewreck.org>
References: <20260825132541.580275153@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Aug 25, 2026 at 03:25:22PM +0200:
> This is the start of the stable review cycle for the 6.12.106 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.106-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Tested 8a0cfbd3eea7 ("Linux 6.12.106-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
