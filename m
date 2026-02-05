Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90DF35CBAA
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 07:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770277313; cv=none; b=N+lLcGW7yHxoT2kzWUPaTIOpjrTo33NMFCn3yA+KwqCkEA7ISn1adTy+XQit2NRsHclz07l6qdP8Xg6mrs1RPagu5cSfkxb1fK/3bLEyRUyOkJRNHR8KMO4aeagQCmpZJjPDWNa8ibVgPAw9sDhMghkoOZ0wvugcb81gG1FJ0uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770277313; c=relaxed/simple;
	bh=QpIu450gDkb5LqZzk0B4ZxA0onIbfsNNT1Zv/8dHlGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XnYzJ6DeEKHBFI0aKpDwdLhpRevkuzoHQJw0s5lcdhU+e1TfA9bY7ZZPYttzVCN2biYZtzkgrj4XBMkk88VBxL9hWtVbO/h6cRMh9Me4KiMANAXagnEETGe7AKIeNAhcok2YqN2LuI3NHJbi9Cy95j5LoQlfhFQE1UenAqxR2Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=YniuS1lA; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="YniuS1lA"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id nryAvqF97KXDJntyKvPhNQ; Thu, 05 Feb 2026 07:40:16 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ntyJvZiDcV6WMntyKv85tY; Thu, 05 Feb 2026 07:40:16 +0000
X-Authority-Analysis: v=2.4 cv=E//Npbdl c=1 sm=1 tr=0 ts=69844960
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
	bh=mffm0K5ps4TOhLLfL6X1BiG6SInYD1qk8h3luZIp/pA=; b=YniuS1lAlOYYbjMRQma/VPqTmK
	kdgMjaEYzYq46ehFM19ZSpSLHUB3mJFfewUIVaBGbAq5f2YXEdyXfKZLUYQBVhpbn7oiewC+/lGNg
	BZ+N+6DRvevl9eBGsreNriDsGFH2rDVDsvyI147BlPg2xe9CcJbg6DPi2oSqu3TpPZiZ2otqcwGXG
	GW54PqiDCmoOmoqSBkb72oTjpl1wjU4m3o/u9ePPqpZQSZD5V4h8W8hrNf91mEREq9KNZStH72oE5
	m1tpJKisksPK6CYi47k6NCmGKg4C0x6sPb4Yzj2QDCPiInyWsfkNzbezJOvAHr1aWDw5XYYkiQy+B
	pbeZouQQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:52574 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vntyJ-00000004HTV-1md6;
	Thu, 05 Feb 2026 00:40:15 -0700
Message-ID: <03a3ccf5-5682-43a8-bfd3-24bd71d3dc3a@w6rz.net>
Date: Wed, 4 Feb 2026 23:40:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/87] 6.12.69-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260204143846.906385641@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
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
X-Exim-ID: 1vntyJ-00000004HTV-1md6
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:52574
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNTDkOXq+Fn+BwjLqmG4exNiLzJIaldOxuzucgJ+abKCIgn9s6f6GlKrW947samNCXwcKGuEu+XDejptCPJEVhPVST0aGPTkgD5BZxcP6D+76WPk/F0s
 qMwMe9tMeFkyn9e2xkFoYzEMAQMzgkFQxIve6IIYA0sUSiDym7cRGfoVfXQUfb4PQ3s0lrlqXEnJhQ==

On 2/4/26 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.69 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.69-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

