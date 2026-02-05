Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3A7198A17
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 07:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770278361; cv=none; b=HUtnJ1mLNC8pylYsLQ7WFNwV93iSLQfs9HTbF1jL04U6fsy8hq6i626CJCreDMze8/THch6Agm0vJbQOidcoNdkmAg3Nb2SNKnlTaSCgS+HdhblvIub52AT2eGCwm/LWBnHIYExxmJxWp65kk+TfqW39v1vuoGah8tBtZMpVWAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770278361; c=relaxed/simple;
	bh=2dWJIF0hDvVWfabzSZ2xLBQKHwUtCJFH3X463E1rKTk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fBZHeClupMxaHq/aifvSjJqLTM/gWnnmQn6iLKqsVmPAULVEDOvPxEJjQkTgGAbvh3l5UxQm9ujMzBSlNgJNikTLj9lr1BkzrCxHb3cd1NOPhGDBT02+EVU/Sq1m0JLGLaW0/1Eu1qmVGUhVx4mfJ/cXSOCaVk1RBnyMEizFbMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=rBsn58Lr; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="rBsn58Lr"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id ntLPvgy6uaPqLnuGmvmfJ8; Thu, 05 Feb 2026 07:59:20 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id nuGlvIHKHqfpWnuGmvdORC; Thu, 05 Feb 2026 07:59:20 +0000
X-Authority-Analysis: v=2.4 cv=A55sP7WG c=1 sm=1 tr=0 ts=69844dd8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=q+Nd4puM2eyYH+ZLn3TieuGth5fLooYeHt7SMLc7FiA=; b=rBsn58LrQuVxJXTSyhjYR0hrkB
	nzTvkM/kmEqroUYG87Kh+eywSwlaeNGuJojyR9hUnRDoGgK232zktFIBuYIzij+4GMAEtONtpHbHI
	YAPebR9twn8f+RO234wsVKUUS1nbvXCe9kPlzvJEwLcJIo6zQKJKuFwObWCyKJALPf+0xZVOodt1F
	ShGkn9ugHrOjImsD9Xib9aRksS6g8mkNs395H3pyJrwfHPQoicuXVpUWTmMoKykQO0ZSx15583VKL
	R5B+i8IYf6mvDm5hCZcLQzjJxHspr9ibkA7Nos56lxVTIsoQhEfKaYp0VDCx4g7DGmj09Ih2kvuDw
	d0ZWLvMA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:35796 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vnuGl-000000001WC-1fWF;
	Thu, 05 Feb 2026 00:59:19 -0700
Message-ID: <a8d4dd96-d81f-4d0f-9ba7-fcc277fc2c9b@w6rz.net>
Date: Wed, 4 Feb 2026 23:59:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/206] 5.15.199-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260204143858.193781818@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
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
X-Exim-ID: 1vnuGl-000000001WC-1fWF
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:35796
X-Source-Auth: re@w6rz.net
X-Email-Count: 98
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCPp8o1zR5WdjClNogfS+EgEz+i2jK/KqgWXw/A8PCjdLPz0qXVuDwkL5Nm87nVaH03e0YvKzx4Ppp4XBOsOOi99DQrVqaHTnQjXvte+ssxopXOcS/LB
 Yw0p8f3FDJIQ2nb2pHserOe502R3EFetUiG7DVG5jhYvtAEQlRIWrvNoIczf+ZVtI+uyBd6NZZyZbA==

On 2/4/26 06:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.199 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.199-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

