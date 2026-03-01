Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531CB2BFC7B
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 22:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772403226; cv=none; b=trqDy7fZgLePgj4YH8UzmxK030+kR/BJHByUew1B7GGGLNR8liSYcLXB49n5jFks0ymtYEbU6cQxgvwbJeqAeIxh6Y672GPc+q2MARJRihee2XALISIKMgEcx6W58d0xFSlfzcEZHcWxvd1J+6IsyG3cLRsclf5MZSpDiOKhFLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772403226; c=relaxed/simple;
	bh=gEs4HaoHTF8OGOA7yJA052UhS3XXipg/5GQUkdxlf0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LxeEk/XnuhlRH9nqsmKS4ElLZtEuhabQln+tWFoZZmdOFwon9M+OyUqNauInTllqYdMmCUrZ/N7M4hsfddeR2Q0ln+pNvsBAW/reS13zaBoU0MeaHvDz0vTlJr+AF1vuevMHjE+74JRLKSlgeDYRvKlts8W0ECqXV3vQj4oUtnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=cPhEfhaR; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="cPhEfhaR"
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id wTI2v2BilKjfowp2nvDGYF; Sun, 01 Mar 2026 22:13:45 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id wp2mvy7ndjAxuwp2mvtbDP; Sun, 01 Mar 2026 22:13:44 +0000
X-Authority-Analysis: v=2.4 cv=EoDSrTcA c=1 sm=1 tr=0 ts=69a4ba18
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
	bh=w4U3eBif6rr1moU3uICBB1et5M72luUyVFsi5JfNWnY=; b=cPhEfhaR28BlED3bKtyvxQJIGs
	GFSrBY7BQ4gAAYtV1Gva3T7TsG4xNDp++iAP2gpJ2VefRbT2JsS097U3A1t7Is7zAnb+naIQwOw3F
	PldhCnflPGprg/E3qh4ideCUGJ4DrWA8QSd4zT0wgivFqS0u3KCRFJLMQhl3Zv+3YARu0zW4z1VGR
	140BEaeW5MyMPABxY37YRHYOh219AtBBg4SdeQGJWAQk3K0/U6bDl2wD945tqEHNmW/49Gyc/RxNc
	0b/jnhSz/FoKEVMdsTRpfJunFikN3eWgDW3N5o4ov2sdFmNLyz8lRMMOnMgAXL7HTvRITxt3W7HTz
	hXST7Lqw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:45496 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vwp2l-00000001kvO-3ob1;
	Sun, 01 Mar 2026 15:13:43 -0700
Message-ID: <23139ae2-053c-4d8d-b949-a8990a768aa3@w6rz.net>
Date: Sun, 1 Mar 2026 14:13:42 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/232] 6.1.165-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228181119.1592516-1-sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260228181119.1592516-1-sashal@kernel.org>
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
X-Exim-ID: 1vwp2l-00000001kvO-3ob1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:45496
X-Source-Auth: re@w6rz.net
X-Email-Count: 59
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfM0S3p64DMDJONQZHjk570ESIiGX54//iKMuUuC+jljmPOKimv59jUtskbRWXycHd3JJpCkvnbn4WEAlbSedCydyAiGEJc4fPJz+7+ctYwfFn8m9ELrB
 d2EL4o4Co2+ecDIJy6zd3RMqKDnfcaJqs9O+fnxfXWCgu4B54+1dOEMPxkyy+LqxV5pMfBcDqQyjQg==

On 2/28/26 10:11, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.1.165 release.
> There are 232 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Mar  2 06:11:17 PM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.1.y&id2=v6.1.164
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

