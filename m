Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156B835A39D
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 06:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787724236; cv=none; b=ldxTi1g0ZuAUvXa9RqvjRXT0EsYdk9G22g9E82eXGtP19QSO0DeO+YHwCAckZm78IzU2PxXuCMYZZpAW/yaWiEDA/Du+ddGCYPAW3CbOCAgycA9uiQlfNdRHmzu/SkOcWFEUiLw/RCQ4OX9OXlwW0TMFYcVUJhaP/J5lCzfb4/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787724236; c=relaxed/simple;
	bh=mPKpC7Mn6hrC2wViUT2hnJ+otPMLrjLw+wBtgGc2cvs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bsc/NMcpT6ojOanzVDqIk/0WcJZPyy+ikOS/8wNO2gCeKpVRbUY5NbcYvUpHnprGd31+55JyI/diN/qvfI56uNq/4P5iCDSrcWW7ukUOYMxJzuTs8PLpZOyaG93nVpgWub+aWlC5W9FCkePNI3X3/FE14InjvIsmbNo9fC8/JEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=UQQyOc9q; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="UQQyOc9q"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id z2eewyGXiuFzgz6jkw8J8N; Wed, 26 Aug 2026 06:03:48 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id z6jjwToeZadLAz6jjwPNxe; Wed, 26 Aug 2026 06:03:47 +0000
X-Authority-Analysis: v=2.4 cv=Aqzu3P9P c=1 sm=1 tr=0 ts=6a8e81c3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=60u_ompe4jvr-0JMN7sA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=lV1or1xeUnT70GOtChIZM6vVlxipD/VcXAKsUGaVXls=; b=UQQyOc9qkXF6P2M3AdkSN7gmQ5
	Cho3mD9jdgNxct9lE2TZQvh37JNXtVGl7uGLz+XZLOuRafIremqRwHEySaFysj3aJoCY8rf1hAvbb
	kp1TFIKmHeNCWQZmRdtbPaHX+qQ1PU4mBvdEp55rekhTaeHqtCT1H5glhnTsum5O1CNIJGDQPSaKs
	4plEQACXtxYWEEtEFVBmOoJOaN8dzROL9SXoc+nVdKKFCAayAU+f5mClgq9VJO1SqLo5h9nEjtHsA
	peP7MRVc8wbkFrO8h51P39aTCL6t7Q0p2RdNVldJaOKHuMiQOuqJCMNgoqNNnMYcvEu/m7tGvEmtJ
	J2MM66vg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:56854 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wz6ji-00000003ucW-3I6c;
	Wed, 26 Aug 2026 00:03:46 -0600
Message-ID: <122bf63b-1df3-4669-b9ce-d263d66ba419@w6rz.net>
Date: Tue, 25 Aug 2026 23:03:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/101] 7.1.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.986300899@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
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
X-Exim-ID: 1wz6ji-00000003ucW-3I6c
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:56854
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMkNqxXOdekotUi+2gQ1RHAqOmajB6UDcOJ7AOkinzZ6SH+V7Myp+S+SulIDRcpOL5F73GZqoqqQdqJCbgnl5ZXOUNH5NLBnebWVS9YaXydah59hoV7E
 pGDR6Kt/asUhyMg+dxTBG07d9iu2Kc7ju/+Qhzo4iFIgCvBje7G0tsnglPc6T3JZHflI7qtJHJxz6Q==

On 8/25/26 06:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.11 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

