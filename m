Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D062823D0
	for <patches@lists.linux.dev>; Fri, 24 May 2024 20:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716583148; cv=none; b=r4Mq47QJfbNnbqCd0L4wZOdlYG/DJ+ROrOxsobQ9+CoswZDsiH+A9Mcz7nGqPZDtDSyTGUhDKwCEPpmr2KDvvFuRB7/2gGz2HHzU0nrGTd6FrlzEgOwxBOwsbBesa5crmafcLXklezRmC9BbUxL2Sr8dtJNtjWwJCajK7uSt3w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716583148; c=relaxed/simple;
	bh=LoWM0TVymoHJriq6KJbuI3hatNBoiVI1Hv84Bj3Qfbo=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=kSwdZm22Q+cx3dN+VNcTQFX6CC7y3tLpovrHWL5mKi7sI4dwl6O27YnkDziPaR885OAOngOmztQGBtQL/9ojT5nC6yiHjtEnRCwoCj5bL2iWkRaV3rZAwdPj8wLx26wHI8c019hKEII9hbkWuWCuwWiRa/bvWDYcTsqewX1yMm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=JR/0IOgD; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="JR/0IOgD"
Received: from eig-obgw-5005a.ext.cloudfilter.net ([10.0.29.234])
	by cmsmtp with ESMTPS
	id Aa0GsKix4SqshAbgvs371S; Fri, 24 May 2024 20:39:05 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id AbgusH6V3YakKAbgusfenF; Fri, 24 May 2024 20:39:05 +0000
X-Authority-Analysis: v=2.4 cv=a4T79lSF c=1 sm=1 tr=0 ts=6650fae9
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=TpHVaj0NuXgA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=BXyYjBD0cXuZo9oD7aYA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=AfmSTF6K3ePH28mH9PRgkAE7ar31QEyzCQWuA2HmR74=; b=JR/0IOgD1ulBHucjtrFUg/gug1
	NW39lml/9HWUGEo72+oXNTzlFjYt4JHyOrBThclN8vTX4xbQ26xfvICUQXangpReAz8jccgFl+1gO
	SgxRq7of/EtmCKEMq4xyZfyAp5Qd6CbwE3ceGHA6i+P5Lxmr80rqfdokaQhNQBlVUM0/k56tw7oUP
	qTLBn6sMxAHSsaZX38H/T8kmXTq/MNy9oGiaXqbo6ohMWrpmN26PQ/No+oznljt9g9O8EiEXTR57V
	dOyr32wzZQdxjlwCOwwlH+uiAQxm6IQesQVl5TrtvGgaTyI1yaN5/r9QOBNpL+ll3izipNj3VS9BU
	4u9UGc2w==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:39798 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sAbgs-0035AK-1m;
	Fri, 24 May 2024 14:39:02 -0600
Subject: Re: [PATCH 6.1 00/45] 6.1.92-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130332.496202557@linuxfoundation.org>
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <e530eccd-5da9-5eeb-9290-c83360b88d6d@w6rz.net>
Date: Fri, 24 May 2024 13:38:59 -0700
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
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1sAbgs-0035AK-1m
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:39798
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMDdr+h3qvZEg0NSJi0BFRIeyVvvk+Kn4Jl6VbD58JqVCnqn5ILEbcM3s0acXVNFMMz5mEfVYngFiHimYOGYMsHEkWcP37f7QGLQHhbiVdBohfytAK7f
 8vQhqA4tvP41/hLDi4Y0v7UstBliBechPPh0XSCIPrAZYAJbr4kRsOxm/lm7EBPODmiA0O7iuJ/PLA==

On 5/23/24 6:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.92 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

