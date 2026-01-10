Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F71522097
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 06:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768027524; cv=none; b=m0wdEHmmDQDXA6kaTJ19RNaHTFGRaAKU+rr4FxEElhyiTBPENtHAy8MWumDJzUNU6uTb1/guCPlWws5lg7PZgZ5qYu2NS+jmORG9hLs3J9VntZltLStjR7CsSu8CSVTp3xFHh4KLj1odk21L53WdmWcIiu6199TQwnAvsmiCLOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768027524; c=relaxed/simple;
	bh=doFG49FC4npag0KQT75ZCVyNhA+7xBxPo4zU8L1C8Hc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LMVRj+uOUXIvdLq+eW2krbHX8BCV4PMBa2z+Hf882JsuQujF2G/WOXTcHRqYXvP3CcZY/laVsc3xBnjtJ3VyB0ACK1x2TzBkwochNUYtJWyM1gDZRAciKn6be200W4KBiaGXbp9Wg42cQrxF7MF/+9noBaecwJ16Hru+UqUxtp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=3Uot7JEL; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="3Uot7JEL"
Received: from eig-obgw-6006b.ext.cloudfilter.net ([10.0.30.211])
	by cmsmtp with ESMTPS
	id eSLnvrUB7VCBNeSirv2Ui3; Sat, 10 Jan 2026 06:45:17 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id eSiqvQZBYvXvHeSiqvebhy; Sat, 10 Jan 2026 06:45:17 +0000
X-Authority-Analysis: v=2.4 cv=e4IGSbp/ c=1 sm=1 tr=0 ts=6961f57d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1P/f+Q3dsace0AmBQqQ5n5Tzf/ydS0nBVyiRiu9kO74=; b=3Uot7JEL0LE7210RUblVe6ph20
	0fzuI1EH1M7BHOWywpIFNWyKZ9jcfxHlQ/p5xY4Lyk/TCfeic+4lB3KzvhT8Ifzn48UzE9mic5qGM
	2ohcryao5eZC3dzEcqgQez9j6yt7LuKvRAZ2s5ti3M68dA2PjwGg8MTXKTGW6fooTNtz4g0jCtpW1
	ZY8JlSy8XC6azjIU4rKZC+mOHMDSr/xzcOgmI++IVm19i9gq9ge0/XGqY0FJa4byF6Ainjc4uvbtF
	oHa1JM6a9DRJqkzWDbP0GwHhegBfEAlPPOLplBaW64jsyKn/YHN/PYu/8VIG6wIG4IazUlifdJFB1
	wM58z2pw==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:35060 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1veSiq-00000000wZn-1LVe;
	Fri, 09 Jan 2026 23:45:16 -0700
Message-ID: <016deb34-e9d7-4f5f-b2a9-cbf282618aa7@w6rz.net>
Date: Fri, 9 Jan 2026 22:45:14 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260109111950.344681501@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1veSiq-00000000wZn-1LVe
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:35060
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMLCq0BTYuQMyrs+Xv7a7/8g9BqKHMfrS3GKlY2SKpSlVS2CpWGHIl6YFabDmZO2WZZuFE8rO9hVgMbgLmT/8uBNDDEmWphO6fEjmPFN853o7yRVczE6
 WewRDBqxrOz8jYK8W6kKBmnfRhePOUZyFQLKwB1CMJgez/F+EPiCz0THzKRCP/AXMLkAVcyzDA/K1w==

On 1/9/26 03:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.5 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

