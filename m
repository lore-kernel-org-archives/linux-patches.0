Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5125E3009D5
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 21:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755121465; cv=none; b=qDh7HIsfq5fELdE923vFjOHFRzsosZb3kFy+yK77lmZpAni/X0URPnSi2PpIaKLgfCL5I/dn968G66J13SLAb3nhR67y/DzNKABSc5pknuZ1Jm4n1X9OgfetrIUFp8kDbb3kn9SGnQO6OQftCXAs8awem3WDENBMf0+s6cGOUB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755121465; c=relaxed/simple;
	bh=RfbEu1S5VlAKyTJtB9cdwTIqJVPcs/984wHpUxeOi/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VU/AVXznylvbOHwlRM8d+7nbgEobu0Fd3fsANFAVpyQaKDnRHrUOXR253dWu5UyHRuPLNzNvna6D4vxOzsydGpRzOOgtE38VR0wLHeBNmBL7CRR+MjsskzgACXCQ0OQmpqH7aTLO0oCek37dJXaHeWEEgACmWpRifIJX7NVZX8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=an0ghj6e; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="an0ghj6e"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id mBYPuGOLCanSsmJF9ueZFI; Wed, 13 Aug 2025 21:42:47 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id mJF8uCWJBrnsYmJF8uTvFg; Wed, 13 Aug 2025 21:42:47 +0000
X-Authority-Analysis: v=2.4 cv=OLkn3TaB c=1 sm=1 tr=0 ts=689d06d7
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=aHXbAQ7li1hnrysWXWcA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=c9aJeW6YrzXpNnexgXqHFdglcRnHTJkzDF0HfgTpJcc=; b=an0ghj6e+l+Zzgb7XOL/sPRCCm
	bYik69S0w1kR1rYbdaU78sTDYy3JHocLrGbtDS++hgavUShCwgH7Bc8Y3i8FHwwSalzNIct5XCLCK
	aWyieuRTINRX+gWCRa954UMxHbxFIfsDsEeEOXSRG1Ie4s2j0FRvZWt/TU/hafrr2oaNhxq9Itoef
	XlZWOy5NbVhX1E8r58qINh2mAMNEqeJM+T7NEaTU6lXTL6ZnBSNhC0wSMJN87vqAZk7W0prfqBmZe
	ici3+ZIopB25HCVKnvulTgfJfTOkLt8DNBxiqT1gWPHbxkBzdsHo85yOa7Wm5psggazKGiu2n7aVs
	Ofcepjsw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:49402 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1umJF7-00000001xuF-1pCt;
	Wed, 13 Aug 2025 15:42:45 -0600
Message-ID: <c0deea93-0c85-4bef-af36-763f60648c6d@w6rz.net>
Date: Wed, 13 Aug 2025 14:42:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/369] 6.12.42-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250812173014.736537091@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
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
X-Exim-ID: 1umJF7-00000001xuF-1pCt
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:49402
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDZSueR9aWYADTfwl69Rmh77Ph0NLsWZR+DBpOE58H2rR6ItewZJLeXgBifwQEKC9V0SekfqMj9TEZgllk7y9Wels4jMpKZ860vr2q45XTc00uNRkGHQ
 m9x89HAw8FgUsgnY94H6SvlNO2hp3J4iWiflervAwerikpMQYxXXi97KqKTydKpo4sVCIj8zVdOO5g==

On 8/12/25 10:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.42 release.
> There are 369 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Aug 2025 17:27:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.42-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

