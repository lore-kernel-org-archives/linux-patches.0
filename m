Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BBE4171D2
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 04:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745985680; cv=none; b=q9mh130mvxgmeBbb3XJNs7INdVPPbERW2QDjnzIAJhKk2wfSkQZD9fzuEvykYLKyDXgg4xYyLfC5KUqpLsjxnPzyMBObX51txZEvUaoDdRun8JGMz2Qz0kWWRAQLFPl1G5EQVAMtPEknWUpoFYbxDsGRd5rsBFdjJFp26O/3V1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745985680; c=relaxed/simple;
	bh=Sji22FZ1M0eD8lQLStguWTgwHobTvbJs4tW4DqZrs1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PveeuC36F8k7atJGmH67ui0+BMebHfggve8Pg5TEaNa5/Os2/0xyD28v6FAQJV6ndK6C9jvxZ4697Hv5meNmn0ClfXmJ+zgAR93KW5P8i+pl7Wlzjo9Ynpm1TtbtlV7wvN10vHoBBXPUmb4KiFM3iKBEglAuIx0C3IpcdHH1Rog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=notk.org; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=notk.org
Received: by submarine.notk.org (Postfix, from userid 1001)
	id DB4A714C2DB; Wed, 30 Apr 2025 05:53:08 +0200 (CEST)
Date: Wed, 30 Apr 2025 05:52:53 +0200
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/286] 5.10.237-rc1 review
Message-ID: <aBGelaBd7q-br4e7@submarine>
References: <20250429161107.848008295@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Apr 29, 2025:
> This is the start of the stable review cycle for the 5.10.237 release.
> There are 286 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.237-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested ce0fd5a9f1a4 ("Linux 5.10.237-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
