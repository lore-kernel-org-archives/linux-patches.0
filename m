Received: from omta033.useast.a.cloudfilter.net (omta033.useast.a.cloudfilter.net [44.202.169.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA6AF2F066B
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 08:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764319515; cv=none; b=ou0WuAapf4c4srv2r8AvF5rUyzbQ8NvrRViMkz2W8X8LBG6u+IrInX8zsuI29WOATtodC1aalUhTiJ3WGIMcfyF+nJfYBrwbUxh3qjZ8Z69ulr8wwLPeAntAxio8HFny6JCV39QbfPXEm/MhipUaJyKSv5O9xL7H+XhrvcI2Vjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764319515; c=relaxed/simple;
	bh=+j0e/WCBshMYmQSKu4O199173Z3gNv3q9J2QmF7yevU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bbZqoG5cUTT3NZYi7EAwn9ddnfr/f1emRAadGfxLG24m3P+eOieew4758Yns76G6JgFUpy0/BoIm5ApOdMzPqqoXenubIXvVSzvVpTt7cmwLGFXvvf36URidifALc46tKScw/utt9tgT58/G7kRhCpMw5xbXuhGe4vwnQgMDK+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=KGGtJBco; arc=none smtp.client-ip=44.202.169.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="KGGtJBco"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id OsRyvxip2qgL9Ou4lvdG5P; Fri, 28 Nov 2025 08:43:35 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Ou4kvpWNjw44vOu4kvpma3; Fri, 28 Nov 2025 08:43:34 +0000
X-Authority-Analysis: v=2.4 cv=ePITjGp1 c=1 sm=1 tr=0 ts=692960b6
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=XxOI6gUC3NoPyDhgGR0A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/TBLF27EBlg4t0LaJnz/wHexiCU7d06ZKH84BgkFnCQ=; b=KGGtJBcoiX020mSMSiIZDMa89Q
	xGTsiGBBw/l4uk1dMJm5O54ksUeeVYj5fUqXyTpkwcuhAOiYqOJ9t1pXpLqo7szl3JopgTXtOSlm/
	ZFfTvRvOjW5sYb8GAl+mxfVdpkTa5JAUd++pNeWuB2WVB6LOQb8nBLN+6bUeEYZkxE6c+BwVEmYTj
	K8jN40Vxlla43FqhXpWPSn80jsCPlUrLlABnlssZETLm0gwj3H98NR0wM3k+0FaPo87+KFFwHsPbx
	YBe9EVS5lOM1Now39rEtYuzTcUfc5mNAhpDrWvHc1OFEICg7+m9ibel1vIdnY3RNSy6SMB46zyOD3
	KaWzYzQQ==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:51158 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vOu4j-00000001lKd-3pdF;
	Fri, 28 Nov 2025 01:43:33 -0700
Message-ID: <43e84023-7736-4d2b-ba69-65df77175168@w6rz.net>
Date: Fri, 28 Nov 2025 00:43:32 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/86] 6.6.118-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251127144027.800761504@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1vOu4j-00000001lKd-3pdF
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:51158
X-Source-Auth: re@w6rz.net
X-Email-Count: 61
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFbimHcLj7Fc2ymbOxFN6VdkD5Jl6ZQHcCQJzXTOxj4TndWa08+hyii9SNHRIckD0rOc0xlw05Krp4CqCU3CL5qIp6KEvh5UpxQKDvfUOkHg721jIMDc
 GK0wGACHFPtlwPHrO2Rh4qH7TZnjXLHilItrhJ5Zwbt9F0AL5hcxlf9smP/Wfkw9z3my4nS1fKee2A==

On 11/27/25 06:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.118 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Nov 2025 14:40:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.118-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

