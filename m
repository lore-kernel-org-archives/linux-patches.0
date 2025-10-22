Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE622F2603
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 10:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761128968; cv=none; b=mKiIvg34JoMzZ7gllbx7L2+WM9/1HW9MV8/4W80AH4PAJV/dL5lP86UhTaJLcx8ULwVenpGgWs4l2GBR9aAOcF7oLakr0gzYiVFdKgLqpcpsNQUbjgnEH6uRYYQwyDWm54+e35wKldvN5hSCfyoM0I6tHKFECxT7pprdG4Cbao8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761128968; c=relaxed/simple;
	bh=Zimn/1Fq84om2vqJsWEkiigEFXiZgionMvk2QSRsJnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AAJ43X7r5csfuL7eGYTC8N7w7G8iBcEbQber4dtiOyfij6uPzC7TaWQTP8JxKiF3sob81vKfspd1XaJ3frmRnevAMk3WUiG7jrNf1nRsh3nP9SHMuELC4I3N/h7eNhK0F9OTjDqlY2zUkfuICA5y7KJQuITjCMHW/+XaMZMKQu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=y3QI+7ST; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="y3QI+7ST"
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id BQxAvnlhuSkcfBW5nvMdc4; Wed, 22 Oct 2025 10:29:19 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id BW5jvRvmt0HUDBW5jvQzUB; Wed, 22 Oct 2025 10:29:16 +0000
X-Authority-Analysis: v=2.4 cv=TIhFS0la c=1 sm=1 tr=0 ts=68f8b1fe
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=6ZOJAY3MKdpOLhjm1I4FmgYvdhlyJ6vz+M1+6V5uxms=; b=y3QI+7STsfiIAdFSrBpMbQE1B7
	KZNEN+X9+a9mrxiT8PFz2S+sI3tURcYTZwWR6yuEFtYm2a8dO0pY6+Ck43JHahMLe2pNN9TS4nV3t
	u5F31/WsjcbCm+P4Liw+jnKfAp1pArqLh7za0MHwdPxJFtZa67ntCtIDHq56fop2cIIcTHDQB8V1K
	xgaeKlzPsFMfDQIJTMk1zSxtZ+m2PW4d5sz8R+VrWbD7RD+4uJZVPhBCgEA76++tyGZC9ep8RpZF/
	ZEr6xu1F5E8FihSuPhWMei5GDA49Zt6WqW7Tj7jxjaMpXacHPOme59YJ2/fA780ENSZylhjfO0DTU
	rvQDYylQ==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:55486 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vBW5j-00000000kMb-0bOh;
	Wed, 22 Oct 2025 04:29:15 -0600
Message-ID: <cbc91031-eddd-410c-aaa2-6d13b3f5afe0@w6rz.net>
Date: Wed, 22 Oct 2025 03:29:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/160] 6.17.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251022053328.623411246@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251022053328.623411246@linuxfoundation.org>
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
X-Exim-ID: 1vBW5j-00000000kMb-0bOh
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:55486
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfD0uwT4zh2RV8CL3WQI/Dh6EQEs770/YfoqBvqC6gk2Qz0DeFgpHes0BS3xFRz/vvzY8VNZ9E/ML6VCrlSo/MARnOT6ESD8QfA1w7cSuYXYCxorB8zJQ
 zOjJGyFMP8bEHlunvqSXZMKU8V87y0TmKRRtRW7VFeKl8H8NxCz7tMSIEtNXDbCwlbpy1vKwhGRcDw==

On 10/21/25 22:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.5 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 24 Oct 2025 05:33:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

