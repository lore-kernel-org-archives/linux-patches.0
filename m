Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12192770B
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 08:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727598029; cv=none; b=C+59UP3/NUq6n0YoqqL/OK4ZUVSDy1YtOgh1jSSEhLX3gpipNdpvWPn9rvpuCZF3MIhbh9nL5i5aNKyR5XSVLrDxmOyW6XNpVBQtRE30DrRAdNRAQ7n4Gur1w3MqYp00ggNntUPg6lQp8YTcDe+ODhhF1etbys8jn24QPKNvThM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727598029; c=relaxed/simple;
	bh=I13Fpw5uTMenjXWyGuatTrgB1UAtuVzq60jSYiuNPGQ=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=aXZQgBKpiiBO5yfk/BY2uDBHb4OTGb18njX1TQkYnxEIhBIRW9BFJdjbGDOGYpj6a7Z+uufR3qtcOOzG7tybh6oqbFNWbb+kRT9DzDo/8+4Onnlo3MMZOR1ap9ElXa0BP7cuI12b/KE6iBAiH3H7AF7i+NG7e6BhX8koSBLD0Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=agxaYVdc; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="agxaYVdc"
Received: from eig-obgw-6008a.ext.cloudfilter.net ([10.0.30.227])
	by cmsmtp with ESMTPS
	id uVWis4T7UiA19upACsTk6H; Sun, 29 Sep 2024 08:20:20 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id upAAs37wVFyvuupABsn3X2; Sun, 29 Sep 2024 08:20:19 +0000
X-Authority-Analysis: v=2.4 cv=TZeQtwQh c=1 sm=1 tr=0 ts=66f90dc3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=EaEq8P2WXUwA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=apkkSM20mLLOJUAzT4/TLg3b+haxaagzswG122a304E=; b=agxaYVdcA/n6n+2JXHxQ90sX0K
	NmtNyqreQRy41nE+RizH/RmqiSQ8Iv/WUTH7tBlS/jUxLAfnL7jkBapc0XRMru4yikC1Nrav/pR+p
	F2tB8GUbsRYtCdf8aPtpnIqpojDbw6EyDM/TbZYZ5Mb1TGgG4ReM/ZgYe5zhmjBcLpOPST+J0J9BX
	rCEYZfaS6MDP+aMfkOdsCFPmftMLHosVCxOZHYCdiMaNvkSe4Okt+f0LYWA2AvrIpvQM/SuuWLZC7
	//05hlrcmijbvJt3rRFSl4kg1RSZDgPLih9cyf5405YP3/erCMZBqyCCSoCwX/fZu/bLTXzy5isyk
	mq0eCfoQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:43234 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1supA8-003kLV-1z;
	Sun, 29 Sep 2024 02:20:16 -0600
Subject: Re: [PATCH 6.11 00/12] 6.11.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240927121715.213013166@linuxfoundation.org>
In-Reply-To: <20240927121715.213013166@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <7e51fe90-d666-1b82-5b5e-e97cabc95ff4@w6rz.net>
Date: Sun, 29 Sep 2024 01:20:14 -0700
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
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1supA8-003kLV-1z
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:43234
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHBDzv/Zh6E7ZJ7NdC5Ebo8SqSMqZRZeO8TcQiLQj2/BHWbMIFKQ4cUgh35XmwLiS+dh+Nrjps0FF9bqfmqTC9lwDzbMHQP+Bwi14WEzK6epU6DKo9tr
 CrLkgxpd44JdtpUGPPUMfX7yqB/C2h4tY6pkTy8N9eiwdLM8eiZHCVyLKpk5ncwbzl32JXnV40lBvA==

On 9/27/24 5:24 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

