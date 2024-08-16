Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B606B13A256
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 20:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723841108; cv=none; b=UeSzYwcbbekaAVss5RPGuRsZ0ZE3SeCXU6NkYQESjIR0aw4gqzitSip2zTv8WoaYX1BuGtpyxYsDytnEyo4hUerFWARpn9zJcciU42quKm1IJbv8klU2eh4cIegqlfuP+9POc36mxOV3N/Mh+hQUgh45WGf/WqBNrgLnYT3PTaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723841108; c=relaxed/simple;
	bh=D0CIyrrVM4FwGv/7HrMqU9NODuSehPITjjwcgc4dANE=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=Hq+1XRYIHKnI6MDLYPIKWw2pj0GfzvRCz8xG5yPpl2GCvmFO+VLEaGw74QoUBh6yKKdhrxSQqtSH/YqY5L45rT6nID0H7EslXd/qlg4BuBMBbIpOr2HMpp2SoB+FKFZxfWTXtbd5N8YbwhI2RPKji3qgI1w+nPK5lX5377p6pIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=kERu4hm+; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="kERu4hm+"
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
	by cmsmtp with ESMTPS
	id f1VOsxikAnNFGf3ohsXzI7; Fri, 16 Aug 2024 20:44:59 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id f3ogsK1fBEatOf3ogsACK5; Fri, 16 Aug 2024 20:44:58 +0000
X-Authority-Analysis: v=2.4 cv=F5ZRdLhN c=1 sm=1 tr=0 ts=66bfba4a
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yoJbH4e0A30A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=dMa8K_NYSMvRJTca4hgA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GHlsHH8KZhX4WinjSa7N+Lbm/VjM/IFlrjYyrlMyRMU=; b=kERu4hm+sd+T1lmSJ4RQvz2Qw1
	+mJXGMf1RtntWeBFnqubS0tBZvIeuvCd3QNMDdQoO/C9IVUItgnVGdgVqb5tT15/7khF0UYSjlD6k
	G5deIXnTbBNt6+cIhyiR65VWh5mRqijmIVzaWhFz315dAMUGuFXblsdrQnt7bQFTvy9ONUuWO+ac4
	xZKTLOCknQt8pbV5aGPDDT3dqXIJjObLtT3DlLYGqBcEysdSw1D2lpkE4HU0w+aRg8q+wLyTuWvt2
	0Att4gmT4oXMwBg7P1T2GkiO6YaXnWf0MOdGUJsnv3f8DSKc8YsR95oNWiTNA+A2klV4r1aMXxHiq
	62tFmVpg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:35224 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sf3oc-000AtD-03;
	Fri, 16 Aug 2024 14:44:54 -0600
Subject: Re: [PATCH 6.1 00/38] 6.1.106-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240815131832.944273699@linuxfoundation.org>
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <bb711081-78a5-a8bd-3605-442db115b69d@w6rz.net>
Date: Fri, 16 Aug 2024 13:44:47 -0700
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
X-Exim-ID: 1sf3oc-000AtD-03
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:35224
X-Source-Auth: re@w6rz.net
X-Email-Count: 41
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfH7l2mg/zByT71JD4TGdzO3u1ZKvWkkiV0N+DahRhv4PiIDexHUn8DO8RbW12AQ88cBFI7fW54m/JMlKL5HEL7UWEGcasNckR1ykrINTkER8+tfi3fte
 V/TZnSfw2ia+xHafYAeEbzzBX/OsliJONVVJjNGSkOvLRP+4NyJ/FPp0dVpFabYgqq3h6XkHRBfgxw==

On 8/15/24 6:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.106 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.106-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

