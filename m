Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC861B6D14
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 14:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738332303; cv=none; b=t9qaqla3NWQ9FIS3R4ElILlA0VuocexRoVK02K4ivFV5lHS+Q4lHhI7IFrZYHmBCt/1hSIrXtPAqKTfbPv34tlHiwf27hbaL4bASlbCmhYkwkJ90N9UAZ3O29CWCOiE+IwDAh7vJp3vu3E23Rwcm4h/aWBkX7AdEd8/G80QpQSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738332303; c=relaxed/simple;
	bh=h2nJTg4+mFrqi7EKmH+vkp6tINkKplVirc+FceWWcAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VOr+6j75BIUZYO6hAGfKeIddQB3UAy+sBtl5xPyeNRk+55Q/WZ4YIlSUYEnSu6oC6afU/5Qaltoj6h2Oflje7n0q/j0uOBHzTTmE0cRQj9l3fRxG9srk86ixEWVKfzPjRuu/JwUiLCbdUBvnFbFRKY0LwGETUb1U02zHIT2AFW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=kEYt6DPT; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="kEYt6DPT"
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
	by cmsmtp with ESMTPS
	id dplGtkxXVAfjwdrdltQYgE; Fri, 31 Jan 2025 14:05:01 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id drdktPSKwp6oLdrdkt4YGb; Fri, 31 Jan 2025 14:05:00 +0000
X-Authority-Analysis: v=2.4 cv=ANS2oedo c=1 sm=1 tr=0 ts=679cd88d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdSt8ZQiCzkA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Zh1W6WffNNBMdkN8ln4A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MXjjPkOeD3dHk3jj1JswXbDQV12qv9i0c/h4Aa5O2xA=; b=kEYt6DPTNaXf3E0YgEGX8RSkqg
	LX/TisN7iYvGPHmJdEXXRW4M+3k6nMZA6Ygp55POIicyuSJu6lIUq4OUQksbx5H63Bh/wF60cEPS/
	tfBd1EG8uq9R0Io8qTrcamKcCD50AbRJiiXbcmtFvYSn/bmFTvaYhZKImdjj/QztI78hR0IT1gPw/
	tuPl33eBtsa1qN/Rk0yVE5QZ+MCgHnXNnVHLKEo88rktiC/KnCjI6RO3fpsNrqXH9c/8PyRDlJeBo
	9aRXV6b3rzboqkZ8ZhOgIGZOZ3Qcr32nbyc27/3c5e4FD8hYwp9G/y1zZIEq+FshG9n0NYLIuIngq
	SVQD2oIQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:51690 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tdrdj-00195U-1q;
	Fri, 31 Jan 2025 07:04:59 -0700
Message-ID: <7857e37c-5aad-478b-8501-d98c4dfa6d21@w6rz.net>
Date: Fri, 31 Jan 2025 06:04:56 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/24] 5.15.178-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130140127.295114276@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
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
X-Exim-ID: 1tdrdj-00195U-1q
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:51690
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBGOZ1Z7P4RmNNDrXm1Ae/aYKgYP6XAlbFNtORsBvJK2hWc1yhY5fS5qMK/8gqrPwsRYbs9RQ0U+7PZsgkiXx8Yk97Ga+F08miGIZ2vqcIAFdBw8zFXi
 UwPr4hYwRm6kreFW/AD4tG/PFJ5aDAmbswUalhEcGJ++bzQSvPYdDjsyLpS1mrCNgjuR9khaz+hh7A==

On 1/30/25 06:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.178 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Feb 2025 14:01:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.178-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

