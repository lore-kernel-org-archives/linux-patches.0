Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFE24F207
	for <patches@lists.linux.dev>; Wed,  1 May 2024 08:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714553118; cv=none; b=evQfrbuVJyyerzThn5srte6LkQ6voPDq/2XNHe+BsuVJHlrmZQjYVgc3G/FATPgVlHpZy6ZBTTs3yHkNDXH9vxmcVMR2w6+7UuGVmP5a8OQLwmpWFRhWRoLRrmZJnArPRcJA/geHr4zpLBjoefoUngoakciZ6swyQnM7ETZKjiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714553118; c=relaxed/simple;
	bh=3g29c/9Ymw1Ku1BygdtEahxt6WNzjNj9SmlkQAbCpu8=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=rWc6POBy8oD6r4vqPLrIu4smdWQ5m6+8oisTkehYDJaZFkjwHzFzW0iHM8NFaFWWaVySZ3PvBY92MHevWtr8/gq91ai2SVSSZKNydzTtsH2K77TrMqIDfHi67nxiN8ymHPHAecBycSGNDnGMFtW7z0gsGZpuufvgfmeb+XFCPos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=yTM/PQO6; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="yTM/PQO6"
Received: from eig-obgw-5008a.ext.cloudfilter.net ([10.0.29.246])
	by cmsmtp with ESMTPS
	id 22gSs1qABSqsh25aVs8PVf; Wed, 01 May 2024 08:45:15 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 25aUslLd8wT7p25aVsWW3U; Wed, 01 May 2024 08:45:15 +0000
X-Authority-Analysis: v=2.4 cv=etXZzJpX c=1 sm=1 tr=0 ts=6632011b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=TpHVaj0NuXgA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=w3vtCogE_fj71Z-Hq2MA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=U5zZUNkCthJCCdC4NF2rQFIUxXdnmN96a5roQLbWii0=; b=yTM/PQO61DCpQuyQ2eM3fUsUmu
	eKPTIms5Mfy12uUfkQJSfopQv0ncHL3Tn+T7cBBTFtZL6PTW8zGc4/KAdla0VSGXf3LA4+vR0Z4aU
	VSDOm+3qm/SfA8/LPBigiL1dF7wpKq2z080ocJv9IgujYNVk9TUrsF98vPCvWcsUsMhoEfdJ+t5GV
	w+ASWnloZwwVbuh5YQ5x/CrDR/Us0T/YMqCoCzfbFH6aYU71wQtxFJWJqUHW1hvcHrMWEM4yMXMUO
	J/oG31lmMjQM0IJxYvZodGWnOYz3bj+PheHRUG30oMGWqv43zJ3SSEiozIMltpm2r4AnYoy3Wedbv
	CD6IDsvA==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:60598 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1s25aR-00174j-3B;
	Wed, 01 May 2024 02:45:12 -0600
Subject: Re: [PATCH 6.1 000/110] 6.1.90-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240430103047.561802595@linuxfoundation.org>
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <f2ad3eae-dd68-3530-4913-d63eab56463b@w6rz.net>
Date: Wed, 1 May 2024 01:45:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1s25aR-00174j-3B
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:60598
X-Source-Auth: re@w6rz.net
X-Email-Count: 41
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIKM7Rs3WX3LyUMDwE6aDgUjHtQReIO0fBWO29J1CkAQ71inqGFgTghSopGNtu+LctEiSwVFXwn5inhS77liTFjfzHriQE+VTcqAoYZbkL+jB88TxpU5
 oAUIR6g8oIASjBORYM7OU9R3X1Xkl1nQCnfqbiuMX83KRXHsO23/5vD0DVaGB7+jr3xKEV8UBsBu0A==

On 4/30/24 3:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.90 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.90-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

