Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64CB1C54A5
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 13:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738330884; cv=none; b=QzEQMYWv6wWAemyQP9ao8cLvE+c1MPnj+squdsqtbIcSykIBhuccQ17TzuWj7ngEmLuQ7SpdUHyssSU+iJgH0u8+3BayVDjREleLZ+mAp1bLOc0W4fyICoFUPDSTVUbrn0XMka0Dub8WKThJ/IoehokgnhIaQ7qinM/f7B672es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738330884; c=relaxed/simple;
	bh=ocByIrvPvPiznh+3UoEMt+a0DRHY7iLkhPgjk/zAa1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J70nOYtPexNDo4C6JBcX0CdUXoh1T9OSLNCi22tRc40Vmxvh9kZ6bHZojRSlW9Zgd4aNoBy6mcA6y06z8xK3f9jeG1mTc5VP86ZJlC7ieyG29ZtPgx+PMCbrxgM67Yj7saQJ5b3bPikSO08dweo41uEY4pT79VZF0/lKCAlHSSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Bvcegygv; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Bvcegygv"
Received: from eig-obgw-6003a.ext.cloudfilter.net ([10.0.30.151])
	by cmsmtp with ESMTPS
	id dk4SthEHJiuzSdrFJtjJAo; Fri, 31 Jan 2025 13:39:45 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id drFIt6HrINMSldrFItKsOr; Fri, 31 Jan 2025 13:39:44 +0000
X-Authority-Analysis: v=2.4 cv=K9DpHDWI c=1 sm=1 tr=0 ts=679cd2a0
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdSt8ZQiCzkA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=JFz5sLme7EOQrv7eGfQA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=48JnqtXpYh3jPntJtpsJ0wyjkcS58NHjuI70m2I5qMM=; b=BvcegygvxCeVCJ9x4Q1sMOouM1
	KalJxFTN9UOrCFcbE2+XtzwCaI8K+S6y0bt6ysZYmXnOnCz9+4JTACVwaWD1SUR7v/aFE9lpuUGpq
	/hSZphisHFXMzEJJff0Kq3Svtu5w8eoSIwXin4oFX5gGiWNNEZ6vIJFCSSvS0oCP5psQ2QCHS/Y5A
	4i+f+EShpKp7KhC0noOOFjuX6KOcB9r+4o08rtpXkwQWuE70RvPJNvOfPntfm/3u3Wg6ETqa3RV9w
	Z4RYERKuaeH5mCtKSQeXVdKCaxkvcBrT2USiC14/uXBZAZ20mrRgFIWT0z3NpnQgGFALLQD6u2/T1
	Ho+A3D2A==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:34732 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tdrFH-000zXC-0K;
	Fri, 31 Jan 2025 06:39:43 -0700
Message-ID: <95de5a81-3d33-4bdb-aa09-c27924791d49@w6rz.net>
Date: Fri, 31 Jan 2025 05:39:39 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 00/25] 6.13.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130133456.914329400@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
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
X-Exim-ID: 1tdrFH-000zXC-0K
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:34732
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBzsNZE1cAoOHXfetRnOVNCRBGe7pn6SE9WPDkUdDWkxEm7fPjZA9v8tZ303JL6qFt7lQCp7xuTHaEsyqFCQdMthf1BoAzfEdcKnMoFScYEF2NFcH+DN
 +XtUWGtVa3WzjjGWt8M2FiUnW71OxehHcIrjRTbX0thsWq9ckgANGokj+BzGntx2ljEK8/roW0ipkg==

On 1/30/25 05:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

