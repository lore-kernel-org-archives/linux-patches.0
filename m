Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9671B14A095
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 02:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741746350; cv=none; b=MorpjfGUHBJG+dKQoRsHLWfnbfCXx0O4WmNK3nkczghn6yusplU+3k4Qtlwwgp57nKh5yZRxDUnm34UV0zAvOgrrZzgq6jNlEbmSSBKyRf3mwxv7V7Ds939CREkJNWNu54gC7pJwNoJks6ct38rv9MU2xFIU6N2rxd/8NnaQ1mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741746350; c=relaxed/simple;
	bh=Hr/1dHLIsfiK72NXU8O7a2kmn9+MqEJsBHS60mQomZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h12BeuE0dodw0xNyaFHuB1oN8FMUTR6HgewItZfegytP3+cFd/d2o/rrRE2RRBFayjTDylpATlSK/rzhPdUHjlAOBo1ckWSdgbcugNrkKlIUQZSGNkxDKEXZA7fwA57XtQgohuY9xNR+6P77GSxeBVZJjkUxPhkrTYrewn1DXoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=NkobOy/Z; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="NkobOy/Z"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 861AC14C2D3;
	Wed, 12 Mar 2025 03:25:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1741746339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n0UXwm9U1+SO+FdlbueVqMzEiFAsmmq/d8t9Dl1Wxe0=;
	b=NkobOy/ZxQoxQPBrL4ueN8DEerlqkpPNDD3baNtmrA5PUbKBhSqAEWGZ+qCMHzntSy26Zu
	LQxX7/Q25wS/gOHEQlYBR2zLGHz/tx0tYHVQY6gyZ6/DnPJLQ5GXHB4jBRRmOf8CVSNQoK
	OkOPjhiocGMOzWOSkWDbN+Tlhcx8ilRdMZaGon2sIwpc+8N2QHJ9I1UCIkl1bMgG9BAbUt
	yG1KbmaafU0v86mpLPGTVhQuS2/TSyT9AFI4ziZmab1ALFxh7/YHlhaGRlmx6kqmUMJtQs
	a7CUoKXjr140hgfUCGfVKWUU79obqsBpiJelp8j4kCEaYBm0fr2jx+52xqbCUQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 644963db;
	Wed, 12 Mar 2025 02:25:32 +0000 (UTC)
Date: Wed, 12 Mar 2025 11:25:17 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/462] 5.10.235-rc1 review
Message-ID: <Z9DwjfdmtFZRZe6X@codewreck.org>
References: <20250311145758.343076290@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Mar 11, 2025 at 03:54:26PM +0100:
> This is the start of the stable review cycle for the 5.10.235 release.
> There are 462 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Mar 2025 14:56:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.235-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 92c950d96187 ("Linux 5.10.235-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
