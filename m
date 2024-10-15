Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360B21DD0FB
	for <patches@lists.linux.dev>; Tue, 15 Oct 2024 15:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729006493; cv=none; b=dUpaJTSzXlQ9y++oN5PwNV5SZTLcOUzavibVM1gcxBOkJVirUQR2sfId8YwYRukud31CuMnNHDqX8tx9oADntra13Qb3ZHgw7j+9/7LWwVRg9o6vXRtXTBoJcutkAOg9xSS7w05REmdSIjY0NJ2fZt5oXIVCq60jjBIVWkFLL2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729006493; c=relaxed/simple;
	bh=K1RESBe6hiSI7jwJi8+1u9FQn/ETWoA9W0x4oO+1hmo=;
	h=Subject:To:Cc:References:From:In-Reply-To:Message-ID:Date:
	 MIME-Version:Content-Type; b=OXxH1A/xKilKq1cQmzJ7vX+sjXUp3FdRqB3All/+ShVgokBgMOpfXOFmTgAA4szUg+hs+7OyyvEgdfMUw+YMbBp+l9gkXIUWzN9H6qNmZ6B9Fuw5+hVOyiEU6qBD/r+npduAccjtb7+qxgYhAPKi1Yu0hdVAqU0C03SUXU+voWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=mMuuWCL0; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="mMuuWCL0"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id 0ONYtxNarVpzp0jZNtz4rX; Tue, 15 Oct 2024 15:34:45 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 0jZMtbQxx827n0jZNtx3CK; Tue, 15 Oct 2024 15:34:45 +0000
X-Authority-Analysis: v=2.4 cv=GeTcnhXL c=1 sm=1 tr=0 ts=670e8b95
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=DAUX931o1VcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=UiXv1XNBzq_yEhrWseEA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:In-Reply-To:From:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=i112Fm/NfDMeEx0S6/m50EZwebHt+8R5XKl+GAMpj2g=; b=mMuuWCL0Ovs2lIwbEvgLhgIOjl
	TIRZuwZZRdukFoY3no5dLJ8qeTTAh5Myb/bL4Liraj+1sWKNTrnha3+CBlsc15N25ir+8piEq93MC
	0kp00CFs9LhKs7vJqQJMk7exSxet1iXyph3oWxaNLQn+8pdftZ6Bi8JLjrBOLQR51GmWcusQsY0B1
	0KrSDjMfSaAXZ4lnUMUvI4vvPexeTObxgJdmOk9ECEg2RdkqyOZZNmJKXBNZktbpEJz6eo5hAbO5x
	TZF3t3uswfvIYp/ROLCj4Gwu1FPEnILo9nIJ0pdyzh58P1tzTQhAg7Iluf6Suw21vfmbR/yNlHExQ
	U+eEfiEA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:47890 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1t0jZK-00272E-26;
	Tue, 15 Oct 2024 09:34:42 -0600
Subject: Re: [PATCH 6.1 000/791] 6.1.113-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241015112501.498328041@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241015112501.498328041@linuxfoundation.org>
Message-ID: <62f2d2cb-99a4-dbc1-0f5e-ebef70386446@w6rz.net>
Date: Tue, 15 Oct 2024 08:34:40 -0700
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
X-Exim-ID: 1t0jZK-00272E-26
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:47890
X-Source-Auth: re@w6rz.net
X-Email-Count: 42
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJbUvYhPnDy3NCpdbvzctG4REd41jPr1a34tQVFses3Uli+NfTdD+rf0h/AV72fY4WLR6fn1IzecJvpPlQxFm84dzS2/zIBoDcKPmWJuYMSx2hRVW1r3
 uVoLNfDU0DLn6V/2AMzYGlYQ1bga22l4SMro+DzgyYTAxby4dlyY45A0ueHllppFMLRR6y8VcL94qw==

On 10/15/24 4:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.113 release.
> There are 791 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.113-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

