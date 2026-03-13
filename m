Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F9C19992C
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 05:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773379487; cv=none; b=EgLPtVMcIPEY0nx097ABOCq/fm8Mym0LPIX3pqr/a2Pwx14DnhdsDj0tmf/HAUnxve/VWjnam3y4yHY2j5g8hjr+zPzmWXE5e3jvNnxPG0MpVUgE0XgdypqC6o/NONdY/RioPi+mwrrYCemHxJiRe37cLfK70nWS9sp7ACdC1fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773379487; c=relaxed/simple;
	bh=G9B5nu7D0sWnoCcZu4EG/mofqovCX6sr+TSgWIfTZns=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B2rTqkdPx+i7ehel2e1JjvNb5jjeV0gh/MY7gwuUbjacJUbDtomzViLOi40Fy+1NQ6J5S29xX1Jh/erdf50JUtlrvXzqqUhdYYLsa4WU/j7bre27JGwW8A4dLf1HvhjiXhLvoyTJJjRsG/6/5+G7DTL0TD7pxhBbCF4bCNBE3eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=U6Bb1Hcm; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="U6Bb1Hcm"
Received: from eig-obgw-6006b.ext.cloudfilter.net ([10.0.30.211])
	by cmsmtp with ESMTPS
	id 0jc2wcgKxKXDJ0v0vwlyzl; Fri, 13 Mar 2026 05:24:45 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 0v0uwVn6zvXvH0v0uwkzxW; Fri, 13 Mar 2026 05:24:44 +0000
X-Authority-Analysis: v=2.4 cv=e4IGSbp/ c=1 sm=1 tr=0 ts=69b39f9c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=HLUZ3iPupsy48M1uQckXBhuqJN9MxnPdM0PGhVkneMY=; b=U6Bb1HcmoTZiAO+WYCcjOnUZLg
	pbGHd2lrir7D9OFJtc6EP4JdUNwNvoAyMjQYRyAztyg1VDQMyIr2xws8jD68pOr0StQtz9P4Xv+2J
	bAzcRhgx11kF3SOuFueMvp9CsNaNym2gp84xtcy5ArQ+bpqMZBvQ0lhvBZptlIHz4G9s9d0z5+t2d
	tL3EHtgbZRsfOj9uSktzX3ShvIEow4OuWS+DDJg2Bxl6MqdjTuPX1DI9I4abtrPNrrC0VoihqbrM5
	X7vroU0mPnuQFlre37+KrE4iikrPrRdo5oHFOjOhHGYaJjjXxdX1guI8iE85dLBQwv8j8UbhbwIWM
	dltDTKqA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:34566 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w0v0t-00000003EeM-3wxV;
	Thu, 12 Mar 2026 23:24:43 -0600
Message-ID: <e77a48da-459d-488d-926c-ee3f8dda3901@w6rz.net>
Date: Thu, 12 Mar 2026 22:24:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/13] 6.18.18-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260312200326.246396673@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260312200326.246396673@linuxfoundation.org>
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
X-Exim-ID: 1w0v0t-00000003EeM-3wxV
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:34566
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJ/CxZSyqDpWMqFK6HWbVA+n6k9s0vwDsWk7mgEv8o/V0Gn+BgOkUUqitmEzVHYDd32WUFP4Jo3goYqYrjg8NIqtJc8MxlT+h7XdRGDAmxWXcWsaNx1i
 hyAmtl4IevXEdOBNNUPwswNQ8yWfYDFi81khok2nrI5r1Hg/tp/u+Ev88GeHCaMkmA8XReoFv6U6mg==

On 3/12/26 13:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.18 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 13 Mar 2026 20:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

