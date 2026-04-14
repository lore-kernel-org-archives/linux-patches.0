Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4551739D6E3
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 11:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776166645; cv=none; b=Er8Isw+gCbBDO9uc/2nb0QUcm46HYetqI+XbDubGXWTstexwvY124c56l6Pcepq+sj5R12lHva0flkWJavRL4/Sxb9g4t1SMjk/r6tQ+kByHBc+l0+4mzGtpdCkBxWc9Z48U8K1Ha2pNYU+FbrDS7tV0wi2bY+0MLUhF2inTAn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776166645; c=relaxed/simple;
	bh=7Ial3f5AKmp+3aQaG9E5VBEKF2hIIJ482FLoHFH1hKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CV1hv3/TCeYDZm+UnmXrs+xsJM3qjvTOjhRDwjEC7C63zdDHS2qMYUwuk4Il6Vl7iJ0my65zcVnK9Wan8dsP8K0ottwgWYA1IVsMK75CPCAhrxpUiZTU9SF9qS0uuNGubBYaXv1bp6A892a77wKo0Bor6D7NQFsl9Ap7UFCOhYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=47fCiu9N; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="47fCiu9N"
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id CauMwwIODjw8YCc55w1nSu; Tue, 14 Apr 2026 11:37:23 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Cc53wznJmYA8xCc54wO0s8; Tue, 14 Apr 2026 11:37:22 +0000
X-Authority-Analysis: v=2.4 cv=VJfdn8PX c=1 sm=1 tr=0 ts=69de26f3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=6VMflzduPCjJA/gCD3m3GtCbh9lWKMbmgxIpHhwSJWw=; b=47fCiu9N4Dyw7brSDp9czX3xKL
	QTQcppxBGgSqemz2vG2htriKIEQLBqQ+oYNtDaw9QjxILGTKVa3/HrAZRjbULUTenDQTMylp4TYGl
	5PUPvlSjTN4a1nfPCjjnlVjg5JPwQ2y315g1IEDzXIWB85+nc2qofbOo9VVaC2Bh7SMVgGvNjGHp1
	9ojbW6T6mtWO/C6tfPKzbPyuEDjYPTqLFha34FmHB1EsNNw5Ckqxk+ERaKswMu1rIDTuqS7qvcifP
	ZTUht0qqszLGTmJ4wbUxDGGN6IAQU5mekrSAsUfVOHjzU9qN/6SxBVtKTu8hoEXiWTvjlF95qItCV
	/OffKcwA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:51384 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1wCc53-00000002fsy-1Y9K;
	Tue, 14 Apr 2026 05:37:21 -0600
Message-ID: <29178c5e-f9c3-4523-bdf3-0c18de9eae42@w6rz.net>
Date: Tue, 14 Apr 2026 04:37:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155728.181580293@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
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
X-Exim-ID: 1wCc53-00000002fsy-1Y9K
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:51384
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAzaQoOSumDqFWDauAQpx3aOn8YUl338/KvBTdTdP0I1nXkFiapZOU0VJcM/dp7hW4dKNPyfo7N+9GSsqiUqluTt1YhVFng1e88ijIQ17u6w8EKDpc3S
 yaHM7p5ocfErhPNFywXjAFql2tLjoiVyvMt+5CCXJe54ZcUeXcQ9O24IxAL+QMrsNW45q8WIvUkzxA==

On 4/13/26 08:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.82 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.82-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

