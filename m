Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826B1BA21
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 07:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768028791; cv=none; b=g7a5/HL6aGw6N2+C3skH+KKuhgqhthkOYl+qcnsfZAwV7QMXDNVei0GRZcsNXXzUbMo95+ztwCRv6VvbVY06HdOz0Bj51Jqr8y0CVGFyJlM0FcpuuNdPJz886UDrMzhTuSO7T/KpVxRtJs0eUVaqQrwNDFEkFlAsNvv4dMzIzTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768028791; c=relaxed/simple;
	bh=Bvpi+RTreBdT7DbBofmlO+Agks4IgU91Dqqjeqr6ySc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pp30Rra6Zbvvt00GszlVIFVCCE8DPBTjcBuwgGCS14lj3E3NAb7YVVHjApCej2zk9NFzUM+ESoZdR1gchXSQuRAsQS0TomkuZDibzbXd6GjetCsCsSDSzb3lJPFmsEeKGGoisRb1EShUvVonEvLF/kcDC9TT49K6MhFWcyVmHc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=AfW9NIwy; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="AfW9NIwy"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id eKWav8kNfKXDJeT3Nvcylu; Sat, 10 Jan 2026 07:06:29 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id eT3MvVfpuK8vzeT3Nvrp8r; Sat, 10 Jan 2026 07:06:29 +0000
X-Authority-Analysis: v=2.4 cv=cJDgskeN c=1 sm=1 tr=0 ts=6961fa75
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=BKoNyMCYlhYbwQFW8G7gOx86Im6KT1D1EkERVlXV+lM=; b=AfW9NIwyKSTWeZYLvGepqupOwy
	8pjfuuFkksbUKNLefCd7lAUCDrcJ244hjtoaZOBodgNnT+d8PpEcXxNMdiRtR8EZKD09M4f9t1Nyg
	Ndty3oaXbnCt+5ahcxC3DsxVEh1Hos+KAE3fb4XijBcTQFp2xhXNDjF2ikb8acl+2zKoACJziRDkN
	Fy83pVcipjfrzNdeZ3eQD8zDBACfwsIlVO1KFMge0yxt1X4znkaQT6d7nMLYnxZvwPadWNtsAjEWO
	pQ1jpM6bKXoX4r2R9Y7nzMOxAu0tXCTzEX3DVPnOnxGYrhaI9h0nYDdcTNCkuV18KS7jhB2LelQrF
	/EsGMuXg==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:45818 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1veT3M-00000001497-2mFi;
	Sat, 10 Jan 2026 00:06:28 -0700
Message-ID: <3b07c2e9-8f0e-4caa-a679-be0f48a24e77@w6rz.net>
Date: Fri, 9 Jan 2026 23:06:27 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/634] 6.1.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260109112117.407257400@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
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
X-Exim-ID: 1veT3M-00000001497-2mFi
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:45818
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIOxhFMCy7x4i4PC5lQeg+jc2gGq5Y9IlIdU9zDCHxUu/BkOSPbbp7ewY8lKZgpgA2CYDAP8P9t34bjiVK99i8dm7EeW2AerFGS8GBDI4HyrpvGmD9qC
 LsfC6mc9k/ptXSsYwXES1Z+p+y6anFFaZCAzjtVrZCmCKpGqWkhFrlj6fMmF4TJb460N1yo2VXpK+Q==

On 1/9/26 03:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.160 release.
> There are 634 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

