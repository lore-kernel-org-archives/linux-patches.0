Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C58A27F163
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 07:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748937031; cv=none; b=gCK6NJJ7JKi5y145TdKzqlJzBtdcdspf7JDLMa/TndK7YhqZT7PSXXf2mvc6oOONu7o702njLVDtPRzEuTo8TW4FkCJfY1tGm/DoxJLqj12yHCtVoHpxURqLZrLl+xjryBBx8JZzeXn9rCdVqA1u6ruqKJ+XPlrWH5HfALLAjP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748937031; c=relaxed/simple;
	bh=QjYb117IS6sr4p0AH8aB1KCk10incPbX1v7nNe9cPzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=djJUn2UCFLCfGZXB958s2v/CNXTUqMUMNf5M3a8BnkMACpF7DhQbCKSEVxOtbXUTKT35e/+UjAu/OOt/gmi7OxQ8c1fVhvTtDjV6wXINt6hRX6cnjp+dqNeQI5i3YLAisgBVZbTJq+XfcmwpTDzZzXUK3cTFp8EbbsSUGamTMpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=YnF0OwjU; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="YnF0OwjU"
Received: from eig-obgw-5009a.ext.cloudfilter.net ([10.0.29.176])
	by cmsmtp with ESMTPS
	id MJ5euQDJsXshwMMPkulgGy; Tue, 03 Jun 2025 07:50:28 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id MMPjuiwRuLedNMMPjurnLe; Tue, 03 Jun 2025 07:50:28 +0000
X-Authority-Analysis: v=2.4 cv=Bpabw5X5 c=1 sm=1 tr=0 ts=683ea944
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=HCRiB6Tz5r0UTqpcufBt6hucix8FJNQpJoI/TidZxVg=; b=YnF0OwjU/R2eBvwVK+VuXBMV8F
	TMN7dmNStTQ2lCxaF5QOqmaVKlhGVlAoBj1birdcO6OWNzo9p2kyUH5+hA3/jUec+2oBjCtcUwtri
	NDh3juZZUNwPrCUsS5L7lUeUdagCdOTmEMr/wETpDdQirKTRkSY6fBDx4LmjrHYVWLmvjC2VdcRix
	ZrKKIWRCLxJ/Va2oNp8y7AV5mmccFET+4DUT6MhYFDTFeAeeW3dyAcoqYT8CXtIeWyu0gow0BFTo7
	OP0hbgkRf3ySJJQK+ZEUB+3juceNLtYT+aPvhW/pft2Uw1ZLDZ/EpBraESd+V8//E60IMe1srjenM
	94d/hcGQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:42054 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uMMPh-00000002arU-2S0D;
	Tue, 03 Jun 2025 01:50:25 -0600
Message-ID: <3a0352d6-5a08-4d20-a784-78c9afac59cf@w6rz.net>
Date: Tue, 3 Jun 2025 00:50:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/325] 6.1.141-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134319.723650984@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
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
X-Exim-ID: 1uMMPh-00000002arU-2S0D
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:42054
X-Source-Auth: re@w6rz.net
X-Email-Count: 112
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNBq4maHWMVzTvYso2OXamhM+hUBvS/J/vNa3NkE+nsNwQjTXSigz1b9gTp0NBTOa4PpLpFAtU1o1pVWJOMU8kpC/IyxS+2tqf768KBs0D6iBH2fYEEW
 JiKtzyijeKmoPPg4NRijhFXXTlAsmejGhVpYBfu1uHMCsSDgKIp4mY4nkMM4vkkWtAVZc/shDXvrHA==

On 6/2/25 06:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.141 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.141-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

