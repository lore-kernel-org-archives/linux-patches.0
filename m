Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD45517543
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 08:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706083737; cv=none; b=hqWfVn9gg7dZ5Z6o8bcuciKcoP1yQpSOK/zBry8kI0wIuAA5rS0YoLrKer7WQNza2N91HUJnddZMorc0Tk548NqsZjqm8RXewlnv4968kQzR5nwyIjMdpVWYBV+n9WWRa8nSDmUC1eVBiWDjVAOiPMRVZ8LbUyNa1DOwK77Kpeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706083737; c=relaxed/simple;
	bh=tjVRPp2Co4O6lcVg8LQ/3gjn1vR4oh5ntnSyXvu+OP8=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=KN3Th72uHErCyirWL92cVZk/aV++NVvYeGRlTaq0tpcDdydFr/Kr3U0cmH3joBMmXRMFjA+1KN+oMso7FiSMXmQVGGBHkCHiosQ7cPn62rIWJklxpiOwCTD/q6uaXBDdMd/DjDpjYQ1BuL3g0rcOv6N+mHcIrWE5TG2ALZp82c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=2bjnlo9X; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="2bjnlo9X"
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
	by cmsmtp with ESMTPS
	id SHvdr6cRNoMN9SYJUr9oe5; Wed, 24 Jan 2024 08:08:48 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id SYJTr13t3RT1bSYJUrgX8K; Wed, 24 Jan 2024 08:08:48 +0000
X-Authority-Analysis: v=2.4 cv=MKVzJeVl c=1 sm=1 tr=0 ts=65b0c590
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=dEuoMetlWLkA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=wAV19y9ws7N_jJsmqfMA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=mDJLb2MtZ3S/4kIFAcYBVF0r8/J/DLjrlxCA2XTsWR0=; b=2bjnlo9X4ih2STIWOEj2LUTazs
	BqieNQjeo4sclcvpgIANSZRBLREhqFzVIH/X1C59I4+lW3NDeJiufi8aPllsD5TEGBkniUADKkDHX
	FQFHqNenTC3E3d6e/BQNRIsF3yS7JhJy2gazgvRRyWfB0kyR89w0nc4snScdJAlNzF7XBDVOnMX81
	f6E2GztkyJKuFyRqNGayjK1NkYyVOIZXYI/Xwa4SiwVjGs22yQYn2HIYVwctQjlpT6AvSeJ1zk4xM
	4ZeDtsPzFME7bsqhRn6pPoeeMV3rUuCkA3X/oe6o2jmyTyDlhZqzCQ6EMdZ102z9FXgj1XciFYGFD
	ByiF52JQ==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:36744 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rSYJR-002UHK-1m;
	Wed, 24 Jan 2024 01:08:45 -0700
Subject: Re: [PATCH 6.1 000/414] 6.1.75-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240123174510.372863442@linuxfoundation.org>
In-Reply-To: <20240123174510.372863442@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <103b7674-d2bd-02a7-6035-946b2cc8a755@w6rz.net>
Date: Wed, 24 Jan 2024 00:08:43 -0800
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
X-Exim-ID: 1rSYJR-002UHK-1m
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:36744
X-Source-Auth: re@w6rz.net
X-Email-Count: 21
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHdBXN3jCcCI5vsfyGfDb+wAlad8ih1ZyhXBGgB65LJbkXXIMl+KYO1OZ53cT2U+lcORSrp/ngK51GgHh2Rz5+hQtcMwGUjwL7krDh6edbCnYEboLM2G
 JTDkPRvuFPhL8ufYaEkk/TEcDmCXuPEVuG3bj9rkYI/sSdRzp9/g9uYKYWYsseQROJcGttu6QZRBBQ==

On 1/23/24 9:47 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.75 release.
> There are 414 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Jan 2024 17:44:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.75-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

