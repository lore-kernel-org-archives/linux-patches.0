Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB83347BC1
	for <patches@lists.linux.dev>; Fri, 29 May 2026 05:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780032800; cv=none; b=qxbU21xW0QZZEWWpZWDcdqY/0Or5nAhw0aiDMuGnuFWHTxIN5zmiBd2bHDkUh3KN6M/xYruBPoqjS0POe28TpWjDR0hId0XIvbEfyGD0PfXB8tca1fkyBSvurCNeHbBZWDsiiQsCP6dc+ZSi3Nl11R9QQ78UOH2/vh45c9wHx2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780032800; c=relaxed/simple;
	bh=Ir0b7A60dRSaIkPxD7+mFPvIdrRtKunXu6d0i1e2aHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ijnYZQO/WnhcwdUh1IuXxo8q2UeMNhOVpoMxrAsAHB8U7cr8/G0832AOn2tUT4WGKY/yHzVxEWwYKrIIs4dix/zRKMdwRrL/twY5e2CTCuaf9VqMfWMRw2oLXjaS50wIMRPMIOedJb8TKBf36FU0gTgxec/a+3hTuxWo4X8k1OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Xvao3Qfh; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Xvao3Qfh"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id SanuwSSzjKSRRSpqLwyYJi; Fri, 29 May 2026 05:33:13 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id SpqKwsm3sfpvWSpqKwHcy7; Fri, 29 May 2026 05:33:12 +0000
X-Authority-Analysis: v=2.4 cv=Y6j4sgeN c=1 sm=1 tr=0 ts=6a192518
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=IVkBwRD5pp5JUwmdXD206SlJF9us+QKiuKtD/U8JxPI=; b=Xvao3Qfhiy8xrZTPhadJl+j4Td
	3RRIQ4PB1eJfIly8z3gFF2YBPiHepB9+SN6ipMtghVScyJyRdGGMmKwPoMp/KGHULRNKDw06IJbWE
	QBDJcflHNKWoumRhQKMxB9OsyYnRV0W5n7FlzZ1ml+UqKSzSXOzALmBhMQPR9UUi0YGbVmk/NM2lT
	cCBdSdKXvbASYC16BLeoQ+pHYFcA/GHxtGTXM8jRAJtK2iUEDl4GiRoKoOiZqXv4c2nIbav9Rto/8
	V6Pw60mckqjszcOI6HObZ9hRA92w7kLOyMyJOZiPVSSokiis0b1EGZmblyQ7zdfPGdFMsKP6/BP4Q
	+MkFMEGg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:41506 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wSpqJ-00000003u5J-3dsM;
	Thu, 28 May 2026 23:33:11 -0600
Message-ID: <a24a30ea-1c55-4197-b43b-ad7c278181be@w6rz.net>
Date: Thu, 28 May 2026 22:33:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/377] 6.18.34-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260528194638.371537336@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
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
X-Exim-ID: 1wSpqJ-00000003u5J-3dsM
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:41506
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMjgU5jfMluFWoXrwg2sUTVxMyS02BEyBCCQURF27Ayr6d7ej7R4xBjkO2dpeTXOkOK8W/ZWZe31N7k0PBsOeUaOACL1ywgYYsSVAhbRW7Xg5NiBICgq
 MBGcWXUkJlg8Q7hV93DdLMwCPOmpORILW5oROGn9hiTPxQwWtz7BtToL/btiqhRYgqsOey7zJWptGA==

On 5/28/26 12:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.34 release.
> There are 377 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 30 May 2026 19:45:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.34-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

