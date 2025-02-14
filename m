Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC39922071
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 06:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739514339; cv=none; b=n/L7+wHPEMeerUpNp5QCK2H5b4pla8I95Qs0ZZWe04e2CEF40QX0AjDlE9fcnOmqVPdDlhmMvKe7/gnTqKFQe1bmUNm2+MgzA0mO2P23/nIwXKEhojuDZl+yXvI9I13HRrCUZVPjV0LusdfPzgQXQBfdhCeJpgJPYEQkYYefOZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739514339; c=relaxed/simple;
	bh=+NE6MU5T3q/y4ouBVcZwZAIkaVZ6laDjR94bKZxqX6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f69uz1H2PPZhM8SLAKIBX2Jz5rJWlvE2CRnyQu/7/f7xqLr/ZxMr35PyWYv0ibfLVTGHwHiE2NrOHhrNtBmqOfYOpIPUmNz72sWnY/XHsHIYCxVLklm62lCJfq5C947dNIYsUYFLdYHGWD0mFrxHOmU512W9lK9K+Bqj+wbjrfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=NAc2NFl9; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="NAc2NFl9"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id ip5StoS21METlip8rtXk17; Fri, 14 Feb 2025 06:25:37 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ip8qt6Sng1aw3ip8qtR2nY; Fri, 14 Feb 2025 06:25:36 +0000
X-Authority-Analysis: v=2.4 cv=aeZnnwot c=1 sm=1 tr=0 ts=67aee1e0
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=4041MwwcWqwrnTXoSgMA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kBZdlEL6DkXfhqaE1RgKQhsevj+7d3qHVeAgZe3tFfk=; b=NAc2NFl95mbZKaEw4CN2Jx9R36
	Yt6WctUWyd+lFvYBLYOsSHaQJHl0VyaVi80P0STTAjnssPh4OgkSsUSqMFtCyzmT6+cc1AbUeESSA
	Z6HNRykiEZmQ8PRqsflTfg1IDs4S3hXV3sNkaQSlDaRiNbk1NLWSDuV+6obHp/9PrfhllzMCCMO+b
	VJx3o7PLT5++qGxAmLpRGMB3twJPuyAWcnMzuNCV3PlMpZA2HEr8P6OVmcARsEkKAK3d/J34Ua4DQ
	87e1ekXWRKNPS96G9lO54Nb8r9Elwi3qhDYKsFgagy2+GyfVeorVCl75FVBd9TgsazQAyAg0ZPYMR
	mcWPpI1A==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:59466 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tip8o-003lKb-1k;
	Thu, 13 Feb 2025 23:25:34 -0700
Message-ID: <d5a6675a-f257-4f73-8000-226bea580880@w6rz.net>
Date: Thu, 13 Feb 2025 22:25:31 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/273] 6.6.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250213142407.354217048@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
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
X-Exim-ID: 1tip8o-003lKb-1k
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:59466
X-Source-Auth: re@w6rz.net
X-Email-Count: 55
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPWMKrqqc8HJ0DqbFe/u0kQe/VFWFbersqFPCVAXP7FSuwmEAGAJwtLq6kAa7H9pH6uG3/J1oyVKBH6uRbm3qrwvx+IByGj/8WK0boBmPJzbYZb0SKSf
 19EMUcIw2scgZvQiCHdwE3t7o9GbDHKzEzSYVv6RLYdvENtSfpXGu+z8pdEusNSEMYVMxiqyiZBLjw==

On 2/13/25 06:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.78 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

