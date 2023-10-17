Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A9C747B
	for <patches@lists.linux.dev>; Tue, 17 Oct 2023 07:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="WWPW8BcI"
Received: from eig-obgw-5009a.ext.cloudfilter.net ([10.0.29.176])
	by cmsmtp with ESMTPS
	id sWYvqnSnDq5JYseW4qRSXz; Tue, 17 Oct 2023 07:29:24 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id seW3qrdaaaAyzseW3qgXeQ; Tue, 17 Oct 2023 07:29:23 +0000
X-Authority-Analysis: v=2.4 cv=D/RUl9dj c=1 sm=1 tr=0 ts=652e37d3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=bhdUkHdE2iEA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=nVRhpLHY2Gk3QZ1Fk7gA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gdSZ8J7VlPPv7NrYIB84zZHVdrpdCDfCf/PUphb8FMk=; b=WWPW8BcIOioFpyzVNjW+pqRjXt
	xpQti3YNFJtNaXd9WHTYZAc6FU6a0Wo0KGN0RTnPETQx5vEdCnL/TTjE2dv8DADsk+ixVCVNli16b
	89ePiOFA5D+nJXl4/lXeAJAe/G/OfVOpfPSE8+DghMhdtYTdMQ1Gf/LMnFkIC6fTANOAvBxepgWgz
	K6sOCIQw62yk7+ihf5znoYEPm6e4vkKZmKpp5CmtU1V65mxIzEFrS1PQfh3i2VqMzcCz5R+LEt1N6
	hxAxjCJovW2fj1OCkFdSHecaHo5cqUvUQpeJjHxWcgSn6J9W2VZHuRbsdE1EXXCRtSrJCqIFJmwSh
	kujegF3Q==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:51574 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.1)
	(envelope-from <re@w6rz.net>)
	id 1qseW0-001WUJ-2Z;
	Tue, 17 Oct 2023 01:29:20 -0600
Subject: Re: [PATCH 6.5 000/191] 6.5.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231016084015.400031271@linuxfoundation.org>
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <cebdc3ca-679e-6897-ad35-b6a3ef42ce8c@w6rz.net>
Date: Tue, 17 Oct 2023 00:29:14 -0700
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
X-Exim-ID: 1qseW0-001WUJ-2Z
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:51574
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBtm+lZaOprYuWQ9pX5biEGcdLpLZLYz+0ALbi+UU3OF6fk1Jo7LrDPhT6cqbxMURM3KYWN9haX6v5SzvOcLgqiR1jrLh6VwWhza3je5hXzzCuveYTSN
 syFUiwqTxLxAkJHeDHQxkcagNmuSLF04IDuDoyeOm5O/XG7wzdy/n6NODavgvJVJnfVai863YXeQlw==

On 10/16/23 1:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.8 release.
> There are 191 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Oct 2023 08:39:48 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

