Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2704054756
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 03:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712632393; cv=none; b=QeiUauzvlxQE6LMkLEwV/P9Uno7Oq6WpqPABPhdWzcNH4VGKb8YLBJF4+Q95ul8FSCVkS0nxVvK46V+F5Yg50o1MhhTMY2CK0j02faSzaktFWv7IacD1yJY6CwKC3JqFY0kbBUQ8ep8NiieXhn7Lc7o/WI/R/indG9HsBz3zzzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712632393; c=relaxed/simple;
	bh=AGjNixSGJ5QwggZtom6Ug2ISD2eoh19CLxKOzqIHrRM=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=kdZtots9vFQxuz5CX0eppNSmgDSGdPFZeJkYtbv629ZHP32ZGDFgfuxJ4yJ6jCIKsuIwjxFi3mUGzEUsboteQtLgWbCgP587GwHkGo9s+gRGTQWT1gmIDtOGznsywJ+x9zIh5YnmdMnhwQbwkt5htSWvR9ogt1AxQJ6J0PKISFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=QFoHTJ4Z; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="QFoHTJ4Z"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id u1fUry6g1HXmAu1v3rtca2; Tue, 09 Apr 2024 03:13:09 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id u1v2rwdS1sT9Bu1v3rDsZf; Tue, 09 Apr 2024 03:13:09 +0000
X-Authority-Analysis: v=2.4 cv=LIutQ4W9 c=1 sm=1 tr=0 ts=6614b245
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=raytVjVEu-sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1fi7cYYhOkV2FiaOiItVm/B3uVfPOHQmO8hDnH3nrqI=; b=QFoHTJ4Zp4MrGnF6VLVdHNBNJx
	AOWLfasXQdswhlrNGXazPmL0xr9eVUmLoR9+bfBhBvbU4Znd6p7Gxy6ro+oFrXA6dnrk229Z5Ks96
	MAfBFN1GMUkg+Cnb3rmYh4X+42E1nRzeXP7/W2JnGdGl250C8l8R23uaTYBRk0ot65rR2eMmgCZ6W
	crODtTJRtY6AxjmV1vBMQ6VJirANz378daNJWnWR3tAwQy/u1H08DR5R+RCmx+RPlGsa6mOdQv3Vu
	cHIG6uxmcBDtpnCzT+OoSZOdsd1WYk/Y4MTSx5Hh2dN0vqq8mRrIuH1RsRNobHm8yZ3PsMLTgOHy6
	lycTjuuA==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:56502 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1ru1v0-003CRV-3B;
	Mon, 08 Apr 2024 21:13:07 -0600
Subject: Re: [PATCH 6.6 000/252] 6.6.26-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240408125306.643546457@linuxfoundation.org>
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <9715c616-e1db-7da4-8f5b-22def173735e@w6rz.net>
Date: Mon, 8 Apr 2024 20:13:04 -0700
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
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1ru1v0-003CRV-3B
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:56502
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFhrwREiR5TpreV/eM/LpSr19BuN9cu+pNGSYHTNcmVMdoBUnYqaEbcnbRjOsWfDeIGq6SEAwTaNUWX7SifLCgn6k41zUhH5akdb7aPr82TkEz+pilVB
 4uC11lQeMLBK+j+MJ5IdID7CZFnLJQRuNyBjYIWPc3bukJj+YHaDBm+aCX4VqWJaaqkvtm7tlhCLzg==

On 4/8/24 5:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.26 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Apr 2024 12:52:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.26-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

