Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8EB3D0C5
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 04:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709612803; cv=none; b=VNXvmaeCQWoRhTD4nFPOf31Ui4eJfeG2I4knVXDdh8ZAkOwhs1m5rShbwGBT3kz14PN/wnXzJBAdCJDaWFrAXoKlUbitckf4PQoroiWpRUD4qDPXeuepcZKyLIhPxZ2FbJWpD7icOPX4Ze7ex1OObBMzAy3AdYjThFueY4AbA+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709612803; c=relaxed/simple;
	bh=rtJiHeGqTE2oXGz2T25urQ5qaz0PATXKFbGa8KKgonY=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=JQdDk9UQIDB8o9RsYVMBrjUQCyCy9ZJKEwMg39RQKIY/qqc5QXhZ1RWcf6CbvgnP3Rddgfp2gvkJtF1gMQmiRr7BGKCWNkknj66DEH4KynbtSY6wez+qZFtuRD/qV5jE2ZMpGyDMo7LutFPS2snAU0QKJlLPH9v9xOAdAABD/ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=s8SNqH1p; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="s8SNqH1p"
Received: from eig-obgw-5004a.ext.cloudfilter.net ([10.0.29.221])
	by cmsmtp with ESMTPS
	id hLJPr8gRjuh6shMO0rBb8j; Tue, 05 Mar 2024 04:26:40 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id hMNzrLPMCjNVZhMNzr6OHx; Tue, 05 Mar 2024 04:26:39 +0000
X-Authority-Analysis: v=2.4 cv=TJVDSUla c=1 sm=1 tr=0 ts=65e69eff
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=K6JAEmCyrfEA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0mJnJnkFSqN0d/gN5NZx+PMZOceGvfeUGQUV/Nt5jMM=; b=s8SNqH1p0P3Ydo50PFfWVSWXAU
	WjjZ4F0ZPft4rWl35uZE9X6xzuD2ZfZ8Osj61dhxR2iRhz1MKFm3mVrxoRySRE6YTcSPosE69qVXZ
	FIJMpcFT0M+spGhAc6qgqyg4ODx5lf1vsA1NGfLBxkhW/+jMFWjCGtSY2UtFPTqWUgskb3rdqeoJu
	grfWvXht6attOmWRWjEdkSoOJZTclSiya2Ggh9hUaOmhYr2bURG8xyPRrl2HdXhiy41QIH6kAa+3M
	A5JQ2bfhQ+VXVpzEWCMhfgzV5aGliJ4sExjuPTx41mrOEwIzqYFpa9DJQDaWGAxmxd0EeQLK6nIzr
	UBIO64DQ==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:49100 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rhMNw-001zsu-2p;
	Mon, 04 Mar 2024 21:26:36 -0700
Subject: Re: [PATCH 6.6 000/143] 6.6.21-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240304211549.876981797@linuxfoundation.org>
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <0bee0620-ae41-0045-4bcb-0ffcad2caf13@w6rz.net>
Date: Mon, 4 Mar 2024 20:26:34 -0800
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
X-Exim-ID: 1rhMNw-001zsu-2p
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:49100
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfOiv+jGo0oQaMUvlOOocJPsWAdxAVdcxcszAHb1vICatGjeARQml0dcgFr33Ql7boz4/o7vsk/xsAy5QYU43TerP89HkgLl9/pWQYR4u9G7Bvoqz/6vD
 E8scDl0ncAzo3EFPgYu1NK5QPF3/2xOlv+S8XPJrzCSSbG+Yj6QkaD/KBp0uLoZtwFhgDQOFqJ7QPQ==

On 3/4/24 1:22 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.21 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

