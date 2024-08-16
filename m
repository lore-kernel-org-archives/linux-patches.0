Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3BA1C4637
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 20:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723840862; cv=none; b=a5RRC3HRvRa4xLJDSdeRZ4O8uU9a+9++flG2CJxJMfHQ/MC73fEw1TJHhDb5ID83qZonzeUoObt2rKOyAza8B7Ia8Lr4aenSdXRh9uP7D6SIKix/dapIpLskVp2Yza1+lYVENLq1rF7e5TQHu8S59OjxK2gi5WKdzht8WgJVHEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723840862; c=relaxed/simple;
	bh=6n4DNrXCxbHln1qbu61g0Z7t3H554RQvfsHKuhBaO/g=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=rAudBe+u3Dke+etqAYKygCgj72x10+pOufeU8CKGFr7HyOsnLhbF3cJ5SCqy2p2FXaLwaXOgszqN6hB4CfuHPIgSBlKdBCXhiym3ihYeKTIZeU8PoE7n0v/DvBzG2OEgErI7LNA2S8da+V3gxEu2VB0Y5+xTal+czl6tsb/dAhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=0LYHF1y4; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="0LYHF1y4"
Received: from eig-obgw-6001a.ext.cloudfilter.net ([10.0.30.140])
	by cmsmtp with ESMTPS
	id f39msVDF6vH7lf3kqseglP; Fri, 16 Aug 2024 20:41:00 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id f3kossVwZZlJQf3kpstvaa; Fri, 16 Aug 2024 20:40:59 +0000
X-Authority-Analysis: v=2.4 cv=DMBE4DNb c=1 sm=1 tr=0 ts=66bfb95b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yoJbH4e0A30A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=dMa8K_NYSMvRJTca4hgA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=23txTYGK1jTO3WG2tSielTbteTQEFkD3vUyAPY9Nh6U=; b=0LYHF1y4tVJhN6ruj6xXV3Itp8
	XGu/TurCj8wQ8en/gIV5U4MBfh25yHJJnMTb8QLRr1iz0JIgojzBIINwwPFpNye7CxKtIJA3/+uPp
	kpdAPv5rSTcVec8SXa87Brrw7NapNzdwGI4c4FIJDeuqPwZPV7+3aFOr68BvxZMtr6ZAXNZKHKJR4
	xPvsGOfJ1MXivL526XlCp0Pa+vr9lu1VhVtLlG0nVnVX2KD7eILZbrLk9O6ufPH3Nqrf+ZQihyq8T
	BmaxRMm4tr8FBrI64FOdDHB9PXtyGgTnYg5nwl01gLzFibuYZBVdeuVlQYr5uhGs2jT5AJRZfBzq1
	XO4r2BDA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:35220 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sf3kk-0009Nk-1F;
	Fri, 16 Aug 2024 14:40:54 -0600
Subject: Re: [PATCH 6.6 00/67] 6.6.47-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240815131838.311442229@linuxfoundation.org>
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <6e89e1a5-c379-a72d-eedc-dcec4c777f28@w6rz.net>
Date: Fri, 16 Aug 2024 13:40:47 -0700
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
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1sf3kk-0009Nk-1F
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:35220
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKY67lwwTJidSg/9bejENErfPGB/JDi+mRhIsIeEC4Xpjpe67EZPIQ5OmtdxYvBOwJSdEDTKXLsxKm0WH/86TZT/6219I4HE+GfMLFX5P2K0JguVig92
 FAoCkWKyAZw71wPOjm9B+h8Tyirong+r6WbsHwzR3KLXOYc5qjTkc7bCTH4Tf+9luKlyOugpoO5BWw==

On 8/15/24 6:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.47 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.47-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

