Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94CD18E1F
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 11:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707909215; cv=none; b=TKbRUqdrRpb9CQco7oZguMd8ZK3LjkuQCT8sWR+XM6G02luJv3OR9dcdfACuq+TqlkjTPoIZXYCTLurhIcmJfrfnXqPaSA3qdVeUCLEDfScDplBM4Tm4nTdw4k8DbBMofmGA5p1SVjqRI5/mC+3ERPRh9kX/YCwdusNAukMEV/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707909215; c=relaxed/simple;
	bh=iLflZ9PnEbYl8GXEHbaZY3T06atPvwTgT/Jb0exuRr0=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=dEYMCcqmgypXf6QIfLrJGHzNYvkRRZ5TEJ9jD4hKT7vhWkvYeJ7fyKMsH/teolfZK/biwYYgh+5cwZbeG3vukCTXOAwQx1gpzzK5O09zd+FOsSEGruJcfZS7n3VcsIy5NeaTAFk3w+4uwR7anPJO/lCYNPcwuHcf173LLc2LMqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=4koZZDLz; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="4koZZDLz"
Received: from eig-obgw-6005a.ext.cloudfilter.net ([10.0.30.201])
	by cmsmtp with ESMTPS
	id aBVJrkJIF9gG6aDCfrdudG; Wed, 14 Feb 2024 11:13:25 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id aDCerllhdSZOwaDCerkbru; Wed, 14 Feb 2024 11:13:24 +0000
X-Authority-Analysis: v=2.4 cv=WZKvaFhX c=1 sm=1 tr=0 ts=65cca054
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=k7vzHIieQBIA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Z1RhuQvObekGR5VE35kA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xId3Yv3kQ+KIH1jIcASUszezOipjWVAnh+ch6eYfRVg=; b=4koZZDLzk6NUnV4nBH7scTWYvQ
	NtvWjNJWa2vKksTx8l8JNXbLwzFzq7ZmXqyqGHO0HxL9WTfjyJwPECbL+ddUHLGqWploYrVtqPua1
	jK1d4HBo1h/2lzQhZjQRB/3JTzkpFKEuARMaDvr/RfcvaOtcm9hE3g0vqtWR1et9Jktdmr9xnTdlt
	OP8dLDi71SrtKRTM7+C+Rkz9Qb3Ny7MLkuTWZjrSfBNp2gDF8WsDU4wOG6I1lsWcLWWHfl9k1RGqw
	2M9gBdMYWigfaK3ZjcpjWkuHn2w04tRSd7l7AP+LGNqvXLsj0Gf867S5I+Ym9sYoOTHTiA3AfnLnZ
	XypMklXw==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:46056 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1raDCc-000Ai8-04;
	Wed, 14 Feb 2024 04:13:22 -0700
Subject: Re: [PATCH 6.7 000/124] 6.7.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240213171853.722912593@linuxfoundation.org>
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <e29f092b-53de-67cd-2afe-f77154a6f906@w6rz.net>
Date: Wed, 14 Feb 2024 03:13:19 -0800
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
X-Exim-ID: 1raDCc-000Ai8-04
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:46056
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJP8/fKKSDCxkSriX3aTjHqcbM5AnmoVsWDfFSjDnRgFTpsWjOeArcEqBzbKf4DtQD6KvnSGNW8CufUBuRPN7Zj8V1pwk0hc6AZdEN/N6Cc4y9sMISn1
 eiMg8/h2WbrRi5rj5AqaJe+r6WwaZKeA/Ybd/BioSfpuGPgd3EzihWwERh0dGwkZOh96bp/HScazrA==

On 2/13/24 9:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.5 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Feb 2024 17:18:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

