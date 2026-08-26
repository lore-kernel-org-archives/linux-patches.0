Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776232066DE
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 06:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787724545; cv=none; b=shJ7oixcPadsVIf9N6e+oNL/3uOqpn5yw/DS0Q1qpldNdaMq1KzIArQfMa2TneH64ZThwocQgQn5yVrbLTGRhG0diJAYpHGHhoN/y/CLTfttW31fiNTUBcYg3GmFi0cwspdrbyEbMyeFRCku3Pl5fCN88HTtYl7zuqqCBsUDlhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787724545; c=relaxed/simple;
	bh=XigFeq7j0xkTZBUpyS+Rq6nDMzEwzkxaoc4pifaTyyA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ozLjCoo66NkR6nX3wVd9x7GDauT8/zhKRT+UBXOeH1PdmKvEJ9OpMxmHg2xi9CGrv470Alf7najl3afsdcDxNVzyJ4OZoqhPhlB1hXzVReUPzeGf1W2N+AcJcmNjMpKYxJ5uQAZAHfET6mXq1Z9qItc/M8thW4PLuHlZ2PwCTM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Bzwnw3nE; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Bzwnw3nE"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id z3aRwj78gv0ndz6oqwA1mj; Wed, 26 Aug 2026 06:09:04 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id z6opwIfGpiutHz6opwqfL7; Wed, 26 Aug 2026 06:09:03 +0000
X-Authority-Analysis: v=2.4 cv=AYuxH2XG c=1 sm=1 tr=0 ts=6a8e82ff
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=60u_ompe4jvr-0JMN7sA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=yGf1jX0GEGUVudkZ+HoRisRu+oXf2kSCb1HCf2ly54k=; b=Bzwnw3nEINvzNpNS+46ugV1V3S
	lrbs72oLUyNAZm8ESTH9BZYbFq+PapJUpftUz6IFlt1VReQNiQiYZl0RqG8Pz9ALgKZGdbBkN0m3L
	BmAoZggEJn/n1eI+K6jYDC1WhJfGh549tD+y5GfgVAlEWtdHnF1P864RDxWSEIFwNZocyTYC+VbXh
	gxd5BHeiXfQwwaSFMF7aD4OXFVN/ZifdJ4WVsw8v0mfKbIgZ1nxDuL7xshQ9IjFsCrvo6v+XSE4lb
	FCq4ja0Wwi+0IzQvJ1NBkbOtm68yOH37CD8u4W4XX4efITFmfCWig7ao4vEalDFp9f5/ODAXd9+5n
	pVFc36fQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:53274 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wz6oo-000000040mb-2rkx;
	Wed, 26 Aug 2026 00:09:02 -0600
Message-ID: <405fc403-c7fb-47bd-ad07-daa9f2b1a099@w6rz.net>
Date: Tue, 25 Aug 2026 23:09:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/94] 6.18.47-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.887883084@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
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
X-Exim-ID: 1wz6oo-000000040mb-2rkx
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:53274
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNkrJ7zIn12WQvKVowD5xkIcEdLF9CAveiTQnZkbcxpQjb6OyouiT1mAom1dS+XvHHv7g2qwU2AWdMZeAwbjr9aJ2S0Nony4nNJAhWecoJkHanM9NIH2
 OgNDiItZGE0zEuWnvx0vaSh1GPxmSMmb6PMZZ85PJLrQmskaX2qvgwdzMo+q7/C/6yX5P1EOiYyKrg==

On 8/25/26 06:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.47 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.47-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

