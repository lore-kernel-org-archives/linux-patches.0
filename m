Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65BF142E7C
	for <patches@lists.linux.dev>; Wed, 30 Oct 2024 01:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730251472; cv=none; b=ps792xL/VJ8eHl3yviTHMr0EYkmr2/MU3wG6JYdx0gaP8lsJaLBihhsVDZZ+tc98H+XwC4y2gRbm5n2LlpfcAWD8+ZY7ajRBJX28J00A/LNM40WBqCXJ6MugZquLYGadHx0HqMOY/PzPtNTO0vQtEYqtMPJwmIjS4T7IKAtEZ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730251472; c=relaxed/simple;
	bh=jTUPt+uihQrc7O0JB8m67/38HBekqhRvsrZeeDYOcVo=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=NrAPTQM3TBqe2yH0vYHsejvU9uC9oCD5mEHWdWKNxoUJYB01QH/O7yt2m3tEHftjO7L3O9Wf9miWOZ2Jhnr/l+slvuCz9c5ziqmloXl96GLNnigeH0Fc8ZnoLd8SmkXYiZkqDt0ZP4PRy0bWgHAb2vbWugkUqA5rQcz+sBvxHXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=U2yf1HFm; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="U2yf1HFm"
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
	by cmsmtp with ESMTPS
	id 5eCetaKH7umtX5xRltHdZW; Wed, 30 Oct 2024 01:24:29 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 5xRktsnN4mNYj5xRkt3wNv; Wed, 30 Oct 2024 01:24:28 +0000
X-Authority-Analysis: v=2.4 cv=fb9myFQF c=1 sm=1 tr=0 ts=67218acc
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=DAUX931o1VcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=agS4W99utiRcsodqIHUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=S7uZQ/FJJPVkNPvZKy1ittsxvNewcEVSMqf+a7g3dag=; b=U2yf1HFmfkmkmH5cH3W4Ff1nTw
	JKnj9/KPY+dJ7x4XOeMHkO3ZQFqdbFdMURPaAsN43j14NOPzVqvghQGP7w4FS6Hxlwgs6Jg171Rjd
	7PpC7GqV6MvrpFM80xphXM2grO2kG9T6iI5laHCtr6pC64FvYiPIZdCAyDZPA6GV6ABNUOZScEvyi
	Nuvk4J+PZQwrwXboGM/XuuhfTcOwRs9fmaCyxaBI+srZn11Sq/nK+AvwCrNmb2G3k3cEgN5HgX7UA
	dgrQEI9RdL1E6SFczRtY8rWM32zOrZgxlof1nn64A2INhbK8y5TRcIuSG57Xkx+RBrAol5VJH5w0Z
	ba/Ru8SA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:36532 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1t5xRh-001Dyz-27;
	Tue, 29 Oct 2024 19:24:25 -0600
Subject: Re: [PATCH 6.11 000/261] 6.11.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241028062312.001273460@linuxfoundation.org>
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <2610d370-1162-e34f-f403-69ba9c7191f1@w6rz.net>
Date: Tue, 29 Oct 2024 18:24:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1t5xRh-001Dyz-27
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:36532
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBnty8FKH1Pke3JcnU57KUL+RqTliIwibtRvAnmp/en5naF1Ifj+SFq4KkHvsGVdmGb8EdFDbF5me7VcSPzTCEhqRpLnCge5mC2Ev4SEMLK9xKS1x5ac
 H/b4RMU26fmV7CoUDh5mVP9pzBKFiDAkjJwd9PIwj56c68VqhJWhpIlQZdiAiixVw3fbJLNGjc12Vg==

On 10/27/24 11:22 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.6 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

