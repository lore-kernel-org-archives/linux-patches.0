Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6BA32F759
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 12:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772540822; cv=none; b=s5m1pg2MvXdg315gNtPwtGAIQShMaCiMEN3rPUDhtoUgcIp7p4SPZr5JnEUFdrkdU9Y/J7yFaKuN/1bb4QGCU1PhpywrF25KF5Y/r0gqH/wkmE58qc8q1JCF2CxVNtcX5osugdtmuaU9yN+/i9nX0+XIvFlSwpCIRRnGEyk5pY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772540822; c=relaxed/simple;
	bh=yB4+WOx4K2axUKnsJ2jpidIbrWvyhvuKtQ6J2hGQmXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YkLwl88V/TZZeei1ZH4TD4bgXQ8EHq9sgdzIrL6tqN2KFyHb/F7IvML3Y9s5//cDu5vghRRc3UKvfHMS6jd7Pc3aclVXcvnLj/MATSPPn8jqHVLALT1hj7owoZ0D32nRvFdESdWj3lpq58KVuQFZBrsp7nr4+uIXvi5Qg51kscI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ztjfDuLJ; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ztjfDuLJ"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id xOUjv7Dr6SkcfxOpzvsKxr; Tue, 03 Mar 2026 12:26:55 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xOpyv4FvlN3K1xOpyvOfMR; Tue, 03 Mar 2026 12:26:54 +0000
X-Authority-Analysis: v=2.4 cv=UdRRSLSN c=1 sm=1 tr=0 ts=69a6d38f
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
	bh=D8fZsfKtYTJ1PolFoPuOEXNXMVUAQrdaxOKJ9R3AKzM=; b=ztjfDuLJ34qUrhX6XrbzEZ4hE9
	Slo6IlATZs6iDMmxw9LrB7/N3VP3apgiLHLf/bx/SF2Z4kus/YaoMM1H4wdUjz6wAag7vNNuEmBfn
	Bkm6NYx8/LPpzINt+M+4EKfDHny5bG8+kzwRb09j+7fsVsYw6Lfiwfpz8D1xPFg6lg2Tgbl9L3npK
	XEFpFdBXu07AjqJ1dfhFdQD8ZPZFJYKZVF1ND5BCjmAgRaEIk/7oqjZjiLlERfWBxc93I8/2tS7pz
	HBXabJXa1HD80a7I3AbRsg+233t02W+HaG07L+kw4jJi+Q5xlrI71wXrW0PyROHk2SIjI8v81cPB6
	wXrcrD9Q==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:50052 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vxOpo-00000000leK-2ZY1;
	Tue, 03 Mar 2026 05:26:44 -0700
Message-ID: <9fe8f043-8c15-41ef-a45b-f53e25809214@w6rz.net>
Date: Tue, 3 Mar 2026 04:26:38 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160943.2522184-1-sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260302160943.2522184-1-sashal@kernel.org>
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
X-Exim-ID: 1vxOpo-00000000leK-2ZY1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:50052
X-Source-Auth: re@w6rz.net
X-Email-Count: 80
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPgkUpYQruo9ZU0NWhAWTaO/6RBAOe+oXy5qSxLBzqiraI9Yd7dix6Bbd8y1jY5c1upYl13lW85JdjW4tfvhewTMs5qgAHksMLQIW6Eite12JBkMZrjv
 e83sPLxQrYoaP1vG71LQ+nCXvGodsFXUWPnDOSNLyNvdnNu/NTYMhOyZHcwKNDOG3h/HngAavm+GGg==

On 3/2/26 08:09, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.1.165 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Mar  4 04:09:42 PM UTC 2026.
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

