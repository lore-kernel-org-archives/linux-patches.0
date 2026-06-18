Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C003D6CC4
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 07:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781769331; cv=none; b=JZRY8B7bs69oScizFUylHOhPOZInbTUi2RDlDg+CjleN9aZ80IblN7ugPFBCgLAR3mVwuMdIFT9gm1JRFTMj3QlqOQXppZUjn2IeOxRB2GOiizUKYfyB9rYdzreHbhpMckbHtW1TTLyRXQVkmuJVR91KiTLfEAOt6MPq/ILbHAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781769331; c=relaxed/simple;
	bh=lsw2NKpnZyGv/KbLbCvKp3VzNnrn+Cv6YRuiD4SbVVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SvIEZplVlcPYNOdbwBEDkUO2akyzOH5EfFuFU3oSJbuJRMyMWlHQRJQj7baIjGBfB5nBIC2L1ByCBAnE1oPpaskfasVCRvFb3Pe64NyWKUb7Ltmi2NAD+L+hTjAZNhR9EnQdQCyAeVnT63w6Zaa7w7FgluTMpFn7HNd2EzU9QwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=3C3BfGDS; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="3C3BfGDS"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id ZzIxw4otLPpWVa7azwX8Kb; Thu, 18 Jun 2026 07:55:29 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id a7azwNR3Q3HCDa7azwIn1w; Thu, 18 Jun 2026 07:55:29 +0000
X-Authority-Analysis: v=2.4 cv=TOdFS0la c=1 sm=1 tr=0 ts=6a33a471
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
	bh=qzVgGAp2WXckS03rSt5tczZni3Kqe09p+5UtyAYOQgg=; b=3C3BfGDSzP3s5uVNUHCYty9Q6i
	8Xz399VQn+iLmFoyU0V73XBMRHshkZzkGpx9PsmZvLVHExS/tq85gpLZ6NVZgeTLAxyCDKlFh8s14
	0oIv8OpLRKEEA7hjDUXX3FKLFkZ52eLIinet+revuCVCBqs+6GRzGNsPX3WB5+RMe7pG5Vy1aywOp
	NiTfSHmqUKGJytKfco9Ez96xJCQ/S2W5pY1E7C8WJSuFMDlkggqXErUUGCdMlvlTiZIis7xp2Gfor
	M3rYrJjsBrut0zOMNOQxCONXP3j08JF6wVeHaLFNLg+rF6UptD0rUdNKlPzuCUnyuGnO5JdCyD4iv
	2kRzvSUg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:34426 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wa7ay-00000002IIg-1nWC;
	Thu, 18 Jun 2026 01:55:28 -0600
Message-ID: <813234fa-9083-4637-b81e-85e9e69e7795@w6rz.net>
Date: Thu, 18 Jun 2026 00:55:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/378] 7.0.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145109.744539446@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
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
X-Exim-ID: 1wa7ay-00000002IIg-1nWC
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:34426
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJqY3W6vRNtxy3ckmAq9cMcMi/hKgYCzJCZ453+FZZPCYrNilntI75bt9j2kZ/OIVF6JSL76KANsYEo8AOQfjq36i//FLk3OOMgru0krhpWFJh1BMnfa
 Igacx8+jU6AEoc6wOcDfGnqVpLXhF6rT8EjkpsxcFY67qQQ8bgEMi5UBYpbNN9hlCd79YHz5JuD0cg==

On 6/16/26 07:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.13 release.
> There are 378 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

