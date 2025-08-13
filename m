Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E38B271A71
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 21:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755121875; cv=none; b=S/Lchm3OYX0m3zJpGhKulPbqQxZdb6CiOVQqy2BiXbuT9eHjJidiOsZKggNiLl5pStL2YzFLG9QXREbcsE4jeY70hqAntyDflDsD9cDuk8rR4KiGmBSG6Hp/domTPOjLGV4nXqPEdK1+n4kws5D2MYekTRdem6UKUfFUGXflnt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755121875; c=relaxed/simple;
	bh=wnB5f2lNcXuWVMEtwXSEyjhFXiesKaIFnLomWIiQQ48=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Upocfrk/wbGqhHIknRn2rsoU7GldEEXXnE4SJwH+101HBm9AXVU6y04KBz7I450aM6OpNIjVZI6tEXLtIJ/RZ4xxcS/flFrB1i2UzuV+RjzFuUc1zPvk3wzUvFUg+fLMLwgMqy0Z9/9YdUAF7WWRq0QnMUFKfv0s+XIT1tsqfRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Ebus4ILb; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Ebus4ILb"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id mG8UuuiLXJLhFmJLluGOm1; Wed, 13 Aug 2025 21:49:37 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id mJLkuk6WywYTkmJLlub830; Wed, 13 Aug 2025 21:49:37 +0000
X-Authority-Analysis: v=2.4 cv=fYCty1QF c=1 sm=1 tr=0 ts=689d0871
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=odtVgXAzkc1_0mDZNXMA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=IF5PjUtDVtCA7at8MAkEA2XoX8G7yVHJ9KEVkdZu7ME=; b=Ebus4ILbPwpaC1vZH1Hst0NsfN
	U+IwqAAYAWhXismvtlamZcRTVBdoK5UVBpn1oj7AWqFweytWUT2qITvcKjlk5c+owPzJKEYYB6t6D
	0rviQDxo3c4/mJ3x1eBTnrmfvtL9fYT36chguuGUh3wIA/6fvgJ4zEEymQR0hM3BB5y3tmU5JR07K
	WX63NJyjONMAz5gKN4qRlqsIOq23BagFJJHkASLnnXgy/X/syWZNAVwSTfAZOifkTkBn1HER57Seb
	LXkE0iBE7PV2pEJUyA370IPwP2Okyly9HO4z+NpPFkv9nKWEq0xtMYjfKr44aKe4VE+5di9s9yZ5R
	vyc1zrgg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:38516 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1umJLj-00000001zqQ-10Xb;
	Wed, 13 Aug 2025 15:49:35 -0600
Message-ID: <be2ca70e-9ba9-445b-86f2-196e6b68958c@w6rz.net>
Date: Wed, 13 Aug 2025 14:49:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/262] 6.6.102-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250812172952.959106058@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
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
X-Exim-ID: 1umJLj-00000001zqQ-10Xb
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:38516
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFSFNDmvWy9ZrUnM3q8FYrzEFKhAbA90bdpMjL3DN8YkVYOEbkyTVRVmEMZZZe8u7Jp+s5h8YJZq5u7+ZMa7qkcsS9OrwkzAum5++2DpT4+mPOwZVdYI
 020iO8cQj+FrDQMHuy/1bSbND4p+E+MsKqCU1/XHb7JO/R6G1vdc3OxwoM/b67EXRHTrA9xS1R4EPw==

On 8/12/25 10:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.102 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Aug 2025 17:27:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.102-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

