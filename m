Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6677D227B94
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 09:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773394642; cv=none; b=XB04WNzUOiWAO+nGz0X/TdV1pRJdYOG6l3P9ckceT16eNtGV3CrUCJlcwT9qeXf775xOivYP8xSZ4aebaW56Tz1OycYBkz6ZPJJYnMYtTtDSPVrwPijD/m7s9CDonHUBBqJO0VYrreat+j5mLCXqq9IUasogg9qxVWynenIjXPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773394642; c=relaxed/simple;
	bh=8XVdrRwFFMeC9dFJaqM8oPsrui61kco+m1XcAVtxLXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o+ByBYzJI+aaWQ+bNzlXHIag9O20C7dqlUo3tG+m4gMCdeoNtsTgctwlyFXkhIcMOc/8WxeWJE7N9Hjjm72JrwVhw7iRUfCyoUEKlk+cMGkmbw4Bokdjjchr+HzdCLsAO4bD3fCmTyBquVexPa69s4qezfuTAHgcwn6rAa84qm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=z9LUrJeE; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="z9LUrJeE"
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id 0o4bwXsiPCxrG0yxMwvBAb; Fri, 13 Mar 2026 09:37:20 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 0yxKwTySocu110yxLwlMl7; Fri, 13 Mar 2026 09:37:19 +0000
X-Authority-Analysis: v=2.4 cv=bKYWIO+Z c=1 sm=1 tr=0 ts=69b3dacf
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10
 a=EGTM6zHwoJqTM8vi98cA:9 a=QEXdDO2ut3YA:10 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JC5kbKYzzY9hREHoxnstOrWsoE8p9+xtS+3usyPFrGg=; b=z9LUrJeEHd/Nz1y/fzNOhBcTCl
	v+qpghkfpxBZ98zeKEuASYZmI/SvJXa7FWeJlLxIFhJahEgYEHM6MOBK4wVvRswtlwh+g15FH/Vg+
	w9W3gXOZcaTjFEnUTuBYmnZEp3eyIq7nbytLpsM0ce/EuRysahj/sa4xgvUaFk0LKzaUDcBQYWhRh
	8zGfa7g05hEJd2cFpxNQ1xiekyXLqObYBwi6U3+WrF4rt1izALZJDVDWFXIKzc3v9Ohc+eHCK8Tao
	B6FiuUFpRRUL/SbxYm6eknO3I+pCBjJcFGU/8LAU+pu79GBGuaLNUEHjnHK+/ro2P8ecMPk2VkQH0
	UaQVlMZw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:56878 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w0yxK-00000000Rcz-2Kpo;
	Fri, 13 Mar 2026 03:37:18 -0600
Message-ID: <88e4edea-f204-4f06-b898-2995237fc823@w6rz.net>
Date: Fri, 13 Mar 2026 02:37:16 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: freeze during boot regression Re: [PATCH 6.12 000/265]
 6.12.77-rc1 review
To: "Barry K. Nathan" <barryn@pobox.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260312201018.128816016@linuxfoundation.org>
 <b4f58774-18d4-4a32-9c85-603f9e2c98fc@pobox.com>
 <ee851013-fec8-47f8-9863-392f17e54474@pobox.com>
 <2a313336-ccfc-42b7-a14d-c116733ef64a@w6rz.net>
 <1c54210a-e197-4eb9-88b5-2ed2589c7230@pobox.com>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <1c54210a-e197-4eb9-88b5-2ed2589c7230@pobox.com>
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
X-Exim-ID: 1w0yxK-00000000Rcz-2Kpo
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:56878
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPy6ARCsng2KjNg6lq/P6xlTWAfaWLgAyV/I6x9xvY7mwykblSmsI0GHVeoWx/UaElX7VcO56TklYqQu4i+AjJFVjx223hA17J6CAitmei2oYugcIWir
 39+V+0ZdJA8CN+VIvKTFwA9XOkgTvzIL0nI4NXpVJYcrKG6VlEgQAmWI7Bgqwy9g9UhWfTycvW+sRg==

On 3/13/26 01:05, Barry K. Nathan wrote:
> On 3/12/26 23:10, Ron Economos wrote:
>> Probably those sched/fair patches.
>
> Yes, after bisecting it turned out to be
> sched-fair-fix-eevdf-entity-placement-bug-causing-sc.patch
>
> Taking 6.12.77-rc1 and reverting both of the sched-fair patches
> results in a working kernel that boots consistently (which I am
> using now to send this email). 

Confirmed on RISC-V. Reverting "sched/fair: Fix lag clamp" commit b547745a2c78fd1cc1fdc6a0d1b05c884c05cec2 and "sched/fair: Fix 
EEVDF entity placement bug causing scheduling lag" commit f9891a33ba67ce40e5a17023d2f3a5e2b7d72ffd resolves the issue.

