Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71E33B637E
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 10:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787048344; cv=none; b=Tb2CLmjTzHpNlYAQF/ISvnKQAY+OVG/SZfsz+t6HOoa7qAOevKsFSuR9ozrLQRkl3Lvjw5W/KIwvcAOEFK55UvR91G2yNoidHlX7v+Tjpk/4S5SALZmPl3L6XQzp1T/ImqUyfVz/6Ls6Pv1MUPuV1NNN81fU/6AwtXReqCStCYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787048344; c=relaxed/simple;
	bh=0TlEoSYHKI4S/s3MxpnfpzgbB+tTwda8gUtINvvqdK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sDTwd5hf1kwuTzwE/T5jT5aJPQKuEdXsgRIrKdL/okOhP32i1bHkErQATBFLuwquz+xPD2H20m5xErk+mSdReo/INZ62u6/pgDbzG43a0pqbRSz1rA/bRsgRTM4kxsmkcEL1QoIbwlMpQL1CmhxZ+t1A9fOoe7nFBIO6nTQFGUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=pdtjAmnT; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="pdtjAmnT"
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id wESxwKLTpuFzgwGuLw1EGU; Tue, 18 Aug 2026 10:19:01 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id wGuKwEFyYWDCxwGuKwfJLm; Tue, 18 Aug 2026 10:19:00 +0000
X-Authority-Analysis: v=2.4 cv=Qpte3Uyd c=1 sm=1 tr=0 ts=6a843194
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=zhJSSY/EK6kgEJflgRaTcp6LU1SosJn9L7Gn7NFlMOo=; b=pdtjAmnTAMTiWIhQ+mrRQDaiCC
	+prDXrrgosyYfJXY/zXhB5NjK7Xeoj1EIvYePeIC16roDpYGOfBkyhsK864uC4x9jid8Ss9TaFFc/
	oC7d1hmbG2KHmPUuD0XsVhTkl0TiZoKaaIyIN8FebE0+Gj3nmIqQxl1JdhXD3HYMeqErDm9EngWii
	4rhcaKAszC8AEVtUAoU4572LtX9HT3oOxdjmxDUQTxKCNLf2UOZtL3MnJ22YIZjjFpA8IY7mo4dbi
	w4J6P5x0rG0F94yknX5kB/nZgj/YwuVL02rYqjUnKatumhP2nlvbHM/+qT3UIMQpikhcQKGWphqYE
	X12OZDvQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:53860 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wwGuJ-00000002Pkg-39QR;
	Tue, 18 Aug 2026 04:18:59 -0600
Message-ID: <f7d9d51b-db72-4ea8-8f20-40a935ec34b5@w6rz.net>
Date: Tue, 18 Aug 2026 03:18:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/456] 5.15.216-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132539.792407575@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
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
X-Exim-ID: 1wwGuJ-00000002Pkg-39QR
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:53860
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDfGhGqphgX14TRbW/ed9pLSFBOSCQRNOALQ/vAUytDdCRjoeZBHkgyXDGV7MxwgCxRvGC5LwicPQfn8x/2lRXPslwZLZVgVrJwgmneHwdGQxY2Y/3kl
 NVlntTk/+0n8JOif1fizedhv0P6BFH98y7vQklvkLyct1p4LMTJpVx/rhVn0/dattZGSoMqGc6EIuQ==

On 8/17/26 06:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.216 release.
> There are 456 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.216-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

