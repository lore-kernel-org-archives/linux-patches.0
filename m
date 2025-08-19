Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F683279DAA
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 10:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755598741; cv=none; b=pwU8NZYt7D62wc9ncVfPn0iHSb6x0DALO2N8AHP5e+RFqgP3grM5f5UVybeDjbTTALa/MU92bJOTLBAQUPFKTbu0WwID15C29dHR46KjK0CNqIf1ZxXWgAXsWCwercLmqoNFWand1QdojsY7OjpB8d+2MP7u+lbuSQbt63Ik3qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755598741; c=relaxed/simple;
	bh=Hhb2cQ0JJTQkVEzTWknXVix4/H+OSoRjFJa3rEm/Wt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GIOwbVWr3FVP/0bu8wd5ZsDMr+7BRfGiwcQs+uc0kTrtutQTgIufsZAMZ2Q2OKpquTo1lWFrl68cYZ8cQ+bwbNh+jWmjzzWGfIHZjIZ+B29Xj1p4u6vmPSxOc/AInH7crGF82X57Yjc757C283pUBaBxK925BPaMrGYABsusGFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=BUecJvIR; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="BUecJvIR"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id oGKAucQscanSsoJQbuIQ6T; Tue, 19 Aug 2025 10:18:53 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id oJQZuLQKFwYTkoJQau4TMG; Tue, 19 Aug 2025 10:18:52 +0000
X-Authority-Analysis: v=2.4 cv=fYCty1QF c=1 sm=1 tr=0 ts=68a44f8c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=tFgQPAS5XSBd2ITqQ24vKOIlDW+0jUUp8BqPdlM51aY=; b=BUecJvIRZyY/jyQb3M18OaBpkL
	oQOA+WUgUjqWo1WOpq3utBg2qfpqXUXDtpjfbWXg5QNcHuy5E97tGhyN8TTOS5gc2NqZxRw5lVvCi
	cNBNnzuOuDn//xLeFqDvAEKYbgGes8HpBJ+Yg0BHZV7uIclfFRThmHXasLGP/PdP1T0PeLwGCB2g4
	SuXblLw3qM+yWqzdIf5xYrzubxeIBKrL7n+C21WejMFLkFTkseNKJ56OjalAkWtNFkBuuzWJ98SEp
	g9hmGx1f+cBsYIw8cYAgWzizHazfzH/3xnd8D/xaYAe6/UmWvBsyjiThPAGKGH0lnVaUite6++Nav
	R/NIUxog==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:59832 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uoJQY-000000025ch-46ag;
	Tue, 19 Aug 2025 04:18:51 -0600
Message-ID: <1dfa969f-3a56-4295-9f4b-47ef24b684e8@w6rz.net>
Date: Tue, 19 Aug 2025 03:18:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/444] 6.12.43-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250818124448.879659024@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
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
X-Exim-ID: 1uoJQY-000000025ch-46ag
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:59832
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIyJXHmzQxtekn2/0LESG9EWBllV/UJs7JH/VXkKcxnWttEeHFMooWxQTsDDMLuIWM9LEJeCSZPPpzkshtNYJJYVQWIyJsDCWIK0h7EKxf5FNGMMjVI0
 oACOUCHEGJ5dwpLHanU/MQ9yTm2BfjzEPjKqRdyN/yfaOfZG4we1SazvC5UsQWLP44VnvmBPLLyEuw==

On 8/18/25 05:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.43 release.
> There are 444 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Aug 2025 12:43:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.43-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

