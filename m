Received: from omta033.useast.a.cloudfilter.net (omta033.useast.a.cloudfilter.net [44.202.169.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5924304BB3
	for <patches@lists.linux.dev>; Sat,  1 Aug 2026 06:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785567290; cv=none; b=CVgDDl788VRIxKXAE47UlmyQVoxemIdNrVrfT1If28K8nSHNCEVjZ2UPqTTk5pkAUIAtH/+8iGqM1k7UAzI5cDAByIj11RWG26Ls1D3WyeHNVThMS6p408P0OprEKQL695fDFlyItW5QsedECuJjWBLjYpsfn6cGZGJLLttbo3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785567290; c=relaxed/simple;
	bh=JJIbv8BDeyHyQDbWakbN2kS3TrgwI3g76Zl4cmWaGFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=faATF1PGBMkyX9APyZAMkfdP7tBGMpNVEy3FLeCufFiNs2fNUQaNONJPE6lfLd3/YI8iVm8yUzk964IpwhQBp2YgcBUmntQwxLg0NCVsOft7hYzzvnFe4XMB3MFzuKjccwOsxBKQVSAaVfVmS/p6sV1WxB/cjo1AHiM8qtWFe0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ezE666jy; arc=none smtp.client-ip=44.202.169.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ezE666jy"
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id pxn0wftqW37X2q3aqwHwUq; Sat, 01 Aug 2026 06:53:12 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id q3apw6bowlaKXq3apwWQdN; Sat, 01 Aug 2026 06:53:12 +0000
X-Authority-Analysis: v=2.4 cv=GsRC+l1C c=1 sm=1 tr=0 ts=6a6d97d8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=BcPpWBVZ1W6q4qeFJZEA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=7aO6yaoWgKwSVKND9Ym3ydlxmgXwBuh5ivRzD8VadOk=; b=ezE666jyfd5T2R48XodJnKbQZ5
	RMuUaPrAfQlmpJ298UUDkl2tJVAZWpVZGXEfDvhbTOCcvz4dNWDp3KMqjbKLtheEGyXLjcuWCUu3C
	5PJA6+aCHIC3yUHi98va3xmfDiiLdo8OfMzfsJlGeuOS4sMUJNxecILklvDWnAICUu57I7PlVluja
	XyJYy9zuOpEcxHSROJE5yS3iyVuc9WKjQkNsZfN1shhSNQrWCRa+8fOWBplIXfeBXeBr9l9eTPFAR
	RMZLAnYquXAq8sIu+S9hhZ8srTQOit94NQ3aAuuNkDVSSn9IBe8KyBDqEubfuboXytW5AXo6l7YYe
	EfoqTjoA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:55678 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wq3ap-00000002lj6-0G2c;
	Sat, 01 Aug 2026 00:53:11 -0600
Message-ID: <5556d366-5428-4367-b082-3de0dac59a0a@w6rz.net>
Date: Fri, 31 Jul 2026 23:53:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/484] 6.6.148-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260730141423.392222816@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
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
X-Exim-ID: 1wq3ap-00000002lj6-0G2c
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:55678
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFW35Lonq4hTtm6JrJQp7WCxsLBw/UzHfAeM1PlZTsJ5pvBjiHtqvMUMSVacch84e0Sgkdeku5D45or3z/36JZ2z6atuCNkz1KlYPmGCW1nM/VxNO9+s
 Txe2I/maCVkHXNfGYW7VgbunFU7ji4Sms3i+JVmKG+sj1Sj+8yVhu2tj3sWX28jeKcdt2kqylpYr7A==

On 7/30/26 07:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.148 release.
> There are 484 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Aug 2026 14:13:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.148-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

