Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8B41CBA14
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 15:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729005950; cv=none; b=AIFu7TbPVBpF4hMPWAcOEy/shIAnoeONyLLkWwATUgkxcXuZOlQSJTRKV80axoKsm7fAwPs4WMuhBJ/g9E+9F7DcK9Vd17C2Kc42F8QYXrkvjLF/nHDEk8ETqdhc93q7Q7a9Xb2yhLHb0nw/yf1dx/vLVeXQhGrWCCg0E1khqbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729005950; c=relaxed/simple;
	bh=NlKtwh+WhTORKH5aD7FPEwxmYQ5WtZi2HQF8QoJKsyo=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=ZyPBmlKPlCxGSpLH43Hic2xRO6qpmQkqVYQSEp+8BJ7XFsUz968rfxyT52/SOrXtE+11TaLAxBVyLCN48xglTa+l8+6sI1/iQijpU1CvRoQFb67RikNTrgaENggsDEJyEb2+p4pYqgLMQ8v53AsXbBQ1ioKobIFBNcay7MNoWSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=GZTy5ZTo; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="GZTy5ZTo"
Received: from eig-obgw-5006a.ext.cloudfilter.net ([10.0.29.179])
	by cmsmtp with ESMTPS
	id 0iZ3tdltFg2lz0jQhtjaHH; Tue, 15 Oct 2024 15:25:47 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 0jQgtstr5qFuD0jQgtfMcO; Tue, 15 Oct 2024 15:25:46 +0000
X-Authority-Analysis: v=2.4 cv=b6204MGx c=1 sm=1 tr=0 ts=670e897a
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=DAUX931o1VcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=UiXv1XNBzq_yEhrWseEA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cbcSXoiP4f/zDA4ll/c+3KBailv6s4L/7Reu/3Vv82s=; b=GZTy5ZToAINBlZAGmdG7xI/Z5x
	IQOaVmZzEhemF/6Ob7YzwnhB7bKy0OR8zWfTDphgJWt8fFXx+kVZNYb+VvsuUu+Q21VBOAQwep+Wc
	7chb1aet7tytYW+yM6XATSGZwyrHIh2mQMx2w7t50t8mCcnGPpPF99OHSZTEJMKWovOaFsMXOL0XW
	w5G1EmhHMhvHpmNHdGuMbQpf77zCqhDdtmmbRBOPA8G/JIa1R5pxbP9JrwRVoQDqLrH0pucKTk1y4
	yoVqatVOtFfKQKwlcJEwi5b5UPMR/vXJSEO/+ALgxdLMJYeeaBNz8hdsUO5Q7rAuB87Uovi4mNKiL
	4Hb5bSNA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:47882 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1t0jQe-00233M-0w;
	Tue, 15 Oct 2024 09:25:44 -0600
Subject: Re: [PATCH 6.6 000/211] 6.6.57-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241015112327.341300635@linuxfoundation.org>
In-Reply-To: <20241015112327.341300635@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <ec759cee-de47-dbf5-fd99-016fc411f47e@w6rz.net>
Date: Tue, 15 Oct 2024 08:25:41 -0700
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
X-Exim-ID: 1t0jQe-00233M-0w
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:47882
X-Source-Auth: re@w6rz.net
X-Email-Count: 23
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKdekqbTewtYk8OhQEZvzF0IQX2PSjMK2gl4aLBmEzhLpUoUHmleSe6XKtL7Du+bXce63e+opKrc4nvjA+U4Lyc503tbdj0RssrDhiYV4zYI3OpkCCPN
 Zh9XZNBPn2b3t9qBcpkhAJ7d+Yr1EKqPZ5TNFChbwLn+faUN9Vp2Ak0kF5lQaGbVmgkzPdZaEWHFEA==

On 10/15/24 4:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.57 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.57-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

