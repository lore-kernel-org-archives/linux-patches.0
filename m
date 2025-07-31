Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5683597E
	for <patches@lists.linux.dev>; Thu, 31 Jul 2025 08:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753951027; cv=none; b=Ghk9qZHAlbmPQDYLrzrE+Zwzc9xiMxcdAVvd51kzV4GX2Qi1Zh9/r0ZyffvZoqj3YIvHIkXjsJNHm0X92YOsXDkDn4SrEh0TpZ9Lumdx8PLUd3CAEKSvAqt3OEdyg4nkFIZwajk1qftgXrHZsnNqQMInurmy8Vzj2uJ3xvHIRSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753951027; c=relaxed/simple;
	bh=d6vv6eakRyIvuGiDTGqAt739nwa+GVzji5Ne7c0xBtc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ifwWZfjGA0Ym8g+HTy5v7CprK/NC8kZ6bDVhVbazH1kAoJYl7+MSh6BT2e5QRXlKYnGkvwbDS2+z9QtJxg3u2sj6+SB9UriNDfyQIaAOa1xGsOmEWQVIs4gpuyBcF6P0IJDrE966mZT+NqahpH1paQ5/FqI4ejd9TumFJcEn0aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=0vA0tvCc; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="0vA0tvCc"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id hLOdux5ukcOgkhOmYumt51; Thu, 31 Jul 2025 08:36:58 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id hOmXu0I9crnsYhOmXul89Y; Thu, 31 Jul 2025 08:36:57 +0000
X-Authority-Analysis: v=2.4 cv=OLkn3TaB c=1 sm=1 tr=0 ts=688b2b29
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=v0eEEZAoNUg_BbrKGCsA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=tc+flYPvwVIjvmZiDyrWijlUd6u0n/v8BfGnNJ0OMJ8=; b=0vA0tvCceErZnzHg2aG1u0rtCk
	NIdiTGLrUNSbCoi/YXZO1UEBVDMvYaacHdDTUm8WcLsKdyN2siu5vJmIarzIqy2Ggf8t0PfFoVFNb
	fMJtIP6a8Ghmx+Qtk+XH2Cy9+j9/liOFi+9FewmM+J1e6DbLArp80LV1VUNgEc0wKgwoGcThEgJga
	48QPa7YvBIZVoRulnLydohK63Xg0jW7xWlw7Zr3Ys5+CcnncbE7OBVSjW+MajymfGEoE2LSpCuyfs
	TD/ArQwJK/P7bPCdXJBV8BTva09wi65PTRtsmLp1VaQ1JvNi4hTt2TsIBO3X1ZBpj4+p/4giuHiJb
	5WEdaMPQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:42876 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uhOmW-00000001Xok-0m5L;
	Thu, 31 Jul 2025 02:36:56 -0600
Message-ID: <41fdee77-7652-4310-ba4f-2ff56ec6fec5@w6rz.net>
Date: Thu, 31 Jul 2025 01:36:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250730093230.629234025@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
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
X-Exim-ID: 1uhOmW-00000001Xok-0m5L
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:42876
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfN7MPxIS/nYecJIMF3NL1lOf4kLSKveNypYyxTVtJyXOBXRReaOPtAeo1QTqrzUtPUAMHLaaD5HeZeMK2SrXQqOyoW+2Nnv5PROrNHFrJLYVzZOUS5Xm
 GOGLeMJih0T1Ki7KREiydHEYpgwH3Zx62hLWwBvPhtEYt3EuSBCczdomxfFmtGJ0RY7SFiJbri4uBw==

On 7/30/25 02:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.9 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

