Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E33C2566D9
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 15:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758640208; cv=none; b=sev2Gvcsc+29eB3ammfUvMSU/WarkbBgvei5MCT/Mj8NwcEsd07HHXnLWL50sVwTeuPY90EkUeRqxLSr5KatIAQefstWc791BgR4nUoQMvbJHskKagdqMmJpD71PYiqcOs3fM9MWEsKrxFh5lGCpmC9oYT4C/r4Ywfc1E7lMi5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758640208; c=relaxed/simple;
	bh=SSiy2TRluSryN9ADgpVQ0qferuYOUc6LMJJchbc4wbo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bPF0sXrSX+vcfHN1Ggkl6dV1EKDF1snPU4IGWmIgbigTeW7p0Ufz5kv6zZqYdiHcxU3uSp67L6f+yKN1VxpIMpV123bHMIrkanAt1H5JRW+wQcWpXTzs4q5b03TmWxbO/wB6L48ZnLooFoS92NbSgEf1fHJSYqLa66PlXbXrMCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=19F5z1+I; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="19F5z1+I"
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id 0ndkvmddHaPqL14eavvlQe; Tue, 23 Sep 2025 15:10:04 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 14eZv5qmJ0HUD14eZvmqtE; Tue, 23 Sep 2025 15:10:04 +0000
X-Authority-Analysis: v=2.4 cv=TIhFS0la c=1 sm=1 tr=0 ts=68d2b84c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=_vbObBfMJV-T1l9kk0gA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fMDigIkoQzPyQti19xkVm/iKCrXMe3NdMvsHL5IpVBo=; b=19F5z1+IVgeEERpYhE2+nSYk0J
	qnE57NSUmku7tjedQ99U7JoTmP1XZXYRrZUvE6rSynQThMLMCHCsPvWK9PMi7J7JZrJEmOBjHmdy7
	0gJkGAzwTz6+M079JR9bbucYZ88oHJSEQ6wEekwhz33ZmcucNyKp0QDfnOvwf+CtNQj7sB1NipP+e
	CIffzP2yKoaGZmh+ar40bcueQ5rDj9EFf0Xpd6nji1G+znMZ1qKzP8JhbQy0a7BErr31vf9AmdkVN
	jampZIG+5HA3uqCcjHmcYjumn2PEj4nZ+Y+n18kFaA+6iBzn9RJwWnlrdKK2f8FeGEDmjOsO8p8oY
	CJ/xnWcg==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:50504 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1v14eY-00000000xJR-2SyM;
	Tue, 23 Sep 2025 09:10:02 -0600
Message-ID: <2ad53a59-6178-4938-8d61-a46e503be3b7@w6rz.net>
Date: Tue, 23 Sep 2025 08:10:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/70] 6.6.108-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250922192404.455120315@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
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
X-Exim-ID: 1v14eY-00000000xJR-2SyM
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:50504
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPgfmgWnJL1FK52gkKIDOVCu0etbzqC7tVP+8gcD3GSZvmF+POMGC7WBlh9gAsTGBDnyBCSPE3h9lPFPymiekxBtdlArzZxT7cAu/NcC+CNPkk36o1Gh
 mK92tcxOEtOBZoTK7QMWHFe2l4wzT55DKMbcj7J+7C+C6B+1qNYumCMLMQck3c89MWngytWyqV4Cgw==

On 9/22/25 12:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.108 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

