Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95E520FA90
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 09:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737537919; cv=none; b=ATda0phajYaf9BzBoP7s1cZAxeW8bwEPxfDG8g/hVbMmC9mM9DLdMKANyIcC3RhOmxVEke380gw493FGahi+JTxvsiKtBmwXETh8MWPALrWJg/rifXR0u3iKAnn29PxyYveuuvB4Asq4XlJZTBomItM43Z3sTXPIpqcaU1BqAwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737537919; c=relaxed/simple;
	bh=8pNMb0JP4o/bvyW+Pk9DSWQUwdyag3bbbosZK/1Qo0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ppkVnyjd3W0VBGAGB7ftrmy/qBZOwzJNez2FKbZxaKpVxxfytIAk6DWV77u/TXr94r+p5oUJYqwDmWep+wSjSnTBz+fCIM38LkuARB1eHDnEcH2H9jKZgtnR+eHABF8iOM7qsbDMHZvRwzm3DsKAEA3V1R0WHfP7KW9Q4ES7JBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=EPUDDcJM; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="EPUDDcJM"
Received: from eig-obgw-5006a.ext.cloudfilter.net ([10.0.29.179])
	by cmsmtp with ESMTPS
	id aJTntCHLeWuHKaWz6tlges; Wed, 22 Jan 2025 09:25:16 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id aWz5tmniLmsRzaWz5tSq1H; Wed, 22 Jan 2025 09:25:15 +0000
X-Authority-Analysis: v=2.4 cv=EJ8A0UZC c=1 sm=1 tr=0 ts=6790b97b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdSt8ZQiCzkA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Uq39ju6kSRtdd0OyVAAA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rWrATLw9KAaYe5G7DDzhULa7ryqVnKqVpE7hyRK1FeE=; b=EPUDDcJMATiNkD+FjcHFoL6Yrx
	PW1NO8ZmJfBn4VpzbN8RjsDCb2h6HlvkYRaYNIVYP0Y0pQQZlRtAk431S3oadrj6wyz7uYU3bWpo5
	l5d2gibTkRK7hXFiNP8tE+PVxs6d6FwimXJjxgHNFgU5QjFCC4+ShpdYmEEJaUWt1opGEZRieZ1s6
	Porm6zJeR1RNy72ERcQ0FOkIOMgseTBQlxpxhCUP22S0OUvVhzIwbEZoCI/sRxi2r+W+f0tJVCrrX
	OdSbRCHJ3X9zAgKaTEvOZ6h+UmLx9Vuk6gtWXPoEYsrZ5QQd65OP/cbc7MApNn/mFUifqL7K37Szn
	3Ei37MFA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:36776 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1taWz4-004HMI-0k;
	Wed, 22 Jan 2025 02:25:14 -0700
Message-ID: <02c15e0e-d2f7-4335-9627-5ced7dae36a2@w6rz.net>
Date: Wed, 22 Jan 2025 01:25:12 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/72] 6.6.74-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250121174523.429119852@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
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
X-Exim-ID: 1taWz4-004HMI-0k
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:36776
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfE8tbLD6hSqZlw263jiUlaTjXlwj+PAXP3zeLsFigLfIigT5MSGEgwr7evDQeAEY2GQAsGuFk5eiRkTgqxtvmwgCNUcLU3R5C7XOb+EurxGkNtYSPjmb
 ZRcajjT3g70gCnN6UD2uxBD3QRD/FhoAN11WB7XzWEfjHLEev/nzD/9rV00I+3IQ3sPmW/xWxDOmiQ==

On 1/21/25 09:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.74 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Jan 2025 17:45:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.74-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

