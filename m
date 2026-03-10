Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C28271468
	for <patches@lists.linux.dev>; Tue, 10 Mar 2026 23:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773184821; cv=none; b=SAvJUjbeKKHsJcTZGP+03zktUuNNmeZE27nlR1nGK8G+sX6eqZX6Ur6RqF+UZ2DUdCauwu5MRX9jdR4XDsaniI3C61Iz/kP4mJk54RgK/AqX44OnNdm+ogK4lUDhJENbchlMMGDoulzU8+9ggua2LZfyubMhd3QnZEucNPFpZoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773184821; c=relaxed/simple;
	bh=5o0OdDkY0YbcEK5YPF5QXHUcDlRclUFWTmYSN2uP8us=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hn21ucGrSqurzgZlmJ0K+ojvb1dduKL+/1ySNzJkOKsdzCW0atMU/jCyK2HmF+CmtSU8dTTF85AcNACdbNMwsgYAkK1ejaekcd8AvdJ2sKynFDsg+ejakdRsIGnn8m0/jw19rgIH95ijQjNAa0GJJ+D2Ek0E5fFPTMn3CeIDOoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=RixsNmz8; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="RixsNmz8"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id 03iKwlJwqaPqL06N3wkNxo; Tue, 10 Mar 2026 23:20:13 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 06N2wmQDlPL3206N2wdI7y; Tue, 10 Mar 2026 23:20:12 +0000
X-Authority-Analysis: v=2.4 cv=MqhS63ae c=1 sm=1 tr=0 ts=69b0a72d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=0ChvWM-znedYZs12hn4A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=qrSuSTFGJ6LO1UNuDSfww8zRQzzVwFy1Zia+vvWUTlo=; b=RixsNmz8SwTkruPKw2lWjjIZ8J
	KZ/2s27prEvDArNioDZpDM7gk4hi1HmLv30j/j/p0RCBjAyndMrbIC4X6bFO4iCybtPG/Ak3S5eoo
	/uNRd4elf39Bv+lUHCNog62pnidzrt7LtZAQMwtI9CZy0J2BbrDgBfee7guD396xjGRPCstCVL8xH
	PVea68syFj81KoK9RvaT3hyJnVPaOlsb4sj/AeJQLxvZ9KFry1vjYVYl5AT6I63okNwIjlvX9ancc
	dY4E7kEC02YqEcN9G53SFt4dtUMAUNE+N/GT9QJapLD56XKTxkfFDeoSDvIsyiLUsE5dA+L2mVsyg
	9kSI6XZg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:59238 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w06N1-00000000KJV-3bEY;
	Tue, 10 Mar 2026 17:20:11 -0600
Message-ID: <a6fc9845-6562-4db5-9d20-8e67bb40f8e7@w6rz.net>
Date: Tue, 10 Mar 2026 16:20:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/311] 6.19.7-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <cover.1773140654.git.sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
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
X-Exim-ID: 1w06N1-00000000KJV-3bEY
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:59238
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAa5NpIZhVdtNH6F4g0cCfCz5QhzzClFtaQnqLpp7WNIAAFlKHcUlcxoPrZ4reNiRT7eoSxxGackt7M9P+h02sgOj8D2xpSyv6F03NJY1Nu8rCvHiJl2
 0Yvbt/JBCgYMz/IToe19g3MFZGlga9BCTG7bCo5RDgoDqJ7ml0in2W0GorkbX3j3laZXUPmCoj7pZw==

On 3/10/26 04:05, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.19.7 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Mar 12 11:04:16 AM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/rawdiff/?id=linux-6.19.y&id2=v6.19.6
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

