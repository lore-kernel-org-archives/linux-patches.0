Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5EB35CB7C
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 23:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789341786; cv=none; b=bX6keR8YszEO5wylh6K4+pQY6nm2Bd68E+qo7o+8w6QroS7UTT7ZPHbTXred+Ruunhg+L5si5u4u5TxJ8XSyPgbFHIyHM0OsHJzBiyUtY5jxj8+tKTSa1FnR6hSKjlh7K7Xabbe8EfiLSZ5M6t1Qj/1BixkIl3GVOPCXxs28KQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789341786; c=relaxed/simple;
	bh=xR9kHmwMgJaYryLjOZQNdkKDOqFMedYucvMNh7ouLXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bRgQZ0fsAQeCrokMU4wQyKy3x2dvbf9d7fVQdArO8vukQPivwu12cCPxJNGTkNkF88dLNrzMnSUX+7pqsNkr4W/YVn1L7LRiQ+MBvmeW/hQxLJCPwPs2Abc2EH9x4ppiWYBWUMGU7PlsNxrCpxfNslkDaOlsJSNywgUrwNhGWc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=jWedjbPh; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="jWedjbPh"
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id 5mdaxqVfeusRS5tXMxDgZt; Sun, 13 Sep 2026 23:23:04 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 5tXLxlK519tXG5tXMxHu2B; Sun, 13 Sep 2026 23:23:04 +0000
X-Authority-Analysis: v=2.4 cv=KK1aDEFo c=1 sm=1 tr=0 ts=6aa73058
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=oEbuaIarpKgN_WPEZs8A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=QeNy8hv7ThVlnYexFoIH40DVtEg5575SXzN1P2E8jH4=; b=jWedjbPhlu2dRUqbfQZFVqVxNs
	XPIBzzXCrPkvuHJr2fU/Yq80WKBi4zP4fF27MfxcKghJlE25+YViPMb6XWQzJ8MCG0JZa1wIaA833
	zYJ+KSDyIyGm8d006yLKEXoLn27VN2DulDjPqw32V6DWLiLYreigQ6WgQhmPJQmQ2yfwxRFH+byff
	KExYWpSauu2LLjXwWeRUv9QFicDPMnaxgRE9mughIvo3H528xBBds7NkGuD6I4oUP8Lsmao7TqVxO
	DOxMQw0ivytmv/4MTv+Ba7lOk5X3cX7UBtVdlBbuUi2WMJUSGQMVHYA0IJWMZpSZvUaEPWMh747Td
	2Jt5OOJQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:38388 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100)
	(envelope-from <re@w6rz.net>)
	id 1x5tXL-00000002VTU-12ya;
	Sun, 13 Sep 2026 17:23:03 -0600
Message-ID: <b5b8a8d5-d713-4d47-9344-7a48ef423aa4@w6rz.net>
Date: Sun, 13 Sep 2026 16:23:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/935] 5.15.221-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065526.833703348@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
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
X-Exim-ID: 1x5tXL-00000002VTU-12ya
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:38388
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBPp5eUyHgGdH1lUfsS8RFhzfUqfCbYAtsyg6CK7P615ZUi+wKGxJPFC8LHnkvdD62nBYWjfw7a4lVQxKoyXZm54OeE98ssutzpN91NFFgtgCiEf43BZ
 MNYnXa+w8iSn2AjK0R6jECYHCsIqfWxXggU2qkRAHuRmpud74CRT8t+uTJfHBDi/OVesuyXI1fk3aA==

On 9/11/26 23:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.221 release.
> There are 935 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.221-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

