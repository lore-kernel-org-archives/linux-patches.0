Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F449195F03
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 12:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718367610; cv=none; b=LTxoOqENQyoDWDer7WZgqFXWtAk0Y5nqCCnMP+9XpNknOKBGjB/b36QiSFOBQdW2HPhFplIEt3UxCpp/CSJiDDusVSTNvrTV96gqqs24ZlR4ccC7A/nlpvqK2/rPtVLlxLw0NACdesaeQHM5NOAC95vbbn0oD5LrpZ5PS5grhNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718367610; c=relaxed/simple;
	bh=u0r125JIfBM8xdZLsVXut9omsTU2mE6jFwfr2wi8EUo=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=ObnpC7J1NAUFKZ5LAUupnsJLjkXTdjYAe+0eJpkYI0DhM94vV2jcbtEkkgkTJdtiYuQezfPovtbqhAFRETkkcbU1qYLkH4ne6Xtpm0PrruV3wGA9J+ZPBxXJ37cOnJSnM//VvnV6idWuKZ2Z9RcwJyR3e4yQujd3TGqLGZ+UXPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=qT96+NjE; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="qT96+NjE"
Received: from eig-obgw-6002a.ext.cloudfilter.net ([10.0.30.222])
	by cmsmtp with ESMTPS
	id I5T3sFjh5JXoqI5uZsReai; Fri, 14 Jun 2024 12:20:07 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id I5uYsNGNniKqRI5uZsh2ja; Fri, 14 Jun 2024 12:20:07 +0000
X-Authority-Analysis: v=2.4 cv=I9quR8gg c=1 sm=1 tr=0 ts=666c3577
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T1WGqf2p2xoA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=k_VYlBbNjbJsBR3UXVkA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nzruOxlZhLS4L8njztAd5vTjVq7eS1cdLUBo3gnFjes=; b=qT96+NjEnP6B62URpbuXwfw0Vo
	hraih4Mhn7kADBC4yYMP3o8YLZJK9VfrzMTuhX+PeyYPkjF2ZCoYnyhCEpeo9Ps3LXFMSIoSOTxXI
	mkJsM5ppCHEK5xlaCfSmM1ZIIldfiDkvkdqXuMd7sdKMbtzXGakbTsIhC+HXRm/8xhmTrKMBq6Vso
	ZNS911WeEcgkHYzei6tYZxxvFUzyv5LLtKT0ZfWuB34zxW89M7C2ffoj6eE6EpnXRBwhGqKrR1T4m
	CBW+8K/Wxy5A3OOTF/FMNhLcmkI5B24P+hP4S5EFxyizJaNyYjJndyUWqT8ly2c/OKAXh7JXx1EVc
	pmieLvQA==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:43690 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sI5uU-001sFc-0Q;
	Fri, 14 Jun 2024 06:20:02 -0600
Subject: Re: [PATCH 5.15 000/402] 5.15.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240613113302.116811394@linuxfoundation.org>
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <2c293d29-41da-7790-e7e3-182ba5420bf8@w6rz.net>
Date: Fri, 14 Jun 2024 05:19:56 -0700
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
X-Exim-ID: 1sI5uU-001sFc-0Q
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:43690
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIJ1XjwrJEhuEdmPC0qWDFLRNJmzeLZBb/79hvj7BJs025D/heTRJYf2bKpelWRf38z4M017vuKTX7riQYVq+FD5bTW5u4fH7CVQXZQ/eJFvQM+WXuPm
 fbu7xrzUN6pgcebjiyPR1WZaRuwGFk1iPr6c5ug5Yq2VpU2y1J3hhcMCVb++vdg05nP20nVxtzPzpg==

On 6/13/24 4:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.161 release.
> There are 402 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.161-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

