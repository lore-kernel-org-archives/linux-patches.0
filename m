Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00F737C92F
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 22:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352596; cv=none; b=Kjbx034bYNI/LKolxNmivRTCo9Tf0uW0NkZfn/aV3lUnA/vVFzjnlj45ZXncNIJzS6/SVSakbBxyOBZA6lOK6Czw/Q/6vIjCdEHEPPBFvywMr6iGaRqdWUB3l5lwS7lwEdGgyaSNPyhiefRyq0BflOutUUatfwUS6o1guTkk+n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352596; c=relaxed/simple;
	bh=pMWUDtvmq6udi6UhiEovknXDjk2PvC/blFDMtM5G1nc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PV+d6pBP8v3nvOp4EMMwyhJCxL7qtZC3oISNn5WuNqvbZEBcxHx1yKKhSZTu1kpI+vi1EJJdDGUqdKVjQUOFxGrS/wQANVXFqzqQ0P/vfoBHka2HNlFf/Pt8MQh7obRYnB2u7+9EzoM0w6UqM/Zv/kIhzpmJ6CeNkrWLl9LNuLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Q1t/Jaa1; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Q1t/Jaa1"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id xWoLwgmLLhJKMxY3fwPllF; Fri, 21 Aug 2026 22:49:55 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xY3ewM1Fh4fn1xY3fwQyYG; Fri, 21 Aug 2026 22:49:55 +0000
X-Authority-Analysis: v=2.4 cv=TuvmhCXh c=1 sm=1 tr=0 ts=6a88d613
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=wW6ImR35bRNOjldo0A8A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cReO8HAfxZd3YZ4LQJzZ9vFOZUZvopQWNAOl7NQsLy8=; b=Q1t/Jaa1zxBnnGnL7u46MyWdm1
	CCF+SOD5GncP8o04BcnofbxmAGHfSexI985eboskhDBu8diqunQ7TcZ167LrhKvzGZYmqDH00DfFB
	B2/0HzrOWV7RJ9w8emQJBd2pVI8Xl5uS9Fk41bEAW8l0skp3W7V4BnuZ27mz8GPM06mv7S2s46Ov4
	Fwfr0A21kkmKy9pTjRWxv9fm6Flz4QLaRqmC+D1XSxD58cYa0HHnmR4duTrBby/RkHeFdvixITDtI
	97DQfpUONED/d1UgkYqOgNFqX/KsSa2thoesGwdJ5p2EIjByXNNzFcGCCtk2tRGI/j/QNQBhqcc4I
	1KusBYug==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:42244 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wxY3e-00000002O9j-0Y02;
	Fri, 21 Aug 2026 16:49:54 -0600
Message-ID: <54b31223-2f9f-4336-b59c-106eceaec475@w6rz.net>
Date: Fri, 21 Aug 2026 15:49:52 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/220] 6.12.105-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145223.480031205@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
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
X-Exim-ID: 1wxY3e-00000002O9j-0Y02
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:42244
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNcsDOEpfbPLq18zbxKG1Tizgt3eyq5vXcW5x/m2JzUkw54An/Ytqiy7/2B8oHX/lssVsW3VbXw9bNGy9y/Po/o5y0BuU4ockkvcepldEn6CLbdOdmPQ
 0CmfyZoaSNNIgbVQPwKJwHtLLENShzxb/NxJss4L3SJbUxzi1h/VeE4zYEanRizMCW/8n/ec1yKWBA==

On 8/20/26 07:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.105 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

