Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1DB6158558
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 05:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736228937; cv=none; b=KmKPAWOS0/pAApgP/xVbD+lPTdhzfYnxRGZFqXE0yN4nxs707kIacfrFpzr8YzraOPRmXcTAFmjywRwE7C+rFw7H2SX9u1Iir9Kf5N4cLELzx90B68KFI/fJJBcDXZ/0N0OdP3rTJUZJWU+x+Xo+s3reAiG4ti/PWjg7JWdAYFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736228937; c=relaxed/simple;
	bh=2D7nJT1s57AhZd7bnAtWkJG0G1NWlqxlRKh9pHXVAKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eubfMRtkwDLIXvI9N3EmNa8ixJ3FRI2iXa9/5Om6gbujPwy5pS4c8x80pEU15nbIRBuzY7SD85DWIqeYh9aAmswatz/TYzNBuQAQJ5TpPnaevnv3fOWU7Fr1z1PI0Hp/WKkY8rV2ZH8cVX0E6hIt30WLs6GEBBgC5LFEkU9lBXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=2EH3mTb4; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="2EH3mTb4"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 7893614C1E1;
	Tue,  7 Jan 2025 06:48:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1736228931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6RhY/zDwnLzW59KAqK0wY5bVr7f0LYhNiClT9bjt9lU=;
	b=2EH3mTb4E/UVrZI+oT3jnAlLgpCTDY/4/oE1SCKdzk6i0mOl2l8oSLpjnRwq9AYJFkh2xc
	Jbg3AG901JhDUiR3x9NnfvXAnGz0AZMObPC3+hSsspCvVzvCakFGw3QH2EsN5oT/WY4bz2
	yAv+zv36YXJPD5yf2Xed4vYtF/XQAoX490vEIRpvTG54kcxFE2ocnM3FBCxBls3H70fPsu
	uaajxfaWxLmpJE8t4pXXT7NsbgFFNbZm8GoyyCbp8Lvx31THLItRjcn5FCTb48IYCz4CYv
	Nc0juzf0WeFO1tc1RZY1RkcA9/fOVs+U4aTvBalLd3Lb6tFKTDjnFA1YuPKPYg==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 7901807a;
	Tue, 7 Jan 2025 05:48:44 +0000 (UTC)
Date: Tue, 7 Jan 2025 14:48:29 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/138] 5.10.233-rc1 review
Message-ID: <Z3zALRN6QZyEek21@codewreck.org>
References: <20250106151133.209718681@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>

Greg Kroah-Hartman wrote on Mon, Jan 06, 2025 at 04:15:24PM +0100:
> This is the start of the stable review cycle for the 5.10.233 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.233-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Didn't run into any issue other than the zram problem reported in reply
to the patch itself.

Tested e0db650ec963 ("Linux 5.10.233-rc1") + revert of bc2472d78aec256d
("zram: fix uninitialized ZRAM not releasing backing device") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

-- 
Dominique Martinet
