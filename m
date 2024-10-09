Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72A31E3DCE
	for <patches@lists.linux.dev>; Wed,  9 Oct 2024 23:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728518133; cv=none; b=uPmm/Agi70g66JQVHHkvqiESsWv0a+vxGkR+gPGdBWo2NVheRtQWOsxtdjlFekZizWIp6hO9vJZhPpA5FsGkH3widGRV5aRVrIxhp5dP380s6hybvzm7Gs9t/sQxaNfPPcfnWhqzVv41swT/g9P59HiDZ6OIw7nQ1YYqVs2K8YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728518133; c=relaxed/simple;
	bh=qHOExL+m94eWa2cgVA8y4g+ufofYJ5Zq8B3r5x5ZKOo=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=a+QRdDnjekony/LAyO2Mw8DoPcq/rz9csfWiLt/Anul/nHzEVYr82YUU6HhKTYZW5DMT9qH9LDeefH6y6BGNRxJtajr7BeE1Q3yyuS2G+xNQ8/zvF0EJB+eTvP54x5bGwv2TRC88VY/Y/ITuRiO67rwN+OMm6P67NUNzn6wSMgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=wmPbI0HK; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="wmPbI0HK"
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
	by cmsmtp with ESMTPS
	id yALssxQdW1zuHygWasAXNU; Wed, 09 Oct 2024 23:55:24 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ygWZseKRTV7ozygWaseZlv; Wed, 09 Oct 2024 23:55:24 +0000
X-Authority-Analysis: v=2.4 cv=Ur9lNfwB c=1 sm=1 tr=0 ts=670717ec
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
	bh=qz3nJ7VPPRrQ3fo9WI3Ql+6KHu0dzpOhd13Cpiv2E6Y=; b=wmPbI0HKMsBgv50f3/OIdGK500
	h4aiw1EkGQQPUuubzpnRG43qsylHFpSDnxREXGHUnid97BKjquBrt61JutCoY1mowoLLY1GMW7sbb
	ERdw/OQtds5+2c7QnOPA0OvzhpA7qW69FtFr2VgULxoG+v4x/97sh7V/S5iXaa95KNYUcshXHUTKH
	/eakGIgpbFdyibYIRlnaDPUGfBP7P4Uo23+3esj+I0AT4uy94ttUe59F0JbNxnAz2PdgURtn2H0V5
	uliVo1zXWCnyHxV4L0wDSKczyOo8aNnHOLsR2TLVa82lfewDWqZW8dGPZSlG09wZRqbQq1Vpvj7DZ
	SNkzNsOA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:46218 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sygWX-002jTP-1q;
	Wed, 09 Oct 2024 17:55:21 -0600
Subject: Re: [PATCH 6.11 000/558] 6.11.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241008115702.214071228@linuxfoundation.org>
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <20cc7325-c036-fddd-0324-7b5244a43e63@w6rz.net>
Date: Wed, 9 Oct 2024 16:55:19 -0700
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
X-Exim-ID: 1sygWX-002jTP-1q
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:46218
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfB669KDE6yloVzMs9f8Vtll3zO0w2bUtAlr2NWRyhLJRy/iMej40IO/BOzN+AJq9FFjU5lG3P2h2zz4wo6gYZr7Q7ySBy8wRIe9/b1R/FBh5rgeQK+FF
 PEMEs7HdsrPJ5gmXJYD7zeVNVH668kNMGx1gsIYvs0rzgR+2w8Hf7h/LzPnUJSW7DUBz6P44BgMdtQ==

On 10/8/24 5:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.3 release.
> There are 558 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

