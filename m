Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.89.44.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217404;
	b=wWRdqrNv5+J2Gtg46bbNon9sSCNSlk4pNmfSYBNRHKxGhYKzET07lLA1NTu5517Dy8jO
	 48qBqa06iIVPfA/Qucah5rjM5/6Q/WWW4oA63rTsV76wHGQTkmtjUY4/QSOpIMB0CyLzN
	 XyFdb6hAqeOsUoLPmWM8PA/UtOzwhJO2QOq+HQoEuACyKqgbKx8jk+yFaDxqKbru8eyzW
	 uOL32ChZ4pMZVNT1CiwNX1X5l6X+4R7q3laHtODWgojuBDYluvXxpmgei7vty/gJSsThh
	 aAtPscXTrPaqI2/LKknwC6lUA+G1QVsva1E01uT9b3K/AM3XdmQLHTVeTS92lpIa8VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217404;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=yi1ow+G90thtWMFWQw3RlqtN48nJc3tJpdrsLfQiqXU=;
	b=UaNW/Y+5yJb7dlNO/+KKs23AbCm9abDRRfyStnM0d7DkdLkzm9919PTS6uTxwhOj82vP
	 tB9YugNB05G7Mt9F8NDBWJwpcpkMuHX9SqjgE+5XaN/68JDtFoWgzPN4n5KGqVQzv/s5k
	 +Qh/3vb25G2ek/IVSSoo1ZcFx4lFkK5wxOtjPD51hJKhDBU6qmG8j+DcO5CuJlyXQ5nEK
	 QYxVRcksdcs03NBVLfxGHDNQjfh4R+oAwKIxs4Omc79gG1Mbm+CJttn0EzjhH06NgE/sC
	 pMIoOxPV/9jxKlR+DIVEaRroXk99SmAPyqcqIhQn2+xjtgmIoQnxe7uMnuWN588dZ6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=2pyVIKuz;
	arc=none smtp.remote-ip=35.89.44.33
Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82051606A322
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 09:43:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82051606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=2pyVIKuz
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id Q6FPxKtfSAR1iQLuMxT79y; Mon, 09 Nov 2026 09:43:23 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id QLuMxcOeixqjjQLuMxvrh2; Mon, 09 Nov 2026 09:43:22 +0000
X-Authority-Analysis: v=2.4 cv=bZxrUPPB c=1 sm=1 tr=0 ts=6af195ba
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=yi1ow+G90thtWMFWQw3RlqtN48nJc3tJpdrsLfQiqXU=; b=2pyVIKuzjdUTdaJnBEWHWWr6mQ
	+7ouAwbeyIN2sPhEnSub57XusAYAnkL2jlFZR8DKg3QInmhOkriEcR/txIb7c72HHXeJMhear5fae
	DX/qPaXYzBHKzsjzwJfeVndEHF/VTnPf5ssF6QShmqbtAZSU9b/vO85J67NCQ79ENbbOWzn02RDo4
	wjbwdeziYucIBsnEbis8Bz6PQoYIqZ32dT0QphmYeKJX/meDAwUEf3diIXQjEUoA2nq+Wkxc+6yYv
	jEoqKcU+AP5ZW6G5SC1/BurMAXxsUWbmM6iOGbg04rvwf6W9GhqvfjBeomZMvSYCnbRxp52v+JYXO
	AWA2Hy7A==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:53826 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xQLuL-00000001Z40-1Q8E;
	Mon, 09 Nov 2026 02:43:21 -0700
Message-ID: <a0116c6c-e947-4a65-9202-6a8b06a7e127@w6rz.net>
Date: Mon, 9 Nov 2026 01:43:19 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1536] 6.12.117-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261107134957.653319350@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
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
X-Exim-ID: 1xQLuL-00000001Z40-1Q8E
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:53826
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPS4YbWe1ru1i+LfWSaScUl4lW91ItjAmMzNOPVYVByEK0drihjcbiNpiBmCWwkgCGZeUPFmcVvihulM4ZzGkoJVX0TbeQfJ45+2LpmyeIDPfj0FzXDU
 25DDt3OaS6aduvLJyrYCsxlY6W2y+HU1BM8vqnYwLWZo2GThbj7uGgZz7hWom1/KLfn+VLcO5+zNCg==

On 11/7/26 05:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.117 release.
> There are 1536 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.117-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

