Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2591C1D435F
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 11:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760182303; cv=none; b=KlwEIudI/0enXdaWkZ4m3tiC/ejCdhGpgdqGeyGR+mbxW+IV+xCS9eBIXbSeM20bb/bkkhXkFekrVjjaRSzjn4cM1UxPrK74AP96P0elFzTSOeHQ5kgRU8CYcvjT4Be5isW5FJ0e+a7R78ncs3SJXCKMUApt97JnWdf6V2pW2x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760182303; c=relaxed/simple;
	bh=njLdoOsQgjGl45Zn8spr984yQtbE3EPPNbhi6u72PtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rSHrtjOI9+y/6kn8IWoAf71jhecSDwuHxXRBbvvxNK0+eNUTy8WWVjGruuFfBYUttPxwixluDQfiy1u3ltgpVkFxw7UqqVdpRAS8SocCwb/7bFN8DlEcXDW1ZAtkkA4FrgFo4v89V/B7KYSOJEX6Ho5WiuvaXuOHCVx5MhntzFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=xV6K/r7M; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="xV6K/r7M"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id 7JHXvFKoYKXDJ7XovvWBtP; Sat, 11 Oct 2025 11:31:30 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 7Xouvr85Kt4eL7Xouv07ub; Sat, 11 Oct 2025 11:31:29 +0000
X-Authority-Analysis: v=2.4 cv=FN0bx/os c=1 sm=1 tr=0 ts=68ea4011
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=VoBekJB99Y0dKvRsJJIA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=yUhxFDibat/XsHQKidB+DYuFneb9Ro2PNlfhJUOiv1c=; b=xV6K/r7MukWR0sUL5Q4lJU1SMu
	0/eXNB1vJycL0iEAJtblF1cT5Zb++cbUyW9dUbda1aSmNbxdzVdXcjs1rHFc3FyCW/tgYfd/LJxYK
	d07DP9V7ZAPKM8VBXs0YqigLgDAWXrzDPGhDzdoRsiEiXck2dER0AiJ1dqp9qU66bg/+ZWO0tqXyC
	p9yimf715Yf8rY2kW9KpyMr8A/phBcTWcEYzfeZD8MmlYZSRUcDQgSrGFf6hXfz8q9GZ9Zr7xngNy
	mNkb9HFCmbanZ6+t4Uq0HshCWxew2/AtvXecuCDXAOg5WF+wWNrzmWk90VCsNaXzSQlBEfHJ7fcX8
	dwY5709g==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:58038 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1v7Xot-00000000r3K-3Stm;
	Sat, 11 Oct 2025 05:31:27 -0600
Message-ID: <e2b940fe-a279-4ecd-81da-b739035a0248@w6rz.net>
Date: Sat, 11 Oct 2025 04:31:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 00/26] 6.17.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251010131331.204964167@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251010131331.204964167@linuxfoundation.org>
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
X-Exim-ID: 1v7Xot-00000000r3K-3Stm
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:58038
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKtp9e/0zNDXkEGco7+tjGi/oo46yHt8f2VkF1RGaPXFTHNexyvQyyg647HkI2/8rE04qqtTEIU+gRRjm7r1aN4gkmf1s11eJHLjmTFV/sGchryW/+WZ
 1sQAXp7gBH+1C17CvhZiOFkyOx4rfFfj2YrNSpHSEJNgtcLsYJ9eFWtIvBDNRcUG06awKmlh0trodg==

On 10/10/25 06:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.2 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

