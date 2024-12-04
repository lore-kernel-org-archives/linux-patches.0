Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37361E522
	for <patches@lists.linux.dev>; Wed,  4 Dec 2024 07:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733296257; cv=none; b=BCRqJ9dTakih6BhCkleAMLsdAfcAfRLNw6BF/A0irfGb3xZe/4hVg8dcl2Pj2GUvw1x6FcdYplw3lJrxvDx6DIpxr6WpP+sqJ+DdSBtY0o1N8JSg2DXRREDrMqshvJFQbmgh/zopHB5mWlSUJPT6eCZM2jPFzGNvOObU+lNt0gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733296257; c=relaxed/simple;
	bh=CC+MjCAkZzJLcoqvbXmhMHmEPLKO53R3HEjLtel5JEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qppM7aVlF0hUrHgxS3/pyXd+Z9gpJ4mlABLVZYv7NKwpaCzEJNsM7JAX1VOfgwJZFkL01x6N1nmuKa1J3PzFvOdrf4etcJcjXIirHFKj9qKwQgV2gC0pXbPVbxp5J0TMADIijZSfAtYfCrHujhlIKs7iuUXboy8Oed1mOd66+7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=AXIcT3Rg; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="AXIcT3Rg"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id IjMktJiWjnNFGIjVet2Umr; Wed, 04 Dec 2024 07:09:18 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id IjVctyzZx827nIjVdtilHE; Wed, 04 Dec 2024 07:09:17 +0000
X-Authority-Analysis: v=2.4 cv=GeTcnhXL c=1 sm=1 tr=0 ts=6750001d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RZcAm9yDv7YA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Q5_8b3TqwLNI1KgPcvkA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=zUG+b8RpCONyYnfAip3HiV/DqliaNHNjvaQcav8VtMY=; b=AXIcT3RgIUnKrMfyc1ZBl5ejV1
	jTd8fJZZz/Iv5r0XBPvkH3ValuZhN+rok+XtjoKE4qMsZHp6hkM96qRVUSS0rhS/jG2P0KtykC3Uc
	xcJvvXU5A0tWafCG4Myt/z7eowDjjV55nMcGR/hEEvPvtF8L2+wBeppFCnLJlH0hzqSMAeTaEIHTe
	LBvu1f1khS46pinLxLY1Moy4NaqNH6sD8XmcHUsO7osdsTyJsBOURc8DZwiRZkLGWzzXiJVsSVESg
	N/YOXZ3Ex3O4V+xdZE9+F+/QVoUj+imvCD12+CGh7eqFnd9aVBex97V3QXD/TQ5b6uU162TTw6APZ
	1743c/eA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:33898 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tIjVb-004BFI-2T;
	Wed, 04 Dec 2024 00:09:15 -0700
Message-ID: <c363a831-83d2-4901-b38a-67cd7a9fde77@w6rz.net>
Date: Tue, 3 Dec 2024 23:09:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/826] 6.12.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241203144743.428732212@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
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
X-Exim-ID: 1tIjVb-004BFI-2T
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:33898
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFQo7fLW9veADbdRESpCq443zFTp+KL2nuhqCCdlPsldo+koPQntOeylmGDyF17LAd8I+o1FlX5UACl7Fru7fpv1ROQdbmtDW8+q0Lsaos0Qj5/WVxkp
 9Q0yMwAmsmlQoYjqoLcwBHYSTprE3ZaNoP+GnX8bhlK39MoYeLo+trHlIZYIyliqbSJxiFId9Q6bMg==

On 12/3/24 06:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.2 release.
> There are 826 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 05 Dec 2024 14:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

