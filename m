Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931691C695
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 00:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731457474; cv=none; b=nig8OAAqX96rLQQ9JPLgkeMQM6MVNnkBGI6vwQ0P7MXbA78Ig4EvwuKSJV0plTRdmckDBqlFQtX3+FTSODfIoTZKHQTrKZVNsZA90MNA7h2oXbWXRXOm2vdNPABZAMcA5bzU/cdOKH3VIYFwwYqw7DcB4Se4tU1yIShRBcYP7nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731457474; c=relaxed/simple;
	bh=fuVcME5BsYF/KDmWaecJg6j3aQXYbUoEbKBzj/5I31g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RWnKqmfBQamZzdG79Z1KkIOWKlekVjr5Dh25xJtDklgn/njjeV1zMv0a6NnvDMYcr4kSJft21ZE4/X2+uTcA6lsA/vFI5aXHyMhMUjBJpuvDO+yBYJYK60wIRBfdvufJ6S15k8nKXvHQkKbkq9ML4ZmRkvkgyar5Az35CEzP82w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=1wyOMHs9; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="1wyOMHs9"
Received: from eig-obgw-6003a.ext.cloudfilter.net ([10.0.30.151])
	by cmsmtp with ESMTPS
	id Au4UtIFi9iA19B1BOtJx6C; Wed, 13 Nov 2024 00:24:30 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id B1BNtd1pXCgT6B1BNta1zI; Wed, 13 Nov 2024 00:24:29 +0000
X-Authority-Analysis: v=2.4 cv=XvwxOkF9 c=1 sm=1 tr=0 ts=6733f1bd
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VlfZXiiP6vEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Xg3r5l62jPq6txtoRjwA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=K+fIiBWt3QFvo0A/lr0YOtxvjEv8y0POVh9URifPW0s=; b=1wyOMHs9YO8LVEQwXAXuHF3oRU
	QdEii+Wv5f3WfBYi+yWlZSCbtpprVXAxNzx9CyJiufqaoeP1xeqxVmIXXTtBgika0xbPRrm7yaWF7
	R85TOJTKveDX549WXKf83FCYty1vqVmFkcet5WlA2SCMW7YV5YlTV/ITILE0WJczmkQ6LM8NO2TvJ
	MGQJAg2BkSTZuhDhVOaO1ogLN/9blBiTCyn80uel5bO9bisrCpMtox4G3hXHwVBizn48JnAQFIRUK
	+ofPodWm6u/7zgjHYxPH6QkjXAoYPAqXrV2OnzjsKlBGCvbtdM6GJnJke4TRh4aWmzr0ksO/EZQcK
	elAwVf1Q==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:38588 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tB1BM-003zln-0M;
	Tue, 12 Nov 2024 17:24:28 -0700
Message-ID: <a604f668-b22a-497f-89f7-a2f84d07de58@w6rz.net>
Date: Tue, 12 Nov 2024 16:24:25 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/184] 6.11.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241112101900.865487674@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
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
X-Exim-ID: 1tB1BM-003zln-0M
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:38588
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfI4+wEOQIiCl8XokyxopAAE0+TLZtZM0cIxyWC1Re2xSb9+lf9IE78AWWxg7zzwIt8gBTTbSCrsZ1hwAMhd5JaAt06EqnctIAS+AAaUYtF2vlifVv1Nr
 fanJNqA9LLf2dbYpE1PWtqON4TH6p/dVDtLS6Uyaoizwfslny4WYSJiiaUi9NW/2L5hhofcgRDxC/w==

On 11/12/24 02:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.8 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

