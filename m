Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C919E849C
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 07:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748935379; cv=none; b=CXym4ivCncgctmhFTm6ONlQ6vuZGmKFvOgc4XGeWHzPT3MB5Q0N4dzOMYBXVV3U6A7+dt9R0VtXzUGOvd8uhL1MMM1WanOwwCedou1Fz/a+oLrbgZuyYjTX5sWbdY3Y9vzo1bVRleoGypOzR3SKrXPzD38YKKBko6blYcnysoZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748935379; c=relaxed/simple;
	bh=kMedSjh4qD7sCMhw/GVSZeXZFdA97A2UdCNKFWFSQdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tatCSuWpfKyp2zgSOh4By5xsTeJMdnDBj3aKT1j5bofbFynPBZdE4U7gfOAD9DPKW1PMZW3f1QLj8j4LxMlOgLCeMosCq4qlSaLQfz78a+3utmyb85jn3+G54Fnoaa7D3OnOUhi4k9t4jpkdnF3++FuqwLEyi5KtH3SN+KAunvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Wfwkc2aN; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Wfwkc2aN"
Received: from eig-obgw-6008a.ext.cloudfilter.net ([10.0.30.227])
	by cmsmtp with ESMTPS
	id MKDruwN76iuzSMLz5utgGx; Tue, 03 Jun 2025 07:22:55 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id MLz4u0hdDDd4SMLz4unQb2; Tue, 03 Jun 2025 07:22:55 +0000
X-Authority-Analysis: v=2.4 cv=CZUO5qrl c=1 sm=1 tr=0 ts=683ea2cf
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MubuTtp0basKrZJvMoE6HA4DEOw3MB294adiixRNLzw=; b=Wfwkc2aNIdZ+IOd/S2XjUim0NU
	jgT6A1/WfhzRjTgcmi9qGh/TVirraxb0RdNr5uzypv5CXmyCa+VKdBn+6XviKoial0N41vMvHDaCr
	pJiBgA0Hn15y77YUSd1XzB+821bFayrPXAiPUGcLlVx74Vn5RKHEdckrhLJhLIbWuiI2nIasF93dR
	isD8cfpwqy4nh7rshMXh4hrSRGBRb8Uxzg2p+1HZZuufCFEDR0IGwXRLFRbk3EAYoZ7jpf6zNi1Xg
	mw/rZ3pbb75ZKmJSKbzSzkWRr/lLB4g0tficwgtZysZ3EbrErmpeIXYxbqD+FH6bCeHR4fySPtx9O
	WciWZkpA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:43432 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uMLz2-00000002N7i-2ZAx;
	Tue, 03 Jun 2025 01:22:52 -0600
Message-ID: <35b44054-7d47-4db8-b573-7e945dc052f1@w6rz.net>
Date: Tue, 3 Jun 2025 00:22:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 00/49] 6.15.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134237.940995114@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1uMLz2-00000002N7i-2ZAx
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:43432
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFvh66cJroF/LrCL4bIICW6hVCQ4uDKx6BZQ5QJ1y7Sw/Ai91LpFt08Kf185o44wmE7uqFAA7bsK48YjCNa88O8rA6OgDQ+h8AAW1Vrp6M9yyuumzCoq
 qQ7UJCwCQM7weeH5DrOVgk8pYHSp0TV3PhrLfmtSIpmfXi3P02IBMpJw9oyvWahS0fbTmOKnzRqjbg==

On 6/2/25 06:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

