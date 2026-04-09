Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2F638C2A2
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 08:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775721827; cv=none; b=T7I9BwyZ10peFXvjp6dR9wqK59vwyfq0IgX2zC3han+kU7fTrEFDwFSlM+/Mdi78b8J33GY0MehQ7EYpI57vvapdIbsHY6JTTai/fQaQ9XgqJGmF+G/Wy83089Sn0yBT8R3QT2R6FFXGE3jrWLaumNk9Hcp+N0PHF+l1rwSn9v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775721827; c=relaxed/simple;
	bh=jjbR/eoGb6f2E8yA8XOOOY6CbY9c9VChAD3bZ4+SiU4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QrK6jjacSJpw17gBqHW2dhCBXzadziNMuCAa2Y9O7/WCQNwKmZpCSRFd6JnnpVkBi8GKB97vt4MBoSa72aM5WjPU43NmxGQrBBwiSakB1t72KyzEgkIyIDUlHVHiHMkCDXy6lmWqs1+8CU60QRM1N481Ls6WzBZMOs4Yt3GiTgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ANVIOUHx; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ANVIOUHx"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id AVhWwE5Mt4RkpAkMUwbklg; Thu, 09 Apr 2026 08:03:39 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id AkMUwNaQDwWe6AkMUwVjb4; Thu, 09 Apr 2026 08:03:38 +0000
X-Authority-Analysis: v=2.4 cv=RfSQC0tv c=1 sm=1 tr=0 ts=69d75d5a
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=IwEcxYCC5tnkj01rLLM4Z0rnCw3GY/uODcAOW/UBs6k=; b=ANVIOUHx4G0iEi4Who14L9RYrH
	BBZfAghsKfknIj+M+8dlETTlvPqtB4Y68Hy5AnoFhlCg9HVax+Ny3s+UeJMknDVgBedaiO5Uc0vFb
	CIyjVbk2isWgCrdx0fWjD/zjLVJba7O8JIqQHjzsk7XDnmHSu8TfidNc5uuq+atu2Bzh60wtHlLQv
	cfqUJkwrjd8HgcR2F/F1lkoLroTl0R48TVrbkI6Dnio0QqOU9n5mr82StaeaQdR+KvjvbgnxhXAdy
	PACEsb6yUscupZARvnXhopROQbt2Yh+s2trjDnBozIID1tUTImIrNK1UK7proW+yNe1LczgAitZDT
	jsfdSmew==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:37620 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1wAkMT-00000001xIl-21zx;
	Thu, 09 Apr 2026 02:03:37 -0600
Message-ID: <b77f7cde-8a8c-4bdb-b886-a675a82015ef@w6rz.net>
Date: Thu, 9 Apr 2026 01:03:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/311] 6.19.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260408175939.393281918@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
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
X-Exim-ID: 1wAkMT-00000001xIl-21zx
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:37620
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAZlni4ffOrzVAhi2Gw9gK1W+n7kJz2z2D5DgKseZRDV05DFVBtzJK4YxUvJJbDUTMiKeBCBxPwCrg59IMkiKJrUC/Tu/MPHrE3jb8s0j0Eq94a+wSAy
 8TCycSZ2TnYnb3icGutvLTOYX5pmAsc47SqPcEZAxlJqXWibIBcx53oIPSShbr8Tbe8Ac0wpbonRcQ==

On 4/8/26 11:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.12 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

