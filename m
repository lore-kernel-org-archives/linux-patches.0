Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFCD3DB64E
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 11:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165936; cv=none; b=YHA9+wp0BH6cz2EibOr8QsGS4DFNv96QWuu/EyRrUNuQHeT64weMgAne57qYQqv1JKKKK6JU3XJAya3kgG62L7dzCwB278Q5IPQ+u+P/Bxe7kggYVwueLagTMkMh/gWwIT8mjjD7YGXugaVEwpe3Wl5hW4vKEwBha5doMttWyG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165936; c=relaxed/simple;
	bh=lo0yPw0F/ngTTxIIpwnElHnq/+W5AJb6InQ/wwsIsQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LfNbrWtSvMOZYkwUC0GkFLwkKMDmj+WbfP2HW3DMrsQyr5kBNnvxxeG3PX+EADarfnOxqVjLP1+WoF8D6Gutnm1w/ZnHhupamRzLXMY84xOlsmMLt58OIp++GyTGLrSodp98kxGYxc3FWOoZfInTu7NxcJbfzsmXAKmMarLund4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=m8SF8lV6; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="m8SF8lV6"
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id CaYuwwE1fjw8YCbtdw1hfB; Tue, 14 Apr 2026 11:25:34 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id CbtbwdVsrMrq1Cbtbw00Zr; Tue, 14 Apr 2026 11:25:32 +0000
X-Authority-Analysis: v=2.4 cv=W+U4VQWk c=1 sm=1 tr=0 ts=69de242d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=uHGCpH4rNZxk94gAz7ESxfkiyyADCknWhIcDJNy3xn4=; b=m8SF8lV6rLZ0b6DnA+ktOzIJ9n
	d+nGzvH1/IFNjStr4ziEAkwqGHqKvdDrc5UJsW4URZS78vge7A5B1qAZViNvarQDA1gp8HlWgyRSo
	xdaFatoX9H0tCZw45vNPhda5KdHWHxwbatYt5juiRWVY63sbRew4X37iQGvT6WrgmWfns1o9IOXQM
	B5v3/vszZH+eF5UAfUZTLU0Z9cgGCbxsaAhTFmpk4B4a4xYgLDe9qWTGzmo8CVAzVkiVw2K8J1zLt
	weHchYQZTr8LwKqvmTzOIH1v2nZyZWmaL1UMby1UJliO7aI117bbslumB+qFX+/CMtH7eVqjPokQd
	YbW9d7Cg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:46060 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1wCbtb-00000002bsi-02ES;
	Tue, 14 Apr 2026 05:25:31 -0600
Message-ID: <70da336b-5bf0-4186-a839-e79b6a54b101@w6rz.net>
Date: Tue, 14 Apr 2026 04:25:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 00/86] 6.19.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155731.568515178@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260413155731.568515178@linuxfoundation.org>
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
X-Exim-ID: 1wCbtb-00000002bsi-02ES
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:46060
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfOTBZzsf0UjDCKt3/uUSEyTg3VQUKgAflLYJOTkjZC3j/Fi53eaXdHAPFd3C6rhC7LUeByTKdClgDO+LCsxzCj4zhRw/S9apoi9xDvpNjDT5cPzg49jD
 rYOis/ItiQj7IDaOuL2F7cPOm5hdSLAg23tPGC6Sxx9VH71OSQXfA/aapfHzj0JcTXICzRfV//oC4Q==

On 4/13/26 08:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.13 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

