Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB323302769
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 12:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758199995; cv=none; b=jieBOlYd+Fkf49inmkyWauIbvtCLv6lEerviMFoFmKfw3Ab9zKwX/eFMz3jWiFML2M/qOjXvJIVy2mKjiLEayzcxo4fn7Kh/tNMozs6wtF+b8zoMlaaZL9YjF7+1qkEX6kGP3hfpi9cYHzx3kYVOmID935hFTr4WEhdYCp6yFvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758199995; c=relaxed/simple;
	bh=uA52+JgYl+PuCJQNragUDZMbNmiYGtb0rmrnzicb92o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b4xpNnDtgV+nkf8Btw3WD9NxdVOa9Na1CLV5KSWSjd4iO9JtOybeU6cEwSD51PThNQOjOVuoAunoTHJ0gbVlQRUd+/pzz08b1gUbTJHi00F1LTlUfg+cZ0NrLtNUBlyjdBq2Ld4dPVp8NQHlqwOnFefgNIKiCT9jQ9k/tTdnASU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=fXV1YIqP; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="fXV1YIqP"
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id zCOOuArxbKXDJzE8IuPJ5G; Thu, 18 Sep 2025 12:53:06 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id zE8Hu11DpfjrXzE8HuI7Pl; Thu, 18 Sep 2025 12:53:06 +0000
X-Authority-Analysis: v=2.4 cv=ItcecK/g c=1 sm=1 tr=0 ts=68cc00b2
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fA0ftzXtmjLLnjOmvkIs5l6CS6NnRZFaEyh/+TKNCEQ=; b=fXV1YIqPGeHDbADRvXJSgYThRd
	10hjANnlHWsI6IRHKmzYX1p4sKNfLMNeY5KXjIAasyGyKgHoy8TvnDOGc4jCyoc7uM0P/B33GDdrN
	GitUNYBR8dLq4BYUlPitIiJ/8ECtGwOLM9YCLyIQeBY+GC2KI9WHM/cgTZJyN4VCoW+CaiFlOFwNs
	P/cqwmmI8vf55S29iAYVD1FCILNLPXF1gSY28UlyLSbIYp7PNP6NyLxQ04ygf6nFGQIZiZw2vmDpT
	XgmQs1wlRGQRK2K9Q+p4kl71bRyJXJUwm0xEqDmAlT/A+3/g1p0EDKFumbRx2lt6Mq1+tbzuhlsMF
	tvloA1Aw==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:33166 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uzE8G-00000004EEX-313z;
	Thu, 18 Sep 2025 06:53:04 -0600
Message-ID: <39b5b28e-4204-44ce-b9b2-ea033feac96d@w6rz.net>
Date: Thu, 18 Sep 2025 05:53:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/140] 6.12.48-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250917123344.315037637@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
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
X-Exim-ID: 1uzE8G-00000004EEX-313z
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:33166
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKtaiX1+3aN4CqGD5XHbSqwAv+5QUPlCZ00zfoRXDeEhq7k/Fy0uH1+0OIWl1R0yxuZz+uYIKAVsVdYHsvEG1PUO64jOSSAzQ/KBkFn5QwxBN67e/ZE3
 Qe4nDQyTYx5+2O1W15RZz85plnE5onZg1p4mLpUV1l60iTbdeoVaRuRdwZ+jf0y2QvsOpn8YvLektw==

On 9/17/25 05:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.48 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.48-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

