Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C7C19F111
	for <patches@lists.linux.dev>; Sat,  4 Oct 2025 21:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759611967; cv=none; b=AYAu/uPW4UzznBJWSSPtR90cmo8cpQEq68bCBr448xmyNMjgd5VDPbcp6k4hbaXQSt2CjPUp3MriiqlOS+CZbIppSJ3RzAdx50esrqyWWkTlS/CIlntGKVIdt7E6Hep0xg2EMdh3LQOMz5oEWGG3xfqf5Z1I+tal0CTX21JO6JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759611967; c=relaxed/simple;
	bh=Po/22EJqppzhG1Mk3xNl5M3uH6961WudLRFOeyPIs+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FHes3uXBuG5MJlGxFyTVE6wsBu4mu30UGe7Q5bW7zg3TDehbzkT/JZNjZJcfG0A7hKYiHgzZlU6RRpbHzdqeEDF+sCwG89+svg5/HuAIPoJ8MmfEtNZN9REDWwV70mc/dA+DtdrHXj4amdrHr94l1jx2N+u7S9LsIfiDFQ1T0fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=QBb3S+KH; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="QBb3S+KH"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id 52cyvDooyjzfw59S0vZWla; Sat, 04 Oct 2025 21:05:56 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 59RzvLOItt4eL59Rzveb3O; Sat, 04 Oct 2025 21:05:55 +0000
X-Authority-Analysis: v=2.4 cv=FN0bx/os c=1 sm=1 tr=0 ts=68e18c33
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=d7CMpgkK/20obOLAVZ+ihHpO1jnM5/h9/gRcJ33ehtg=; b=QBb3S+KHDIr2UDqA6Lg/QOGhIu
	M3J9XF/Y2d/MbOFNjlUzPIlZDe1cH3dUrzjQMum3FykxW/fVUTprj3oSu7IOZwyeXBIRv8Xys7vp3
	zxofYemrcvvD3XbQ8H22bl6hmpAKyfjaMb7UbYQRgjw2uKBdGYgjW2ZjjY3Eand/pDm+OgpASv48v
	YSgbORwe1t7GQz6N9SeE/TZqzh4tdlC88KCYvkQSVaKj/G2M+pW5GbY3WNFTSVGuOTfP6CviGXLxy
	Z/ZTqk55TiWkVMWWH0w3YGo1sVIoIhjeayKL5t6FoW/+eaKTd2qOQvW7PrbZEJHb/4AHFTLxb+cmO
	yQGOeZvA==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:48642 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1v59Ry-00000003k58-24LW;
	Sat, 04 Oct 2025 15:05:54 -0600
Message-ID: <47b7c020-6ad2-4f04-9ae0-e1f5a0532006@w6rz.net>
Date: Sat, 4 Oct 2025 14:05:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 00/15] 6.17.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251003160359.831046052@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
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
X-Exim-ID: 1v59Ry-00000003k58-24LW
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:48642
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJ+LlK4OhZncG/xsbeomqg+vPhZ90SWp+oEVljrBy1g8WsFdApp94syGc1WGhk5oVAXp6PPSyI906Fo0ba86kbEVeRI6AP2OKqATx/71TZf/IU9rS3xS
 bcJegUw7CQUZ92EwKuMaGN734NLagM06XJH4kC3gMG9dyAdKY3hVA0uyYP1/YfzFs+/6N1Nhi4XuQQ==

On 10/3/25 09:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.1 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

