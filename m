Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877AE255E33
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 22:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740003951; cv=none; b=MMShlWLEun9gOUxNilxQnvY3fzfBobnCC72/rrWoPgvUBcQ/haT93oL0mPY0pf4GysFpoOnEZkDR2H0u/bLVLgSUa33oYwS5HPHNLxK93nRB10LjwnmVmOdUFSXx2q/LQHbPwOapucSCMl0iCF/Am3FMemO4WjdARYKODwNFVcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740003951; c=relaxed/simple;
	bh=u2tqcqCTos/mvVoG9SA2/8Mptv1CIIlVh0FDbvQwBG0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qDvP93xJdTvuKYkjoAsx+1vETh/RNbmeP1hldHzpTF0VrSc8jT7ed5TQWmLbqeluaXP9l6wf8LwdnZFNyIUEBnrkage6pRoXGd5J66pWhfQGtwemcDnIKK9YT7sapye1gZhWmY/2zHQJgpgPIA2rn+07FyNLbYcnSsIwXcvv/sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ZopvyFX0; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ZopvyFX0"
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
	by cmsmtp with ESMTPS
	id knPattJitXshwksVot3k6Y; Wed, 19 Feb 2025 22:25:48 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ksVntwWSVlqdtksVnt1UYg; Wed, 19 Feb 2025 22:25:47 +0000
X-Authority-Analysis: v=2.4 cv=JIzwsNKb c=1 sm=1 tr=0 ts=67b65a6b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=XuDxmZHshaIfwV7d83o/IVeM2bOm16daCRLmJQnB7Y4=; b=ZopvyFX0iyz6Qhk7kNFrfidoVR
	n9Cs4mwCVrS0S78Tc2TXH79j7HFcpiCWyd0fEEey4QR5VlOq01bIUZDj5DQzxlUi5FkYwlETK+O8e
	QZ2y0ORjpbx2PTknDSOmHUDtu1Kcepu9LxuuKOyxSdJZHt/pUvyvdqik1w/Bp5KrjDPWA5U00QYgP
	flFfWTwP9NUKKSEQPSX+P4b+bJdE6YrD005N4/tg22SFe/ZYGYGtLc2djefh0xA5KveZMcC0Zo6rn
	yhO8CWcs830KS5WlMgUqJEProsv+Cgd+tAPj356hudoaJLBBMX7VkRKL2rlPTmbz4ei7TDZhEvHDs
	DHO4E+6w==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:36884 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tksVl-000BhJ-1Z;
	Wed, 19 Feb 2025 15:25:45 -0700
Message-ID: <3db657cb-ccc2-44ab-bddd-bef10e6a5462@w6rz.net>
Date: Wed, 19 Feb 2025 14:25:41 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/152] 6.6.79-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250219082550.014812078@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
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
X-Exim-ID: 1tksVl-000BhJ-1Z
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:36884
X-Source-Auth: re@w6rz.net
X-Email-Count: 55
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPn5AWcbUBIDB+yf0xkuYXNwtEWGrLw/4fVOpE74KuVXspBEbrSGZS8bw09V+61weG7cM8FDE3CeWMsOGDPtNfIh5vbydBt5uLYL3nlpD2wK9Adzk9d/
 dEhUmrb3f5VCaMiJSSLVNsfLzignA/6cLzbV4DrqmXmPKaJZhE3RQ4v6ADbDE9APZNcll//8a7FNtw==

On 2/19/25 00:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.79 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.79-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

