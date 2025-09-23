Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C397D19DFAB
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 15:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758640587; cv=none; b=ZN5HkB1bwEc3yaj/I6urjThjpc5gbp/zw4yNGaW6ayMLiAwnF3biMLl27tmfJTKTyAVNiVSuiLD0HZ49xu/FKD6GxPx74WsRaQxQOLkd3tgMdbHnLC1+7hoA7uipaN0EmojdC3w0lEd8bDY5MMZWZlDWsscrfHb7JVsc9vqGspg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758640587; c=relaxed/simple;
	bh=TCD5mryo8Qr2foLQR3AY4j7mLplUOZIiR798hd1ldCo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q0eih6KEcaolZDrzhHy9Ten3bnGlSBtCEPLE+umZQ/vudf9lsYSQVmuzh3DootpK4JpqmZ7CEQ3h4xiN5GMZYKCpkXIk8vEMNvEfLH3wdb6AXr1ZyKXpp5IkJiE8gKEQQJPIEQC+3EkdS3afaJpwsyI3bcAfVYPNmbpMiKYPack=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=dPHGT98p; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="dPHGT98p"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id 0x0Pv6TS8Skcf14kiv9nT7; Tue, 23 Sep 2025 15:16:24 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 14khvvxF7p0Hq14khvkEMB; Tue, 23 Sep 2025 15:16:24 +0000
X-Authority-Analysis: v=2.4 cv=H/nbw/Yi c=1 sm=1 tr=0 ts=68d2b9c8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=H2e1TcdlFpyve7uw5OEA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kcL2CBsiMVraYHlvW5SX5jwa4HvqiokUH2wH5muwOaY=; b=dPHGT98pS3dXcrM0N4/z+dmW1V
	vVGLBSShmyTeVBlGUD7XdPXOB8dU0NHvvDmLuZ2AGAdIenoNITK3KOvpSj+sV86yW0drgEvoK/35M
	3flmJWrcsT9R4EQTBRW7bVNSx0RuLG6CbLuCe0hSF88JgG1kv176fZNY0IpgKdmP0pJ4uWHJnRZT/
	ZEC+I9SMtgyp8ugnLJjav+Tm4YzvHtfmGDRc9PKcOcdY4bF9q/C74DXBVcoTzIYTarWVv46LPudtM
	8x3jl4rPRSTK2ZzY6HIp6LCIYb3c0XVGArJ+K+UIr8hlE39/Q85xRZSfU7IuVDEs04ZbYgzrPLHKe
	O46hxfxg==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:54206 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1v14kg-00000000zdP-37QM;
	Tue, 23 Sep 2025 09:16:22 -0600
Message-ID: <083af45a-16ca-4f2d-97aa-105cf08c4c08@w6rz.net>
Date: Tue, 23 Sep 2025 08:16:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/61] 6.1.154-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250922192403.524848428@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
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
X-Exim-ID: 1v14kg-00000000zdP-37QM
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:54206
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIHSKlgXp3Eqti+e9P9eAonJ4XLn4tG8DSvbwdt10FLZXAhPdqg1qXC+Frdocgyb8zwpX2yDhU+Blx2BTwgc6VvHUyc8z0nFa4BTKakSL8LGvxwnsfPI
 QX88fINq76AsaqqMDQ8xtB78fmzbj1+mVXiDwbs5cgFdPYZ+20S2r5arNbjoivz2GG5zlhzWQE7slw==

On 9/22/25 12:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.154 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.154-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

