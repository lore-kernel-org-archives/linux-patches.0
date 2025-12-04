Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8252FF142
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 10:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764844129; cv=none; b=gKxhP+XnxYq+I87CCGFOUniuPU8bmCqcWF9Z/gcIdpAi2e6Pn5mcVTup0rjfbs43qczEjjiwll8n+7rW1PT3Ubf4RdVvT8iObzZIFHLHxiRD/MgNgml8IqUyFW/I/7dITpUIrnvkMxuzBB86sO2lsO9uPfg4XD5qHhVgyvOh3PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764844129; c=relaxed/simple;
	bh=r+6AWt77fcDf6gqoDqDOFOrjB7sihLKMHX8TUNUIZlc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VyuMkl6PEfYUwEPBdihcrHx/3HRcRXlXNKKEswKBLhrAjHf6Ci02N+1m9LkkuzUQSo4uEQYD4bkIdQpEPgG2jd+5wtF4UmlMW1ZBllgxcwEB0e6KNB4FWcREEWaza+9N4vb3VsJHIX4T7WJEI3mbtHkQSS6VairgtpXS9ZNMrVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=3ulW9f+P; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="3ulW9f+P"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id R3XNvwulaVCBNR6YJvArDY; Thu, 04 Dec 2025 10:27:11 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id R6YIvzmj8h8QWR6YJvQBwt; Thu, 04 Dec 2025 10:27:11 +0000
X-Authority-Analysis: v=2.4 cv=Mcdsu4/f c=1 sm=1 tr=0 ts=693161ff
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
	bh=J0gk378wmRlM6jpbPcKmXR3sdiw8XWzMuTan+A06LyY=; b=3ulW9f+PHE6iasf5DLvMDxjmli
	lHBbcw5XtOyB3qNUH/oxzs8DNrSA8GYP8hqK1HfclQwbtM7PhnnekvjeCUSK4sAZI+vI5u2+A7XtU
	XWg1shAqqFalPfoG7fdz3ZXcJV0poWoGer0pAD1tmGLdhKXlDay3ejWW5GzVQU4OjZviIS8xTuICt
	5GTQCfVBZgh9/BAfU5HRj90Ae+qlw+1bFfZcIce6zz/htoN8QRTtnjtVTZbV7h/kURRaB5Zu/EoF5
	joqpq9U3XVgB6CHJ9LoxBIiixmjKjHdu0nfn8NhkX71EkEA8NIuvMSYNUvHBqmOzWuXkqMn2zgO6A
	2ik6Wqqg==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:36244 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vR6YI-00000001Tar-1u9M;
	Thu, 04 Dec 2025 03:27:10 -0700
Message-ID: <c04a92b1-75d5-4fba-91e1-ecf27cae6c44@w6rz.net>
Date: Thu, 4 Dec 2025 02:27:08 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/146] 6.17.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251203152346.456176474@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
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
X-Exim-ID: 1vR6YI-00000001Tar-1u9M
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:36244
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIqnxk2X7pKPTdVMPXjL0k6p/vRt23pZAvd0/ThEKhazZfDyvD1WUECozE5MDgg9RiZU/1xD1yLx9PJjD742d9/xe5WQKRz6jo0L8HIMyK3599Tb8FAs
 GeFnHYV4M/LcN6aQqmWMofOOt51Tw+/bXKBZadz+3b2XVJj90FS94g6ZHbB/VNIgEVfF4ix/O2cIXA==

On 12/3/25 07:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.11 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

