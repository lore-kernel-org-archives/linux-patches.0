Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FA4225793
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 09:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738834971; cv=none; b=l5+j8dVQR3W+jFEMsqoCbjRzrG1Avq+PmJQShhFBbvkYr8Ez4h1fw4Zv9DXYaEeL/eu6txpv46aVTYjYXej/wxx37eRQ3oAixMRzo/v9HmoxabAG5yhBXkPcRpgcYiP0T1pwXiJtLCcegNSuakqlpKYi1mKtHZthTNSkr7udT/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738834971; c=relaxed/simple;
	bh=Wb2o0iIk7n5coEs9u6nS5KfJtSXUqf9HGkVWV97rNYs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FRlOwIY2F9js99Q1GKIPN84c1ih6dAkUtGJBkmIVPbFSsNquy6BFkvjRg6PlPP+nOjptkZnHA4cWTWyljFtK+IfD+SB1TABSxgmGqmD34OJXWlYXt0la5YiK2UyDhXJJDIyaTrnaWUZ/pG9R3N5Yb+OXS3vRsTmXk9Z0pncE7WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=wwTXI15w; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="wwTXI15w"
Received: from eig-obgw-6005a.ext.cloudfilter.net ([10.0.30.201])
	by cmsmtp with ESMTPS
	id fyFzt824LzZPafyPHtztvv; Thu, 06 Feb 2025 09:42:48 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id fyPHt2Ebavt5YfyPHtXsQa; Thu, 06 Feb 2025 09:42:47 +0000
X-Authority-Analysis: v=2.4 cv=c9JgQg9l c=1 sm=1 tr=0 ts=67a48417
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
	bh=vJMK8iCg2oMBunpgPvbScNcRC3FGUvorAxkIzeCDGE4=; b=wwTXI15w1PeBiN9wDaU7rTukFA
	u7PSInqABduKzGmG5cLgkBLnYGoDFEV7G5ObF1jo3PRJBbZ6WDeccYH0U34trJorrJPIS07WJOD86
	B2Cvlh8/7zSi3rwTaCQHNAsxF9RtaYNt1l6ATPqBZCZRD6Hmvy2lw8Wlmu1XrKghZBTKQcnh4mwDK
	CsdO8AfLOR2VyOTYvM3yykM3h7BS4dJWChYcGw/nINWJd4cHwNk55TQQlmxrMKpstEPFjWbBueR73
	gS1qNnVD9Wu5oE/C/Teq/hJ5XHluvqB0J40afRWhJmj5ZH9SCD3Z4z6TYVNXLL0hSP+kwx15xvCfB
	b9L6RMLQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:33754 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tfyPG-001mRg-1h;
	Thu, 06 Feb 2025 02:42:46 -0700
Message-ID: <75721b89-078b-436b-9753-981d49eb3534@w6rz.net>
Date: Thu, 6 Feb 2025 01:42:44 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/590] 6.12.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250205134455.220373560@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
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
X-Exim-ID: 1tfyPG-001mRg-1h
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:33754
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfD0WIUaUj87ASiFHyG5rF167Qbu0q9ieGW1nahvmMfo5YuIMuzEY8HXKKqByXaEc2e1rDPEvaFUahzDJ3aSjl490KOmaNXVbTaYQWLfIEXfT+E1u1A9S
 oBb26Ui3TWv07oFT1Lx+9ZcMT3sHxxKH+CAFRggSBJn1cYwAqSeLflvNTR8J4zsUthfanJZAdS+HzQ==

On 2/5/25 05:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.13 release.
> There are 590 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Feb 2025 13:43:01 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

