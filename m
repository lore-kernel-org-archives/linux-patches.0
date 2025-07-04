Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED5E20E00B
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 05:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751608381; cv=none; b=rFt5uA3295cZwrBinas7wJTA3/Fndc8YwMskDJ9NkAnsQs3Y+MMvddGcBInvXW+TjYe2yTq21Enie7tKjUpfYrVpck8YBdwD/vqnQxUEa/gyFnCi0kp93QvCnTMmxqJJxbEvm3PrGzbtseFts5FrOQajCnWv1G+EYmn1+hDPETw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751608381; c=relaxed/simple;
	bh=rA4LBDewxvPyjFV5f8OYkZ7aP5FZ1aARUOL3n/eDFb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A7lnMtEqikpH5YDU/0HJFWPngOkIbTH2O9OBO1LdEs3hce6meJ663ZpRrutMA7Aqqv+GWiy6boMp/UAQFWEFekD4fc84CMR3lq/jUjMJDHK7dQtq2m5kAt7HtgQ7nbhisHZNbkRp5jYoT6AldaF+HxFP1SbTXQXxkYHCl2/c2Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=yA9lgoBL; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="yA9lgoBL"
Received: from eig-obgw-5002a.ext.cloudfilter.net ([10.0.29.215])
	by cmsmtp with ESMTPS
	id XNPyujmcqWuHKXZKUuCOUM; Fri, 04 Jul 2025 05:51:22 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id XZKTuUvFPCvF1XZKUuXuxn; Fri, 04 Jul 2025 05:51:22 +0000
X-Authority-Analysis: v=2.4 cv=fvwXZ04f c=1 sm=1 tr=0 ts=68676bda
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=ZJCAKeS_rTr8ZDEThcMA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=O9MMJkEsR1KX+OJ9KCLO9TodMSMz2wW/Kp46ei93ju8=; b=yA9lgoBLNBZ0ejKSWPAEj13tkT
	xmrj+Yy9lqFly1B/TrFac5lJrA2Km//8QSBEwgldGZW4oraWoHHnV4CCInadGR5iRNdCEmAzr9whs
	QRZs3Y3iMYina+DaDMbk5qRIwmV/Yb3RoiFnXUCjfmOXOYnm0bXU1ypEv1bdxdOSLP+q4EJBDE70V
	heDCyD/WqbIPTq3sFTiJeEEzKhjXcFIN9ihsvKXn1IINuEt0zFrr3utrr5CobUnWT/+rIfFjeCmu1
	8Y9xKhmnCxWvIv+l/viwJA9LWbPDSW1c4qqS7Ov3HXXaqumlGuCsILLO2ZwAdyYP8v0t5fc8sl45X
	0XjrApJQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:33296 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uXZKR-00000000mGp-1H4y;
	Thu, 03 Jul 2025 23:51:19 -0600
Message-ID: <d984a233-edfe-4748-bc07-0c32f8d27458@w6rz.net>
Date: Thu, 3 Jul 2025 22:51:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250703144004.276210867@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
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
X-Exim-ID: 1uXZKR-00000000mGp-1H4y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:33296
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfL1SNxvLH2mZprx1s5YGDHzCSgNl+PQdhZ4xZe/nT/tESxIrBI9LcIQT++Q1CdjbsZRyMt48A1kcVUnKtn9CB432JwlD6xCK0Lh6ieAjReSnhpDAjTVF
 jb7iQEFu/ElGD+xn+ukJZkPvTGg+POOTBb+ehcMNEm+03WSSaypf5WQyZe7hgD+t0YnDZFWYZsEkng==

On 7/3/25 07:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

