Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322B936606B
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 08:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781770963; cv=none; b=PuhJQRZRFtZBRVVpalqnCwvOHW19BQWy1XYMs3Dlvwog10uo92LUTjryMja8hu0sFYHADDgNoDSWJs9qSmhdr7WDND/iP6x7heD1nusVGSP97hcCodSDeof593QeBTg36sWYArhhoeb3yJ7ASY7QYwpiVp0z1UZPM991FvJuE1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781770963; c=relaxed/simple;
	bh=0l6PL2+j0UYTsoEPQmorp4yUwegpL9NEbxh6Tz+Jljg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=icBaoihV/0JfTPjZfU73/TxRtF034+dk7P9hMelCYB7e5JiLoh3Rea+zOKRBRW/gft7CeE4unnht+s3icY32RQcfQVQYPyVAFU2dHts9s4h7b0eEh7SSgRyBw4QevnSfwXbPytoIa/shu/mXTZSSsLYqmn9axdO3yeixCL3JlxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=zFjTlgkF; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="zFjTlgkF"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id ZzfEwcdzsjgwea81JwPuQn; Thu, 18 Jun 2026 08:22:41 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id a81IwmLgJcYN5a81Iwsbds; Thu, 18 Jun 2026 08:22:41 +0000
X-Authority-Analysis: v=2.4 cv=QN5oRhLL c=1 sm=1 tr=0 ts=6a33aad1
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=9GQXaQUDpQhx98mIA28A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sF0te89c/L30WqI9HCaU1VG9I/eL25o3xPRxasN8C3g=; b=zFjTlgkFtxiwub6y682cziPeih
	GvxMise6/+hoRltJniD/MKYRnz6dQNFLCJIDeFnZ0CIoal4HpBN8esAiwKSxrHenrqmWqZbzqVf2w
	xeRlFVGzhggE2gU6dQo86EYC5JVwSbmcq001ZarbxmxcDvESzZK3/D5KuXYpZvjc9QMWl4BzG8ZPn
	hHE1pQ4blulS4BCyA/KP9YmaPrKg8IXKuA0LTb3AbAt4nnuJ/X89HKDnNYnn10CF/5dpNhGANjrqx
	XB185AursIbThqozJshVOCtUu+yY3L3khvKhKqNAWan23DSa5jxSoNzKkx9kOjQs/CtrWa/yx7iHu
	GUkd2IhQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:57208 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wa81I-00000002a3z-0aII;
	Thu, 18 Jun 2026 02:22:40 -0600
Message-ID: <28d73da2-7472-4ff2-9d36-3e3860d42d55@w6rz.net>
Date: Thu, 18 Jun 2026 01:22:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/522] 6.1.176-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145125.307082728@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
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
X-Exim-ID: 1wa81I-00000002a3z-0aII
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:57208
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfEj3Jf1x0Rn0GB7dTXSoMNrzq3wR7jfAU7jrQ+AsMkg6fRdeCw8+JIE79EpHtrgI1Nmp/uI7ij0+7r5MiUxSnZFB/RWJ3ynAx84F4A5D0GU3pfNcvPin
 rFdIClI/DColryzV6PaaGSuAWvppvseNYyoDLUnI3ypn+bEycLaHdAl4H5fUR+VZ93HzfO0KTon6HQ==

On 6/16/26 07:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.176 release.
> There are 522 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.176-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

