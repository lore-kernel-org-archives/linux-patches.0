Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC2E1AE0A9
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 14:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718893112; cv=none; b=rSAQUdZl12IdLcDY6JFYKrczO2yt0yFR866y4wsHiUO6gs/3ntCXWbS49dcOZiLTnjEkwuO2tCN64KOqgR4lVdWIId/7uQm2BVy7hDKYGOyhhjv3FvjWjJZTl/dQTIJaM9pr1pBfY7L/Esza4rPi/wurIr5p9CR4k2SuqM7p3/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718893112; c=relaxed/simple;
	bh=FiTIEM2586OeYCc04M4ohcysGxM456/1S9cHdyWyxlI=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=Ny0F2MNWbGPXfQAQrcT6qA/r3IaToE7TrQ5QU11cYgRX29waRUOuomrD3s/8PTHljQXrixM+sBGQaGk666LOUqKoUHJTFMjZ1jqHEhPIIW6WO22IQvKXoQo5vrX+Oyh4Z1X/Q5wkZWVUw9wJOH5xTAr/pZOF44qFVFcnpZWJw6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=cRMrVZj0; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="cRMrVZj0"
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
	by cmsmtp with ESMTPS
	id K9u0sUdIkxs4FKIcJsYAuC; Thu, 20 Jun 2024 14:18:24 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id KIcIsuOafr2cRKIcIsP003; Thu, 20 Jun 2024 14:18:22 +0000
X-Authority-Analysis: v=2.4 cv=UotlNfwB c=1 sm=1 tr=0 ts=66743a2f
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T1WGqf2p2xoA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kNzFyEQwpmlpIjNtX5zmjNPnL9cJHaoTaVBgjYFDMbA=; b=cRMrVZj0AJvLQz2cxQk8O6LZxA
	feTp3+P55CLY05MKDc5sS5bMVlwOVDHIyzQJDvMeCHYt/hoBK8LE9R+V3F29SoBayI+ayoQFqnriM
	aQJGvBty/YfsbDla4pf4fQv4KVD3vMRLt+R5RPEA1tiwH87l54NyFBRLLeVRC1nPNVZt7KSZpymS5
	7v2BvDP+J/6HULZk4juRuIXK3nx8O3DI1SJ84rH90d1jl6Tr7iYIWSs0ao7lInd102pJZIz+dyi9y
	lW9jsF2tbXXmcdnGeBPVl1tYByxUMRliJMAX4HIR931RAcEE/MGoRy2FnWw2C/T3ejufK2t9rql5Z
	z+/aHiYg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:44936 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sKIcG-001dNG-0V;
	Thu, 20 Jun 2024 08:18:20 -0600
Subject: Re: [PATCH 6.9 000/281] 6.9.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240619125609.836313103@linuxfoundation.org>
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <8ac334b8-2b8e-41b9-e532-873216d57c5a@w6rz.net>
Date: Thu, 20 Jun 2024 07:18:17 -0700
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
X-Exim-ID: 1sKIcG-001dNG-0V
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:44936
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJYe0jWDInKIJVaMXe8+R0iNQu2v6D14OzaEKdqQwhm2QPa1Afctm+yVtPcIYM6R4WmgJlX0kX5nYEyY3S69Gl+pMCe1iecjHBPE5i4sWEYzBiPeCM68
 2/SUb9x2OePRFYTbQzOT+7qtkus3OoVuxFxXgoS8iFIwrRZcri0WIxU8OHXMycrGMqwgNII8Aji8HA==

On 6/19/24 5:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.6 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

