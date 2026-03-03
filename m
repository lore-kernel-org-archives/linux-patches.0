Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30ED81A6801
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 12:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772541514; cv=none; b=XmKNZHS+t/CQhSO7mEUrE/mf/dj/AMrJUcm5INb8gP9KTFz4R1DULIKNATI4ofJwqS8GUxYgIAbrNTJbxi8Sd34p/bzEKRiJgNgdympqM6SktySpVH5r1S6HEExCD+AZa2IrtOwylgcL2a1NxaWpC8wsXX1+N3mA/5PhMggXMJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772541514; c=relaxed/simple;
	bh=H2sC7nH3XMT8/9CSFV/y/V3tCgYNqxVkVVTCc3Ri0xg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VMDFvj1Nn0Nh5B+Ft7iniQVh/I0SXEinaDeJWHB6LaNfiQeNBAMZKUQuXEfGrtQhqejK2SXlcEREc/W7iRWQ/hcJroUwpuloGWKb1p+Uokj6esyYNhaH5fWMLnL6By5hGt7Lg8XGV/G0UtCW+iOAW1IqOnXC3IH4kfDPS/+XJC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=J3AcEdl0; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="J3AcEdl0"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id xMMnvuTPcKXDJxP1EvGYZC; Tue, 03 Mar 2026 12:38:32 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xP18v4j9eN3K1xP18vP5xp; Tue, 03 Mar 2026 12:38:26 +0000
X-Authority-Analysis: v=2.4 cv=UdRRSLSN c=1 sm=1 tr=0 ts=69a6d648
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
	bh=ICI43ik9HQ4b4rhqyjEM2wDIRnQaaSlfFUtuoUp7oIo=; b=J3AcEdl0aaVZQavZpZjQK9ghje
	0DzmKr3k8T2bFjYcntQO84zi/rCqK/0++tljLg+e8G6odIwzGc4BR2NyQ5bZcxUBX+36ckwz513sw
	SDrpFbWcZH9TcFDO2qxdXw1cW/DP7RCSlKB6ZebcQSksJMkoOrRfcHHXdrxaA4z4n5qi67YFBN7kD
	NaU4tlkevYxz3/FZueePsrAdpLwGd/jPB8I8+8ImAhFikVd3HCXFtYugLDyQiwrKj30o3CqBLUlkt
	AjVYE9UxDWEWLI9yxXKlFnRDZNT+02ZTbzYO7tqVtTaTCXDmngkj6qqi+hUIQ0OHzD7qmhxa4THL1
	aEhwUQ1w==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:54780 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vxP13-00000000r5x-3vW3;
	Tue, 03 Mar 2026 05:38:21 -0700
Message-ID: <1c237ed2-54c8-4777-8603-36a495f2738c@w6rz.net>
Date: Tue, 3 Mar 2026 04:38:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/410] 5.15.202-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160955.2522727-1-sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260302160955.2522727-1-sashal@kernel.org>
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
X-Exim-ID: 1vxP13-00000000r5x-3vW3
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:54780
X-Source-Auth: re@w6rz.net
X-Email-Count: 101
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFdaxsGKqG1t3uZzrg7xfBmZId7YV9ar7+maF+YoKIpOM7DIvQaJhdqAx2k8Dd+nW2W9N/9tDNu0iUu1k4x///yGn9Y6wHGREHVrkuDuHE08ATKszD1w
 HXO09hfaktTjQiQizChidi0doCWpn5bzfQuopcS1a0pK6BhIBlBQJk0Shd4bq7FnHFheQgJ9LLZBwA==

On 3/2/26 08:09, Sasha Levin wrote:
> This is the start of the stable review cycle for the 5.15.202 release.
> There are 410 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Mar  4 04:09:54 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.15.y&id2=v5.15.201
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

