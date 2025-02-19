Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7565286280
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 22:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740003573; cv=none; b=DVpui+Ed9gXh4rxc47JMmGysMyCfqIKrlSe0zb9V8oYEbbviBphMSYWmflSbiVLvz5wsNH3mKm91wi6KVpP62lyc4ozrX6zfzN7WgNO/WE1RB0bpRMWQXF+GS8RyfQnhPPcYDU2kDtR3+gYx4WpZQBWawE7yT9nRfm/+JNKk4lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740003573; c=relaxed/simple;
	bh=UuvRB0BHM0tOQgmqEXao94qgvvejyVAkxYDUGU5u3EE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S1mIcTaKWB0gtwdOSHsKdQJRRxkyuNi0OfUpYmpWg5plEk9mJQE/gJ1ywJ2kM4b46Ke6ylzGaNFi45tUUuXeiBKhFGCr3CLXiBgboi+VKt+8RjBdvMYvyTRnh7J4it9mhEGeX2A3INsMkq98bblX1+Go2UrLXj60j4qvRde1lps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=vschN/81; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="vschN/81"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id koqmt5Twvf1UXksPitdvyN; Wed, 19 Feb 2025 22:19:30 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ksPhtcNAYddDQksPhtS71J; Wed, 19 Feb 2025 22:19:29 +0000
X-Authority-Analysis: v=2.4 cv=C7vvyxP+ c=1 sm=1 tr=0 ts=67b658f1
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
	bh=z6vCtB2IKYusn3GbTu0UWshmx+1Qzu5wR1vbHxfbHDc=; b=vschN/81djw2N9N5aHMX804JCg
	J8pRqPWcfEdFkeOt1YCMr2SWDE+OF6dqNe93gl1uC6lz7jHkLZt0S65bdYaU0hu9gDClo2JUNbRKn
	FhKB7XghS0arAGKfIAViDBpox44Y48JYct5x9Ad23n5tSs9+tnjAKnV9owhSMdL4LzVHQTuErRjBJ
	Hu8azrAbkStowbnoghkNqlcAbUCQwwT8+LY0NPNIxxAZsfxiJYJBo53DSvucbv8S/+GsK4kmxNoza
	cabu+XSvXj8e0YoJKDjZ5lAGTuTt+tH7IbndfPzLkzgPKuOrRwrsunuKBeGZ9B5jvczNgIiGItAib
	iknJQuXA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:43276 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tksPf-0008XF-21;
	Wed, 19 Feb 2025 15:19:27 -0700
Message-ID: <7486bca2-d212-4383-a491-0afc600b5bd9@w6rz.net>
Date: Wed, 19 Feb 2025 14:19:23 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/230] 6.12.16-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250219082601.683263930@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
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
X-Exim-ID: 1tksPf-0008XF-21
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:43276
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLVlKYfU3U9xU29w+2XF3KkcDmMBThmkfbUOagJN9DIc3e28biK5pDCikKYdjiRFyBQcH3RIDog77bmr3Gzy9YF+peOyRHf5s4GQDDawZuDxdJnc4DxK
 yMdXulUd+AzKCnpGpmeNUCbhnfJxgzMoMMV9SFS6F0H6l7Irbp1YVc3X3IChqxWe2UdfP2qW4vm2jQ==

On 2/19/25 00:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.16 release.
> There are 230 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

