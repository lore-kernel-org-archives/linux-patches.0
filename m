Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5198C1AE00B
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 23:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731714661; cv=none; b=HcOUy0ASMDEi9fibQEnvjIU1qMlOXSm0N0so7YVpmrHmKD7M6+SUasfSdEz5xOhrF9Y68MMq2soex4FXbaDgrsrEneF3MCgcWu4PrQLVDBEY9pYTp2g7auKOvV6Mvpe6MmV6Rz7d8q2EEMhTgXzNLOXVJ5RfYdONxU6LjNtAKms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731714661; c=relaxed/simple;
	bh=FXB8KfrG6LQU/Mqli+pn+JitQwrgrbd6o3WyS/Xs4wg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Td3t0AS3B4CoWojoZODnWaXTstuZYLS/twcfxRVhEoGBzgZVQNCd1WEXbxV94vH9LkzYpRz1f4ZOsioE3a9gOoYAG4X6qLDFPN4ZdPBppGgm/U+4aSDZkURa7kcdxBJWkYw2Pio9//Pr6Jj5jd5+C+wDFEW7zRukknK5y9LdZZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=g9FYo7ma; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="g9FYo7ma"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id BzcJteyOirKrbC65TtvbVP; Fri, 15 Nov 2024 23:50:52 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id C65StY1BAfkSoC65SthL6Y; Fri, 15 Nov 2024 23:50:51 +0000
X-Authority-Analysis: v=2.4 cv=dtLdCUg4 c=1 sm=1 tr=0 ts=6737de5b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VlfZXiiP6vEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=hkF7UjICvhDUN6hEiEAA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=TZjrYAUVPhGj6S/Hl2h4USY8zvXns70WNu2i9VSUbBI=; b=g9FYo7maf9KgfQ9OfCOlqVjMcj
	oZtxwDozvD6zYWEbBF3vF1ZxjJJN+2oZTF1cxLsPKMabxy2UsH/tDYBXXsrT/bPIinFJLGOPx4ecN
	bx2exuplFvuIH/aw2wdC1Pa9rHoePEP9Y4ywBNtg+ay8v1bHIJQX9xDySoESa45u0r1AXdFluemhW
	oPoVlYJXW4fYHmQEZCUYv/G+0gFayNJaIQ4sNKs1t3NjGfUnmGTAXo4EFW79zhTj/lPmpNTa34bKh
	0iDoJExIPY3Dp5jiAJOy3+a+fKYA9AjePYAyzA1AsfmkpwQ54gC7EWl7iw+M7nx2aP9E8L/qh1Kym
	fpAJN3pw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:59976 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tC65R-002m0G-24;
	Fri, 15 Nov 2024 16:50:49 -0700
Message-ID: <3c97fb58-0d37-493b-88de-ebc62a514310@w6rz.net>
Date: Fri, 15 Nov 2024 15:50:46 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 00/63] 6.11.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241115063725.892410236@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
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
X-Exim-ID: 1tC65R-002m0G-24
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:59976
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLf/lnUUw1ioONtRSGTXorNuH0+lktBoKMdIfJNzqQxZzQV29bMZjBUeL1BrnStz7gdNRQui2hBEF0DZBVyQXWlhLSAJrdb3sc7kGia13lFdmm/dtjzl
 857nKuxHjsC79oh1TXiKukcCaCuyHTHR3BID1AJ2itZWgU+q4YCMCa6BA/Wkgid+wq02qhJH/+BQrA==

On 11/14/24 22:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.9 release.
> There are 63 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

