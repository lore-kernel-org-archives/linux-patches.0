Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D7F378D8C
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 10:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769681639; cv=none; b=mv1izbsB/NZ8qaK+dRw15U6dzro+a4qTby4ikB2Uu689qySTwqz0HM9TckKCGzaC+Zh8/ojqdf4tYwiLaTVZ9tqBfG5GUp1QdKKRLvr3MCsalTqI4JulaOe2GtIRMlmeLQYj/dn4yFoh8jfYHoWHR9NUIRQTSneiNDc/vEhfWG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769681639; c=relaxed/simple;
	bh=ZxtJuxhZoa3erhjlbVEKcHFLGa59wlKEFbgprn9OaDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ddfVXzjF3iTvTYfhwV+RrMzrlEJ1DO+bXm8MckGgIc7g+Cf3n4gifQUBr51SVyVGh1+c6NTvcIA68aZ+mnA0DdP4x2PBrDxH+kZZ4v/l+iP+rmnqSGdarjPQOa5Dw4mZaxFGOkbDkAAIhDktFL2/acovewMp2+/oQeoUcvb6dlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=c6zM+V8H; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="c6zM+V8H"
Received: from eig-obgw-5003b.ext.cloudfilter.net ([10.0.29.155])
	by cmsmtp with ESMTPS
	id lN5xvhwhuCxrGlP0fvCqrJ; Thu, 29 Jan 2026 10:12:21 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id lP0evuNbg2l0klP0evkNjw; Thu, 29 Jan 2026 10:12:20 +0000
X-Authority-Analysis: v=2.4 cv=UfRRSLSN c=1 sm=1 tr=0 ts=697b3285
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Aseb/jQeTkgJlfU9hBMKMfOV1nTEjw3wKg4Z/3BWIeI=; b=c6zM+V8Hx/7Cv3pr071XLPmhlT
	2Q2ip78O/x3rWFjYpms22zbY9yZUYVYnsmAEyZc1bq5Z8zuUtWMK8idqsCiitwfzeSQdASd5TYyG0
	4nAwViFtEBHEw+nrAZA66s6hrVyfNezLulZ9aJHg3uY5JKWsA+xnWKwshN/aDCjM4sfX0PLPB85k9
	vhqSYtg/BJxGbS7273dx0h6sO+zcvjH9qVmTSnFLyyZd69rVOTtWfItt8ZQRae/l0Wtv9XG/XNucQ
	Poa6tzOtZswg3W6qjL0WErvHHmvYJ9UTEU4cW+sfhavCYMoAFBJMF0NEN/8o5w0+tBobHbzeYdWM4
	SoApeLbQ==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:40776 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vlP0e-00000003wS2-0OMp;
	Thu, 29 Jan 2026 03:12:20 -0700
Message-ID: <bb9ea68d-ff40-41a6-bba3-11b31f21bde7@w6rz.net>
Date: Thu, 29 Jan 2026 02:12:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/227] 6.18.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260128145344.331957407@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
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
X-Exim-ID: 1vlP0e-00000003wS2-0OMp
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:40776
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMEW5lXOc+ryt7c9NvpgptgfyT27qZNnjL1vhdnmZZ+jE9YG/gNFV99TJbGj/Xa3UKntza0xqWnv2o4htPY0m7/+tjSilpyN4dLUNsjM0BnkPmO2KlHi
 Hk6C7V6JwvimK/cHmEl/M2Ax+ThhnKEngz0/meQrG0D3MiXZ55L99iaqTVuTK00cK1B7zfD3gNG6UQ==

On 1/28/26 07:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.8 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

