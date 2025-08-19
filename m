Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D8122615
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 10:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755597875; cv=none; b=oTn8R+i2UMa0gcQcP9BOL6jbfoQJfu1ntRh9PbNzqdPdi/R+fPXjQUlmvlxaBC+wq0oiPsbkuworrfRNNBiGkIFibQSX49cGGC7tJRW0ZD5Box8URlUemZES8OYwh+MAGl9GcOG6uion2CPeJuzJ+vFv1XBTC3sROorl8QOkqEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755597875; c=relaxed/simple;
	bh=hlJs2knitb1lARST0gkSxsBtUoXWm4wfC8UP8JL7gsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lROFf1hZWjJSdqmu7YIz7Sw8jFHq2wSnL8ULQtd1SCc4ul/v6s/7F3ZNgomA4DZsUdUb+iEItXWFGbEWYoCNzx0S+UKZr/vTiBq+KZRHJkhN0D+RABbZt5JqaIlHJB0DS9oKnvyCwBAf3XD8hsT/yNSRG0rKk6KlmhW7pBuZmQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=RIEa/OVG; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="RIEa/OVG"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id oAhou4bCP1jt6oJCcuRDF4; Tue, 19 Aug 2025 10:04:26 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id oJCTu7hyXgahDoJCUuPMPy; Tue, 19 Aug 2025 10:04:18 +0000
X-Authority-Analysis: v=2.4 cv=faKty1QF c=1 sm=1 tr=0 ts=68a44c29
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Zx/jWLPsUjbk4SBooCzjauSYqfhONLohftEAL4RH0So=; b=RIEa/OVGX3YEwQhQ6D3CfSivHt
	pDUeKibg3N9gVpPdaYM/4Eju1KYB6VgXnWzbGxUwucKrOcccuEJNfySR7atHoUTMyZWYWf1jSiqg/
	S1idIOpSsRjQiygS/V3mWUsavxYe5nERf38TLuiW6lP9yRv5kuUInjldkrVud5r97tCzr3nSLWz4R
	nn744gG30mhz2q4IJdhmbo2N54V/gpj98MDVQFgQL/tTIMJ7dPIf53Sf75R/lXfz3k2GMdpK/SAzu
	ap4g7H8bRZWGBmZwdCkrVHAMq2ex4H/qreguWRuy8RHtfHA1fZbmtoWUSFNq5u9rA4gKzxOO3/hfE
	92pxYGZg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:33660 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uoJCL-00000001zF3-2rZe;
	Tue, 19 Aug 2025 04:04:09 -0600
Message-ID: <c3dcd0ff-beac-45f6-919c-9f58a7d65d7b@w6rz.net>
Date: Tue, 19 Aug 2025 03:04:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/570] 6.16.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250818124505.781598737@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
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
X-Exim-ID: 1uoJCL-00000001zF3-2rZe
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:33660
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLtF72Dt4M5dJwd9ASB8XCKAJoryXRJidCJemLBPYBTzu3iXHo+Xham5gzmQ1yjMu2ar7vIn+XMNKMWH4muoaAmGvQ8TkrRFklMslsAeMQ+GxAsXvxr0
 /0U00/1A/Ah29s9NMzO5zCRTVmg3g/W2n1IZfIa6m+QwhqP000EL2p3+9uBF24Ai0yt+PtCVxOY6Mg==

On 8/18/25 05:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.2 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Aug 2025 12:43:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

