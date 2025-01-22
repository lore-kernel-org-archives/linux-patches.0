Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07237156F2B
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 11:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737545387; cv=none; b=lkLWKSiT+Y1WQiVKAGXsBX+MHjlEzsrMtqoEE5MbWbDji9imtNTKrHe2chwCyG7N5rYWUQSN+GmXBCbUKgztzxGlF8LtnnxzV80hOleFzOrZwyLM2Qs1EkOMw3LanAnc29PS3gZ6cupjmj2i+dUK44g5lFKmdm1ehl5oJjg/11E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737545387; c=relaxed/simple;
	bh=bPKbKvF+c0/9ffoq2We4FHJekIbeOf8rHFTCcowBsgI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z1g0puydwejYOr7zhPc9GPl2LagCAzcaBzLf4TrXla/RgLZxIT1DVlOVkC+0PnE2dMuIQlhnksn7Q8vgRokA0PbI8t+qmkVdxvgpjpwZN4PJ0TE9MvvLXQDcPvku9dgL6U5N8hrzm56j/HcNle5lSha1xyRhFZxerrNnxUz1VwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=wCyA5EYg; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="wCyA5EYg"
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
	by cmsmtp with ESMTPS
	id aPFUtvTWFAfjwaYvXtGqWs; Wed, 22 Jan 2025 11:29:43 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id aYvWtbvwmHEACaYvWtRX0E; Wed, 22 Jan 2025 11:29:42 +0000
X-Authority-Analysis: v=2.4 cv=HdLfTTE8 c=1 sm=1 tr=0 ts=6790d6a6
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdSt8ZQiCzkA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=N6S5BkFEZOQ7AHEsthEA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Q8oQjlQ/g5zvR8k8Cp5eb5VXKejq1jXgCKe68fvmcRc=; b=wCyA5EYgXqur+SU4E/7jQwej8Q
	qi9VXXIijIVpNip9Ct+kauq1npWq1yy4Y0TJyDtrPMDmdUz5ciNOIz9zxm3k7IHDVOy8pUGI2OKOE
	MJ1N23yGE5OrOqN9NsJXCFvCiu2pj9TcgCcN/0OBWL0S5txjk8TGhLDOeZfQQ34RAGRTFyFvELp9E
	u8XSsEVzVy49sabkj4bZGp9NjY/SslbTv2DOnLDAqqAQg8iSYxuWOn8frqpXlICX7YT/CHwfFjtfe
	Zy/d2mERquUQrGjWVxp/Y1/JK9EIviuJLVT7TwL2RIfVDiwOhgMbYQl0twwN/r6xhDo/7AxRbldoM
	0pxMWJnw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:56230 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1taYvV-000blX-1N;
	Wed, 22 Jan 2025 04:29:41 -0700
Message-ID: <37856bee-2886-4292-ab14-cd152a0fa569@w6rz.net>
Date: Wed, 22 Jan 2025 03:29:39 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/121] 6.12.11-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250122093007.141759421@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250122093007.141759421@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1taYvV-000blX-1N
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:56230
X-Source-Auth: re@w6rz.net
X-Email-Count: 42
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCJTBe80C+a714Yrti6JkIyGPIBITfzcECpqZOdkXrUrz6zi0FKNJIFd1GGpSqhsF339gc2OeT0J8leSCd/tqX5ODopFmvZI8DWoBbrqzz4C65+Tc+nQ
 yra6tsWVAHl8foGz3f56Z2LX3UnNm/tgCsiiZBDF1kMlSXZWPIFvJzs2RIljJct7TCSt9MrBDVa5nA==

On 1/22/25 01:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.11 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Jan 2025 09:29:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

