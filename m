Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B342E622
	for <patches@lists.linux.dev>; Wed, 15 May 2024 18:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715799048; cv=none; b=hDROSRRtUnQC2QZMZUblyeXBDluikcyCSfn6LXkcMHEFqMH8E2lQLawOqGv+tVFbCNzJHWXezq8Z2M7HrlOytW6TVs8WCVJQJuG4ey2abB/3OFpECVZMuC61VTqDTCHlTovTeYu2aOueUV3/1SVTuOKaWzqjKGf+LKcSn9WNnzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715799048; c=relaxed/simple;
	bh=Za42TSfcWZzLOdAhQj+UtZ/Fhid5/Cdo+6/AAZMbkuk=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=LBgnh441rAlEdBM6krNNlIgTOR8Gw4WqC9JVhP5DHdaKmMs6X5VloCsiAp+ldGp4eAPvI39UKZ6zZksrwYLF/jtLYZ2eNaczc/9cCYgUtWFhMR71sP4/NPQF0+aT8p9q0bNdGLb+/OMxVDGGPhV+scZtOTmciuZx7BXczCn4QMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=wuOSOXIM; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="wuOSOXIM"
Received: from eig-obgw-6003a.ext.cloudfilter.net ([10.0.30.151])
	by cmsmtp with ESMTPS
	id 6vXoskO9QAidI7Ji9svyEX; Wed, 15 May 2024 18:50:45 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 7Ji8s13Zdd4oe7Ji8sVS2B; Wed, 15 May 2024 18:50:44 +0000
X-Authority-Analysis: v=2.4 cv=aYKqngot c=1 sm=1 tr=0 ts=66450404
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=TpHVaj0NuXgA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=HeeXhtpvNHrroWCcVeHmY0/29+g9hU646zMWYJ1iwZ0=; b=wuOSOXIMvBJyN21sxkdyQ5F8Sr
	sOwc7wkfQlZjm3Mf5NDfieDsGKxS+fY655b/X1km7tZAImvHZUZURzaaah/w9nJUzkx5dZ/bNjzRa
	woML37VV5D0ZYewPJoxcrTDaeju5H+FHQbHQiDutVRzemtJ23QrzlT0uyfaaFu1indOiDRPvxtkGm
	i3Yiy1aqTTANEwdZMD1jc0Sai+/9f1Ga9kX1ChWXFVMwZ6PsYjr4EvnH4MHnKWQREULCUJQkzeIuI
	8JenDMBqDRu8jAVq9xZTOk7Ca8sNaZjWnl1WrDYm/rIoWn5kE/tVONZ35o55p4afCSOFwzyaJFdCI
	MnuCaXqA==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:35788 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1s7Ji5-002M9H-1I;
	Wed, 15 May 2024 12:50:41 -0600
Subject: Re: [PATCH 6.6 000/309] 6.6.31-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240515082510.431870507@linuxfoundation.org>
In-Reply-To: <20240515082510.431870507@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <5a730f78-1c64-e091-8794-fa8f8d105d20@w6rz.net>
Date: Wed, 15 May 2024 11:50:37 -0700
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
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1s7Ji5-002M9H-1I
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:35788
X-Source-Auth: re@w6rz.net
X-Email-Count: 41
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLFWcbfOWwIP0c3b4W/gJH9bp3N3jAJaNVm0g4hi4H0jDO7NXrcxFzLP+EjRPz7GpuikLnkklmjAPh28H32tJOGcVXfWdj3tkNSGakqkjZsT92m6dtQE
 EwVA4H4V35Vf+31PG//WQGrHp9nIM166tPyHn8UvR1G2kgOo6DcN1ZQs9IG9xPJA5ktO905vER2F1Q==

On 5/15/24 1:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.31-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

