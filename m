Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B731B043A
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 05:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749361841; cv=none; b=KC9pFYpxrXgaBl28zV7rTsMej6Nhl/EoEixNw5nE5F6zPOlYAO1x1x1FJolfpch2Vb9YKld4gt+gmVLjiNXIkAbrbvdSKPCrjGhIqBmizdZWQgYzFgEsie98PofrKOfid1ReiCKmSFacYa/EQ5ExCTCmMb2WzW9evQ2DQNxOHMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749361841; c=relaxed/simple;
	bh=TlOIMpuuoAyKGk9gjg8G/OAZyZmpaD/ZxYdYhrdhNdk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OZe5IQoOuH/JF5LhQjWpsiaitqxgX0qwO9O9U0diw3gIooIVa6CfXBRsuu1q8Y4uKRG7gwkNyIbxPcX5WebA1pX/BBiQWt+b0vnfxr2rCNzq7+k5yIQ6kzalQsqJixIEaJjU1Jyi5ngM76aGQWTB/iBtEX7+BDXDhS2WNXo5gGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=cDk9ImqY; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="cDk9ImqY"
Received: from eig-obgw-6002a.ext.cloudfilter.net ([10.0.30.222])
	by cmsmtp with ESMTPS
	id O3ZtuMBJcMETlO8vXubVSl; Sun, 08 Jun 2025 05:50:39 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id O8vWugg5T1vNyO8vWu70rx; Sun, 08 Jun 2025 05:50:38 +0000
X-Authority-Analysis: v=2.4 cv=VMQWnMPX c=1 sm=1 tr=0 ts=684524ae
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=lUHmgINEyCFmmkEtF4jfi7/biy8jznJWVAGipEhPEvM=; b=cDk9ImqYc2NN9gjE8g0lgZPuxB
	axIpbJ3bye0M/5qZHW+18czKia1gtD53IbqrD6/19nbNoYmnN9z/HSh+ngMFHSEgU3pFUMelZPVqQ
	3HfZzrKrNulDfux/Z7OxzRpdZ8KHE5A9uFGXioY754HYWv+4tnwLEAALfKjJ9TBNQvymwbSYa4Mo2
	lTsqRDndfGKrY3eSQ0kHT2wyenq30NJyoAo+aSP0fodwF3LG+gtyw0eLOtrhyrCaTQd6MdNGC+Cvu
	QeDEXd4U6kEFf4PQ2l0+/r8+hbsSAu5ltrsmjl82ljBqbKJ9HtJOmAyce00Y3h+hm9LdW7c8PUKp4
	amGnhX9g==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:50976 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uO8vU-00000003U2C-1YPz;
	Sat, 07 Jun 2025 23:50:36 -0600
Message-ID: <3491ec91-fc3a-49b7-abf7-3f5c8e227d93@w6rz.net>
Date: Sat, 7 Jun 2025 22:50:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/24] 6.12.33-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250607100717.910797456@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
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
X-Exim-ID: 1uO8vU-00000003U2C-1YPz
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:50976
X-Source-Auth: re@w6rz.net
X-Email-Count: 55
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFXdPkCDFfObza3OkSmXr5DEtgld1UkcrOvX/qtlE+V93DgGypEhbTBRKoJKWkGz/YzfZ7KjXvcw97ldWjcnVITk+rTMTIhCqUGgApgRbum0DeVn3MwP
 9P3R8iBVKmoDG7lsuYr507fv5f0vMccCt/eDi2Xr5RcJx3h6maNEd5CL3O5ex8eIS/mixp6Kzqme4g==

On 6/7/25 03:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.33 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.33-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

