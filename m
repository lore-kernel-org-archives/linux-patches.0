Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9333635AC31
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 07:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789285052; cv=none; b=My2A099olXceF6Up8KHWl/BEUXi1CxBglapI9rICnKlqd8yogO5A40umKWv+ejjl8E6Vn5XljKqUsoMtEmUPoGWI5o6+kLpPVdN9WnHCsuJJu/2EKOH2kkAQX0rhpo65Iz1LPAaAg4C/8tCjyO4BNCj9/qCZiZVlcnZ2EqOHIZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789285052; c=relaxed/simple;
	bh=k8BYXum/PuRaBEEMf596mYNLJ4sTB29GrQHK0crZ0qk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D2F4S0yrLg6a0rDxcdWkyiSzmG79ckuN4rsG1ALEVF1biuqTlj7jblGXqzaSwbOZuowTqebYWabuEjF/l/m4aWPQDOgyTImygJS8YcFbqW6UBs52NtGAUd7kq8715TDKahux14bRyuAJC5MnXKvaDNwI26GUCxaVBzl9pNrS+Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=JjhY6shv; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="JjhY6shv"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id CA78F14C2D6;
	Sun, 13 Sep 2026 09:37:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1789285040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GTBZY/rXFWFKF9FxnC104y6S3ZrR0NVi7aps1PvauN0=;
	b=JjhY6shv9fcE28g6biCAkVCgdodpXGrlWOvPiqGj8+DH/c/32MV2r413kjJuPa5NXfUcz2
	/UPt27C6wIt0+b74b1md1leXRTtO7kCaXMDTdLgJjfoF8fUmeRdFSy2Aem6feVl7HfWiA/
	TBtlP6EevVHu7UiT7drEWHTX/RcbTJp/9XQLuOsuF7s8E3cWyeUCVm8Vfd3eHpUr7GOBtR
	sPH7Lp2LF2jx5HdIowJdjC8Ijqt6Vz/wyHFlGKX0XxrknJ+3Fym1tTQ6IxJbrC2PI7qwQJ
	AE0QHIGre1dsMBDX5coX2elsosvTtzcMQtUgH+n/KLxFRa4oQqvem8MQc9pOMQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 6b118afa;
	Sun, 13 Sep 2026 07:37:13 +0000 (UTC)
Date: Sun, 13 Sep 2026 16:36:58 +0900
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
Subject: Re: [PATCH 5.10 000/798] 5.10.270-rc1 review
Message-ID: <aqZSmqmrIXXFzwx4@codewreck.org>
References: <20260912065516.948645775@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>

Greg Kroah-Hartman wrote on Sat, Sep 12, 2026 at 08:53:48AM +0200:
> This is the start of the stable review cycle for the 5.10.270 release.
> There are 798 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.270-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested f69aa74a8250 ("Linux 5.10.270-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
