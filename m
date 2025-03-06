Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F9D1F3FF8
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 08:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741248673; cv=none; b=rzJS/lUegc/6ilTi2wCMUWv5xev1o8gbRfj8dx09dXId8kggz4nST0nbYOKL+nFlz7haoaXm5Fs7Z1DuFc7FIu+IOXHSarPMPyr1AJUQANcb7TrvjrwbgrTCC41G8jSGQmu/+7toxLRL+zmYo9os/fb1/rVVGycZ2IPlPXyHTqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741248673; c=relaxed/simple;
	bh=2WtO7fJdmpFUBWwBkow+awaZg0rcq+XOh/tCzbCjYkY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p3HtJpMxKNgBoiAPVYX0nz+x+u6YJUvdh6BxCBAhx2B+hQu86o7YcwV5SnKk1tbxy4L0hgiACNS01G2MjweGnMyV4GFIl3MoHAF8vmhLo+iLAMmU961I8yK7qxu+K/FZeH86qLMTKroq26CKoyWhkfp5/VoBQZc296C1Izc8BV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=W6iagh7c; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="W6iagh7c"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id q41WtOqp1METlq6Jst57pj; Thu, 06 Mar 2025 08:11:04 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id q6JqteNruUTWAq6JrtDLqr; Thu, 06 Mar 2025 08:11:03 +0000
X-Authority-Analysis: v=2.4 cv=TZ6QtwQh c=1 sm=1 tr=0 ts=67c95897
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rErLWITuNZXW3qYkC4siHHzOtOybG/26/N5SxBLh8+o=; b=W6iagh7cg9JLvNaCZV29txXbOM
	o2qfbekY864xfHULVpGe1FcLvNDm9HfWKbvtnILZIJA0dFy4Af0GRvFw6dhbrAGK72cSO/txYoXYu
	gDBCk8emQ/uJjYKi1NKIyp1tZvP8ZWg4DAoareBA/lButdMYWl11RZ+KDttRhEjm5k/ORmqQa5MDI
	AxrK/r5PxZdoJC9hQ/sCJ0ZyMn6o2MLs4OAWJl15puXthr+3DOgbtKIysIroc+McqDwwZcRquUjtY
	GMy010teShK0wpagOMHfkLacQQnvg5RUXVtufAGBIn7l7tLCt/FFhqkcno7DBF2Sjwc+0ldd3yclH
	TIPe0rVA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:55354 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1tq6Jo-00000002zZq-3ifH;
	Thu, 06 Mar 2025 01:11:00 -0700
Message-ID: <d698d4fa-85a2-4566-a940-af5dbf1fdfc6@w6rz.net>
Date: Thu, 6 Mar 2025 00:10:57 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/150] 6.12.18-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250305174503.801402104@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
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
X-Exim-ID: 1tq6Jo-00000002zZq-3ifH
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:55354
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDEarZTYvKeYMoF5cwapFsqmKoch4FRf2oSd9uRnh16bfjGRT2UYfnr5964KVVQVQk9FEt6Yzt1bUPtBDpzubAjLcxxnGp0CwBTeBZnunJ7NPYqi6NhZ
 5ouCW3dJ/0xZBLoE97wjaTxT/9gFr7V7T5wMMl+c7ZykKawBStsq56FjB8GWU9jwLfrdmRYDygf10g==

On 3/5/25 09:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.18 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

