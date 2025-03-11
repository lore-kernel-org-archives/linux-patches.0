Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663AA231CB0
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 10:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741688366; cv=none; b=OZrmjKfpwkSRrhyf9jjkEpCVnvRwiHzyxp9LIXPVbHhRyEJXDGH0Corslz8HEdGQcumXwqqj7zSzrEk1oByQC1+oixg6durkOG1kH2wq9wujTzvDxeQ3V0kETDWLZTC+QH0gqtfntg2OfhSwYyNoK3WpKDcokPenNVl50SKgMbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741688366; c=relaxed/simple;
	bh=79qhmXbbTGpMFrXPo7q28fHNDo3c6ZvhTXXHWLU4bEw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tm/HZQcWEh5ZMHMYAnkgTNKHVbgH6IOCyY6KyJuWXCwA1T0wduYQE4elwLCpk28Vfqjm0d+eNrbr6JRWTH2eipCfZFYNlGqprTlh7hrxoae1Z1Qpg/UukvRkWTOJAD29Mb6VsUhj03li7SkFOXsvNYPCqGVSgokzl4Q6x4GZcS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=e6DEZLDh; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="e6DEZLDh"
Received: from eig-obgw-5009a.ext.cloudfilter.net ([10.0.29.176])
	by cmsmtp with ESMTPS
	id rgvTt44WbAfjwrwhntOQyx; Tue, 11 Mar 2025 10:19:24 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id rwhltGVYOpIRhrwhmtXLje; Tue, 11 Mar 2025 10:19:22 +0000
X-Authority-Analysis: v=2.4 cv=ONwh3zaB c=1 sm=1 tr=0 ts=67d00e2b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=TRiU9yirtu/jI1IpYly3+NIJknA+txu8Be0yyLNZ7RU=; b=e6DEZLDhqtQcPKkVxNfXmVY7Gx
	7qSQuRW1AnpvUbAbDNdsRIFj+qv8V/8Yag+adoHIHD2dtRf0WMB6v8vfSS0wE1tclcMLuVw8TdbKy
	1UZhz2xBPLhOX4M5Z9SZdSRv/h5mYG4Qaf7js2kJVRvdtY4sMJTrJuGQWaACVy/GXRfjC+R/4z9xV
	aGGN1BQ1U5cUvWelr/AxEa9k9MHw2AY8bm9NBJhylbkrZT2eqZMHpHfR8TXAYOyrYiOlxHcm8EnbD
	26FQkYEHNYd3SSCaAHtHXXxqrJ+nG08c6QSONeG0neCpbmt07VX3XnxtcDcU+IYLc31fvpS2ujflP
	QMP4DL4g==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:47726 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1trwhj-00000001YoV-2liw;
	Tue, 11 Mar 2025 04:19:19 -0600
Message-ID: <8f5a78ff-1c9d-4d33-884a-af231613398f@w6rz.net>
Date: Tue, 11 Mar 2025 03:19:16 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/109] 6.1.131-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250310170427.529761261@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
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
X-Exim-ID: 1trwhj-00000001YoV-2liw
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:47726
X-Source-Auth: re@w6rz.net
X-Email-Count: 55
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAm+0Yn0f0LBkOYC6AAcjc5f9BEJoOp3hQHTAHmDEWQCv+S/cOJlGbZ7fB+4Jo623T4ADmFrx6OfXkgKTEbI6XIdg5FjW9k5+D8Dg392xjxMnS9poDxv
 FZJjp98xTCegXrG3m1mCGerRyFNb9PZuZOUeHETkFNOWHMu0p4d9COfzvOwsrJomnzH6ZUzCIBTt6A==

On 3/10/25 10:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.131 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.131-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

