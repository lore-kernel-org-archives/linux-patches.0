Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF79638BF85
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 09:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772011092; cv=none; b=AgRQ9EevI7EIzuspMdmaFtCagSYW2Qcdatec0S1sF13SUkyehHjGhfyty9qfp5Ln8DvC1oExj0n1L6Amc2FsDtkjThKBJnfmSOPRkS4JrkxhgTmIcY+1RZQYh9DMz4n3lCp+eJy3rYyinYWj75UspY1QPB7aeyGYJxK6PnLffOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772011092; c=relaxed/simple;
	bh=MMwGGEEnyaKWyggym/xwedompx1+jdn/7ihSagtsb0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ATgk+f1C+Kseq4yr/CHVH4pPJxxpysvZaUeue0HfnFQ9BWKKv1G3N6rL7V5HY4ZskhiczKVKgC4FNTlu4UNW3mecOCRVGO3JR3DoETPLXeweREWsDIQqqDOhyW5hXipAxRfz04cAcMDH34Swk0nfrcfbP4aI8yP0VLJ42E2Ncqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ak+MYosH; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ak+MYosH"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id v8PGvb6i0aPqLvB20vqX9t; Wed, 25 Feb 2026 09:18:08 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id vB1zvGUnRPL32vB1zvECva; Wed, 25 Feb 2026 09:18:07 +0000
X-Authority-Analysis: v=2.4 cv=MqhS63ae c=1 sm=1 tr=0 ts=699ebe4f
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=AKe3ooYFs9pqdXT75enX0rjg6PXGXFTaUMMp2vQInlI=; b=ak+MYosHJfCL5W2msp+qs9TvNx
	1sNN1fNGMHFTvcHhOEf9ZZ1mOmf/plCxYj9bSKJ+kHk0AWf6c5iQjrxriLLh2JQ4cERC9176Vazic
	+o20nmzNOHkxgG3aO45IS+i7Kxx2itAd/Hxfk7VAGvI/kOL0chviIt6ptxjuamOIxVwwDpR2+yJW3
	IhFkb1Z49pDHhX9B+I9nAwptBIOWf8qXtP+ISBJQx23Oc4CBliLDQfwC6kMXzJZ49Pi0PTuvNRXIo
	02WAMzvzsXXzhzIHJesV5l+TxaNrD+wQo8Yt8+xb8J2kM7cgOnFfr4Fp9ZDBgGz21Jlt4bjMDSt6X
	1ueCREng==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:34348 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vvB1y-00000001Mad-3ieZ;
	Wed, 25 Feb 2026 02:18:06 -0700
Message-ID: <765c8a31-8408-42b6-9d07-fa59b0c99fe9@w6rz.net>
Date: Wed, 25 Feb 2026 01:18:05 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260225012359.695468795@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
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
X-Exim-ID: 1vvB1y-00000001Mad-3ieZ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:34348
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfEbPUkLvUDsy4m6YD6Rpyvs+U2/cagYdVsbputciUQELhnRRblowmO64ScRJk86435mWJqN0JqaRgLmatQWHcwZnfepe/et35bfdw8of1ngYoRLILCRj
 byq1uQ9j+mnTlElvCXWB8wbLMldfZCYfUvcL99pJrGnFoTQDRwSTm9KKYs2Qcq4TfCzCK9Atzf05Cw==

On 2/24/26 17:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 27 Feb 2026 01:22:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

