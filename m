Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0041E487
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 12:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772541294; cv=none; b=GHsrixforZirCIhfr7VMbdRoZC+CDAmwfwX1nBLu00gC38ezO4mEx20onVj6AJSacXSlrPAnZ/S0BoXRwCcvdOmUTx30S7HGnkf/yrc1+c0fNiFoG8TG1GHwuVkqsJ9Jo29+MnaWFeT6J7uIIYdAO2aB53plyhcBFDPFA7XnVpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772541294; c=relaxed/simple;
	bh=QE1y0XcyZwgvfESXa/V1yj/rydaAsVNuxuvPsuh4pBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KRFta+mVUi9mQdgwgZ/wttaOxWzEVSSwzcidBOXRKMVIB/GeozxWiD0WSloYX8R3lWKGsn6edDSgUqH3/xEGCyBcOiXjxllhKccxKBl4RZ8HMiV0pFEJjLU7g4fp8YlYWNCBRXP65JuzzLp8pB3PcJGT0W0t5XYpNBN3SbWX0E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=PbGf8whk; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="PbGf8whk"
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id xHV3vU9QCVCBNxOxbvgK5D; Tue, 03 Mar 2026 12:34:47 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xOxavXm1ejAxuxOxavLfVV; Tue, 03 Mar 2026 12:34:46 +0000
X-Authority-Analysis: v=2.4 cv=EoDSrTcA c=1 sm=1 tr=0 ts=69a6d567
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=hNvcaCYiSxOUgNfjoalSVHMrvMcTpzZ85ipHuVE9qow=; b=PbGf8whk4XMmfIUeP0E9CVxlyQ
	VKo6JUlDsy+QirH/WlWB+pz9fXsFUx2bL7gwg1FPNMnmpBonSp0D/0tmSEcnI2ORc5cZcLr7PGo1F
	XLHcPD/TB6EtAle8uoy0dZebXHxTyqOHqAAyPYHyWks9dg4nU+P4GgzjS4toN2TWzk8fXdz3NNwyd
	GSdtDZoBQYxUOg+kNCjA1W+itrSAJfItbPJbJ/nna5NVAdT4MJKtAXTHAl7QZLM5q2KzwdCRG8WsY
	sXrzk/ugFPJkUI+z+aJq+JTmXCjJo9Y7VxyGo2QWX7pMnwjQtnX39HKVe0h4uKNulPWkoFs7L/MTb
	LTSeQ0wA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:47268 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vxOeH-00000000heB-1MxI;
	Tue, 03 Mar 2026 05:14:49 -0700
Message-ID: <ff83d88c-e6d4-4c2a-a8de-bee4e8dc15cd@w6rz.net>
Date: Tue, 3 Mar 2026 04:14:44 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/956] 6.12.75-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160918.2520730-1-sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260302160918.2520730-1-sashal@kernel.org>
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
X-Exim-ID: 1vxOeH-00000000heB-1MxI
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:47268
X-Source-Auth: re@w6rz.net
X-Email-Count: 84
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAe6xnSjt43P1GrY8r9480luPX8nKV4xuMgcR6Uaj/eyq1GNS/sZpC6yF9/UMfZpvN8kxaCtw/UwR2fUM7LfWYLgcwPb4PQMIuVbWb9e73qk497CSTKc
 oWs38+obEwVdcjXiKwUcOd7CC0jg4U1MZshhMdz9VKYrF6AqnAjZo6vmKnsBuvqAp/YkdbXIQ+Ln7Q==

On 3/2/26 08:09, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.12.75 release.
> There are 956 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Mar  4 04:09:04 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.12.y&id2=v6.12.74
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

