Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF208F6D
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 00:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731457903; cv=none; b=fzhQs51PB0ZdV8RfKsLMlm6r8Vwfp/KWph1AhEjf299OaeivEhfIVpzSlwxmdwvVxZrAQQHMp2gdGkuw+DhdaD05QRhvzNbD1dLIH7DDZmxeLxrK5b+Ezsuxef7jRoHyB6T1h+hrVwkmJhI7IeXYnvGxbCy0P9yQuT/dFsXFN9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731457903; c=relaxed/simple;
	bh=BXYnbyD5Pa9/PcgnAk2NFGYl1EcVhZ+i4oG4geqloM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QK7UgBq6TSI6VGzqIwlnFp7Gbmb1WZPOCXt+mttQFtIy5LSxiepsbw6KrulJpiyQv/PX/pbKGR5+PbS1DgHxXjsV+r2IY8HzD10qVxgmVlSSKBK5mhsMLrs4t53OYMYABRLIMOJcR7LhUIBCeplPnGmuVCSbjfFfd8yjm1sYnXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=uvKzD8hg; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="uvKzD8hg"
Received: from eig-obgw-5009a.ext.cloudfilter.net ([10.0.29.176])
	by cmsmtp with ESMTPS
	id Ay2ptdgBFg2lzB1IEtFC9M; Wed, 13 Nov 2024 00:31:34 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id B1IDtEqobi85LB1IEtA67I; Wed, 13 Nov 2024 00:31:34 +0000
X-Authority-Analysis: v=2.4 cv=N74vFX9B c=1 sm=1 tr=0 ts=6733f366
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VlfZXiiP6vEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Xg3r5l62jPq6txtoRjwA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2v3PU0kAByrpk1fKvhdLL2XQ7WWMq+VQ2i357XT9vTg=; b=uvKzD8hgKyNoVCX5EJPtobNmCp
	I4Ocqz6KbzC4GAyoWCIH6uycAYGvNXJQGmfYQdi4lCOPpI4BRY4q9ULHYaYlkpVKz24vQ6gRI81nM
	8MkZnYLfhZ2WiPA5oZpSu7ByzTDUOpdnPUkf7zx1ST1foeW1r+tfuWXHWFhScw97ge0COCIONJPlS
	b3Bggh2BK+LWvWPCPg/MX1wqhVuUjlLFU/NA+2y4hfX/ATSUNz/MWc03I/SaxSDj/mIKQb6Gn7jvm
	P/uJHtwl1f1iV1drcm5XTVy2t+mcp5ouLDooRQ+nz87/sZte9K4M7YedRO83silfF+/EYD4RgI/ox
	hS01UaFQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:38924 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tB1IC-0042OK-1g;
	Tue, 12 Nov 2024 17:31:32 -0700
Message-ID: <12c23f81-df78-48f7-b923-a31a5b3d75a0@w6rz.net>
Date: Tue, 12 Nov 2024 16:31:30 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/119] 6.6.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241112101848.708153352@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
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
X-Exim-ID: 1tB1IC-0042OK-1g
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:38924
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJTfuNEoHIMt35e5+QfCO6g2XDiEdVFLjuRyD+Vcqc4sT3aFn+V1q76LGeVGlAPGcFSy7NX7LYazu+ft/L0OndJBUMLFxrQoIs1j7x1hEu6t8Slamm8U
 YrRNxKzWs72TGIZ2DaABsj/33UnwzdjLtLt7bzFNA2B9G4FFrlF9MvFAvuKaZlmFjXLw32vEG9BZkw==

On 11/12/24 02:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.61 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.61-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

