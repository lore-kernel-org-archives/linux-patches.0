Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E7D283FD9
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 21:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746047335; cv=none; b=lhO9rFuJEjGodb9+2iWqkyCp23VawdbdUrlvyoTODtBWyasYrZWv+tBs7B9UxtbDrQzvJuG7hA2dQ99jg0IDy6jvrNRPsGOmLQqT0kAhzIgYepGvIW7o2XiEO0GtgtjBpDaqn8+efGbVMmznbEQVAM/4IRa3ybGRD7r27Q16ICY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746047335; c=relaxed/simple;
	bh=n5RTaCK5eZAxSP45S9CKljtatqB+MXd4Bw/ehZx0jyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hTh6AEQb6cxu9EdQLGBfQQ+KnDnNH08ILRgyamqtWOyx2kt2UgJU7JBJR7A18L52UQ0gsA4lsaXaCjlyeZZ2BMb+8PettUV9nzp5XxMCiJ07uzfnqGc8bOKft3FzUJSo3/Dhnhd5ehSbBeN0mcmsA2s28dkPwosaUEJA26hNFkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ZnkEhJC3; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ZnkEhJC3"
Received: from eig-obgw-5006a.ext.cloudfilter.net ([10.0.29.179])
	by cmsmtp with ESMTPS
	id ADRfutM3zXshwAEfjuGyNS; Wed, 30 Apr 2025 21:08:51 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id AEfiuSgncW4jOAEfjujgsc; Wed, 30 Apr 2025 21:08:51 +0000
X-Authority-Analysis: v=2.4 cv=UNHbHjfy c=1 sm=1 tr=0 ts=68129163
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=X_drXzbwcQU-ujxrCA4A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Wu9pcqENrYdVuEdCUNHwcIQDgoPGKN0S/PPSWP0M9bA=; b=ZnkEhJC3aXXEscNUJmfJyRCtx9
	MjLv4snNgpViIXeZnFp8CJjYyGEgljj2OFW8cPGQPObDtkkFmHc5QTEqzlmQvMlAw9B4c/aSAV+Fe
	FVNNiI5OildzJjNq+LzIjtTH0c8caoGqVknHe2dEK8WWVbTwjT6pSEbvk1ZfeyD2PRuDdjFj2Vz1+
	s4K1bToT5L9BcbtA1YdDTpZ88pkEHUOGJ1C0wMMcd+Y/+2FIPvcQ2rkR4M1Z53bnfjQz0m+Er0xEb
	+HSfyoYGyWW/CI4ADHjW2h1ZMFKyYAyj1JFtdPkpUqmvkRDOF2LJ7EBggpevXwSWXAMyvZeWF7mbc
	6HFURBIw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:34632 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uAEfg-00000000TLB-2utN;
	Wed, 30 Apr 2025 15:08:48 -0600
Message-ID: <bb4992c9-6b1e-455e-8b3a-0b7e3f92697c@w6rz.net>
Date: Wed, 30 Apr 2025 14:08:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/311] 6.14.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250429161121.011111832@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
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
X-Exim-ID: 1uAEfg-00000000TLB-2utN
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:34632
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfOlNGOj8d3jWwUtDztuJW4iR6a2swdsJp7E05+cIA+X/xzAq9JnaiBh4ixnaNLSWYaMZT11jWCFwE5rL4bQKXvgaG/Mc0fI2BLqPys0S2zelHM80D171
 aNdBzHyVU8b6uVvo+3sRBVQwoRcd6tBpp1juSbfZvKPAEl/n+Rso9fWtX91l+gRcb0JmP/fNef0arw==

On 4/29/25 09:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.5 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

