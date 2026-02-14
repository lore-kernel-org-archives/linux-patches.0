Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD76220F3E
	for <patches@lists.linux.dev>; Sat, 14 Feb 2026 10:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771065037; cv=none; b=nt2WSQnSZ/AG/6m0VHO6dj3KMnFTinXplOiDIcY6vqdoaIJ24zLoaJrmb3C2Cbxzc0Al8UZroCzpy6o/J/twx78f1C8VchKTwrxFzOIK4W8Ibo2clAxFlBBwQvgo3ZrHmI5H6qiIZYcTQIMy7bQ6t4dyLxrPNbOxs496qJdECmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771065037; c=relaxed/simple;
	bh=mhVQbn3nnML0QhmjoO5oXEEVvkbwgpE8kBzVT0J53No=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kze3EVEFkYhfrLvGHPBGKANc/rsLbg9/F6c5NFsoMGAo5mANCTMyBUgSnPRrxOK0tpFVlu3Plnojlkdg3MDbENQXrDh7jCLOWv+PVLd5aZfhFjIeW5ZEBeWsaJSuK6qXAXPsNBQ47IMZQBC/bTKhyVrVb9Pnjb9eAydkP6NFvGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=DmquhwzN; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="DmquhwzN"
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id r9Z1vfGZ9aPqLrCv5vU1LG; Sat, 14 Feb 2026 10:30:35 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id rCv4vT54zcu11rCv4vJ45X; Sat, 14 Feb 2026 10:30:34 +0000
X-Authority-Analysis: v=2.4 cv=bKYWIO+Z c=1 sm=1 tr=0 ts=69904ecb
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
	bh=uRFftV3Utlw4A0MkRmJBkp/echvduiJKql7tGexIFjA=; b=DmquhwzN5UDwX3jLG9STW7kNI6
	xatJLYJQ6PAF9iMbrQ3W0sDQyKx+ADI3Z7PnmQFTfbSvYDk93+CX3PZNhjZK8uiVXEEl68VxcPWxc
	IwytdY57K0jWvYCm2XZK1anoSNDKM+0aP3ijwxVdWnvz0Mx9XOQbji5POOledvSCHP28nWQ2G4AiD
	LZtLabvZOwiA1SYuI25TSwBwL95qZDikvWAfVyMHFaZRY9Ace56JNhHFuaM8DuK8zHowWgzE1lk2i
	6DxoLRDOcd2e6KIJxIZd4B+mqNI/l+rfadDO/TQ7SWDTwzVBTxEW3QL98KW7XvHloX+6H3FyjAtGx
	ubmy1O8Q==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:60954 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vrCv4-00000003QBZ-0xAP;
	Sat, 14 Feb 2026 03:30:34 -0700
Message-ID: <46e66366-5daa-455b-9ab9-268a033793fa@w6rz.net>
Date: Sat, 14 Feb 2026 02:30:32 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260213134708.713126210@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
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
X-Exim-ID: 1vrCv4-00000003QBZ-0xAP
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:60954
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfArODOkLqdGodv18ZKtllZ8w7g/tlKU1Z8IbFCJ2sz/GtMKJxFwDu5fBnY2aAiHRWCjO7zS6MEY8SvkrCTMkfSXGnQrvAQfurgmB540kELG7UI2JtuNE
 LYIXfTvA4meHGJ9GPRli2H37Midj2L4Ztmzpnb+/9RJtdKzUgf2cBtfcNsSFub8kY2evKYi4i8LwAw==

On 2/13/26 05:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Feb 2026 13:46:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

