Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F8C33A71E
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 07:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770710336; cv=none; b=pIxABNQBqSAQ75R0NSUqAF2SyN0F7Mj4p4u1eV9OANOZI5EqsPKNRbYRy6qwQYjgge8eu134ApUBm3re8SCL4mG8bXPXBpqHohVzPKuo2nfzeMQRNnP2eXbDTXtc4N/LddHSZuonAyuyMc1093XBa02H7V+/vmcNXGmmrTtZXzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770710336; c=relaxed/simple;
	bh=1/Wjh1IrM1DeJtN0jeODxzLA4DL2I8UA3kCBfWwOP1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gh3b5pYYFMtlFpYsdMTqeC+eoTeAt26ko8E3VlGM+9qrhZ6EL8Uou+43xTaTUhBDaHItkNXkf5b13U1D19L0Epd8gBROxeRIBapFA2OTbDzc8AWOBSKkcL3tlDKVI0oYCJrmpbOpTCqLUhZZwA2L2u8N1m43vKqUnQw/sxEKDOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=2ToDphdz; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="2ToDphdz"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id pfr2vRuw4Kjfopie5vUhEB; Tue, 10 Feb 2026 07:58:54 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id pie5vPvbPN3K1pie5vZGgI; Tue, 10 Feb 2026 07:58:53 +0000
X-Authority-Analysis: v=2.4 cv=UdRRSLSN c=1 sm=1 tr=0 ts=698ae53d
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
	bh=JpSLuJCMUnb5UpE9ZlareAMMkVpRSsX9qyI6fQJ169M=; b=2ToDphdz1sxNK3PTufO5jGvbdg
	CVhLaoJVuUfl75DNvTrK9sSGaXLnJOeB9Qemdi5GFpLvNi7YNMOx9x8lkCeAeQizycUkELLG7Gd1y
	05awyNNhdlHbLhf20Th0G2n+QdXcSX/QWUyzqFkUZ8TkjvzNK8xtwBuRB94reHdE05OUvcS/ZrEnL
	hZ9A6ADIQXee7h97lKpLWDZTonnThZ8rKNISG7qAbQ7NfGe+JN0g+wolmUpezXz2uaUxVfCGKMpEQ
	ECh9I3IsAi0YnGMxw2dKgnLjveZLJtjKwNTSDECZx07bsF9tmRYpK9+2Sft2BMgu6sF9PM4KasbSS
	I3QYAAIg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:35274 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vpie4-00000004KtS-2XEB;
	Tue, 10 Feb 2026 00:58:52 -0700
Message-ID: <15d48101-c50d-4c9d-8c9b-5f21a43a83ea@w6rz.net>
Date: Mon, 9 Feb 2026 23:58:50 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/86] 6.6.124-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260209142304.770150175@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
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
X-Exim-ID: 1vpie4-00000004KtS-2XEB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:35274
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPbzy+ZJMWrInXGSvi81BHtNmxijHeYHRn8BwXqVU+KvbywsYxay+owKEgxjSWPdCVIKuQ+e4DDbyiNx1xTc45yogg4pQv6j3Eij+R0uUd9TyiAOeAJj
 Lpw6SAIFEbQbzX/6LixfRX191+xsQGnakotF1t5KjzBhIZQH4VT4xCaGU+5xAcf0DoRbnNSff9yv5g==

On 2/9/26 06:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.124 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.124-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

