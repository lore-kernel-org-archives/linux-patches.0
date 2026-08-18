Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1DE449EA6
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 09:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787046938; cv=none; b=o927/PYN0jYIUxcnBT8M4rmmdUYvONz3orckAflt+4B3SIWC44l514kkO0kYSypk4uuhVlbmtoVVyiTNqIH8HsBplM7Vc6N7FzljujCsJYRihLK50zMCG7P0mcUFRoX3bLmkz1uCxJgEk0mK3yhmNsshi2yiTVuTB+IJQQSn6iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787046938; c=relaxed/simple;
	bh=1vbP4WhIUGNliUOAuYt2b4I/CzcRo4D9AQ/QRMHhbIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IU69c0DQMVcIxiQtxpdNilqAxrv7YRJVoZEcLMiuJMgiXCbJ48Wgs1xCuIJ1CRVYEQGUFTuadSMc+Zx4vySnWK+Nh0VeBgtqaVLUAUfjiR65UaBocx8WadF6V4uuqfow7Z7ft7jLSSXP7q2LGd4fIC/s+LqioDpVtbXd5ZVFF20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=a/lL048J; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="a/lL048J"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id wEjtwKOJPuFzgwGW8w14i6; Tue, 18 Aug 2026 09:54:00 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id wGW7wpHG3XiyOwGW8wIAWL; Tue, 18 Aug 2026 09:54:00 +0000
X-Authority-Analysis: v=2.4 cv=P7w6hjAu c=1 sm=1 tr=0 ts=6a842bb8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=e2snAWBNl3fu4k9McZjqAZKu+oCQb1/46QZvkM9P13w=; b=a/lL048JaYfPUabHsdHlwA/5ez
	j7TgytyNTx8Oba6UcDHvR8wPiPdQffA/418xtStVD5w3u1WIhf95CBRLSOaR4px9iavcDMuwRU6xD
	WHHGbvCZKNo3FQujTmMK3Xxz2zhk08UppHnRhVPLnPQnlQNtiu27xL7o/XfdLgsDGUwkzTEE8DiCB
	jjN1fTnjALk3pz9Id3lyuroVlMfMa7bLDazKzKJYCiSQC9yQjQY6SRA3DxLxKJ0s/3rRRzLANChQq
	uUBYfHx0qCX+bPWXMOx5O8V2lyYwZv/+NlvEy9juxivAgzorc9QmPvbnGV8AVMgSCABf16sJUJ+SB
	e8iDmCGA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:49470 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wwGW7-000000029St-0jvd;
	Tue, 18 Aug 2026 03:53:59 -0600
Message-ID: <05829366-d5a8-4d68-aac4-182a465f3565@w6rz.net>
Date: Tue, 18 Aug 2026 02:53:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/250] 6.18.45-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132536.466235697@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
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
X-Exim-ID: 1wwGW7-000000029St-0jvd
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:49470
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHhTB0ZEsSmdzVhZDL+vzYRu5gnIvIbpsAWPZkIkQ1DROjcvmsqOsyGVMp+QzSkNJQ8jemSaxXKes5EDxsmS2Y3tkPoQkYLmh8ggE6duB/0wYE2uPvFi
 PiQNvtodWVfwBdEcf+wr0TUdALmmKlDsZGskieBIRkZ8eoP+F3Shj9ANsx6NngY0xBkPUvIHpWOrQA==

On 8/17/26 06:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.45 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.45-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

