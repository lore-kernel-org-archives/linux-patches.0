Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1033A2E7653
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 10:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764844792; cv=none; b=kXel8Aing8O1QDMPkFIZVkX/+4sle2s0ChQpi2gVUXELTDHoiVvF1k2KBSwRthdbqolgGCQC8O/Xzv/GG8A1AJjsrdQ+XYp1avRC45LJ3EAaZkfpSmkmKM7TVy2kA+4mHKLG8ktONejyu3wLED7pDONuo7p42tctytH3DoVUHTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764844792; c=relaxed/simple;
	bh=nTF5dXyJXcZmBo8sfznGNyeFPTJIxBUFGUsLSHEAdwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u/Z7poTL34Vwr9RA+Youf56o2+yzqdmAumdMkNKqyCjYi8b3fmlpOlD7HkoecbymQAYqi7I+Rh9iH0CRj4kR6P4pP3DnCSHhs0GmbqTWPl4gHGOO99ceECCFSly4hvJq2Mh+2J8Pcdjb0wJVQWdBp6esC004dti7U7TQ/I3YLNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ksmECPAJ; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ksmECPAJ"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id Qyh7vToG9v724R6kTvfncg; Thu, 04 Dec 2025 10:39:46 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id R6kTvKvcnHSQMR6kTvDFKf; Thu, 04 Dec 2025 10:39:45 +0000
X-Authority-Analysis: v=2.4 cv=GIQIEvNK c=1 sm=1 tr=0 ts=693164f1
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=E9a5hM8EkPK/t7TaD0teulCvjz/eWSTm+mJSdQrACXQ=; b=ksmECPAJeFW3tnNwYueDC9qn1N
	STqY5hMxBNLhODH6qPZj57cC4RcCzscOvjJPPZLDYmtx3z+MfB/GIFShjWFWgMPnZZUQeAT+N5oTK
	n5erNovecXao5S7X0cbe2gkjJpsCNOWhG/8a0j5mT0OwlOxxS4x0Sr7I7ATYGL0LGt09ckKolvf7u
	KAshY0JHLi+26KipS+FeMJcKe9KsLvw5S+PJkUKXpmVKAM4nnOIiLHssf711bUlAdOpyY/A9z1fQ0
	itkTYtLBxTokL99uD6Ky9PoZXrhDz0UVOxyqLl15Vd7k/ugd5Xm3NFOuYhjFUkFuTfdAskpKRe04r
	aoQ7iyRg==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:60538 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vR6kS-00000001ZBt-30ow;
	Thu, 04 Dec 2025 03:39:44 -0700
Message-ID: <30edad97-faec-43a8-a855-d20bed99a29a@w6rz.net>
Date: Thu, 4 Dec 2025 02:39:42 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/93] 6.6.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251203152336.494201426@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
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
X-Exim-ID: 1vR6kS-00000001ZBt-30ow
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:60538
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLL5kWBmxPkusNT+QaVSp4+f21qA0Vja5D3RKPTo2HUBfujua2k3E3sEklP+kIYg2lsEeBT5XuZzowLCmmycG/Nh0dxsp09abvbTs7G2iJBwxkWwxmz8
 FHQZl7GlZE2yShYeedRPF0FZJfjgNdgK0wt6KZVGHsa6kkkdp8PEFln4j+UaLNwq+2aPMFW2hfpgMg==

On 12/3/25 07:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.119 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

