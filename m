Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0202367D1
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 02:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759287431; cv=none; b=jouIf5q98dAB8gF2n8MjbTzp1i43U53di3yz4WVBSNhtFaKofObzgOXIDKuAv4SqkfIi5i7+1+I01RMkpxsGg9F+5fUqcLVe1kqg5Q9VX2PfA+yynIBBxrytatdkBV9SsZfFUYfFx3r7SohMk0gP0qjJowFN4oMc+OeNbwQqfu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759287431; c=relaxed/simple;
	bh=GtczccIzz5O7Z16gKNcv1d0B7uzOoCg7X8Xa0WzZdAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HkWN4Eqgjh4mg2/j5ZPsid+V+lgOw1H7fbfCexrIZh4n2KShB27EY14jqOaKWgivYzcDJmCKTe8U/mYVmHsDbZ81cCa5OOFtZh4acPb/cmPWtAuqRpnlaLj/PwH0gLdPdtJaBBu2rpnB5f95ijhpsqrLwnsr7XmaJ+gfwWUFwag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ryg8qD7T; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ryg8qD7T"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id 3jKOvcdDQjzfw3n1hvnvB9; Wed, 01 Oct 2025 02:57:09 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 3n1gv4sUHp0Hq3n1gvh8Tb; Wed, 01 Oct 2025 02:57:09 +0000
X-Authority-Analysis: v=2.4 cv=H/nbw/Yi c=1 sm=1 tr=0 ts=68dc9885
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=p6xn7wKALUHmEImb5F8A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LC4TixobF04pYEoU68Fuq0uTJ86xlzmVuhaZY5JWCoA=; b=ryg8qD7TkVIAawpqrSAk373Sh3
	EGTeWNpt0SxSXcY5LCNE3nV5MBKODS+UYF7hw8OgNiwazT4ChW1Xb7l0j1R0LtHMObPC1oh+esPHq
	V/eksqdatVSQCMsjpOdH+Hx01DcmC7H/uY4GfPqTC6dwHR3i8p1LKrm6oleg3ENKsEXA1RclyDiN5
	aDNNmZpMAKhU+Rky8c/eIEahvu3sA+z+fvSih5r28KPeXPLtKeiIjyriY0FGbxzbUSG8/65cPFL/i
	ncR9RWTl96eek2vPUUNQIPCz0IrGwS6TPo0C+7aN1OIsS38cnEC/J4jNYKbtvLuultwKWRtkRu+j0
	cb1QOaZQ==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:34780 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1v3n1f-00000000ZJr-3gt0;
	Tue, 30 Sep 2025 20:57:07 -0600
Message-ID: <fa16c90a-ab74-4848-bacf-c0549bdbe227@w6rz.net>
Date: Tue, 30 Sep 2025 19:57:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/91] 6.6.109-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143821.118938523@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1v3n1f-00000000ZJr-3gt0
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:34780
X-Source-Auth: re@w6rz.net
X-Email-Count: 55
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfODjBhhRsCf4ztSINJJVto8VV09Vv3tZjLhc1iPvsLORegOBtCWf1wGtOakNz3vz2JIqOaCAa3H63RLPileaXIWWvdXmbJfSNU/NgeD2M0J6cyctFyal
 qcokpgg9tNFQPSjdzz0XHtx7XCSYVGiCc0GpaOIFDEL4qmZffo0Um2dJtkLFvk5OtTPkqP9hPPT06w==

On 9/30/25 07:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.109 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

