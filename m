Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF133515C7
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 21:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789247511; cv=none; b=pxyN2wTjtFBqm6kikO+suh3UTCpL6no/rHk/FCk4BW75lSfUaH2bvciGWwVHYcT/T+vHPU6NTF+tbQgFbVPM1cdcm6+UZgvZgBuyh9VYLm7k7Z3innoPb1nRX9ilF9jP+pKtDjL/Z9XrlcmbRy4/TOUzs6RDil2q8U5EM5XADio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789247511; c=relaxed/simple;
	bh=8BBQ6kjnp+uP5XIue0haE/J//P2ZW6vcDmkaSWv0rJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNX0VHexx+VrhIWtNJuyaplW7va7pj74BHwJfrv403j6lvY4FUjDgRsXrKKfoO7oJH2RrnAj60q8FwgDcseCT96MWf7lNNCTCDPi3hhL77HvvE/RObRL4m/5jIlx5bwrfQwWodDuTC7y6lnqRGfNq9nE9niv+vsku2LVOWNgzjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=mNWXpPBU; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="mNWXpPBU"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 54C8414C2D6;
	Sat, 12 Sep 2026 23:11:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1789247503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mab7f1B9PnjhcruwvAv5KUtu38AlUoK6V3lDJRX9oSM=;
	b=mNWXpPBU48wU5cpMmum60E6bnS7i3SuUGPwflZPnD98B4m84mED8zUSMjs3LF0GVib//85
	FAPWzqtJEgekrbUmQKHHhkkmmgH0L94MmO5LWfPSEKUSUSTk1+MspsD5F7I6CLkYWg6/4E
	baShRVKFL5QVig9IaaQFWaapw/BMga02eSYjRXRA50bygUfd1CASMNBislCo9Q63WvWmr2
	QsjaCUky94n1FaLATa38qmJM/D2jOHd38XeovZzjW2o+MM2dmbxf8dhz7LeVw9dQZo67mm
	fLjtrOH96exPnuk6WMOlF7kR1liEC1NPjrbGu3qqv/22NBuXOqiSVYD8tKrH+w==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id d69e7534;
	Sat, 12 Sep 2026 21:11:36 +0000 (UTC)
Date: Sun, 13 Sep 2026 06:11:21 +0900
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
Subject: Re: [PATCH 6.12 0000/1376] 6.12.110-rc1 review
Message-ID: <aqW_-W2l3YYARUJE@codewreck.org>
References: <20260912065607.535295758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>

Greg Kroah-Hartman wrote on Sat, Sep 12, 2026 at 08:40:26AM +0200:
> This is the start of the stable review cycle for the 6.12.110 release.
> There are 1376 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.110-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Tested 5915db8cc000 ("Linux 6.12.110-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

(didn't actually check patch content yet, but there are way too many
commits for a sunday morning so will reply again later this week if
I spot anything concerning)
-- 
Dominique Martinet
