Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD0F25B663
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 11:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760183470; cv=none; b=ZL/l8bv1BW8tVO4wqRdcaHUnPj7LjLn8eAl+RSzgZxYvj+peV2jnJJ/S88r8qEpEwRm64hjf7FHF57VGIW5v6VFTKShOLdkmMX+hPwVGuXV0nDWtlDqZpZj5b0NHNg0Tw78tbHTHsfmFRECY9+G52k/QrEExLx+f6fRoMh7XakE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760183470; c=relaxed/simple;
	bh=098OeeX4IliHr82oSjeqB/JsXmrpro30R5/KPLzVS+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pb93uBR6GQvkSZn55NxocVtnymJRqJPU9Rw3OQS3NK7Sxvenqjqfh5ATPsnQR/GJADb4hUvZs5cvnTtFzHXfJh6QQiHxUBNtCbVugkmwCw4ICBGNFDtqCjt9e04CgMYUGiEHPHqIg6pl5YsBm4D6ZgOx6Me7pBQQQskMEP+BdlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=wUE0kZVg; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="wUE0kZVg"
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id 7VSOvt5UGSkcf7Y7kvSA1u; Sat, 11 Oct 2025 11:50:56 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 7Y7kvwuvTfjrX7Y7kvfA6p; Sat, 11 Oct 2025 11:50:56 +0000
X-Authority-Analysis: v=2.4 cv=ItcecK/g c=1 sm=1 tr=0 ts=68ea44a0
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Q0YZzimFZhAAkqj1izUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GZytbWVs2HsAKfU8QUWZlmG2txeze7+PeqMAOU1sZvY=; b=wUE0kZVgVb+y8LNvKTVqX4HEhp
	O7zs+umu67bhb8+WTtTFlI9mnhWYst/wugcZDlaoocJ7WlEvB5lsUMCRG8mMy8nQ6+B6U1p1kzFRN
	AXnIV+b0pEWcCqqWYrk6507RSUXtPfFd/qOEgcfj1VJqfgvm0VftpoEwYZDLBoU3ri8yS7FZw8id+
	btTsY1FzF9XeUcoASY3Gz/kDwoYgmDRMM8r5U1JfWY00FDzl96y+aJO+w7NBrncbwSSxGHo8gbNzZ
	cBxpiwNzcgPcJ5qG4eeCCCXXYyvaI8QKZvCR2KAGU4SrG5giLSKUwEynOAuNYA8NAzC7tyic1WBfT
	g6FdsaVA==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:33184 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1v7Y7j-00000000yPi-2GR7;
	Sat, 11 Oct 2025 05:50:55 -0600
Message-ID: <9d3697fc-be1a-48c6-970c-b4ce304f23ea@w6rz.net>
Date: Sat, 11 Oct 2025 04:50:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/28] 6.6.111-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251010131330.355311487@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251010131330.355311487@linuxfoundation.org>
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
X-Exim-ID: 1v7Y7j-00000000yPi-2GR7
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:33184
X-Source-Auth: re@w6rz.net
X-Email-Count: 74
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAEQ+lS9RS2vg1bk/4Dm6SutDCjh9C2hyhWu4XzpVDHJlv+cLCabknN/ImZkkMafj/N4FZLHfT7sy8iIiNKE4NYxS2K2GYy/wzDWs7CJAIzYnlNB/Hyl
 F5KVxv/KMVR2gKZtTVTeJJlvQY2EqO7slJyN+/+gnEtICcKHXroiIAM+T3HCoTYjIJgDab2VKnOGBg==

On 10/10/25 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.111 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.111-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

