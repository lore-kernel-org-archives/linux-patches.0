Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EED53DDB15
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 06:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792391523; cv=none; b=dYkbggXC2Wf2PhV1uX56lCP68xdSzzfqE2s/IntQdJGbygaohik8sp2mnDq/vEJ60tjrOLH+9n+csKEa6QGXEn9ZpXNS5Ihukf6xguPJui4VtUekEtB6pzEbt4GOJ7gNCbrb2td2qgwniH3NAuFBi4AKJff3rRSSB6qGDG3BYto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792391523; c=relaxed/simple;
	bh=eNa4aBeBuCHOvTppFnIoPlE6btJZy6pC3WpVF0OnK44=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h/9fL+ukuPyZJsiK2joXp1sknnuxh+6r7vlgQpchMJdxV1lVIwgJXFJFxQJ13RqFvn9/3y17pJHFFiiRwRPP/kKecjeuS2NaRpVWOhaSLoni+Yu8GQexkTggRqKKXVZFWPH4imu9lpaCeYypAYP9iTDajva6SPsdfv6tFIPDgiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=osvsUn6z; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="osvsUn6z"
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id IJ08xbgmtc3XsIgufxWUJ8; Mon, 19 Oct 2026 06:32:01 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id IguexUVPMQr2oIguexj2ry; Mon, 19 Oct 2026 06:32:00 +0000
X-Authority-Analysis: v=2.4 cv=C67pyRP+ c=1 sm=1 tr=0 ts=6ad5b960
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=fSA-YJl1BVv2D8DOKtkA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=WPNHJ8FMLPIOlx4AXqkpB/QRw20QCcPhM5TvqnekKM0=; b=osvsUn6zGY497yw519csEqGqRC
	M9yKA1jnGUvUkG8z1Ak5dnTiBcZyhd61NcO59hu2DIH6Pm5Zc85XIMIl+FCMV5wXePUJCDL0kYu4S
	OyqWBX+EE7k9baoEV5b2SNNQ4dbnlarkoY/MBMfL2yIy4nHiP6k7dH2ukkLAzsh2nQvayNvr2Vn+I
	T5DQRBgJrdUwOz/m5m7LkrqkOozr9Y+e+/Z7dDND7bg72R+Fc42kzcZfIQrtDdiRDGxrxY38l3x1Q
	n39afU6qmqGsHIRlnQH3hfBDvbjsFZg1WSTQ2j6ZoKfQBt9hyOwVMdNuvqmXjphOXddmQ1y4Sjex7
	V0kuzD2g==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:37342 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xIgud-00000002xDU-32id;
	Mon, 19 Oct 2026 00:31:59 -0600
Message-ID: <98dbcecd-deb1-44dd-b2ee-8ac57d2a2fd2@w6rz.net>
Date: Sun, 18 Oct 2026 23:31:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/52] 6.18.58-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261017155104.830766652@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
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
X-Exim-ID: 1xIgud-00000002xDU-32id
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:37342
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPQhUuqgDWO7850h53xQBIVDNx0AFZ2QZewkfJj8S2IumUSYeKiyBWFNcorGNKaqt6Ox42D5biWIdgP9dRVyWW6kouoxSTPyq1hY5Mp1YlVvOpn76pz4
 kP2Jeq1hlydLF1CP5dCW2+F2A/zPDw2vduv/c23jGzz++YM49TxA7X4KJsQKTZ2Nm1r5q6BUD3F46A==

On 10/17/26 08:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.58 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 19 Oct 2026 15:50:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

