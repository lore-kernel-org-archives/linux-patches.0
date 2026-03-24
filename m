Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F97C364EB5
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 08:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774340290; cv=none; b=SPhPsxliGvhe43VeVagRIezhrdIgKO5JihMw6pzN0nyTe8eE7Nu8ovWiCMtSGH5cP4JONV2dhi0vGFKy5WO0EhAZcw4AX3xQyUoSU86ZpJ/69262/OcXgkHqE6eNZtR47TqV1VMSQmf8Xl9UDpppExa2j85f/CrbCLA2ILmySfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774340290; c=relaxed/simple;
	bh=aGxwVwgY8fQlAytt/YvY0H9GHVqgVMa3vLjCLCionrk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TJqxIFiKanIlOITYJdf75xek70DEv4A6zWDjslqTSScsPq1c5j5YMSFIW5OAV85LGirLQhcItT5URffQvLiDe/NbD9IXBNHPixfJp+/07smmJpm8saXy4P5h7QICG6HTw/AYVeth60sfT3UmAJD1LHmXIBGUXUuD4MZbz3PTFRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=yt7vZFhy; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="yt7vZFhy"
Received: from eig-obgw-5003b.ext.cloudfilter.net ([10.0.29.155])
	by cmsmtp with ESMTPS
	id 4mhOwwSvlJ9SZ4wxdwRddV; Tue, 24 Mar 2026 08:18:02 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 4wxcwczt52l0k4wxdwU1tr; Tue, 24 Mar 2026 08:18:01 +0000
X-Authority-Analysis: v=2.4 cv=UfRRSLSN c=1 sm=1 tr=0 ts=69c248b9
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
	bh=307mS5r71rR6DE4nNDkKdPvGIPbBYMj5IY8JH80sgTY=; b=yt7vZFhydINQljDIB0xBszUEM8
	V0yW05qjapOPa42RnjbSN8SB5SMhKDgx4TE+NLRbDX9bPsAdZWq3fgm3M6RcJbxm7KAlnfKrTIQu4
	1vNWoJmEVGWhqMhRXKZ/ro7LY3QrouxNC0vTj7O9JsGG7b3V6+NyB0qzb0N5+Kk8Pyz3kL02uI2mr
	tQf4nSBaGnOG5ypufWqcIQDWIRB+qYx19y6xGV3rxqu/SDu+ZgB3lezjBisf1cCHgzyjf/ul7c2uF
	/85BtwVMD9jLCyOoqfjVBVjAzjLMoIuOjzCHlC39kC1qrj5AsUFzROdwCjDADHixEAb3FQxE4zybP
	1jMg2C/g==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:58338 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w4wxc-00000001AHa-1Q7O;
	Tue, 24 Mar 2026 02:18:00 -0600
Message-ID: <3505dae8-5508-42b4-ac1f-1553340bb6a8@w6rz.net>
Date: Tue, 24 Mar 2026 01:17:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/212] 6.18.20-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134503.770111826@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
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
X-Exim-ID: 1w4wxc-00000001AHa-1Q7O
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:58338
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfL1yMv57KTipZhsrr6ydHRFIPMNWPIsvihS5aXVvWV7SXBwzdDkANe1Zr6ZS2eityo27hoaAN8/8K2PIRjCxXwZxYcQNB8ma8+HB8Hpk3JjMiE98yo3P
 Rl/PHXkaX4bl27hxvDdRgQiaMBm22A2KPQnIjKghX09Jrh+sZ4JhR2f5y0aJBjSzcHlP96U4KkM2Jg==

On 3/23/26 06:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.20 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

