Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919CD1FF1C1
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 06:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739513815; cv=none; b=hcM0Cxm9ui6J6NVXJjwbC7B/bsQhhUV6uoqNFff48XUXO6tAgqInjBlIbhOp/xlForeL40gkddxVoz+W2c92P1LeQt0GArp70qfhj9KY42WCn01shBGBtfNnhaziOqObfsEjzmN0GdAmsVgU/m/OrGZsAbQLPEn3mM3mD9V28nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739513815; c=relaxed/simple;
	bh=dhxq0fekYHtupgYL2lccwRrN7Jhx2mjWQZNWTT333HU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qskpx0lKVBQV6eOGy0ivzlFzvxT6/tfmG1n9WTMzideAUYOrQ8JennF+aUhQ/kUkWWh8T42AvtU3UQMBnoK4oPRffRw8VGtE0wjXzK7sSvB8BdAIf4QXxXasGA1OxScmRssG5d12RVUTGgtTjOsSyJ6WW2Zd1LYRiVh7ia0nrLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=rOH8mDRF; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="rOH8mDRF"
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
	by cmsmtp with ESMTPS
	id ims0td800f1UXip0Jtwrh3; Fri, 14 Feb 2025 06:16:47 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ip0ItbHYoHEACip0Jt3l6Q; Fri, 14 Feb 2025 06:16:47 +0000
X-Authority-Analysis: v=2.4 cv=HdLfTTE8 c=1 sm=1 tr=0 ts=67aedfcf
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=4041MwwcWqwrnTXoSgMA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1mAj3l4wYEbu+PyuxSVHeh+ZNOD9tJiIitvX4XPW1Xg=; b=rOH8mDRFMuTtcl0+wVCrmJauEi
	oNBmsKUv8s7DDGQzmi37MZ7KY9YLuc5TXEMD2id02EcZsFaVzJHz5SeiwujHJHQSOxtN5DVqXWMVm
	1Ym7uOQqnBjqLmpZDOW6OglzskbILD+YBp4HXwteZQPX6FDFcfKWf0Hj1/8c/Jnp32OilQtTIf4nF
	AfS/Fa+/WU7YB44ceEck7QxlipapFtBBio1u+5ZIcpX3JL4W/kZ1/J8u9VZVqNDJbBBc0oJWpIBMb
	MY6y/l1r4DFjvKpq23o3Ce5bXkm5f2kzWaOjQie1o0YA7iGiRqHhZtDmdaGJF/cscTK4lEcaX0GjB
	wnITxPuw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:49026 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tip0G-003hDR-24;
	Thu, 13 Feb 2025 23:16:44 -0700
Message-ID: <2176e236-4865-43bd-924a-bc6b7d94e980@w6rz.net>
Date: Thu, 13 Feb 2025 22:16:41 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250213142436.408121546@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1tip0G-003hDR-24
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:49026
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHzyggJszlbMbTam5dYD+6uUMqtu/KxMPTTR/x+4qIjSxQ5IoecKE9Chh9rnCkXg5AfjrGeKdSqmB5KYr1rv1yjtS8ytXq34aJRMswCjSVyQNUpOhPHR
 nwJzeFBB0iMSNFEHmN2P37bhSsaZYDtrSQ1jcuVywozsouYwRpj0Gy61f9/f+mjqg6/ggx5tcHYuCg==

On 2/13/25 06:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 422 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

