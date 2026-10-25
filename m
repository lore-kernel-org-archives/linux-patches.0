Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.202.169.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792930373;
	b=TWfzAPBmKmsjdFnJxh25mpNLc102RGDi/L5ounZEUJaFlyzNkmUbSesuYOZ5CFh7J1Qa
	 Nn0mi98n/TXBtOJYcixwn9AGoWj5ChUBLznN7eqiw1PKBYL0tW3uvlqZrE8JYzEUv3Zgo
	 JJ/7QVM86MTXoLd1+SPuF48ZkySi1KJa2mex1CMwMGYwkdkD8KpKfP5ZXDRz7uzjYlcUL
	 FbPL+66w6sdlPOz2V6GDaj7EhQN3y4QVYKsyRmK9IdaJ0u+1RjzGCxiMbf0J8/N1UM/S0
	 bxWMBvVjZ6osN0VJWIgoCuJDJOi1TqFA+T3t416KOj8htCKBG+ToSkSG+V4PXHsr+vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792930373;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=1FkAHFrZwr/cZl6m1vojFQ55ADEqETD6Ysw/d07Oc7Y=;
	b=zYH0tiG4TO6yCIcth3ayNT14ugOhltbBqSMrHgc30I95RaJhAKX7ZPYzvAzOkuHSOjRJ
	 chR9+IUHhojkPMiHQYQOtFO0XyrBUeuW4WqHh3LltNV7XPh7qIOySmH5UaqL9M6/xwdPX
	 fHA0egpI737xPaYIEzQ4x04PVj9vm81jbBstL20pm2C6XytccZyGLF6m+n2JG9QbutVwS
	 z8lDGrUVAUWizCU1A8tws4OIVd1tBvZr7JfRL5mmP/h6Of/pnIo8z6f/aYio06YFdBw1g
	 Civd8khz278YiIzez2zkRvECB7fKM6r+GsNzwNXTw7lCCEJrpBLjIKyEzekkk+Z+e7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b="IXYtTV/2";
	arc=none smtp.remote-ip=44.202.169.37
Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC98606A326
	for <patches@lists.linux.dev>; Sun, 25 Oct 2026 12:12:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBC98606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=IXYtTV/2
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id KwZPxPhKRJFmFKx5nxzqET; Sun, 25 Oct 2026 12:12:51 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Kx5mxPzRHQhdvKx5nxCJLJ; Sun, 25 Oct 2026 12:12:51 +0000
X-Authority-Analysis: v=2.4 cv=Lfk86ifi c=1 sm=1 tr=0 ts=6addf243
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=3X-YNANvarMDBeD6avQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1FkAHFrZwr/cZl6m1vojFQ55ADEqETD6Ysw/d07Oc7Y=; b=IXYtTV/2CWD0yeWGjVN4k3k48J
	H7P4RGT6fcWXNIakTvBGy4Fv1aqpTMfrRXs3mT8GuAMXckPMgIIYHSeASbykYiNOV6XzNJ3BlPl0a
	lhee0qp2LhOhxa9uzGl/v7UqM5/D1PcKbkZgnhmrDg+qeSyumbfotfvm0s1thlp9QUrFV1WonSqwY
	6PUiiyoYwpDCufaTkSzKcv8zLVSSKVcKg1P1+ks3hoCOqBdTHUsxtfB3uSq3Z7klGLDwcjlFev5p+
	I8Sep+TUeXNBxYWyOfHxauz7ADSK3iwaCk8wgH1goNqV4x9QgDZDCdsqrGng+FniDZvaJdfyz5B7N
	R8Tqb4MA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:57588 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xKx5m-00000001pF3-0Y36;
	Sun, 25 Oct 2026 06:12:50 -0600
Message-ID: <567fa279-bdf9-4634-8b4d-ec64c627ebb7@w6rz.net>
Date: Sun, 25 Oct 2026 05:12:48 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/243] 7.2.13-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261024064731.125251200@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261024064731.125251200@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1xKx5m-00000001pF3-0Y36
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:57588
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAu3MeIYY4XZdf1L/v7SikHJkkPzd70XGNMum79x/jcydEVBna3AGECW2gQ5yzALsbj59XL21x8CRXVWIxs3e+yMfCRPcBfQlOHbleLbK4RxhGyGMBJy
 YcdOcUrajfLaiZ568Sw2QZfgD3XmMKKukWPb77Zm5XX2zjfzg6lc6dZW48DieR0oj365ERXQZMDQZA==

On 10/23/26 23:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.13 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 26 Oct 2026 06:46:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.13-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Upon further inspection, I've found a dmesg regression:

Oct 25 04:01:40 riscv64 kernel: faux_driver regulatory: Direct firmware load for regulatory.db failed with error -2

Unfortunately, the bisect fails to boot on the very last step. But it's either commit "fs: stop sharing fs_struct between init_task 
and pid 1" or commit "fs: add umh argument to struct kernel_clone_args".

Note that in the commit message of "fs: let idle threads share init_fs" it states "Note that kernels before 7.3 need a different 
backport.". I'm guessing all the fs: patches from Christian Brauner should be dropped.

git bisect start
# status: waiting for both good and bad commits
# bad: [7694d244b4f8a6e187060f1f66cc734f5ed16d7b] Linux 7.2.13-rc2
git bisect bad 7694d244b4f8a6e187060f1f66cc734f5ed16d7b
# status: waiting for good commit(s), bad commit known
# good: [cc9de5d4b5ab6459f5774946aa3195ad51236fa8] Linux 7.2.12
git bisect good cc9de5d4b5ab6459f5774946aa3195ad51236fa8
# bad: [fa9a1ea1fe845ef8d55048bec58f0c1914f98190] lib/crypto: arm64: Fix lost Poly1305 carry when resuming NEON state
git bisect bad fa9a1ea1fe845ef8d55048bec58f0c1914f98190
# good: [8e0e8f6a2381e3a945953f522af34add71424c89] fs: notice when init abandons fs sharing
git bisect good 8e0e8f6a2381e3a945953f522af34add71424c89
# bad: [77d6387712803b293c9735c1511a70d38d746590] ring-buffer: Use subbuf_order in available memory estimation
git bisect bad 77d6387712803b293c9735c1511a70d38d746590
# bad: [25afd3de9842d1c1f2c443fb673bf9dabd2e5ea3] net: hisilicon: hisi_femac: Move setting of netops to fix crash
git bisect bad 25afd3de9842d1c1f2c443fb673bf9dabd2e5ea3
# bad: [fc4fb8a05292c20b1f7cdc310e10dad30da3ccdc] fs: let idle threads share init_fs
git bisect bad fc4fb8a05292c20b1f7cdc310e10dad30da3ccdc
# good: [7af0a9a193154ea8818b1d46930646d94818fbc2] fs: make userspace_init_fs a dynamically-initialized pointer
git bisect good 7af0a9a193154ea8818b1d46930646d94818fbc2
# bad: [14ec8230d78887f5018867013520f05e212aa701] fs: stop sharing fs_struct between init_task and pid 1
git bisect bad 14ec8230d78887f5018867013520f05e212aa701

