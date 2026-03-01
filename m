Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B431A9FAF
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 22:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772402499; cv=none; b=EUbl+AuqKn4ggbwojhfhz6q3urugfSFkiD7rIhKtoQ8OCbACYqcEm626Q7jDTQtMmaUPS44/6LJWYzdSE6IdZoYccpAeLPYtAsrcACHaIT9LT07Z66uehfoibgarHRuWICgWdaXbNieZ6lViP3giliPk5cIHaPMbZI5oikuTntk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772402499; c=relaxed/simple;
	bh=DehidYUgF/HRhWLgqtGppChTEYVisQo8qxHwkdFJ/Go=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z8FU92V+F1t/wGd8e4zvAZcBzryMMNE20SLIZQbk7I/5Jtqmbugtag4+JcvsHj2IofR1AtD/DmzpfBweurqAYCZharG0JU9U1pK+P3U6HlAIaTYGy4tKO9tTIlb4PPIJm0HAWExkOXcgQxbcxnl85IGzvfCF1C+PDsBSOZJviJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=fIVZvtSl; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="fIVZvtSl"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id wKrVvjzCMKXDJwor2v2Yuh; Sun, 01 Mar 2026 22:01:37 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id wor2vKRJFh8QWwor2vDA9z; Sun, 01 Mar 2026 22:01:36 +0000
X-Authority-Analysis: v=2.4 cv=Mcdsu4/f c=1 sm=1 tr=0 ts=69a4b740
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3mMbAX3YfbnIcvKWH83X3nNx0ElNq+XaJMQRRPolmUE=; b=fIVZvtSlTwLmWURB224girZ9u3
	NvKYbciuAS0L49m7nHeb/BgFM92hg0J5lf0WgRAe7mn61onhGyCizCCZzuOEjcldEtcFNY+0TXyJT
	C4btgX9Ki0xXGjxhq3lH3BxYsL2atmPXFOEFdLGgULLPsRbxElJ9VprI7/igBr7u+CBY5HIw9PjiE
	n2q+im/OnqROc28YVgUxWVc282nmrNkWyJbD1o2R6NsV02FnTB3c5wnfPS9CVZoUXuTJQDgO7Wz9u
	iEMRPVTWfj6b44TAM7Dmg5h7USvX+pKlTwfnDLU8rMqQK00d4whKT+5dbfvOp19e2ovPotRM7F0W8
	caSywyZg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:41240 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vwor1-00000001eFk-3NDH;
	Sun, 01 Mar 2026 15:01:35 -0700
Message-ID: <203de9b5-5086-4215-80ba-7ebaab2674e1@w6rz.net>
Date: Sun, 1 Mar 2026 14:01:34 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/385] 6.12.75-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228180001.1567994-1-sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260228180001.1567994-1-sashal@kernel.org>
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
X-Exim-ID: 1vwor1-00000001eFk-3NDH
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:41240
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKb51LNF+PhfuPZ5WIaFl50PXZ7l2A48Zx4Kd6NQDwgAycpW9EnK97g4InekiL8I7nPxa+ZJkGZTJml0xN/TQXYI1Qr55ZUdDLwbmA2c0wEA/gtnFOVz
 olxux5FnGysUOdz9gNA21sN1ZSrgq2uNfb2IhFo2Ye8fI1k0V547JVj40e/yjeTUsFsE+IW0oI6Y0w==

On 2/28/26 10:00, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 385 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Mar  2 05:59:55 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.12.y&id2=v6.12.74
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

