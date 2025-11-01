Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364BA134AB
	for <patches@lists.linux.dev>; Sat,  1 Nov 2025 11:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761997885; cv=none; b=IU65w+0XBLqyEUl7ijh59pHDB5kBxgoBS6cEVVkFyLfA87mGTiqVbnXz9n+IzrGUG9GMl8ZXFOPoq42XVRN+jKgOnbG1mnB2f97bK4DS+y257vHoDItvsamZuuRXrc5Xtm+a9t+ElUMERAOgQe6rqQ4SIfGea6OAkFajwN0vM78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761997885; c=relaxed/simple;
	bh=HW6GKR/sJBCgYQzAZcNaDMPkzyWXK3HQJa6tAhMCYk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E638BGTuf879kWnUBzZkBndZZIv6jcpgR5SHNeETnbtQim+e3/zmo4r/dueOZi/nGbheHnQmiX2XVpnoEQEAiTSNqOuBfRQTFXk6i6SLtpf9zMZCozgKOOg9bJlypMXx9S1bJ97rcwnbL5gfln52Fh5BzGfb2yZtitwxE7xvfdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=EyyW/oVk; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="EyyW/oVk"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id EXsTvBn8paPqLFA8aveEgN; Sat, 01 Nov 2025 11:51:17 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id FA8av2vooFPddFA8av0jFq; Sat, 01 Nov 2025 11:51:16 +0000
X-Authority-Analysis: v=2.4 cv=OphPyz/t c=1 sm=1 tr=0 ts=6905f434
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=HZNXMTzG_uFtYxrW7YgA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=blHPvg7TAE9OMAOrnuHX0jgx12qoh8iwCrfCCxr1ABs=; b=EyyW/oVkneRD6RZtuFgQHL1/52
	5QZeG9a+xzmZgfuPAg4nFJ0gfTwMgsze9Y2GxU076s8OAAAb2FEieolQj/XFwzp+X3N74i/CjKKgA
	24DQolZZAxuejyws8z0N549n1b9mgv2fxPjll/6KUBIUYogf1cVWnB7ynNeal6hn5t/eZQGPov2bX
	rqZFuaVgBp0PE59zhYuZ/Z0Rv8oc7Gj7zjjz5MJhZy88wr+CDTnIR6+6Cc+5kVprINPN6d6Yd5XW1
	/0v+uIY1CGq+zRkJeIWEmogQk95gBv+4WDhQYb9dXgjCjSE4eiLzjHbPTvuTv0AKHAd8zO5L11Bfb
	JMqV1qgA==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:57776 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vFA8Z-00000003gAX-3Jdz;
	Sat, 01 Nov 2025 05:51:15 -0600
Message-ID: <d4c9ab6b-edcb-4e6b-a193-e7a9164ff16b@w6rz.net>
Date: Sat, 1 Nov 2025 04:51:14 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/32] 6.6.116-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251031140042.387255981@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1vFA8Z-00000003gAX-3Jdz
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:57776
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBUxEYme+BiPCbHjSSQ4m+zekFZECOhpgENfUQu47Gc2YlX+PsYIroPESiDW7dgUtI+ky5T5G0LbQ3ICokODDvpod4wncHdluAsBnpBP6F4lB3aaJIaY
 kZ+Ni10760PAay6mR0bBnrXytJqkpf7A3EHG+6+qCl9sMRQqc+ACoXXf3Xvyex3wMiALSDhbFOd44w==

On 10/31/25 07:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.116 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Nov 2025 14:00:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.116-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

