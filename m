Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E36305948
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 11:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761652795; cv=none; b=MFjUpnPdNwTITZSjiDGsQ+eiF4i+r9Y+W81FUIjYr2s24e+znhgLGEyXxaOkvTJisyJ0VByD4o0vHjfvYXBdkLgT8wmh79pdTQI+HbUc+sXCSWpBs9ZYZqA9jXfI35T+udcoo3meuNS3s5PLq84eYIygKbFCSgwKHNCRDYj9rZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761652795; c=relaxed/simple;
	bh=V3Wwwzc9OvQSBcoohec1QVAUKsVR7MlPxbYb8/I3uEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OiANGk8gYKPdhUuKodGhPDvs+CoN/h9ilKgjFBQBqisoGTpSuD0s55eKRtLz8/97Kyh06E4iyEdgWzxhTHi25F9JU9InI8LEaBkEPsHz+GRY7sfY8LV+ys1Z6m9p3o0Q0W/ecdIkAMEfAdrfYas/Yok4ThghgTRBgYgL93VjEwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=oiqsT0q/; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="oiqsT0q/"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id DhxYvkBZ7KXDJDiMivZDaG; Tue, 28 Oct 2025 11:59:52 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id DiMRvHjFRniktDiMRvwhbu; Tue, 28 Oct 2025 11:59:35 +0000
X-Authority-Analysis: v=2.4 cv=FOIbx/os c=1 sm=1 tr=0 ts=6900b038
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=IZuGi3YAW1ZzDR9SpYUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=IgyVbcgswd8Gzq5Qaxiho7nDwrU3LRcLk4xl7W0Mt8c=; b=oiqsT0q/sVoItqv1CKZIdkTN/7
	+ZvUxM2BbTov3gtpsh8FtktZoSjoLgpC4VEGpE8jXIwwix5Xw5oQg7XNRcbHxEeUzLF9lPLIXTWlL
	yaHac+wjEgfGP7IveWPbvnlP7ljyaNVe4GT8NylW2dKR66/0TxRNlic8kGbbmM5YsNOXcSMHSJ7dx
	BtWgFI78f0QnyPdeJem9OfjC717uZPA92E//kPBMzYVDR+b695T1lCafgd4ZcCLsOn6cvT+uqapKe
	/IBJ6VOYtG3qti9K0dgYHumzJO7eE8cqghi5lbfpXsiXA+HQUIxWuLM7Ws63wzGAxq57LxNC+wuLb
	2JxGf/yQ==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:40436 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vDiMQ-00000002Flm-3cl1;
	Tue, 28 Oct 2025 05:59:34 -0600
Message-ID: <98586f40-96c2-47d5-b073-446f42af28b3@w6rz.net>
Date: Tue, 28 Oct 2025 04:59:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/157] 6.1.158-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251027183501.227243846@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
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
X-Exim-ID: 1vDiMQ-00000002Flm-3cl1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:40436
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMg1YhLS6JQ5KlirBK08jF0ldP7gqY747PytWaiG0ARhNQOkHVP13nhRZp7jXL4NNsGZP++PG2sM1efaKTYfDNrqlu2vSSd8+a8jZLo8EgrPEGbmCN6P
 edrapRjKOKjFtPxwriZ24gdfyarJ4Bx+ZSGKrwOKzhM0N7MZy2MmSope3Ia4YFOJF+HSsikrs6+U2Q==

On 10/27/25 11:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.158 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.158-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

