Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE579453
	for <patches@lists.linux.dev>; Sat, 25 Nov 2023 09:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="xE4jfUAF"
Received: from eig-obgw-5005a.ext.cloudfilter.net ([10.0.29.234])
	by cmsmtp with ESMTPS
	id 6coPr1aKNhqFd6p9prIqHH; Sat, 25 Nov 2023 09:41:01 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 6p9orNsGh1b9N6p9orMGA3; Sat, 25 Nov 2023 09:41:00 +0000
X-Authority-Analysis: v=2.4 cv=FLYIesks c=1 sm=1 tr=0 ts=6561c12d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=BNY50KLci1gA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=vGS5dqk7DHs2eXP7cbUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=QOgGvUe20mf6Hy9UoaacYblwjaB8PTJVfmAJuKIWXoQ=; b=xE4jfUAFVSjcxM7QIP0WPqfHnJ
	Xv7ai5mw7Rv1oQJiLfhwEFr060nWiQRZ/oqxpuupi1+pHw+oXCOeD8l8AgmGoMG7SgXBU20EOE12Q
	08/m11Z4D4/IU6gYU8AYaqMCqWAi0GJtrs8OICbraYZq0HYILtsq0xo2Q0i1ZdJyxnxxCNkvOYUvf
	FcVbbYPyXc1zowE+HkMobe4eMrau3ls8C3hwGnjibmiNwwkDTzkTp1f2s3yFXNtnTzEjty94EuoQz
	3N9PUFk9LZFM7/5cgAtehUophUTjsp/n+8QJgwOH5IX5VocEsfbRjew8hVP5UYA1uDOiNMiaDia3x
	7YCyx4Iw==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:56744 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1r6p9m-001jDn-01;
	Sat, 25 Nov 2023 02:40:58 -0700
Subject: Re: [PATCH 6.6 000/530] 6.6.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231124172028.107505484@linuxfoundation.org>
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <6e35c454-af5e-1e1e-37e8-fe42e59ac844@w6rz.net>
Date: Sat, 25 Nov 2023 01:40:55 -0800
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
X-Exim-ID: 1r6p9m-001jDn-01
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:56744
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLjf7JBtP6cjK84vvxOxwuD35XpOlKZUoMjQ33x7ozwK7k5obv+p6GVS1izcVpGxhi7sVWwnfbXavMTct31Jit2Mq06ro84dN1M+7OtEiMNXXDs5pWYm
 v5g90euCMpN7stOCpGi6PhwnBmLS+1/qdSa6qmwzah9BaocOWYcUelVwzqkkxwxG21xTx5QBCRwE3g==

On 11/24/23 9:42 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.3 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

