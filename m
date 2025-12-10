Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118923B8D75
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 22:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765404141; cv=none; b=YN4sVsqXwAzgAWWgZmpbLcIzA4WkkupMU/7wdUoY2x6hJJbDYJZHkZxLFdGfG0JEHaA63ZhkJJEt2iGvu0uA7f/iI6EdNo9oueHr0Gq23H3CRmbiMf+mR3DzNeIoGzOPqHyGmOlmjfqZPDmDTjOB6OMOVyzEVuki/ZYZVld1zbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765404141; c=relaxed/simple;
	bh=6w++4Uesw0hFCBHgcULW+f5wfu07mZ1veOSY+y5Awpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cOMS7hJlaFSTWbqw7t6PxZRt93fRb8lRQOFZ28BiTuZPxXqoDPfMV7XXkAnRbe2BPcXtzYeJwGkB59EEnmILx4NaZ8vPIW3EGDEJk7cMzWF5yL/2rfyQ9m6qen8Dwkawh3QUEzhaStYKHIjbh/Z0NRwQsbbeb1EDlT8fHwDZ04Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Oa+AsaSU; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Oa+AsaSU"
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id TOTBvv43Hv724TSGIvhwG5; Wed, 10 Dec 2025 22:02:18 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id TSGHvdoZKMvWITSGHvUkx5; Wed, 10 Dec 2025 22:02:17 +0000
X-Authority-Analysis: v=2.4 cv=Ud5RSLSN c=1 sm=1 tr=0 ts=6939ede9
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=mm1yIVvKUzIrDlGfL9JfmBfjNLytDJ+LGVsGJ+EPMKM=; b=Oa+AsaSUGOm29NYphSl5abdrDD
	6npEAA/xdietfTlmIVHCBD5feD9ZLxzaacwlt0NFLranXg7QC8+qII+R8Fx0dHMXoy3XHMws2eyJv
	FJo78XsEIQlosOUPttFZI2KuSDuqW6hVdxLd8MTn4irnWzxvsDw5x8xcuMet+L9KleOLOp5difmYO
	fIa74eYBOgiT7KyTDy2Lm2GOiINFLduem2R5zqc9CXQJQ7Jq6igPNTfGZdePb07pWKvORgYA2uz1I
	TyMcPvpTw0HlrGLj12HrajPj4IwWYdgDZGz5467xu7xSh1FUa8DqcEiPoJ+IPIvj9r9bPE+XM880P
	TyNM18xQ==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:45674 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vTSFw-00000000xAu-2zFP;
	Wed, 10 Dec 2025 15:01:56 -0700
Message-ID: <a83629f8-e25f-445f-a95d-aafee86c5524@w6rz.net>
Date: Wed, 10 Dec 2025 14:01:33 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 00/60] 6.17.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251210072947.850479903@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
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
X-Exim-ID: 1vTSFw-00000000xAu-2zFP
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:45674
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfOS8IGPsEOgb4j33/4ptiBNKtveXdYVj76SDtycmhxVVUu6lnWB7eNkWknHtObTAJ+zV+jEdvkLsNTnlrZwaGHVJO5HTxM+dpOywFddgsu4MSkaz4q9i
 /43QWYBaZ2dNk5TccCpjT4vydwYA4Bz+6TN3Z5zB9UjHthfd08qOuRjzifCwCNgm7wbsNfqKT+hPhA==

On 12/9/25 23:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.12 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Dec 2025 07:29:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

