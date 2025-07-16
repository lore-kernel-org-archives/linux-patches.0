Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F6E2F270B
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752663436; cv=none; b=X7w5zpfarYPl691ehJu+wlOOMPiSwRh+5tQepxghrhm+ZqBZp3TyyqiX0i+EPqrDRqExcFndurUGHA2MFFHq6QuA4C8AQMSAwdUPjbwy/VLMNNnT2PFTDyigbEJNzkr1GqkTAnC5d6iF1XmjRTkH75VUnan7ObLYArxsDGYuf9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752663436; c=relaxed/simple;
	bh=GPD54MiSwGpnmV9EoyB942cPlsm81UA9gPTH2S6tKd0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rDCE1kDPJP5+jfY7Gnvns8F9lLuQSn0KmoOXdvUOckGb8WIJCUHE2AlftZlfGdbfInWRNXvLi2gUdlDRmUZsObnR5ce+wYQmVclIUsJpiOVwA1BAM2EGf+M5P8OFs3TS1M6lfAysY8BNucByZn3nUWzekVY9B2rORVCEKK9BmoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=fpb/o/NT; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="fpb/o/NT"
Received: from eig-obgw-6007a.ext.cloudfilter.net ([10.0.30.247])
	by cmsmtp with ESMTPS
	id byS1udrpMWuHKbzp3uurlH; Wed, 16 Jul 2025 10:57:13 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id bzp2uZ2fwUJ5Ybzp2uCwqu; Wed, 16 Jul 2025 10:57:12 +0000
X-Authority-Analysis: v=2.4 cv=MMlmmtZl c=1 sm=1 tr=0 ts=68778588
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=XfPcjoVuuVMqcHTMwS0A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nSNvkqUVQnD5t2lsvIJK8rW3EzRskfl46AXDGVKpmqk=; b=fpb/o/NTNjaUcD7lY/KM05zW9s
	MFQqenqTlqYWnIzBYdVDEDe/vqGQAVvl4HGvzXZaJxDREw6f+bN1ILEptoOebOvAjZEOT+eBEbLgK
	t51m7sycjJoz9541JIHhY8IkvcMtvhaurRSSqE6drc/KHIasocqBCP0eiuzl+ux2+yeFb8hxuqBBk
	zdmYa0hATE1S5yruTSF4vcwsU6y6VKJ+XMVcmqzNz3CXoECx5VJDyRgcJ/6mAOKyy3g0lCxTyS3jg
	bxQBScd9aBcBTQKiEZ0kiv1mGVMNakuQGDktBdxepnydRQUP79/Zv6ValEHsxU9+bKZwFE/m1pSN3
	kK1UqR4A==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:57232 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1ubzp1-00000002QcL-16KP;
	Wed, 16 Jul 2025 04:57:11 -0600
Message-ID: <5f3ba5ab-74b9-4174-83f4-6c1d7cf2df3a@w6rz.net>
Date: Wed, 16 Jul 2025 03:57:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/165] 6.12.39-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250715163544.327647627@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250715163544.327647627@linuxfoundation.org>
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
X-Exim-ID: 1ubzp1-00000002QcL-16KP
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:57232
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLjCU4jqM0+vgRFtqtzq0rb9PXLot3Q9lijHk17lSpOODh1THXtCyDsLPyvxqToA7ageCYcdGrY8grAQ2bG3btt696i1RgwR6/uChpYO/Y2ym8OkNist
 248xRVGdMYrcosWz3EhTyalm7UzKrqeaTFaSMGGooqxP1igqfcOgFl2mCRx7QXIR0GhX970zgA6NvQ==

On 7/15/25 09:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.39 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 16:35:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.39-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

