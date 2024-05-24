Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C388F29AB
	for <patches@lists.linux.dev>; Fri, 24 May 2024 08:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716540845; cv=none; b=EEJ/3c6HVefReszjs+6MNVg/Ccq0wRbB3EkXQGK9DVqM3n0NrySL8ZYHWtIoJLM3gt/8cGowrYrVc0ijpAgV0Yj2g8qAEDQ5PFC2K6zF3GUwXQfuNh5RyWEmB1baak2tu9XzAmzc6GNxjttgJNhhXicf82IDmkEBXawAQf/vZR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716540845; c=relaxed/simple;
	bh=g79TpF5NqmfM4/+AYCqHAMnlSQQsi+jBILUac8AyAJU=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=fzBLQJJBdNSBgH26dlHu8wKiYwWshcgIbDTkvCJRxNbRtz0hqcpyEIdRso/zc4N0Pg5N4pPeZ29yDDAgBqcqfDpedDiJAERCUTVKkMIXtK+n+Cp0T+yYN97x3inU8ChHuAYMkFA6mxAahjHzWK5zOpHen7TjL0fn+crQA9wERv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=wd0JHmYW; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="wd0JHmYW"
Received: from eig-obgw-5007a.ext.cloudfilter.net ([10.0.29.141])
	by cmsmtp with ESMTPS
	id AMiGsnLsexs4FAQf4sDwvF; Fri, 24 May 2024 08:52:26 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id AQf3sK7uLQJKPAQf4sIKru; Fri, 24 May 2024 08:52:26 +0000
X-Authority-Analysis: v=2.4 cv=EeHOQumC c=1 sm=1 tr=0 ts=6650554a
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=TpHVaj0NuXgA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=BXyYjBD0cXuZo9oD7aYA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=8mMZ7AvVhPnVUl8xcQJIPlIXEWATxZ5xmhCKjmdZjgI=; b=wd0JHmYW8tM2Kq/qUf303dyWWO
	UJexwYNqW4u8t4rw5iuouzWAKoQfJT6MHok1bGfc91NQnGZkHSRWb9bIVKZrGlall6b0VRIzlfgRC
	O7+AeclVtX6iX8Mz4gJ10xpWPp3fjEsD2d6XuyHjWfmCCw61rp3Wj2aN655tzgELdofZ+/gQX56SI
	+2da6obyBxbvtpz9+jdyIFjso51620+efYrTi4t4g7gupqAEbwzges1o7Z+N0ba1n8KCw8ct+sOeg
	C6/dFX/YJrNYq1peOD81Wmi9ZAQRjqgul7OmldMSa8fnhPZAXXwk0lNRC7k07z0VeE+QR722RErqF
	9BL5UWjA==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:39708 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sAQf1-002rOS-0q;
	Fri, 24 May 2024 02:52:23 -0600
Subject: Re: [PATCH 6.9 00/25] 6.9.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130330.386580714@linuxfoundation.org>
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <50c32cca-8a9c-ceda-46c3-2c86e0cc0a25@w6rz.net>
Date: Fri, 24 May 2024 01:52:20 -0700
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
X-Exim-ID: 1sAQf1-002rOS-0q
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:39708
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPq7h/0IF9R0JgaYmnD9Esstm0rTs3NGutjgvvkkU5UIEqxU3E60fEM/Zd8cxErT+maTIMQ2vcq173poiwwPcbmzk+i7+HRWa5Q+fE8Rc3h2Z0uwQa60
 8b88W6DQnkzUdjSiHlw2JJWAbNHAv6htZrRn2BqHKCypOfBQsDOA24vhhF9uzp+HEU1iyXejgbKebQ==

On 5/23/24 6:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

