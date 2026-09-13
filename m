Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED972DC357
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 02:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789267688; cv=none; b=Z9kGeAnVrpQKGzAS0rnxq7nSHmGOYdSp+wJc61B/ieF9EVDa/EeB9g4JXiYKw8nWi2CR6qsnao9sADCBFpeILPXDxxA+Q+9cPEAOIAZiDGyuA+7n04G3+jdV3uQW8S6HDdhf/Q3tnWrb4hOjvJog2KKwgYRkrOOSig8rNfVb5/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789267688; c=relaxed/simple;
	bh=30cBZ0Pjhx1PjBAWkg6SuTb8at7xsFr2Um4k6xITJho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QgsHXkITlO1ScElTKwIUVJtggIWWIWPGl1D18hfwglcKQX7KajA2DwuOse2oVKnQteUnCic+6Kdnf1ju9M3AOpUoAhRN2Mdv0+WlqZNLziklg0NcHd0/kXOm8fBy0H2ITLmxtDn7gOsPJz+iq2/XCA5N5Xpkkj4Hps9Dps1yMr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=erUQCtxc; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="erUQCtxc"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id 5SxIxL5cJJFmF5aG7xReS8; Sun, 13 Sep 2026 02:47:59 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 5aG6xBVge0FbV5aG7x6bUj; Sun, 13 Sep 2026 02:47:59 +0000
X-Authority-Analysis: v=2.4 cv=Nv7Rc9dJ c=1 sm=1 tr=0 ts=6aa60edf
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=i4zM2ZNYXPBlML4XQsQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=7FsypSqp9DRGIP7U+X40sL9iflms7aFlly7c03WaRho=; b=erUQCtxcO0/mQVFSohoXW6o3y1
	fuxz93GGW/wuc/ZUDQEVCTUIIIy3V1FUsY2Upp6sZ09Jm3jqjxAjhKDrfufZ8SdV3aCBRzMookCyl
	+PezcuVqDAqZNltdYxIWZ5ZAEdG6y2YyE/53iHSIzgA3lKMLHSAy1PWuB16EHfZn26+79nqDLm0Lv
	fj94vpTFQBmFxDQGucllGKbBVZNDFC351BfHo22o+eFQltBAlQ5n9xOGZgnN6cXZZ/kYFtrsxKx0r
	GrUzpPLWvxfmLN1EWFjcsAJXc061elryxvJcJL+sj/M+kf8XtQRci7AxkuGPq1b4rl6oqGgSrSGBp
	VpixsVCA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:48622 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100)
	(envelope-from <re@w6rz.net>)
	id 1x5aG6-00000002jkV-0U0b;
	Sat, 12 Sep 2026 20:47:58 -0600
Message-ID: <1a29a80d-1615-4110-8aa2-eaf931b579b6@w6rz.net>
Date: Sat, 12 Sep 2026 19:47:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/1191] 6.1.188-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065548.086904252@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1x5aG6-00000002jkV-0U0b
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:48622
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfA+GWpuw6q0RAik8RDT/zhuQBkUp2pSdbxYHOfpp1gJ0567EH00MOdd6B8vZ5Ef5vaZ65zqu9+Y9Ch+MaUkP+6hvlicVBKNR57Ek4gafiwhBqNIgDfAX
 NqtPjQQpNPLQfybbmcQkYGgXkr60XeTmKGkXK5+d5sZpN4JADfaTywqweQfBHzEBRX3ihcdXQSMwKA==

On 9/11/26 23:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.188 release.
> There are 1191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.188-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
>
The build fails with:

sound/soc/fsl/fsl_audmix.c:461:12: warning: 'fsl_audmix_runtime_resume' used but never defined
   461 | static int fsl_audmix_runtime_resume(struct device *dev);
       |            ^~~~~~~~~~~~~~~~~~~~~~~~~
sound/soc/fsl/fsl_audmix.c:462:12: warning: 'fsl_audmix_runtime_suspend' used but never defined
   462 | static int fsl_audmix_runtime_suspend(struct device *dev);
       |            ^~~~~~~~~~~~~~~~~~~~~~~~~~
ERROR: modpost: "fsl_audmix_runtime_suspend" [sound/soc/fsl/snd-soc-fsl-audmix.ko] undefined!
ERROR: modpost: "fsl_audmix_runtime_resume" [sound/soc/fsl/snd-soc-fsl-audmix.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:127: Module.symvers] Error 1
make: *** [Makefile:1977: modpost] Error 2

This is due to commit "ASoC: fsl_audmix: rework runtime PM handling in probe" commit id d8f18d3367a252b194e2eed54ef785f7fff479da and 
I have CONFIG_PM=n in my config.

