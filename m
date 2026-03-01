Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3352144D7
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 21:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772401780; cv=none; b=NWi/50sNlug61bTH4LUwVqHGQPLhCIoBRB2FmDfT3fUXKiDz2/dCb5q1DpkPW4ltgcta7TliuhR5xmYqcYvV3owgxCfIxl9OClUKE0kmIeL6Fe7hAoR2gsmSdzrlmvfFN9nf3Y9TzvJb3bQA3E9uZ7DNdvhhTk5wj8YQyywAfk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772401780; c=relaxed/simple;
	bh=BKf1DYMJNOQD2urRjJQAoSxsdjHYw3h8Ut2+sh6vOSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dYOvoP8cxGEURvt9HTMJdxzGAZBDbdWUOkNPlZK2yky9DbCU/gU3Ulq1l11eiKpd33rYJprgs9cIvNRQ0KlkKF01F2UwMaOMo38EiJ6xBybDBbhrcihKphcvtWwO6rWp5YLjXY7UrQxqus5LUm3GFzVAntFXD8sdtrhBzkcoTAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=c3C/Axs0; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="c3C/Axs0"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id wLnXv12TcKjfowofMvDAgJ; Sun, 01 Mar 2026 21:49:32 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id wofLvu3K2V6WMwofLvSHrX; Sun, 01 Mar 2026 21:49:32 +0000
X-Authority-Analysis: v=2.4 cv=E//Npbdl c=1 sm=1 tr=0 ts=69a4b46c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=icscN20noawL9VZy9oeYvFFY0DdW8rj6uEOwu2FDWFU=; b=c3C/Axs0gwXN0jPVvm0/5UdBPL
	9VOaxBw47WZwy7rxqilKkkRaIIPAFDif45wYSZuuCoc71Vkj8ZXQ+VWhFUtOrEb74711Q9A7J7VGd
	nluzbU5RAlLiMEdrH3L7+GW8FIh+0HAN53ebxaoHOVehUi8t/Yk47ZrbYSfYWWzZJjQrDIapLYARm
	4GWcBI5dNowKLqauLHL6PeZKpsnxBzt8YWA3GxIRpibi7nz+HaUSV6XSy8/CcJhn8QVDigZnxT1FQ
	oPDugcHLAQ/SUQ8tk81a1RkunmyYsui+mlxtt7HRVCj5JTAkrTTT77SlVRy0p8VhSUkqOZu0+7EyU
	zMLVSZfg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:53984 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vwofL-00000001Z8v-0keB;
	Sun, 01 Mar 2026 14:49:31 -0700
Message-ID: <b0d57142-1095-4687-8ad3-f782ed09ecac@w6rz.net>
Date: Sun, 1 Mar 2026 13:49:29 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/844] 6.19.6-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228173244.1509663-1-sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260228173244.1509663-1-sashal@kernel.org>
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
X-Exim-ID: 1vwofL-00000001Z8v-0keB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:53984
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKy+4Q0LqyOUH1dYhxPkPNgvIkasqQqCtit60mxfiIRPqIaepYXL/OS0ACDa8H0sEfxj139DnG0wVncVoXOhbjc/M82uYg5BTeoGlrdntwS92XYlREEP
 xpO+5McEQdPSOtz6m8Kyop/x4asQ3eMFFCMV9jfbNl5DMvxfyZeKE1MmOwuMemOh/eOdyYj+d80ydA==

On 2/28/26 09:18, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.19.6 release.
> There are 844 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Mar  2 05:32:25 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.19.y&id2=v6.19.5
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

