Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.210.214.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795071642;
	b=MHylDoc8jAb73JkVvN5qXe4UI7d8cy1zkqC0+ZgViFjW2TkHwju9fl9pV6q2R/CIzltE
	 J1SiC9U1Mvrj93OtdpCQDzf+kdYEhJHrBWREwl9X67Q4KVdk1dOZH4Thm6vYtHYeFms89
	 vRdU2VZil6dq3/UnWPbFXYFdY/4cXYszkSS/8oXuHgVrxP7+JYlwyxaY4h9S76Z32LfGj
	 qQrJcOgJJx6n7Qc/HeBjH5wxvBr75Sp8EiucTQZm8V5oNGJoXhAbMnuXy+SElFoBXUPn1
	 nb/6JAqm7DXLpz1ZANxL31HpecJQ5p0LQobrVYfoo6nsoSaT7TM7zXbSz0Z05Vy8XhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795071642;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=CoalCSWaK7sUy1Q08keHxSpIFcytLs2vQWDZRhflLgE=;
	b=l28c7iL5JXoQefH4bfeM4vLmrVILZknjAYp6Ilcz43n1KJsO73l4J/hqH6pzARUDCihx
	 ExC+CNueJel0IHpcOy6sIlTuzKzS9zb8U5/XJG8ubrWV39xOVBcjVHGBo7pVS/R9691MW
	 ASyo9lfDnPukX/LvVMfpBiaoPxuQkEYS+if4iMfAU7FEpAPW5rXjp7U55gcyEJSjGWhSX
	 J55qN/9n7i4/SaOuOhgAM9xqImK66802Bq2KO/O2oDMn99LVW3aHN8DCaDkU19Zj95+5k
	 E0YoM+S6n2B5eRXnv7AdkwUB1Kz3MS5cisBl1LLByn477eeo9LqziYIhczb6I58Rw/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=codewreck.org;
	spf=pass smtp.mailfrom=codewreck.org;
	dkim=pass header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=ozOdZDtS;
	arc=none smtp.remote-ip=62.210.214.84
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FDE606A325
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 07:00:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0FDE606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=ozOdZDtS
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 51F7414C2D6;
	Thu, 19 Nov 2026 08:00:30 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1795071636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CoalCSWaK7sUy1Q08keHxSpIFcytLs2vQWDZRhflLgE=;
	b=ozOdZDtSxzsHCpZg1qYi89sUmdYKyMSEehdJlI8ULvM/ueL7G1F8ex2ZmIJrvlr+oKQbkz
	wO7WdYjzCfBDQr01uz+QCMZqqRHiiqAyYp7gYvMWgAmYSWIhSHXUoGFAm98OBj3MGdczwJ
	8Imu0fkgA7b4vEhW/ct6F71GroSHXdOtHdPGxBAlMnYMZ66/xmFgw0r0dQCnMYuwmOW8dR
	eRQb9rJ1rXJLMUN6Abd8wgvugndf2PBysrMuyu1ryzkvjru4D2jj3XPYy1CowWO6EBUt5W
	IWPbKxgMd9OGCLMmXqMxSZS0IBXAitPC+lCjd0fUkU6gWECCqtQCphg+GEzijw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id c91dd502;
	Thu, 19 Nov 2026 07:00:28 +0000 (UTC)
Date: Thu, 19 Nov 2026 16:00:13 +0900
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
Subject: Re: [PATCH 6.12 0000/1756] 6.12.119-rc1 review
Message-ID: <av6efcmCVIhqCYZA@codewreck.org>
References: <20261118150007.957976754@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>

Greg Kroah-Hartman wrote on Wed, Nov 18, 2026 at 03:35:27PM +0100:
> This is the start of the stable review cycle for the 6.12.119 release.
> There are 1756 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.


after reverting commit a8210490583e ("phy: freescale: fsl-samsung-hdmi:
initialize default rate"),
(I only noticed Francesco/Vinod comment on the 7.3 tree to drop the
patch now... FWIW I also checked fb output works on this phy, both with
the patch reverted and the extra deps I suggested)

Tested 52008ba8d06c ("Linux 6.12.119-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

Thanks,
-- 
Dominique Martinet
