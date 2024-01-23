Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CB11FA5
	for <patches@lists.linux.dev>; Tue, 23 Jan 2024 03:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.121.71.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705980779; cv=none; b=FTSo0T85rkA6pfGbcbuVvf+4OR2FVH+piqdVBijhlg3IumD147cwG1NpwFAjcU4rkZop4pgqiHXj1GIzUNe6VGP9Y4Kq790bVgEqdkyXiJe0iz+Rpl1Ag2hpdVtoPd8s8GazB6hfADty2rx2ROCde8Z9I6kBYM+gzdLW5Xt2Juk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705980779; c=relaxed/simple;
	bh=7fxI+iyyNWSoSUmsJMgY6DVZ2y7voll3MUa2FDfiIq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BeozICzC/DfBw7Y5oGzHLtsYYZ939+U3obr4TSxcFftdslaxiP/hEZ5RqDG7uskmpiwBnNFIPGUmApRRryktg6XzyonvdNKYIHHEGfodOJrICbpoja57n8MkcGQEZQyv0s+RlgmDkGDN/f5v62EucFanGewgYxMFL0zs0q+Z6tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=3TINPxLK; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=uGqyq7q3; arc=none smtp.client-ip=91.121.71.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="3TINPxLK";
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="uGqyq7q3"
Received: by nautica.notk.org (Postfix, from userid 108)
	id 10AADC021; Tue, 23 Jan 2024 04:32:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1705980768; bh=b93yNmc+VBgXRL09Mp5+7dMbMPdweACw/yHwyKfZMKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=3TINPxLKpzP+CnAOS8ruiRLuGUN1PORXrQJGS2SflN0ep/ND4RH1KRK/D4Txlcdyw
	 4OHNrH2MXfF+TDLSupxSRbU8ulpBuathC/jRKnSQ3a2khN+yCpQkadYfQqkTztoo+s
	 1Fi4jbo4xptftj0hj0nT/I1myEWAqLmFkSLfJMHgR8YdCuLYeCWkaduhSI+/KJvh15
	 Lapn4qgDtw+ZxLcHFppj4/oTOLk6T3Dy4ssajMNcdUak/ltVkIEpvl+f93gXB0trHN
	 8eL9G1mLYyLtsJ/bR1P3HuoiUhW3f/Z1TjLNtaV3mZaDKpOQ6J+B7HXjgwS2CpJAcx
	 2TlIPbkdWrk6w==
X-Spam-Level: 
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by nautica.notk.org (Postfix) with ESMTPS id C0C17C009;
	Tue, 23 Jan 2024 04:32:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
	t=1705980766; bh=b93yNmc+VBgXRL09Mp5+7dMbMPdweACw/yHwyKfZMKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uGqyq7q3dtVz1Wuap29NUBqW+tgGwLJWWHGmTDAGJw5xMX8FNcwxUheP58fmPzsbs
	 336aRtXaEnjOanTSAVTZHg9Q3tNGXIB+EysKQRg2a7Z0BtiylYGhTqzice5S/qpOLt
	 IIyDSwXdcqWYwji4jCsh+GThzprzt2gWwxqRcJTgFXN8jt7mhQLeH8k4HZEmxDnhNY
	 2UkFbsoK31jie5WjYB2Q+5olw4Y0j8QJCTJHZpVIDQ1XpDYZlux9qTu1D/NVuVXJJv
	 o72Cw2xKL0WF2HoIf9PprLW+2Isxf4kFGItMHBP78y7j/3qsQ8HDLex8zRVG+ZPCRQ
	 kxSmm+0rBUXTQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 130446ff;
	Tue, 23 Jan 2024 03:32:35 +0000 (UTC)
Date: Tue, 23 Jan 2024 12:32:20 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.10 000/286] 5.10.209-rc1 review
Message-ID: <Za8zRHpPN1jqKiiu@codewreck.org>
References: <20240122235732.009174833@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>

Greg Kroah-Hartman wrote on Mon, Jan 22, 2024 at 03:55:06PM -0800:
> This is the start of the stable review cycle for the 5.10.209 release.
> There are 286 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Jan 2024 23:56:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.209-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 3c264a5f70c7 ("Linux 5.10.209-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

-- 
Dominique
