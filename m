Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD8B2C2592
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 21:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746048124; cv=none; b=NZxFiLxO17u+9DXaat0YcqY+sW1YQ5sy5Qde6Z633+euP91Ye9QFQSOa5GNTB7mdxT9HqVVIRSi7rPbwInvK9ecqRnQX/W0lGfbyxvkIdwED9B2mOUiB8LKqRY/ATQ7uTJCi5Io7bfC0TLMQqtvqUDzDGlMF58jNvuuEghwNO6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746048124; c=relaxed/simple;
	bh=ggk7MT9GbwIM9Dqn2EHuGngwdbitOxrv0dj0Wh8WMGg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b0hOR5IGJoJRQTZSGbTLRmg1amIsrPTDAc752GyxqcFX9UTllCJ8QF64+qxEnVkyESO65nrUv8/LruIuqq4ht8nK2HvxMjP5NWUCnsqo2ECwdpW3FezmbkwfbesQJ18o3wAOxjV0Ypds9mANw7fVvhmwUVrOqBkRhwg4G65YRoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=eNKN4vIe; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="eNKN4vIe"
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
	by cmsmtp with ESMTPS
	id 9zYFup5uvXshwAEsTuH50d; Wed, 30 Apr 2025 21:22:01 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id AEsSuASWoRlrsAEsSu5QwV; Wed, 30 Apr 2025 21:22:00 +0000
X-Authority-Analysis: v=2.4 cv=Qamtvdbv c=1 sm=1 tr=0 ts=68129478
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=X_drXzbwcQU-ujxrCA4A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1IPnMfGp2/0IsT7dNFlU3dqkmzJ7tISbUOL75eLtcNY=; b=eNKN4vIeHstTE8Nw4PXxlZ/xz3
	uiiJbvtS2cripnSWPRGw0QaPmF6LDckS++8AD1u0SDSCB3HnrGp37MG4iwi/ei0dYot+XoBqKqwUK
	BLS8nHyYkKO/wcHimRr6HKLwsvYPzeQaoPeTDSyDpGT68u/nD/q23DlHAuhq+CO07H9NaBfQxb+v8
	WktkOLh5S/3fWzSOn0dyqDTyQbzqk07UfPLPW6JgpxchWmtAmxK5OXCyBPsEfLfwkcb/Q8ezAp8U5
	8+SMSh5nw6L/0ii2yBST8RWH+s3kbk7BQC6+KGwF8G1Rn1C7295sGWhYgLXwHRXTopz+ffJ6jw6y0
	wl2Pd3uA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:59904 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uAEsQ-00000000ZUn-1ugu;
	Wed, 30 Apr 2025 15:21:58 -0600
Message-ID: <77815016-c513-4f7d-8af9-07cf263df16b@w6rz.net>
Date: Wed, 30 Apr 2025 14:21:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250429161051.743239894@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
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
X-Exim-ID: 1uAEsQ-00000000ZUn-1ugu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:59904
X-Source-Auth: re@w6rz.net
X-Email-Count: 74
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCC40yy8a/miXuP7neZyv5tXyOaqQcSkTDgrncPWi2vE7OvB5FkDeUVICkS7OE7q94zwFCb0kEQ5AGwglfpyhmSta/AdDplkJeUbSwovOTbBNJO86W9+
 v3vSXSHjcj3hOFqcgVo7LF27+q3ZCuzyoxJF6h6jcCb3rhpadTUE6MOTyol75rYb3S2Vj7xmER79qA==

On 4/29/25 09:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.136 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.136-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

