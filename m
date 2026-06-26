Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5062149C6F
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 04:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782449989; cv=none; b=jxzlBTVVBrwozU/iH9ggQZ4Ntl+DlxNPH5egdUSpBjlEYX5XSTRt/QfgGeXmQ6MNiMeinJZKZN8bfl6P3K5iYuDOdgBCDEiS5Kl7WkBVmwRqIeldqUHnWlqM9bj0r986NlkBSCKInazW0dTUoR+x/Kzh27bJ6uesZ8P6pxxbirU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782449989; c=relaxed/simple;
	bh=tqCdWBcMHdkiEepgTr8jVgCz9nRxV3XiMl2vXONGYnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rqAi5v/68YAhHiVG9KgyGGgDsJw/YwNmCL32dMhUkiFupubp86Ss8azKzS+LCJDP0+ZLai4szvXrwhayTZnQxQn1WQzdZ9moFe1rTGq8vDTmJyR8sNa4+jxGnvpjm0tkUH2wworvR/83MKnU40UUE1ALVW29KYaEg3c8pZL0DGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=LZ+BbU/1; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="LZ+BbU/1"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id cxZawaSQxPpWVcyfFwcXOA; Fri, 26 Jun 2026 04:59:41 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id cyfEwjXkM0F22cyfEw141H; Fri, 26 Jun 2026 04:59:40 +0000
X-Authority-Analysis: v=2.4 cv=Z+fsHGRA c=1 sm=1 tr=0 ts=6a3e073c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Lc18GGwJt_UjcvvaV1cA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bz/RO4b0NVOgwnSQFiU0+AXl3rGuGC4s2XRWZv+vfrs=; b=LZ+BbU/1cWyQAYV7Xdw+bpIhfD
	uco/FfiIYf78bgrfabNiGQaIG4jy4A69h6Rf6Af5rn+9JGBlZWKoA9lx4CEFWhCrqNoG3dnw7/ezt
	G0Y+hvEDrzWrY9BusdQhJv3eXSUg3IPd+ij6Ly4Ws2vLVPnbCroPVKI8Or1Q+F4VeKUx3YEcb+esJ
	snhXXFBH8vx4skGFLidtmgCRyh0DCdmR52LHR9ah4XuRXQfN8nz3KzmNnebmOgWvvDfPMOmOYyAXP
	f9vv7dMNx6sVvYb9L5CrrO7LcD5Y4140Tydj2KC1ZBGaXSs5W/UlQf+8KbJaU+tXUKEdCAaui5u1N
	huZJAhSw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:46856 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wcyfE-00000003b9Y-00lO;
	Thu, 25 Jun 2026 22:59:39 -0600
Message-ID: <bdb6d149-b8ca-4f51-b860-45f9bd2af917@w6rz.net>
Date: Thu, 25 Jun 2026 21:59:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260625125613.243729608@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
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
X-Exim-ID: 1wcyfE-00000003b9Y-00lO
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:46856
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFkbnfv01gYmP+DdTk+2Cnnz6XOuQtfHx4gP0MdXxCWlsuXCPZ90nYLLUd7SbI8v+jXJTasvS1BRnovbKVGUVrW8qn5OxzBKWGvndFb2DIJmQQnDANp0
 U+3+CdUeK/oHLbGpoIMI+c35r58w1AKhSkixtq9UVFKpTQ5rUNZajAXm4tTSN3RBKsqPsnAMoXlDbg==

On 6/25/26 06:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.2 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

