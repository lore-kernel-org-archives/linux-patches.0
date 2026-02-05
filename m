Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B84835EDD4
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 07:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770277960; cv=none; b=e0hY6Oi8AcxZjtYz3HE1+u0LkdJPUGF0/oC2FhDnTH5zsD0YIXNcGl/E/yHN11OSBV7p2HxuSYwBoGAsXKrybWRnMfvr6OzbNAFbGV8QhIp3vwfDFir9CGU5yhyNq2ns6g1+OumTZlq9sVOy44j+3iOYUmzs6s6+gPz16z9NWl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770277960; c=relaxed/simple;
	bh=MryXMbJl0nYi3d09MwKoFoZ5NMuyrnHGamMXoy7EDQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eDz+1+2FnatylqNLXsBby8hg28udvLSS6QdjWmjrw94zBmGSY82LH00FE8nB/7HoJQ+OdOLPoxMzRfNTbYHlseBiylUBQQ9Bu8cvfM+eu5yCigUI2md5Edyi3t7VUrmpgN/GKctu1GSakkgeFEF6fK4dk/Vuwf8e9TZU6byzKoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Af0ulR+O; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Af0ulR+O"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id nlthvPsiBVCBNnuAKvpZhH; Thu, 05 Feb 2026 07:52:40 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id nuAJvGIUeHSQMnuAJv1aHw; Thu, 05 Feb 2026 07:52:39 +0000
X-Authority-Analysis: v=2.4 cv=GIQIEvNK c=1 sm=1 tr=0 ts=69844c47
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=swx36Js26iwtVeJqZBNYLAoB01iJdVvh0bIiRnF3Dxc=; b=Af0ulR+OX3V5SMWoKbd0Wspag8
	h7aK/C0WbclSmlxAam0YymsYM1/lyQ5kq6805+URbdXo1RdiYGb0ulVC47vmcwteebPT3fGJNd+HC
	eW/USdHMRiC29+TfGwVSMZCsKreyc8y0LCv4cm3lnGJKocx41g3hOkmKenaWkN6uzkuTiyjsNN3PV
	R0Rl905bV8zGtoH3GWrqfPYCrpBKkmsgpm0hMXK0vEXMB2U7N1JJcJu5Wz869ypcJMH1UYZsODxco
	QXNfFk5zsk94CVWjMmEjQeVBoR5NwuAAgx9wPk81FpOhScMJ2dKuqfdD8HMIgvLNmd/h8oXAArK34
	HOHSyxYA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:38454 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vnuAJ-00000004Mo9-06bG;
	Thu, 05 Feb 2026 00:52:39 -0700
Message-ID: <75fb4870-b02b-46ce-a7c8-78e4ba7840af@w6rz.net>
Date: Wed, 4 Feb 2026 23:52:37 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/280] 6.1.162-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260204143909.614719725@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1vnuAJ-00000004Mo9-06bG
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:38454
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBNFWW1XvoIWgcriLjlN/QZ4yx0lCw2tryPQQldnLtmwy9ck9Zzo0fYWS8FSSg1X9KBDRZGw/aleVrphzIYANqSRteg1p65pKtiABXsb92/UArp/rwg/
 UFGENurw5FXupBpkyczJ1AtqFPub6w6Bf+dEm3TSacXFd9tLfb2g4fv42jFntx7cBZuBxYQDGIfbaA==

On 2/4/26 06:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.162 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.162-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

