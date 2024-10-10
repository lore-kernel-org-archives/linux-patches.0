Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C302D173
	for <patches@lists.linux.dev>; Thu, 10 Oct 2024 00:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728518671; cv=none; b=dx+5VAJBdhpPxVk031VS7+zLlSoAcwV9QeClBYqUm3AYj8DGfGBfc+UOz5do0OnCx/VGMpAPEiyfUcFw7dE8unIduVA8GkCX13DWUcTjErSSjuhqNVpnlfB0xrVmBy0bZqR7j5lgfgFIV5AOp0oR8DtacWd78ddtWUdatQDdgxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728518671; c=relaxed/simple;
	bh=xCFdlQe2qIXmkhYaOhV8Oe1OWnBaKqhn/2JmRB3U+Hk=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=Qv6lXSqPgMy4eMfRM3dJ8+mY7iEK/bc7CjuHCXBaJ2MQ0LIO8MKmBmzXf8Ov/hUsJCuqV1puoQeIvf2bgS3H1LByXdlaDYNbLWYjdY3hbHq4TppVyQgMZ4jRTt+4jM6PPZ2fcIHdF+EwxxST8LZacSHKxiZuJVYko65XBDt3r/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=PsqeiHLs; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="PsqeiHLs"
Received: from eig-obgw-6003a.ext.cloudfilter.net ([10.0.30.151])
	by cmsmtp with ESMTPS
	id yfOasYqMFqvuoygfMsmsHk; Thu, 10 Oct 2024 00:04:28 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ygfLsDAHHCgT6ygfLsjXdi; Thu, 10 Oct 2024 00:04:27 +0000
X-Authority-Analysis: v=2.4 cv=XvwxOkF9 c=1 sm=1 tr=0 ts=67071a0b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=DAUX931o1VcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gdqp99qaU+axZJTHntMncWRNOI6hwC4IiVkIpoyf888=; b=PsqeiHLs7IAsZZGG11WnF26iyN
	ZwnpcDzJrtqX+js5Zz7xRA/i0/E2aHnuXT4kWrT0LR2knwXR4jdeWlTaQaf14Qhp3mhDDQwmnaCh4
	72CdANEaG6BXkHx8hbu/m2ZmE+yJFOSxR+jRMxXQlXWPtkn+B0o3iYjwtWlF0Q6qwJGw1WkUL95l3
	woAygRotoXhoqJRXDUJh1edtDfW4QOo10RZ2alJAR7cFkP+3HHcDGMntMwuxlOcxnqpnchdauqzR9
	1fNggrlDUjPLHLP/2bJfieezlE9i+OvwTL4zvzD3wDqvowMgphv5YRUqSAjcgGcfzlTNlb2U9lbv6
	P20Z+ZMQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:46230 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sygfJ-002nN0-1S;
	Wed, 09 Oct 2024 18:04:25 -0600
Subject: Re: [PATCH 6.10 000/482] 6.10.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241008115648.280954295@linuxfoundation.org>
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <f2d65195-1635-9cc0-97ca-b9cc8dc822d3@w6rz.net>
Date: Wed, 9 Oct 2024 17:04:22 -0700
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
X-Exim-ID: 1sygfJ-002nN0-1S
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:46230
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfOPXFgRBU+tKYhOiHmrjCvfUIzTxICihTQJb3XT5XwfXy5Gkzh9bGx7+16ssNlBjcudDuvz4F/wWVzoujVjspDZp45xahvE1Ogn9701AX/a4VYkwuX4p
 YQJtuL3/W/vE/lS2QznGtPIgmRyhMz3Ucl7XQG3GhSoh9hHub+uEZdaGpKXPeyi/iBuJCsjAeiIc3w==

On 10/8/24 5:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.14 release.
> There are 482 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

