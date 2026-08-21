Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3887D438466
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 23:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787353346; cv=none; b=iWzkNGS0KlzNPHtEdLQ5k+gTARWFbOd2GadihqNmcbE8onnIqIHFWcuKK98LtkW8tftP9aNBXMismfUyAyfMMiRBnobUijHZqjTZHDFEmO/IkAlu3NrfPzuCnqOCN7B8SKd1uMKOx52uhEZ8Kc5iKHwiZpzdzoirWBaQGkyRjUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787353346; c=relaxed/simple;
	bh=yks9Vg7J52nSQdnijEpnVqBPxqGvsKcWpzlMO6QI8Uw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AlJ90cC2ZNIsluisV56s3SzwVuVw5pVyZN8HlC8fyCd8nbsTwYDgGqATefZWCOwXbdAXWlQmegcrMdmD8fEU8KS5G90X5zjWfi7cmUvt8ED7fxBHgSkfz2r4Lmq+ZwmpGrZMkzV8xeBjWknuFaEmnBhmenHl81pXBXtRYtuVeHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=MQRh/k3y; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="MQRh/k3y"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id xYDUwROBOv0ndxYFkwdGbc; Fri, 21 Aug 2026 23:02:24 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xYFkwNk0C4qQIxYFkwaRGG; Fri, 21 Aug 2026 23:02:24 +0000
X-Authority-Analysis: v=2.4 cv=dLummPZb c=1 sm=1 tr=0 ts=6a88d900
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=9znkghA2arZQ6fEvHFMA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=h+D2XIVVLT6TzhHA+m5CNdqPT1j1BQ7PgZamxK8fkV4=; b=MQRh/k3y8egfY6KtM6xUic9xr1
	zIvd3ww0P3ilO7xeXeLYTjv6am+Hyl3pAOTzzrCqXVTdeItZVT2kETMhdEt/v9c3p2UXJWAbbRwdx
	W0XIusjFbVPxjicPk7gZUNtQrJ6ciW9ldMGX8G8WfhXwF6POJzlJ9CEeN1CiXvDSNVLTeVytI42Wt
	pLoCXiP33whSEZIGuB/U1Vh6jmCShKmQwuklAD+g1YZ3WnvzuS3Yt/SsVlZW4y9AaHF8vHvUMTAEV
	4NlIp4jlF5gWYjw6ZQ/qBefkLLKFrlLF7Y1e4IioBkuuj+6WGcDbr3Qn0UDqtlUAibyCODu1xKmb8
	KwnHtY8g==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:35772 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wxYFj-00000002SVe-28Z3;
	Fri, 21 Aug 2026 17:02:23 -0600
Message-ID: <136cf082-cb63-4a44-8b2e-3585f74c4066@w6rz.net>
Date: Fri, 21 Aug 2026 16:02:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/303] 6.1.184-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145253.200766705@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
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
X-Exim-ID: 1wxYFj-00000002SVe-28Z3
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:35772
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMVEcD83Dc/6QUbCNryXK0YvNz2JHHTChQO8KXUwve4w7pzaYZcq0UPkbDzjkcnuYPCFpU0YStaq+wmDs0ci1xta9fyaO842eFD/GTGTmqQCL6P+osWV
 T8oCsIVsbPXw+sq9I5pUe5i4xJ8EezUhlWQ3G672PfK2670MwcsxkZIevjKDOmht+4hoiMF9IbXJZA==

On 8/20/26 07:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.184 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

