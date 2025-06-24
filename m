Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0952586EF
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 08:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750754385; cv=none; b=P4maWKyQORWzA6Lt83OA8jgdkrvOf9ijqbqNX9tMgBsKouS+i3OS97xILdOva6/+VzNTDWSgaruu6SSu7v8Enu4kuqQCu1RGixcs9RqOKl9OCidmkj9swa5Ht86YFdURqEub9RpO/kGQB4uu7XAi8h8nyUCpXDJ/FRbopkks0t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750754385; c=relaxed/simple;
	bh=rX6P9uJ++V6vV1O8h53puKB00AubrWSSwqgASU6o0tE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AwYDHY3n/W2CYhMdy9DjfJsc4/P3MFT5RBWynyESD796++GpmbBe7+jHp2Yy7SyxX/C3BDmQV2SMVQgJ/y2e5Osjna/Z3ZwE3sGuKEq2s8MZc9hJqPpuP93ZpMqQY8DDjkixpFBm9sIJxJAUxYY9kRqwl/nkdGj7/qmEeVGtp/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=qUVdZKPC; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="qUVdZKPC"
Received: from eig-obgw-5010a.ext.cloudfilter.net ([10.0.29.199])
	by cmsmtp with ESMTPS
	id TwVXuWTfziuzSTzBuue4rL; Tue, 24 Jun 2025 08:39:42 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id TzBtuNlnMLp4NTzBuueDFf; Tue, 24 Jun 2025 08:39:42 +0000
X-Authority-Analysis: v=2.4 cv=LuqUyGdc c=1 sm=1 tr=0 ts=685a644e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=w9cJ1qrvW+sy42b7Whs+I9aymfUJla/Cy2Xe7jpLw0w=; b=qUVdZKPCUv6fCnqaqY5L2grqru
	mYUW45kUMzKD+GkoNo9QcCxHdcCSWzKBc4eZ3IvzmzemHQFMgfLkEpy8J038pkYLe3j0KlZD8HIM7
	E9pcbZ/RrkRAHBw2Gik2ezpV7+OlScmHZ87xzM1TKda2GXfvidNsMshyVBDi4SJumo0KzI9cdjaMV
	OhJrtk16bJi+T/uB9PaqJfii2/+7DBI0Qmi10Qt7QcmSNaIAxK+2J3VJLImlV9BbgwWkCVrSUhTOA
	HBglQPEwOejSu5ihZ9/0JgkPuZJCUHRrj12+MWkUEmhFQLvWa4oNSHxaayszLwQUt0IX8I4GiKRCf
	yQOYoSAw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:47032 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uTzBr-00000002ROq-0YHg;
	Tue, 24 Jun 2025 02:39:39 -0600
Message-ID: <86227a29-2385-4bb1-be18-f1ac734fda55@w6rz.net>
Date: Tue, 24 Jun 2025 01:39:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/411] 5.15.186-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250623130632.993849527@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
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
X-Exim-ID: 1uTzBr-00000002ROq-0YHg
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:47032
X-Source-Auth: re@w6rz.net
X-Email-Count: 93
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfM7L/qIKPK6IDCNR5FDJlp2gtYAF+r4POgSbT20TZD68WfqDWV3jA8miWqGHQ164fR0JOEi4b1lvEte0KdetiE5O8B4iWImvLkAJSY39LTeY97GrdFte
 8nkYO4CW4F83AI4b9FH0D4wd4KNmeQhcUTrMhgH2kQnPvbDPzSKF0TgoN+iqQzjoy7oy9uF26JeVvw==

On 6/23/25 06:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.186 release.
> There are 411 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.186-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

