Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E9E33F8C4
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 11:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772539055; cv=none; b=SlzSCWznYOQ1dFWfiq9ArVAeFUQVXdWhXx0BmxU/l8K3cIyjjKBmlzZHHYA5dvXLGX64MUwznhkRc2vLFl0PdLdUWxEWddvxaJDQNMFvawlmu4Mb8081nDe4nvKCYBBgFa+XInKODXnN15VFIX1s1XXIT8YT42Q1WTvdDXUqmg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772539055; c=relaxed/simple;
	bh=/iSpQNnqhc6ihuZha1txjP1qLxJBHJJeqdNalIw6w/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cU4UvRgoRf7nwv2n82rNZUvMcjZiESjNKKs2p+yobYGYnLIglK4fRD/mB1ntQJPyaSodeXab7cUGHdjIKGEWmNjDqyAvRA2LGRIPWw0gWJc/4NYyThYVaVLgecrbKCpQhDeKWCtsGBDrCY77bOP5boHBMUn55h6QtzB6aiLImAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=PLgXn5uD; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="PLgXn5uD"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id xJ6hv5mlnaPqLxONUvd9Do; Tue, 03 Mar 2026 11:57:28 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xONSvoxyJh8QWxONSvboHR; Tue, 03 Mar 2026 11:57:27 +0000
X-Authority-Analysis: v=2.4 cv=Mcdsu4/f c=1 sm=1 tr=0 ts=69a6cca7
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
	bh=yCHH62CRqfgELOSFbphBNXI4bjEFPdRa3Er4H+2CznQ=; b=PLgXn5uDlItdKgFsTy5bPyNefi
	WiuMS245An+tHAQ4wBgyJRPxgLcwQbrsD6pl4lRMAa4SlVcVSK0/MNq1chTloRryxUoXg64ztH4Wh
	X1AKVGjVYp/oNtkRMK/Y3CFZWSLn2vs7QSV6pnoasBTJsOwotrsy1OxxyP7m7eV+Bxoqz3QoxDOM7
	orFZtPR27EN3ado0y9JSuVj79mtpRK0ZG/0THKFACD20KhsMtflVyb2w/9p6zxjO9WEZMjqKsPlyo
	wKavQirelvUguVYwQQd4eMQG5jLOAFY3gyATNSDxMxe4uvOLf0yL59eKU2ig1liyxgP8RY/J1wpBM
	Q/Vyx+XA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:52398 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vxONS-00000000Zd9-0xS8;
	Tue, 03 Mar 2026 04:57:26 -0700
Message-ID: <c22b118e-661e-4fb2-8eb8-23f626f25e5f@w6rz.net>
Date: Tue, 3 Mar 2026 03:57:24 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/850] 6.19.6-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160834.2518716-1-sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260302160834.2518716-1-sashal@kernel.org>
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
X-Exim-ID: 1vxONS-00000000Zd9-0xS8
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:52398
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfK4EgE56m+lwMGkgeHarv4Z3MELkxx1tPoWFE5JXDwpsMkWy9ciKylF7mWvQlm6nyyzYcKr164z1I1nKcjkLUyv1MHbLokUY9sZJOVeQgp5D1Ug6zBLu
 FlTbITUGME2SyhF4Elo7NYnY9sLmf2zwWZAlxyV13wDWYH0u9j6Jba5XDBoYb/AN74jqHgSwSl0ueA==

On 3/2/26 08:08, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 850 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Mar  4 04:07:42 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.19.y&id2=v6.19.5
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

