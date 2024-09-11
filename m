Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5531C2A1B8
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 04:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726027458; cv=none; b=KIJiI7sTjgo40SZ4rneRgb/L/wFKP5FDoTk7Oab9zdlz4XvtmqMg+1ZyqsdZC9MmWRe3wSYbSBYAqdi9DtT8OVnhO25sOevbRsjk2BySzmqt9rYoXOA7sAzTUsiapapB8Cuz1yfLRkiSGtuhLbr5Ho2uw9cTg2A7BwSEAE7tL1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726027458; c=relaxed/simple;
	bh=k7NTb5W/wfJLGgtqJg4aFK9EsWEq5Vpft0/YuaQKC1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rbLuu9gGI7GnDeRP/UrxqrZC/FIfjQxubySAafpA5WVYJH1yiOkLgOJi6DaxO9ztBRL7CQXTn5C1UOn4Jkx0Hol+I1pir6wgz/yP91B0quiVEpqIv0J8okDUghxmMeJ06GL/2vp5mBROwBdTfmRs6LPmZEFXXpl7Kv5DRVGSHz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=N2vRlJAy; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="N2vRlJAy"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 5FDB614C1E1;
	Wed, 11 Sep 2024 06:04:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1726027454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V1L+VY5qSR4cVzXyL66IYrvBts8dTWMT5Fkv13DwB7M=;
	b=N2vRlJAy7GTirc6U4+yybgYW2/81DCDDH5fHPavSR5fdy0DS5PQvNimtUnf4H1S2RL4Tpb
	vS//Cqq5olO7SJxvo2dcb/BopHHvQTtRrJAJ7694Mrpi8n32uz1RiRRQ2ytetO0gOPOIZP
	5uLwbVFmA06PqCMuFEEyd5l5TUuDwDjhbIeGDxjhvea1yfgxgdpfnfES9lgzXxjqjD8N+H
	hf+MLP6aTj1TxLtyfCoevrg4wDBp0AuH9clKUucmyegiGIBtHiozHuQAZXLW54WIFvnZa6
	zEsHZkmLfIXekTEcxFSX+wD1wv/M+et+410YVVNS4kt0WosJguwoPp2aSSstgQ==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id c389f985;
	Wed, 11 Sep 2024 04:04:07 +0000 (UTC)
Date: Wed, 11 Sep 2024 13:03:52 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/186] 5.10.226-rc1 review
Message-ID: <ZuEWqCE8SdAmQDEn@codewreck.org>
References: <20240910092554.645718780@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Sep 10, 2024 at 11:31:35AM +0200:
> This is the start of the stable review cycle for the 5.10.226 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.226-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested b5b733d78a83 ("Linux 5.10.226-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
