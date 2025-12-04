Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA782E1722
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 10:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764844411; cv=none; b=ZoSs0QQ1AIi7H3L98AmNwQwM0VuCb9rEmHtwLAxE1sfEi7itGpWG/FQaMLWtLRCUnW1W95i0Ahn9i5nCB3otXDXyji23WvaKhr2ftQMwpUl7tpBVmz9EMChufSC/GOC7Pet+/mjxTVoGYQf8p5pKcyBjVZNCA+gcJEDpsid9bKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764844411; c=relaxed/simple;
	bh=i18JZRVm+skLEE081xAYASLVdnYVHRngJ0Bt10Jpq6k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FxGYWRRQFTsPJpBtf+CwwuPou78hIGX/lD7y6J1GEkzXKHzEBNDnzL9J/+ZjXUGmpcwBRFLChFW8aGxwRQ1auYl2Vz8FSRlAXe1caJRpK4DDXxI0ONuLRPfQhBKzgDZL7Cgt/XMZVIR0rZ0AtGbPkjaT468EwhuWH0dFIfOQCUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=m6S++G+D; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="m6S++G+D"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id QxsEvw3QaVCBNR6eJvAtnJ; Thu, 04 Dec 2025 10:33:23 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id R6eIvBjaww44vR6eJvesU9; Thu, 04 Dec 2025 10:33:23 +0000
X-Authority-Analysis: v=2.4 cv=ePITjGp1 c=1 sm=1 tr=0 ts=69316373
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=UMBD4siJeQm6C1r26erKSKCjq+jTSXw6Vs8g4lyD1h0=; b=m6S++G+DfVbqGmtuVggGdYgz25
	sXqOhJ9P1ODRjibKhTNXncPhXYNzgEY2DQyMMvaX1UYh+7emunWxwagJhr2ngKoiRz1dHo0yyJTTT
	O/XmDFh+98dbqhMCmDIfyQlalbEAgIXCxJUym0HxPU53zseFFeq/wg2I01dLbgDJjUh8t4LCQOqzM
	IOEzxBGq6ZiUfHOW4MvBkaz3mCVMgxrD6J9mOEENgDTl2KQTPrtQqia1hG5gxoMKxiowUD59J3Auy
	ZcLw66Eg0JtZsvKzHXdpXmoKUO5/o/INY+Js1UF6IfAr1N07UyRs52zcgWFgPAP6jKt59zTv4lEB0
	gvjejc6Q==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:40840 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vR6eI-00000001Wrq-1bMA;
	Thu, 04 Dec 2025 03:33:22 -0700
Message-ID: <b4894e31-614b-4a86-a1d7-844144451ad6@w6rz.net>
Date: Thu, 4 Dec 2025 02:33:21 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/132] 6.12.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251203152343.285859633@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
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
X-Exim-ID: 1vR6eI-00000001Wrq-1bMA
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:40840
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFK9iPA98wR3m1YD+a0ZOeHcsf75jrPqqS6h7VFbgNKv7mCmywYS6CbvphDa/CjaV0aKFROynM6DIVb0XJhqzcNBxyhgT4BJw/GcHTfzRWNimaVdhN+/
 ggH+2ChZrAf1zTFIVcfOnvKDPXP2O55KD4cypor2n2uCPsTi9w5TYx7TTK7oEX/1/jIbqgvuq9SBlw==

On 12/3/25 07:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.61 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.61-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

