Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F3E25A326
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 06:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740464993; cv=none; b=JkVw30WXOkeYDjn2YmAUTwxqly7NS2glXHqdgIdIvvVKiG2BsVYDKbdkK8qjT6W/Nb9OTq+3Gifb9PsdfTX9G4xRIhUSkEDgVA+3t8OTp3Zs1LG9zRcW4bTESLOJAkPO/PJmiNErTcuTOWtXnl3jOS+yiFbEymJofzGvnILB7Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740464993; c=relaxed/simple;
	bh=ZBHnfwZYwn4I2BQkXindYSZKHPhm1XSFyZ6IYKOObxY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B7sWKW9++a6qIEz+uPVW5RhMX4T6fEaRTxXBcxW8Om7X80boHQG89M6wn5R1wRjAEjXpgY4miugpSvAOBGPlgi0uk+TWP97Gg8XEfNBOUNrGs7SprOtAMii46vqsPURXlRg2MRvkX1sRjGBlNqbOx5AMlOQLB62VMo8RBOggtEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=CXzqGwHG; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="CXzqGwHG"
Received: from eig-obgw-6003a.ext.cloudfilter.net ([10.0.30.151])
	by cmsmtp with ESMTPS
	id mbAZt4dnWWuHKmoRztzXoy; Tue, 25 Feb 2025 06:29:51 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id moRytUErlNMSlmoRytHzFC; Tue, 25 Feb 2025 06:29:50 +0000
X-Authority-Analysis: v=2.4 cv=K9DpHDWI c=1 sm=1 tr=0 ts=67bd635e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3f8LB4XS3dq57Z55X223F1fJxodVBl44Tiv5wJ1zFio=; b=CXzqGwHGCIaSV+5lewCLCbTHm8
	JFi6aaMpzIoGP3tOQ1WlfbyZdaoorP7lRK5OdKIpoDJi8v8YaeGvfV3Vqs+AudhjToXCNJjydOPoJ
	wl1FYuqffUQiK8R+FPUzE2gAVGem8/v5VRTCjYq9e6Wfl+GgNOECVdzQVoKBaI4qN1XP/r1UvWCem
	4XJ/SEN54/7WP8U3KVQZ77MKFQNu6R686SSZACSIn5x5HUYz2iOEaKVwWrUTlR7+eeG6XrMKqLKJu
	HfSOGDlpuZaCWuQKcQDEHL30BHa76BcqMhoHFhudGyVIymx9GEtXll3OrYHiv/xXaFXAOwYgYx0MD
	gcScMqMA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:48638 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tmoRw-004BYc-1f;
	Mon, 24 Feb 2025 23:29:48 -0700
Message-ID: <f252d815-81e1-4711-8e2f-f362272c3d28@w6rz.net>
Date: Mon, 24 Feb 2025 22:29:44 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/140] 6.6.80-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250224142602.998423469@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
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
X-Exim-ID: 1tmoRw-004BYc-1f
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:48638
X-Source-Auth: re@w6rz.net
X-Email-Count: 55
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfALoMiGeLNqXaJq0N+hxqqqh13yyTZvOhaIVs2om+wH0vbh3vbHWKWv8g3G2vzloOQm1lEbXBU2np0JnY7YcKpydP111OOFr3w+QOwlYJV9ksB5+rOM4
 wJJ1gyD4bzgSaW8alNfPf7DOPTmsmXBv3p84spC3KmB7wN8L8c7Qg0gtb8rDRwPZCtWqDtBPlgltAg==

On 2/24/25 06:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.80 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.80-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

