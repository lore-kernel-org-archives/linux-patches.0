Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD501360
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 02:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="kJ77jxSA"
Received: from eig-obgw-5009a.ext.cloudfilter.net ([10.0.29.176])
	by cmsmtp with ESMTPS
	id v9zOqQUhH8HtevU02qdYUz; Wed, 25 Oct 2023 02:52:02 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id vU01qaEM8I9guvU02qgNqi; Wed, 25 Oct 2023 02:52:02 +0000
X-Authority-Analysis: v=2.4 cv=Ds1FRUz+ c=1 sm=1 tr=0 ts=653882d2
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=bhdUkHdE2iEA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=_OMBJEvUAhyczVGQSLIA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Vf9QCsmeTEwrLa8hL7Sr2z2WQTo0ojoFeAd5yGbr6AM=; b=kJ77jxSAZiXjyUcDqggTSBGqc6
	xG4A9loaERFovKoUMNayC/tjVVXgL1GifpLkgv1aOkLKK//J7/J9rTqex5ykNMhH7w/aMA8zCVz0/
	5n0HjHC7A9QBBizkmF9ot4xahD3iOe5hbrvdw4domTfeHeFFaVI9qFnYh+bpRYL/a7p0a7CHncYgP
	iLuYAy+9HS5E49wUhnGjYfj8jIczgPiNOIuYxpVfXdhUTYvuZKoBhkpQY/GoWLI3Qht32XQ3VE/nb
	z77PQhdzm1ujl2znR62RThl+AyAXNak3427zQjBd1jZW7Tp2hJPKE+kAjMrU1Rht7SI+PYrmLLPxO
	ku5RJJbw==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:52644 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1qvTzz-001NaP-2B;
	Tue, 24 Oct 2023 20:51:59 -0600
Subject: Re: [PATCH 5.15 000/135] 5.15.137-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231024083327.980887231@linuxfoundation.org>
In-Reply-To: <20231024083327.980887231@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <e5748b29-d6c5-6c0f-6f83-84835bee31c5@w6rz.net>
Date: Tue, 24 Oct 2023 19:51:57 -0700
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
X-Exim-ID: 1qvTzz-001NaP-2B
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:52644
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCXBOLDTZdX09tHK+880D1BpEj40IjBehgMmpD6SVFD2o/8unQd9vJo1zOOY3HZiU/8itwom+ClhoGMwlhuIXJr8OfghVNYMV++RTvunpFGkiDw0sMKP
 rqSqPrj9Bz45Ksy3whlMP6YVAC2y+HqPnkuoPADOSeYrgdOedpkKqbYjWkWCbx8fyxzkLuh3T2zx9g==

On 10/24/23 1:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.137 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Oct 2023 08:32:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.137-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

