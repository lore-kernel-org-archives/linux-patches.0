Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7C71F63D9
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 07:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748936609; cv=none; b=OZncq75xhkxNHgPuu1UOEA/sT0r7pClmQsNWP7zFIdPVmQaFSb7Ejv9JE1F7JLQtEDv05krg4fqZW8NqAC82Bz0O5JMVFOHLPui2YkBYiVrimFqdEeRL7XFieu36OUvECvjVDS41Y3WV3dEZl0a1OytPV7eWSxgBQTprFzmP06M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748936609; c=relaxed/simple;
	bh=yS4mv+JxO21QKaxhp2hFv4h3uZS3RJjesAtqe5PgnOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XqH267ptQ3UHMIATmzUYH21QUHzQzFmys0nSZmth72jcuZlit4XsCtnEPi+DTFtBnDvirZLHmDU3c34ZG2AERf1VH3ZEDB/r5bk85qZqk/rK8fApsnK6rYPU++0a5FfgDu45LVU4YLFPkPAM2li8N246R2mAqrDWh8vtzy+tupU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=J/PbtZRf; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="J/PbtZRf"
Received: from eig-obgw-5002a.ext.cloudfilter.net ([10.0.29.215])
	by cmsmtp with ESMTPS
	id MKEvunZjbzZPaMMIwuQWhV; Tue, 03 Jun 2025 07:43:26 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id MMIvu3Hr0J4PgMMIvuHzKO; Tue, 03 Jun 2025 07:43:25 +0000
X-Authority-Analysis: v=2.4 cv=ZaLWNdVA c=1 sm=1 tr=0 ts=683ea79d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=HhoJFD9y0GdeyuwBXJtk3soczcT7TDdsKr4ofTKY5Pc=; b=J/PbtZRflgTgKmEoPJfTrlaZQv
	Rdl5Aq5UCQ4EkgCMQmVwdwnvOp6p8Pizzh77UKvVs2LOnxzLUqXwF2Xj//r1N3Xi5T0kAMH+nToO3
	X6syadcm3Hk6NQScr+cbD9o/55sOUbG1xr9Ll0S0+6E8XowAciIZlIn4lu6ztCqTibeFtvNBThmst
	Jk067gSD8JKNGXZp9XzqKVdYVZCFV0TkdZNE4w2lxkymQWY8vg51aMONqSoziT7woVjlWLZIUvgGX
	/lOuVlLSSccjAxQ+iyglYoUnabkZO8h0OZNfG9/F1UUR17Rq1OIIjzHUTSxrmCs4CD4tOrwbZnzQZ
	FYLeb40g==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:45348 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uMMIt-00000002XTk-26Ut;
	Tue, 03 Jun 2025 01:43:23 -0600
Message-ID: <4dd70bbf-4d4a-46fe-ba87-5dc5a7aa32c5@w6rz.net>
Date: Tue, 3 Jun 2025 00:43:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/444] 6.6.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134340.906731340@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
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
X-Exim-ID: 1uMMIt-00000002XTk-26Ut
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:45348
X-Source-Auth: re@w6rz.net
X-Email-Count: 93
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHNMt3mASVv8BqozSe4ynDPa7KtP/8lEMsWU/61ToKCwjE14uNPFDN1Aik5z1nkyBQBh6GDKxcbekzdu+XzIQTf9R2qVd7pa/Tz3NkIhf1TmqNF0FyGf
 8tujZ1/bbcBKD3y8iwpl7J0m+FSuHM0CzrwurLd5PydyXXUAvnk+e2lRvKUpqDL/uwVk1RtT5KgKCw==

On 6/2/25 06:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.93 release.
> There are 444 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

