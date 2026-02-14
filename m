Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943301E834E
	for <patches@lists.linux.dev>; Sat, 14 Feb 2026 10:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771065361; cv=none; b=rcv9sdyp+up1I3zK9nBfXTYltH7X74wfJvKOpIwOctm8FTZaieg0VhfmvqTQVqGLiO2pCDVnYV+J2BH35CJcUd/fBKbKwGl7Bk6fL4Yk38PXprmEyRc275HPA8NGdnog5pHxzyN7SjIs2NctkvKHpSQjkPz827PjOITOI6/l6js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771065361; c=relaxed/simple;
	bh=blvJItYWfXxjx/JY7pOjNkfVMNnpt2Wfc9F7+PdvYyc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=maefXoIQiKHeJzMA7xZnjNLu5DeI5vc0hS9BmwErrPsD5pNQXMcwse3Vs57eEciJr0iE+BKRFwO4FQ9Mos3cfgU2s08pzdSIDJ0HMNq1gEjagjATPEX1UJJ6/0Z3IwheJxIyEMeSoGElKdgr7ZWsm2wPDYHXc+AJz0E0egK2tG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=pCMB5/Yk; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="pCMB5/Yk"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id qaQ5vXwVeKXDJrD0Jv7CMc; Sat, 14 Feb 2026 10:35:59 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id rD0Jv8ZeQHSQMrD0JvMQ9v; Sat, 14 Feb 2026 10:35:59 +0000
X-Authority-Analysis: v=2.4 cv=GIQIEvNK c=1 sm=1 tr=0 ts=6990500f
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3WofPNUP43pyeOJ7pdUNC7uim/FfaI0HcjT3JB4Ygb0=; b=pCMB5/YkMM2l7UEJ/Xi/WeCKTt
	sAK4VMv6Ay/NDGZAfRSZjtJYziyv6EZRQ5zLuotHz4m27yobh/E7qliWXi2fY+hvXAdiu8rFSLRlr
	Rla2dIB24/Ti0hIm75Ir/ROVdf477F7oeRBfwJ2rO26fTCKlJvBFeam9gFmoLg5RRsNRjQwaPfsOq
	bE4SLS5HHNz2cmDYUTdLCyNYuGNqlnnrhEWQj7G/7sDBktXxBsfTvMu3JVZIU3uZI/oq9011ECrfO
	rzUewIaos6B1VlS3Yc82ChVPVEVnLi6OVoRkgg+3T5HppuuCKNjjsiIp6YUhgk76WNm4np33C4zYD
	bjMLt3DQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:55822 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vrD0I-00000003Teo-2idq;
	Sat, 14 Feb 2026 03:35:58 -0700
Message-ID: <a2e10f19-a024-49a4-99b2-ad92e5b7bbf2@w6rz.net>
Date: Sat, 14 Feb 2026 02:35:56 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/49] 6.18.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260213134708.885500854@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260213134708.885500854@linuxfoundation.org>
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
X-Exim-ID: 1vrD0I-00000003Teo-2idq
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:55822
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGvvj+uolKEQnOLcQm5/XOGQMfUH33RXl4lbimNdpXsjUqMfbgVvPc5Ff2X8WhUXgO34huclZX7Y2QB0uOQDzAUZSlqqlf63xlTaJArmhfENoBvJrWC7
 ONDztXirH3akWb7I2i0MwRp5aAgvvqVBYooor29YxL3oVEhJ7Z3k7oP/qRWWQezhPLCDXm5lQSovzg==

On 2/13/26 05:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.11 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

