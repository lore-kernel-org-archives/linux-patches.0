Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06246244670
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 02:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764814970; cv=none; b=NoCqeF9Klb3PKnkqtON1CGVyUupPfia+cffewMMwHFdOhN9ZuZV9dMxFGNtpmRyH7ha3VwMahMurVjLFM7I9hPPJVTfgiQrjXRdZIzWzVTV0k+IthjmnvtQ0xhgp76iXDRuV73gZJLK7/PtelLtlm18LD5a7mQVzroITDel7Pmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764814970; c=relaxed/simple;
	bh=yzAODckhM4rFpo7i9i05cohU5moyuWPql2YE5M8UYxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pPefa0zqXM5uLkwd++ET8+hoGiPfN/6baWpeAU9vwDfeC/0hoXVQiIpNvjC2oMGIqR8zDRiN0MhdL5GZnnDjFUfG0l7N2yPe4FE2obk6VHTiXONOtFV5rkMnBUbV89OwQ2CA+/Hah+kf5PYmyfvZmw6ESefs27iqUixsDT6I6w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=FUtorLZe; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="FUtorLZe"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 29BFC14C2D6;
	Thu,  4 Dec 2025 03:22:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1764814960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eDHm18M974h7SrfSginIdxPvfaA4pN1AlaDtA/joVMs=;
	b=FUtorLZeWqSRN0lsarMADHq/fh4hk4nGqvGsOGlxBWOeXyMEmE6xp4xBqkI/HjafWXU+T0
	E5vAF1lOndwlfH24+yEKYV2zRgL6Nj8KkjOvkLjQfL+1A4OAs/4p2q9FXy3609xIg6wjA1
	929rlPH3/kIQO3hdQJ5EmiBvFJAU3hLF8XphKSyEzEebY6qBsnFGS+trr6YnRMwDHmEpGK
	ls4bvv7zaB2jbasyvaZ/u/qkiImr7qN/F7tykgC3YFDbSNW8pTc6PStYNPVArneX/II46h
	EB2/v5AtpJyc2jmhT1IBv6lB7TaKmhIAmrcZL7EC6PBU+URwRF8t8prUbN2ZBA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id fbf56700;
	Thu, 4 Dec 2025 02:22:33 +0000 (UTC)
Date: Thu, 4 Dec 2025 11:22:18 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.10 000/300] 5.10.247-rc1 review
Message-ID: <aTDwWlpRn4I2JmuL@codewreck.org>
References: <20251203152400.447697997@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>

Greg Kroah-Hartman wrote on Wed, Dec 03, 2025 at 04:23:24PM +0100:
> This is the start of the stable review cycle for the 5.10.247 release.
> There are 300 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.247-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.


Tested d50f2a03a87b ("Linux 5.10.247-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet

