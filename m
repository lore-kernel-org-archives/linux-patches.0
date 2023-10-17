Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42F21A58B
	for <patches@lists.linux.dev>; Tue, 17 Oct 2023 07:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="GDtY30nm"
Received: from eig-obgw-6005a.ext.cloudfilter.net ([10.0.30.201])
	by cmsmtp with ESMTPS
	id sWJfqQCfaCtB2seZfqIjOK; Tue, 17 Oct 2023 07:33:07 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id sea7q3OKDqfNqsea8qL1ht; Tue, 17 Oct 2023 07:33:36 +0000
X-Authority-Analysis: v=2.4 cv=LK11/ba9 c=1 sm=1 tr=0 ts=652e38d0
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=bhdUkHdE2iEA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Anv-yIGj03VSDu8hvJIA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=XS4UdtZkqIX7yvrBUPZ9vRr27DkHJZdWdIMYkybWEJQ=; b=GDtY30nmAKP2UBCFyymd4r8qSE
	Q6LOlAQrXBSfZgt5gnoCCVOPmswh7oEeTlXtl5UoRTveb5jZGkyUlTGJni/L0fC9jpiqTorlJFtUu
	bnaHecagG+JFBhBTXZifhsjfLtn/+PYGx+MTTtllsde4YW85tfUM5YoOZtJMORbMk2fkZwLP8YHHU
	D31lo0GVIXdF4vdehPJy34yTqtmqgsQL7/OHTYZNrr9D7fNLH7fPphmwDMEjr+yagWtpipUTeIZBb
	jlqqnH1OTZbDXHwj7q+yHYaP7gRaFXZG6HevHhJ4qaUOjakIL8RGZPRXoT+MyhanaHLat7N3Wz8cn
	95pfy2iw==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:51582 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.1)
	(envelope-from <re@w6rz.net>)
	id 1qsea5-001YKH-2l;
	Tue, 17 Oct 2023 01:33:33 -0600
Subject: Re: [PATCH 6.5 000/190] 6.5.8-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231016185002.371937173@linuxfoundation.org>
In-Reply-To: <20231016185002.371937173@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <e0982f8f-1572-8ab5-8869-195030025230@w6rz.net>
Date: Tue, 17 Oct 2023 00:33:26 -0700
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
X-Exim-ID: 1qsea5-001YKH-2l
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:51582
X-Source-Auth: re@w6rz.net
X-Email-Count: 20
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDCZRRGpqEa39R0dEe2FBO76b5FvMN4pRFGemX1pxwasywEa96PyJNSFDZR61SZWSeiAnnVnz7aPtBO+g0os1Vnac1mskhk8pislOT30GYB9bzKrgUuh
 plfR1Udh/gg025Og5SpmOVfKFYuvGDDWJq6v8hNdVaTXyVby2eqZzhul9+VjOqClkC6e8EIi+U/Vbg==

On 10/16/23 12:48 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.8 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Oct 2023 18:48:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

