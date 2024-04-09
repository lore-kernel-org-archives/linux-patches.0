Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5265473F
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 03:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712631966; cv=none; b=KaeAeARdVeDjtPrOxyk4K9YWVGLXBdK2UGGX4IuKXqhyK0nRB7q/isVkFx7/M+Mif7ojtSI+wKQGl5c+GxLYxO1Sy0OkJsyeok+2zAtOdR5EJxuJyOHR2RMqmWkmGG0Ejlr4wIO2RcDT390LX9FUphlGFoxtrGYEgT5TjiJvMZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712631966; c=relaxed/simple;
	bh=1srLlaBb3CAzh3pzmayB0vpkQzdmZufUE/0AuPJvYDU=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=dsRHHAFOgJvGSHxsc/Xm5Y+Y14TAtvvDzwO7kDQXmS7/W0DCpA4FbvEuPGHbG22zNQ4biXbLB3uO/x4H01bfScMLeyB2D/+nVZVGSPPAvuwcnsSsvh3sUFqwPDAGUfcMteOMVSuPdna0tkbvDifFn4TZCtiBfi6RJO52LEgYzx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=kCNnYBLC; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="kCNnYBLC"
Received: from eig-obgw-6005a.ext.cloudfilter.net ([10.0.30.201])
	by cmsmtp with ESMTPS
	id tr1rrvBrlHXmAu1o5rtaf0; Tue, 09 Apr 2024 03:05:57 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id u1o5rzlxmHHoAu1o5r6uvu; Tue, 09 Apr 2024 03:05:57 +0000
X-Authority-Analysis: v=2.4 cv=dskQCEg4 c=1 sm=1 tr=0 ts=6614b095
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=raytVjVEu-sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=XWcTseHqe1p+jkUCD0kibrWZ3BesheZRIkkGQoLOgE0=; b=kCNnYBLCy0jt/LUZHKq6Ryckum
	E8i2LroEsBUmgZnPJr/lirozzfwjcjEzqxSA49k9WrXsDaJVVRN7Ikx/6FFTsRVsy4Ms6XALM46rB
	napalRZUoE155BAyg3dNQr/Wd/oAOZFDizpgr2Z0cQ1H10BrdvWw7jteLHIHueU6H4jEbUMAWcUv2
	WjnQgyI2UlwsvDhffzF6g9397Iql0s5YC9LUmCHnZNQTfmF6EVtUy0QSOj8JTXZco2Cie/MmpeP8O
	p+UTU7hRCwOy9ohXAzvdDNCgGUSF/3h525VHsKQDaK5P9ltbB7gambhQJmPKP2IRFacnvzZKLpoBg
	Wy4NM6TQ==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:56496 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1ru1o2-0034h7-2r;
	Mon, 08 Apr 2024 21:05:54 -0600
Subject: Re: [PATCH 6.8 000/273] 6.8.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240408125309.280181634@linuxfoundation.org>
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <4a2197b8-ba0e-75d4-f81b-b84f5fa439ec@w6rz.net>
Date: Mon, 8 Apr 2024 20:05:52 -0700
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
X-Exim-ID: 1ru1o2-0034h7-2r
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:56496
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLrDkEnd9wFPIR6C/IUxT29UTEuzvlOhl7ugTPIJLc1Wism6mekMkjQU+c9ALhP/BeKg1RpRYgAN8w3O9t0eFfW5VbKOk6j/QfYE0fkft5OdQGUs2OLr
 iKJBwte1htqUHJrwNOXoSV2ASLxshLdraOSSJLK0+Z5zAdot9LApfRnpaRv93WaC4pLDwhGhjFG9CQ==

On 4/8/24 5:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.5 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Apr 2024 12:52:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

