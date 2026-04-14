Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D65F3939D3
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 11:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776167920; cv=none; b=BoykKUrXgCXvdxQX9jELa0w6enkLQsz/5+sa5e4HjQAFVzORlK5UIbMUMMZZE9ZcGH4CyPG3+5ch9q+YtirveHqaDXX/Yz74W9Fx/F1Ub80NY5OcEzhnaA06FoTOiKaKOnfDGIKYWvPhkUn3Ue7rgifu5AXFPWf3IpbY0KTIULQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776167920; c=relaxed/simple;
	bh=9IY2EvPtm+mWxdGdPq+saFX8Tdj3eRPKQK4AC9BKDc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZN5r/KxfCiQTf48WQrzE+u+7YEyrzS1yJVpj0Mgh/dn6y8wqJvctHwDebdpdvu0DSKMcGVlfbudBadL0EgUJNJSTmAi8XLHXcUJ33DS1ZUs9XyseQloPXgu/iFkH2bbvWUjJp+xV5YiHp5x7YVFaMqpoLPICeHfPLBdq6aqKmdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=VlLl6952; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="VlLl6952"
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id CazVwdlcishqQCcPZwPo66; Tue, 14 Apr 2026 11:58:33 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id CcPVw0aEnYA8xCcPVwOkCa; Tue, 14 Apr 2026 11:58:30 +0000
X-Authority-Analysis: v=2.4 cv=VJfdn8PX c=1 sm=1 tr=0 ts=69de2be9
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CPOQES4QBB87O0Rs79mI6/nYy8/FKv7EQ7rdBgW7Ow0=; b=VlLl6952F8L+y5nSIvFNv6kjUk
	XVNuoztSiOEI4oSIUS02HB7IvZGj1L2cvnkCZtqvmsThfmYtywqIfeEOpmf2bQyoA3AzdLkEaXSYV
	khABpYa4BtorAYv43YXqPSpalK/53/SoLuFVxGu2K4wAhetde41R3KH/hG21kTswwn87IVbOXiZxr
	kjtlkcabqYzfQ4Q4tkxnxBwCQoVm/XiSD8Qxe5d22VJgwKnFzFwL65orYLZ+KhZPdeWQlZdusXXdx
	FwkbZ71miahk+393h0/RFN5uLveqtWlOMfYNHFGoDm1gH69GIVoo6sCeCLLUC3AxXrhFADfAocNvG
	3eia5MZQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:35140 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1wCcPV-00000002rJT-0Vgj;
	Tue, 14 Apr 2026 05:58:29 -0600
Message-ID: <a89a9e6c-4951-40ce-b741-37f17d7ec650@w6rz.net>
Date: Tue, 14 Apr 2026 04:58:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/570] 5.15.203-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155830.386096114@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1wCcPV-00000002rJT-0Vgj
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:35140
X-Source-Auth: re@w6rz.net
X-Email-Count: 118
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDecSfoEPsy0PU3EdVn/b+VuYDJvH5x3Dw3Ng1c1qHW+XToT2UZR+v7VlOQLCOOok3u37sYdj7T880CYv+S6786JuxMCdOhkPFhAv0q+xUfwRF7rCy1k
 ojhlRTczmSZGtYOk82tFvCNyPtaptvNEwi/jbd7V5eSdWH+rj9tsAesiBb5IeRPUanULjblHQzmYrg==

On 4/13/26 08:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.203 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.203-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

