Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A2A175A7C
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 02:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780279366; cv=none; b=j6moLgnR2m2g34+vwXpAoYAfnUkZz18RkMWxfpPXIiVI6NuLvWN5FuNJEftShDNuIqvAUyF5lNJheXGw2Ps2FPgMhqKGaUUJ8E8Q5dI1ZB2HcnoEc/FVRGL/ESfdlyme09VBdRtF7Xl7BGx0VXXh+IPXbabOQVawoa5WXNKu1ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780279366; c=relaxed/simple;
	bh=kIyAVGqikNIYBqGlMVbXQ15Ume1KkLxgyU0xZyeKqZQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IvEhpghgXpUsn3PzTcJWwXz08GKOb0Xh5IjlPmz9XPtT/Y6KGHXcJYApMLbsKNeCeOnUeGxnlZ67q/8V9zpC4k8fWykakOE7Vhv/dgp5KRUYHaB8u5NLo0VgyVAXsBK44ndhNa/IzjyHmr68tLNVMGSaM+dpIsvp00by1noq46E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=bTpuFKv0; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="bTpuFKv0"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id TkSCwhLtRKSRRTrxkwH5RD; Mon, 01 Jun 2026 02:01:08 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id TrxjwNO3m3HCDTrxkw6qnb; Mon, 01 Jun 2026 02:01:08 +0000
X-Authority-Analysis: v=2.4 cv=TOdFS0la c=1 sm=1 tr=0 ts=6a1ce7e4
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=DPl5NJZ2HP7I81JMaYIA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=BQjTqB8t+I+ZxzfC5M5zRR7DNmyY9UnWgwS6DfA5LfM=; b=bTpuFKv00w5keNWpyh/OtpL/19
	psxIKEVUgdp3v7DZyKFT1Y3CkmuwZpcQ88GbRsfIg0yTCeh8JdeboniH6s+20zlATVtjs+u1xrlu5
	TsXI3Qu6jBbVzPn/tVwhuyJGCGkQocBxuIRASQohyTonXCdK0IkYTQjeRkpz71odE28Zlesfke4dh
	12LHSwMnUtT6d47Dd3V/B3w60X+984WwCNkSeuTZoj0bt0W97WKwxk8nUQc6lwNaGqMUnFso78Yo4
	VR6uGb3uQLAtb1QrQ5VjdglZyVN7MXbLDQqT+g8ctWTqlshreIYTrqzKcjddfZK8patMz3Kwhu3Rs
	R+1whOXQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:35378 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wTrxj-000000028U3-1Jg8;
	Sun, 31 May 2026 20:01:07 -0600
Message-ID: <b1baa639-fb6e-497f-a5ef-ba7c31b4e864@w6rz.net>
Date: Sun, 31 May 2026 19:01:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/969] 6.1.175-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260530160300.485627683@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
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
X-Exim-ID: 1wTrxj-000000028U3-1Jg8
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:35378
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKvarobK61D1DlpN1c9y5Cn+z+ry4+fZYynKdIyXw+krPwExztuiabEdQOsWqTeFpIvZHn6NE63U8+wQVBPeeEjZMklRBNwYi9u8lpxB3KymEKuZESDn
 +2gfWS0Na074Jpu8HQMPPqp5e6IJ7gC1YuIKXmMax+tEaDzV2UoIPQfmGvV3qIFKr08nfq2t35vp+g==

On 5/30/26 08:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.175 release.
> There are 969 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 01 Jun 2026 16:01:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.175-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

