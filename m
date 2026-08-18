Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245C123EA8B
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 10:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787047636; cv=none; b=XodpGwY3xDB16dRnpfwrgz6GmrBL2XvWztTVrjU1mifcJFAm2dCI0oJvbWL5ExLluEmbuHBh0tpk+XXQgpSV6vSeC7f6SuJO7Z69l5/KnEuPdi81SxmdrhNaiJxgqE1ahiIfMJYFvWYDhw/d3CeE6xPIlnw4z5WucL10fEuZBps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787047636; c=relaxed/simple;
	bh=QFBckaYk9XqU5F9TE8XIrlBL4t8kCU/cH/emXb2z1mA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bBSKr0Sp1WCkQE8t6GIMV7RnE4lSdXM4lWE18kPdYJU7M7fS+FW5k+GrAm0hSzkOkwd+0RP3A8Ywse9T8fXKCKB3tLGmcKZkwrUyTNd58arJ21OVuYWllGi+JptA7uYvzO6WuG64nLcXDxyGWYlrJY51g+aYLBh3ZD2Gp/0Lf98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=gWibWY5H; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="gWibWY5H"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id w1czw6qTAv0ndwGhPw2pI8; Tue, 18 Aug 2026 10:05:39 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id wGhOwPD9ALQlXwGhOwaqgM; Tue, 18 Aug 2026 10:05:39 +0000
X-Authority-Analysis: v=2.4 cv=AeWxH2XG c=1 sm=1 tr=0 ts=6a842e73
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
	bh=8jKBAO/7BNap5iOtVDAuawwbhAJbBlRjBsfuCs4oyr0=; b=gWibWY5HK64BzEi3yt0LFOi64X
	imLuo7Ucsa63gZBqXoBDXipjk8QFvhyrYtsC7VPZTqmfIIOva1X9SbFWl8Df0hVzbqdR5SzAC/ezl
	i1jMa5cED3yqSDLYRWmqWUvxGGzwJVhekuKinTts6Di5XdEMdk8GX0HtpzTsr7lv1vLa7vPWUlSpK
	y9seQbAtCxIVrrxKiXRpo4W+X8sy18MrjUPEcVQutyvrtbt1gHhjWhqwStHYK/J4WoZle9zEJ4jw/
	BY8F63IebxwFq+OEbI8c7qeoxqFvSNzaXNUzgqwh7S8mwXcAu/LIW/kGMuaWD0xv9o8lgpXNpt219
	aoENSupg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:37848 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wwGhN-00000002I3R-3ojn;
	Tue, 18 Aug 2026 04:05:37 -0600
Message-ID: <5c9904f8-f43b-4fe2-b999-f7de1a506599@w6rz.net>
Date: Tue, 18 Aug 2026 03:05:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/156] 6.6.152-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132534.666299318@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
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
X-Exim-ID: 1wwGhN-00000002I3R-3ojn
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:37848
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJdrcsL/iZdfrdbcB7e0Gu463VJpy5lFTsIpDl+T1G3BPNnsZG4Ka0MI6G8FvjI7/dX+Aj1fnlIgHhNj/aTKWF/V/zkRxix5h3RKwSUwBYLxFKWawQcw
 uSI3KV4QbN2OzV4f7VEgUL/CvpX2fIBmCFRJiI+WBI5u9L7AgSSsW/jcOa9RN7WL44TevRw0pUVOWg==

On 8/17/26 06:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.152 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.152-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

