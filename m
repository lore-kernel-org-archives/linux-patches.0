Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.202.169.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795147031;
	b=YQMlwL0at9R/u/5657OpfeeJ9MIPXJoO7NZl+rwwvUgMgPAoGr6e6INtWcUjb+nZR5xC
	 4MqhaT6+SprhNkxzf1RlY57zJkYUzMBp1DkSPlG9ZkrNi/UOQRO8nnSzqZLAqk7rhg8EM
	 /AaKvUaqj/Kegqtzx5TwiaThdBL3LktqJcm75A/R3mZ5qcC/PWzlFu+Z/83VyIJ89Qa27
	 R/K0C2rXmCke2HB3QH+bLwZUFB+6tkaLlgM9oIbgWWG8Fm7fpuSYGPAca5Wv9ittEaKkJ
	 0CcSxFK0WHLpvPPfXEBQzcInpsSOm1QoD1Bugh2gg7u2aZGOTNTbgFqT3DJZjPb+kDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795147031;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=11okyqYHxE0IernNnQyz3EyafRRbkarCz5jl6k/WWBA=;
	b=q5CQLJpucAzQiwst4BucLxChbG4vFyWHPYzVGL7E7E6/7fLlqGsAu9zvLljpOZCZt4tl
	 kOmdB6SzqRgHNCehOnlAOBWEro1r58QtBT2ABEpSCcvQpYmhBonoOXEJrHgLHz9jHSXUQ
	 WxTv7E1EszbEa3MgEvx82gNzw2NM4MDBUV/jHxyT6AyUP7DpT0Z77AYDSy70ZvmisWtnW
	 9roor1ValqYbXqs0hkzEXFM9y0LHXeiljeBclydc6UneodeZJTee+wkuGyPeuhcA4eXf9
	 KKy3w05vCwx+Ra8fbEZj8gtZ+49XjElelC9RW89TTI9TW/KZy4zpUeIsK1I8zYXWDdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=JIUXM2qO;
	arc=none smtp.remote-ip=44.202.169.37
Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EF9606A32A
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 03:57:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88EF9606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=JIUXM2qO
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id UC2txftdvV16IUFkLxS5PZ; Fri, 20 Nov 2026 03:57:09 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id UFkLxw5EYuJrPUFkLxL0Ug; Fri, 20 Nov 2026 03:57:09 +0000
X-Authority-Analysis: v=2.4 cv=WLZ/XmsR c=1 sm=1 tr=0 ts=6affc515
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=UheLhBLhog78gnJQedQA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=11okyqYHxE0IernNnQyz3EyafRRbkarCz5jl6k/WWBA=; b=JIUXM2qOrIubJ6u7hVHK1jHHGD
	oNHMX6yo1YUSyEe5IJC+XlYpOcpCL1IYQkC957TCwYiCskR7Fb3anf3wCGpzsaIUwtkreEWxzHcZN
	hM+ffR/PX6CNwr9bzF2sib9pAk1gA9wJRYIebYBinVDznnbyf807AfeqqOKy7bJfmxQXO0Zp1Umch
	T9YPMvP/RgWNnaKQXaqMWKzjdPGRE0gBj9olPEdHXRUpCcHOJiH2uGpndoiM2v2r/mGrm1FGCS0eu
	JG8RG800aCw800hpyAWFYZ/qv83uyfx8WaCHKJXNuV4MfnFTUwp3bVVqsv5MCDa6jwXPbHfigF0v8
	EWjZ4N1A==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:33018 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xUFkK-00000001Pyr-14cM;
	Thu, 19 Nov 2026 20:57:08 -0700
Message-ID: <4a210c36-d99d-4a74-b94f-41f6a28d5040@w6rz.net>
Date: Thu, 19 Nov 2026 19:57:06 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 0000/2214] 5.15.226-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150009.797899913@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
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
X-Exim-ID: 1xUFkK-00000001Pyr-14cM
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:33018
X-Source-Auth: re@w6rz.net
X-Email-Count: 118
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfI/JK0mWI/T1Yfmm8w1RgTBgVJ78hpozznqEVwrg8uc22EwTgt+UuIy8nN9vd76PfJgyq09QOjM85RKXB9lugXkh5kKBm2AogRlOForf6st0vsnj8PHy
 9xTlNNmz35xu3UAFmzzH/Byd5jhTawuhlnj3Yd1+N6IaKWCMqVfB1L/g0UqrgnRGKQwnAoWZ/ruIzw==

On 11/18/26 06:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.226 release.
> There are 2214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Nov 2026 14:55:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.226-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

