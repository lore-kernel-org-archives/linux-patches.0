Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED19B2580EE
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 22:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740004469; cv=none; b=pZaXtY/y4lMjMEVLtjLw6WMUXLWj9BoVlUNR9iEq4Id4SLXvd8jr2uaoJMsikMRwBi5iPXfVRVMAOC4ywC83VOMz61ZBGBvKtodHmz+Mij+Z2pS+tRaoTc+qfVzFO1Ue15F0c0W/6aknu/H5s4X6wSRa1/dQLhGuzHN2kwRRKes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740004469; c=relaxed/simple;
	bh=SynUM2Lq+cr36Wrh30BbBrmiBuRu4pvIuqQRFZpzQGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cqyC2Cocy6jMR2Lt6alnBvpmyYoXWhhMjw7AJlmtM+EPYvavMU1T4bGieFMC+qfUwcqhtywbbqy2XFfuRJBYbpc2qn9EOapQhiRUI747J8Sic1AFQBJMT4hHxPXfbMBc447FHXO7j+dNUeoJr1PKz6U6qDsDbG+xPtHyMs2UbqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=IJFaop0X; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="IJFaop0X"
Received: from eig-obgw-5007a.ext.cloudfilter.net ([10.0.29.141])
	by cmsmtp with ESMTPS
	id kjwTtsIQFXshwkseAt3nGU; Wed, 19 Feb 2025 22:34:26 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id kse9tYD7Uqwd6kse9tw79N; Wed, 19 Feb 2025 22:34:25 +0000
X-Authority-Analysis: v=2.4 cv=dOygmvZb c=1 sm=1 tr=0 ts=67b65c71
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wj+t9WLm+9s4MykfjxmlDXFy0SWYysmW0BNZhvFJ1oQ=; b=IJFaop0XXYdPYBDuIb56aKGTi9
	fQG7eSJo0fxgiOUUt9Pd33avauP82xYD6jzw9WX8dsG7Z2t2plij/hR6TvUfXyjuKDG0p9SIZvGR4
	//9TK1Bf1OtvSAwL3ehNYfTFHI9lcmhCnDpIihg643lW5D/MRmlNz5x2ZktHLJFL3B0wdcACfD1cB
	7aXlB0FnRByY41ABxmm8PvFTQiNveVciUWmtKpWC5P5QOOOj15qw07Vmr6vXURsCxsTqSQ9caVsm/
	LhWfWuYl+4EU89l8T4eSAv6UcODj/3vwcZGwcNFs9+F2XhNO9pB2/DfxuVBMNu676KswqiCE0hadq
	3JZuJLoQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:54628 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tkse7-000EHi-0u;
	Wed, 19 Feb 2025 15:34:23 -0700
Message-ID: <eb64972d-579a-4acc-9d15-634d0a49b01a@w6rz.net>
Date: Wed, 19 Feb 2025 14:34:20 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/578] 6.1.129-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250219082652.891560343@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1tkse7-000EHi-0u
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:54628
X-Source-Auth: re@w6rz.net
X-Email-Count: 74
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNo9AjCHF61IDbaraKoRRmwRALBxTTqNgU91dpWEwiOL775NBisoYq459gCmaoIG8usQUeZJ7AL+Twu726eaN7i6j1QYHuZX1z3nil/Gv7TJIJPxSR8W
 UYpvfAYk7AGIP3xvVYeIz89Twi1zaNso45qBX5Sli+N121wAGS5+Zg9X40PdoZlswtxJQRW5Phm8pQ==

On 2/19/25 00:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.129 release.
> There are 578 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.129-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

