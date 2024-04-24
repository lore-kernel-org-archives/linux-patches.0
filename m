Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC3D157468
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 08:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713947204; cv=none; b=R2VvrKF90dClPeS1UiVYI6s4JDaT3IdxNl+qcG0359TityQywPY3x5ZgPI0GOy04bGlx8LbnRuCTXE4lpAWkmJLkzL3QYmwE4JfREvhG6g2wvUBgBlLsJ9sH/13oICrknV/IPYnvClsYa8W9HE+xFza4V5ymJOKjhhKwULNjVzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713947204; c=relaxed/simple;
	bh=/McE5mTXtuwDTyfGYM/K02HZiI8R+y8gSoKAk0VlCN8=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=uUyfPNgkqTvNrQDZu3ZBHQWhLPtCYK21be3rX+/vSKUV2qfLIWp9HeLt/WFxTGRcg5V/gDCD3VBHJ68Q3PUWluAIdkiKDOQuyYCtHjlPs50J5BeW0CNzAKYdrrPmlIFguwve8FRu9mQBTXeuWqO5hZXR4xBp6Nn8h1vP62tYFOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=S2LZXF8P; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="S2LZXF8P"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id zKbLrOVQSQr4SzXwArGqRJ; Wed, 24 Apr 2024 08:25:06 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id zXwArcErcsT9BzXwArNG8h; Wed, 24 Apr 2024 08:25:06 +0000
X-Authority-Analysis: v=2.4 cv=LIutQ4W9 c=1 sm=1 tr=0 ts=6628c1e2
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=raytVjVEu-sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=CMKPsDBNFkSOfaRWdswA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0mOX9MgjqqmtOtuSB6MNWCwKvl7Kg5xuKiNv9Ti0oHg=; b=S2LZXF8PPmjurjyXTFXEkoLtH9
	Jsmu7BBgPK4Fa0AQvb2do/qVxKo9kUSVT67Nykqa541TCL210m+5W7PlW2dykO3uOJ7lwVzB+jM5P
	CkJ6HjInVkW/aWer4irkWIBOLizdGbG59EXQlfBrPpPvvMNim3H8qoufmSd5Ko/6jRZ+zYixFoT6H
	jPmE/YRxzgEFpSWn+nk76w9jHeP4ZZvg7JIhbCKoUbe0hvsFMLpsqk4puwIuxS78ur4O+0hUZf/YY
	7rl0pNx0JD9aPOrFsAQWdOj8Sdn3CnXCmUOnhLlihYGelzvQYCwbWlnjp6C8iHPoOkY5KHiy5aSMS
	5JT7kk/w==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:59350 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rzXw7-003bgc-0l;
	Wed, 24 Apr 2024 02:25:03 -0600
Subject: Re: [PATCH 6.6 000/158] 6.6.29-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240423213855.696477232@linuxfoundation.org>
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <897dd6c9-7dd4-5c30-3b4e-3d055130e0f5@w6rz.net>
Date: Wed, 24 Apr 2024 01:25:00 -0700
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
X-Exim-ID: 1rzXw7-003bgc-0l
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:59350
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNGrUbLHaidHKgoBswwh/21PrAKwbByomZK28nTxEoKkonJ0KRBcq/DthH7yyiy2s1SlYvM7EScwFKYnjApkW9EPLESu6WHagAqozSVbdk2jC0KEq2ix
 0VmCLpFUvgIDRhU6P7tEWtKY+NTGl1f5dwNucjBl8+SBQaufCJ5+efyteEi+orcUM8XARHER7MxDKQ==

On 4/23/24 2:37 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.29 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.29-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>
