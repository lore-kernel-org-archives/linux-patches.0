Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39457157499
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 08:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713947210; cv=none; b=X9cBcyU/+bOtuXFvCj/gSvByVJGpfIOsBPbyuOKEhQUpvcCGVFH1xAeMr+At5NTjEyIaBDA/a41ch2k5zAnlfCyMA3vqTsX+i46PiWE5gOQk72NNIvT3o/QIllxK9iVOKvf6utYHCOZTvwpxAdwCXnDVrzlXF98X15N6AReGa4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713947210; c=relaxed/simple;
	bh=KmTHIIywUObQdICIchFzfqvn8mHrr2b/cCg6d+QkkeA=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=WgteBNug8JlmR9GBdb62d3BOF19IfEZN9FIyleqVQUEbO6u0oojvTWKGGztQqw2YCDh4pHXebdFxziMG/LNxPkvBoXkutm3fpPR+HdCWS3iUp0Yb/4Juj8kY2MXFnsTfI5Y10GHSV/LFxCUp88cOqS8iIBht/6dcVtBjZ2dY+rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=3Lky2W4c; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="3Lky2W4c"
Received: from eig-obgw-5006a.ext.cloudfilter.net ([10.0.29.179])
	by cmsmtp with ESMTPS
	id zE8grSaJ3uh6szXxnrVqG1; Wed, 24 Apr 2024 08:26:47 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id zXxmrVDJMevjpzXxnrKnNJ; Wed, 24 Apr 2024 08:26:47 +0000
X-Authority-Analysis: v=2.4 cv=R/gFG8RX c=1 sm=1 tr=0 ts=6628c247
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=raytVjVEu-sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=CMKPsDBNFkSOfaRWdswA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=9kH6E5uNEsMu+RCPjQCAkG0PnO5BVQA1Lz+SzOLuonY=; b=3Lky2W4clwqNTTcDFlEGYBvox2
	ZEXy2HAd8ye2h756AYq/iukn6goqQH57ufvwgd6EboVCOoFrX6GK63wdM9MYvGpytGWccFebw9Pxl
	tg35dYikUQ1BKfPu1bRXzKjBu7ZCGPPxzAYe4NwswovavJRMWvlxZ1C8zYmAylcOIdKNi8w1oGUZL
	vlPpEcnwZamO7lHRXjve1I3ejpm3cn4tKVsRtPvm8PTDUjOHIP5vTS8sZglNpktnmtY43+aRDpMeG
	/YATffNbuY5/2o08kaG94/fek2YgfYCj/md/GUMzEfDbQrlBPs4nohLc2uyWu6/RC5CuylUEcNxTt
	S3roBZtA==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:59358 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rzXxj-003cQc-3A;
	Wed, 24 Apr 2024 02:26:44 -0600
Subject: Re: [PATCH 6.1 000/141] 6.1.88-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240423213853.356988651@linuxfoundation.org>
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <abedef3d-738e-6f53-73c6-39e3d5c6735a@w6rz.net>
Date: Wed, 24 Apr 2024 01:26:40 -0700
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
X-Exim-ID: 1rzXxj-003cQc-3A
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:59358
X-Source-Auth: re@w6rz.net
X-Email-Count: 41
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfP2IpXvrd9aF74tH4sW+JiqAurQPIihRP4fLdkfLP31RNBMxtqt2zwlJnZJObWEAomW3hcHESX7KyomMm7+e2QZgmtMXjoOS5/sefbZ+WWUEbAcMvV9t
 U2rxxYQBOysYBrc7r84tpsxNA5ZzPciZCAt0FP16AwACWYfrlksj/2N6uRHUkiS71p613paWl1PwTw==

On 4/23/24 2:37 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.88 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.88-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>
