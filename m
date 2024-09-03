Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62331D61A6
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 07:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725348220; cv=none; b=njb1FPZ/2VSP/Bq6cl0zHyIgNFqZKMpIejifWVmO6i1iOf4QKVITnBxs5E7czabHy2iFvfGkCd7oAEwTJwx7VpVt3qxm4Vz3A9OLnnsMS8sdJWbWPOb42jBXyyIKhUuiEgB0lt+g7ER3S5go2GSauZZWKIdSLT3OkEzupLqQrJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725348220; c=relaxed/simple;
	bh=RK0CLJiWiFErOQydlKBU1W3DeY8lDl057TNHV3Wy+v0=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=E6/jjW65YA+oYVhHAu99xOFL8TgaxmkUO+FgSoPV7MmemH/XHqprtU+UVga/G6f1t4uZh4ZPmpLRGMjqr/NtJtt9EDkA3TXM3I0qVifu7jjsXXEt3UtNU9V9OwP9YsqpJCeTuARHa8N0Xs3N6xdqV+RV4wmVfPCaAt8O6voCmHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=moDCBtaw; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="moDCBtaw"
Received: from eig-obgw-5006a.ext.cloudfilter.net ([10.0.29.179])
	by cmsmtp with ESMTPS
	id lFH5sewMzg2lzlNsxsWWJd; Tue, 03 Sep 2024 07:23:31 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id lNswsQJnUX5ErlNswspFHZ; Tue, 03 Sep 2024 07:23:30 +0000
X-Authority-Analysis: v=2.4 cv=K+QkHTWI c=1 sm=1 tr=0 ts=66d6b972
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=EaEq8P2WXUwA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DoUcIWUt8XG70utxTyRBG9NRYRSVnBN6339dmTUA4hg=; b=moDCBtaw1rB7IFoiMV6EspHo+C
	kmjunu15x3xvRD9Hp5VMAaFWeCwYD1a6eTJ63EoqF5sZTzwSInrDjzwK9eEXFqSjZkawy5J//KfQk
	YPX/4qSwPLtv8kNMrwJ92fNTurc3CDY3jfqYbu8Nr9qF9BYpkVrgdzaE84u/3EUsS9/FjAOQnkC48
	oA4qT2pi94IDwMfDU2XGUfN7excYn1V397lK3aCSl9KYj9Pah66t+rwdblR+yHeNg1Kauxjl0JGAP
	IspQeKzNzyG02+Gk5dXONfuJ1CaE8+yvlNsEaBhElTLetn/X3y1/vguA0jPUm3CBEfq4a4Wo6Jozq
	AzF8Quxg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:38102 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1slNsu-003qRT-0y;
	Tue, 03 Sep 2024 01:23:28 -0600
Subject: Re: [PATCH 6.1 00/71] 6.1.108-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240901160801.879647959@linuxfoundation.org>
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <69afc5a7-91e1-bda5-98b1-7e2af6410364@w6rz.net>
Date: Tue, 3 Sep 2024 00:23:26 -0700
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
X-Exim-ID: 1slNsu-003qRT-0y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:38102
X-Source-Auth: re@w6rz.net
X-Email-Count: 41
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPzgidNwwfigR6F5JIXiXLJ+JM0Vgle0LYw6ez24dTLutp+1XBhXayWUNLsPu6fHQKmPs1AfuADvAc7Dk7vNs4+KRmd0pnSvB+oxwrq/+f5l0Ua1hXO4
 jesQRI+0wNf0EVT0uxrReCpt24M8ZHJddIURKpcWwa614edhvfDoCJp73n7Nf873VX8BfrBPZvevoQ==

On 9/1/24 9:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.108 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

