Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B203043BD
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 10:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767781719; cv=none; b=Rn4rwsov64bzaX7oLaG/Du7XH9ex89nRQcKDuA0lm5rp01J58KlGbVnYG4qyFXgd2ccwlodUfR6mSBxohEwLdCDRpXr8QaCjbyN/JgrG7Wbw3L1HNEjMhlb6PAe7+v+a4doydtzUC0Pp5341aAXOMb59Ws6wmF6dmN24dvcqxGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767781719; c=relaxed/simple;
	bh=X9HWrMElRT3UGSonTmaCp5nTPFp/Xp6g/+/b3awL+jQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e+lmaHxx+nozDbjzaPquEIl/LTQ85U1UN7ee8kjnWgWKl0MC2BDPbdtBAKI8XvgNBQm+ng32wqFPWoKB2VxtyzvFuzXK0vpoWYtLRRESWjCEAyt+6ScvKVqpSMypilNU/c86vh3bFCrf40vsTdWco8x8VSXPlx01HrkwODkmZmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ubyfHXJO; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ubyfHXJO"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id dNn4vpr2RKXDJdQmFv44cr; Wed, 07 Jan 2026 10:28:31 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id dQmEvYLZJV6WMdQmEvgElq; Wed, 07 Jan 2026 10:28:30 +0000
X-Authority-Analysis: v=2.4 cv=E//Npbdl c=1 sm=1 tr=0 ts=695e354e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=-FLzAiOpiDMxdiaLSvsA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZnD3SEKrnSp5IcrT9yGEWT809G92MNlONkSF60Lk2pA=; b=ubyfHXJODTzaqr5nHmEjgOCx9n
	AwiO+ekt0YWC/F4AfFenRFpE4IrqpICSWbfHj3vGXvEjBVu468mP0H7wNPbH1bOUEGW4CQmgZlBeF
	k3tDQ4MNPZ+1dpAADUNA82dZa/342nclVkuaC5kpAkQ/fXK//ZNsgFwHSf4iwG3F8WZHOWw+LU9zY
	Y7bn5rByiFxJ6IUbxay5Whc9zF0KIvZ9b3fTQv2mop36J3uJ6qFNxwWi+JfGvBm09WPLikEijMxMm
	p4ROChzZQG8l2ewVYjMf1csDnpQsQ7gaF3CXcCI7qtllRbNOenh/JfwhOQlmPAygDV5S22YvPhYhW
	Ie4UZcdA==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:46896 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vdQmE-00000001bGt-0Ckw;
	Wed, 07 Jan 2026 03:28:30 -0700
Message-ID: <1a4ec31b-7c6a-44c1-827c-d1992fd9f34b@w6rz.net>
Date: Wed, 7 Jan 2026 02:28:28 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260106170451.332875001@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1vdQmE-00000001bGt-0Ckw
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:46896
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNHxb8Ky16PCg+kijt0IoosQeZkpi5I1Py7nICIwtMQB0OTldTKJRbnhRfeQZLRklEU6+o8Muz0YjcGuh/XvNYMvj1S+73XTpnDoqBOukqQgc3leilPB
 xk2yfYnBR9mxJjQCEPoB/aK9C0q5Lnfnyql7weV3C9bosZoqGcJ2sBDtadddhcMOy/zaD25guk8DFw==

On 1/6/26 08:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.64 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Jan 2026 17:03:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

