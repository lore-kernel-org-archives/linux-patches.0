Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9AA32E14F
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 07:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770276882; cv=none; b=RIjSfEVVZdZOpTLOw+yNecnYGl4vNx8SMiV6+AxMZTChJJ7RtO8idALNhbyASL2zN9wkgjAR5yqcHkaxQBzdHRGBYpE33bI9Y+LzL/z1LnFmei6tXMjZO9k/NZKxGss5+56NNdGDv0YJTkfKwpLiHCdALoAf42NKaqqxsU/beck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770276882; c=relaxed/simple;
	bh=0zjVYBoQPtQ1txu5iltn5GIOXQfuwncEJMvjBs8PUrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bwCx0uzDPtZWmVY3YM1RR2yjbnRElkRWevdHSlIB49pgtPkEn/GXCbRyKaRRCAEFA7PbCpglV5GhOwEc2V7JgZ1DPInq77ctCt33bSMEpLYQFiGkBWr9Wo/EeqyzA7qp8XWHkn2OHdsatqEB0l6+yPr5jdEng+IrQfc1lGtqjoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=PT0cKKWN; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="PT0cKKWN"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id nrTIvuz0qKjfontsqvaI5x; Thu, 05 Feb 2026 07:34:36 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ntspvZcZzV6WMntsqv816o; Thu, 05 Feb 2026 07:34:36 +0000
X-Authority-Analysis: v=2.4 cv=E//Npbdl c=1 sm=1 tr=0 ts=6984480c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qDPJzqd3ahirEYLJiIkMdaPwf95xn2ZVT+tPnLRxOKY=; b=PT0cKKWNZGjZpLdtHTHQJy8ZPL
	5FRY6iPSNA70j3vxwKueoIb9wctFDtmL/beBDMr8cvWr+wsPR9pv60WaOVr820tctlzVt5lelj4u3
	TeWlLx1MoZ9C5grmdx6hXoGc7tpHpo1hBrXq4SmtpN14xa1UdjwiWclKKz/9LIjWy1qJIGXIylf3p
	sqeIZBpOC25YbKRjsrPMFQRpEeGEgIbTe5VQH0cRvtnNbxIl8LcaA5xQO2xKIbj9x4GbxIrQyWmll
	PK3Q1inmznFM3qSgHQetDfZfjsipZ6letjkSHmL76mf2KfmMEL/36Zsjdj9jQ3VHFX/NHLKZW0PF0
	05BKD2cQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:33456 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vntsp-00000004FEH-1St5;
	Thu, 05 Feb 2026 00:34:35 -0700
Message-ID: <0ba223e1-04e7-4374-9d62-643b3b43ed70@w6rz.net>
Date: Wed, 4 Feb 2026 23:34:33 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/122] 6.18.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260204143851.857060534@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
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
X-Exim-ID: 1vntsp-00000004FEH-1St5
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:33456
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFOx1HCYSAV8P8PHp3kZTEw9RNUyjqYTQdtiBmiKNCSsXmz018lQLyfZ+tHJ8KVOzLM/YJZKYPBRr7+puoyU8upo/7iiX7q0G6BZ4YkeOQauRS63ZjMW
 V6sOPafcx46O+UjQBEOFAx3CsZhyptGwX4KZlOtBB5Mh4vmVKqhuDOuHM21tFfxYKQd7Kv6VUjNaYw==

On 2/4/26 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.9 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

