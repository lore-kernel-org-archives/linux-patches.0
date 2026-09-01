Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2028F449B1B
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 23:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788305196; cv=none; b=ZvFdQAPm1o6IM/EUZRNM+OHjG7F5yQCTXukfNy5slHtfVcy0EUJmY/Px8V8hY60+3PJJdLjAsC9wAq0GGoXBKGNZQdJARlJxBaNDL/uW0XF085KK86/2EV/BryXEq+wWDc0vp4kNAzhk1MDYSWhlIWd96SjFGOEhVj2SYyGjBvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788305196; c=relaxed/simple;
	bh=Ky3c96ErmVkuK1T/2yqja5kZLq0+dvSbCc9fIgGP8A8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N4PVZCGeNT58OLAyOnE8VXraKQK7uT9BUjcFVarlVM0X94IweenSUwYQmKQIX0xsYDuXmoDGaoNe5EQYP3WOLU2TL4ZNHCTS3EzqinpGIovZW4Xqv25or35cNznIEKbtS73DXRBEhjd+kNKLKhdenD/dsTTJzj3GkiuDgI/TlVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=4qTdjbod; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="4qTdjbod"
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id 1WHExBjX7v0nd1XsAx2ar4; Tue, 01 Sep 2026 23:26:34 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 1XsAxQfXe9tXG1XsAxfpdI; Tue, 01 Sep 2026 23:26:34 +0000
X-Authority-Analysis: v=2.4 cv=KK1aDEFo c=1 sm=1 tr=0 ts=6a975f2a
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=y2ERv7ko0hlTFnYyMTsA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jAfdZe60KbGrQDbe2CZwZmiZknj8gvjr4F/7lkjfOiI=; b=4qTdjbodObweod6/lzWr6WT/0W
	rtzWDMA9hHkokfxX/uiBRpli2wla1nLGzVKkAgI605KVKktfdNfRwKthwkB8bM1ZpZgYNPmn73Mhh
	HB5mCyR83fbt3SvMWPB6F5qj2ewm+KjUm1jsSGO+/IJ8b4x+vbTV50zqCpJeDmbqVhvJUUFRLd+Rp
	6qcsMbntvs9li5bwB4oT0lN0Wmn9qur048HrUN2SfueQ9Dw7Ab39XrNKfvSqRYmBN6SiRRKlhKA9p
	HHYNvXKnB5QG3Cr8L0wnQoXEQY5a2GlN3ACkFjmHNgt6v1octLRLY3t2jKJe5a/hAf7cD4106IDgv
	aqESi68g==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:54400 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1x1Xs9-00000002YK8-2i5h;
	Tue, 01 Sep 2026 17:26:33 -0600
Message-ID: <3cc3ca45-7c38-4be4-bdf6-0fd01026dfb9@w6rz.net>
Date: Tue, 1 Sep 2026 16:26:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/92] 6.1.187-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.482388899@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
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
X-Exim-ID: 1x1Xs9-00000002YK8-2i5h
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:54400
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJsO2GGBYPeZrrfPDaz0dSvmaV4FXzabgicWwqCsB1erzqUcYgPDMgjlhHgVHkb0IbdjPfirWUeptRqFIvv2SqG2RhozpPo4bzG6CHRKx6bPz6rZRTkg
 +4XOpXT9tVYMi96TBbiCtZanPNA5z8kKssnPHNngTOBiZJqcqkaODmGAubApGZfGw42QHwonHZ2DHw==

On 8/31/26 06:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.187 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.187-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

