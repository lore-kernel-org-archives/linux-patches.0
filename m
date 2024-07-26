Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDA42E64B
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 08:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721983623; cv=none; b=njVPcjlHF8n1hvfUWdHs+J1G+35n9X6bj9v8OX7lja/gfUUP/7pez2GV1WQPzoycBvG2lCkoyipPJ6PKZb8v/qO7NSXN2f0kwX7FVVFXHS+TCpH3fn/p1mCYDL2AeUKoDlSYvScue87dGHcFaYZBLezP/ujiS58sfI7V2m2CIhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721983623; c=relaxed/simple;
	bh=GlY9aa4gGoE2V43heZAzTH9QWMGYp1pFjNavKmIa+Hs=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=XXKPB55czdlH58ckQdeGqDLFBDfPtFrhvNCtONqk4qmw70YAzA31jqiZo9op1YdPbpHdWmVEgNeNqm/NAPKTzRI/cqsTYntVOALtaJCRlw3scFybMDxtRUuktmXGnuikSMXujsfh+IzcEzBVyqmfNR4fOFrPIZ8uUEjHRqrz8ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=U6tYk5gm; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="U6tYk5gm"
Received: from eig-obgw-5010a.ext.cloudfilter.net ([10.0.29.199])
	by cmsmtp with ESMTPS
	id XCidsKrIAnNFGXGbGsUqF9; Fri, 26 Jul 2024 08:46:54 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id XGbFsohldbFeFXGbFsOE7l; Fri, 26 Jul 2024 08:46:54 +0000
X-Authority-Analysis: v=2.4 cv=dJKgmvZb c=1 sm=1 tr=0 ts=66a3627e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=hP_FQLMrEgTDVdh0MfgA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=72Vjo2GWED/GA+jMRh77g4QFy8aP+xnolgShSF6hHUQ=; b=U6tYk5gmg6UUdT8vlDr9ybKoT+
	D17cCMG2dqfZtOeyOXYqM20ypJTLx9Kota4tRoGfPWdQERWIWJkw3P0eg3bLtfMi7jQvCl8Azb3gC
	8CLfCzdRfofHvqmj3rRZuH94Ia86eOP0gFvS/u7vJLyZpbPFoiGXZHXKgMVW7cEk3MRZLGqeZr2Ce
	FQ9JCnTxiGXRXS2/i7J87EdlXi5BgurhKcFoo5DdFi+7MvW8CoPrGYaSFbSjCBs5sUxE05Z0B8HHj
	4Z+1hhkAcksV7GHEqE0wR6IUX1fJQAd9DPIesylXoAY/QaMCNqGZhK62VASJEX4HbBhCyBTeerlht
	07eNhKSw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:59252 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sXGbA-004ASz-2l;
	Fri, 26 Jul 2024 02:46:48 -0600
Subject: Re: [PATCH 6.10 00/29] 6.10.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240725142731.814288796@linuxfoundation.org>
In-Reply-To: <20240725142731.814288796@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <16ed41f6-b6e1-0c1c-ed97-755530caafaa@w6rz.net>
Date: Fri, 26 Jul 2024 01:46:42 -0700
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
X-Exim-ID: 1sXGbA-004ASz-2l
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:59252
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIRfXSTyPUommTGJZE554ml3ZMzwmu1ICjMo8FnNuFsQBkceVEMv57zWFPguL7joO7t4lTUY4O3ZuuWtPcUbAGWED3zWPgD2mReOXFj8kYKC/5Ma8xIX
 pQJFdw9RbUh9/O/Vu122pvCBby81YdKRvAt+KdC9VBfHrlGUqjKB3ICK6bzi8xCVWZma5eHt0ojG9g==

On 7/25/24 7:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.2 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

