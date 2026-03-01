Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CCE29E114
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 22:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772402883; cv=none; b=NYOUxeqwdwLNoWmeOw3a/oPMqtBAd1muviNkI4+kITvA0/qjsImSpTgtka+mPdGhn0Db3K6w4GE9hGy0rh3wQyV3YPHXU6uVKkx5ppt6VidQ8SE4EYffHTWCf6ZvGzc4zQniPdGMn/1GAd71+09Nf2CRCmQ/6Io0BC9sZ3tn81Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772402883; c=relaxed/simple;
	bh=AQplnEusqjGQnInPSkixW+JgT3wkaITSZFtHyk9xwpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FwfnQ6apWwJnVudgoDU1yj2DLm77Hmlrdxg9pDymMJJmGOBmXtNUvk0Jx6Xjtq1h3XPUzuCl9aQT12jKowMlh3G2ueMpnHDsvnXsbIsR38PHa0rT1xZFi6YDqVu46VV/UTawTk9kd/147/9pF0CZ+s46n/+X5XXkO+w158QuCcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=sSTan8h2; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="sSTan8h2"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id wJvdvjpSIKXDJwoxFv2abL; Sun, 01 Mar 2026 22:08:02 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id woxFvKkGmh8QWwoxFvDRmj; Sun, 01 Mar 2026 22:08:01 +0000
X-Authority-Analysis: v=2.4 cv=Mcdsu4/f c=1 sm=1 tr=0 ts=69a4b8c1
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=aKglea2J+qJaMft4HHA6gLZfkg56MowePW8m0ZBT+FI=; b=sSTan8h2GkdaH1XHMuN2sBPsic
	l8b36WytS1guAiNIY1AVY5BR3/J+nUcZWwc01U3SoMNUpMF0loSbcKby2rKfpjgUQhdhBUu/fs9XE
	5sMfylG6sudJ6SEk/zsxNPegOL/8hm2RAmXoHA8elfW5JjpLOsCXlf/sKZ84jbkGhrqGPaLObc4Ti
	2/THKtEClrxAeM47mICtQjwONCz2Oc2jzj0IEPCQ10JR+1rYpeyPTOSPsOxGho4sSmxyHVOZ3iAPi
	VP2idXn+YWkYEu2FP2+dEsF9sQ02jq07BIju+MqJamiDc947cCua9LlLAjv/d/jq/5yLI26y/XptZ
	CQmqisGA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:45818 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vwoxE-00000001j3X-3twx;
	Sun, 01 Mar 2026 15:08:00 -0700
Message-ID: <e795cd68-119c-4104-b57f-38f8c5424097@w6rz.net>
Date: Sun, 1 Mar 2026 14:07:59 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/283] 6.6.128-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228180659.1583364-1-sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260228180659.1583364-1-sashal@kernel.org>
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
X-Exim-ID: 1vwoxE-00000001j3X-3twx
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:45818
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfH3VzXiQk+uDvC04GrXzR6Ec7j9sk658zkw5RJCCCgpbNCu6YcIVm8XJGU9gtuKp6Gna2/ztUkHb+5UfE+Utk2eazHVG7FW3SmGd49leZFlxBs0FHWlv
 CfIlqNa/slY3E/TNFzXhrN2BEyYIFtVVbmgdqvaNP7ACck8bwULhVElFV3AoIdO+jz94POfXEdFanA==

On 2/28/26 10:06, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 283 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Mar  2 06:06:54 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.6.y&id2=v6.6.127
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

