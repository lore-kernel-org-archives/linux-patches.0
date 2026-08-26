Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49EFB3932F7
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 06:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787724880; cv=none; b=PO8HWdQWKNuCmFkW5ZjGmq5Z1GnRpYMIaXJVoZhZ0g28As0o8snky1HxsarZaCbgiLJr6TkGhUqFUAMlODP167ebZbRayWP636omgCJoKIIaxaOfMcCOWp7/eA+fIOpTBSe0mVlrRcrN9soMJm0VcmLRq1U1Ejmdr8SpFcw6IaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787724880; c=relaxed/simple;
	bh=ey++j3zelDUuVijHgPUibh8G1WDJS9UKVarxglsFC3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GeRWF+lTRz3HtXhDVChLmBibwAQJ4Bl0SjNECQ2HyH2BvvFHpPrPEQyODdyX5R0CV6fHbXwybnGSPfJ+aAmRAd2vRkT5yECEm7Sl1qk+4WSEqhAkG/EjFINOnnENioMzfu4WyU9/p5P/CEeLArckmFDhR9UwVUWTNG6VpM+Yofs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=EKXfqB8A; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="EKXfqB8A"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id z1u9wKaNfaC0Uz6u9wVVMu; Wed, 26 Aug 2026 06:14:33 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id z6u8wquFXn6N5z6u8wWX7S; Wed, 26 Aug 2026 06:14:32 +0000
X-Authority-Analysis: v=2.4 cv=LJJmQIW9 c=1 sm=1 tr=0 ts=6a8e8448
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=60u_ompe4jvr-0JMN7sA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=pZLr9M9DGDvW+Egjoe5Kz7CgZ1vDjM/ymuP2PokQ++k=; b=EKXfqB8A9JKPADlnLMD33On3Oo
	/aa07ymzjRFgDnAxZLnC761r2CcnnwgeLN29DkFmEduXvN7U4aAgzD15/xlQny7vWmQ416FIEzw+5
	aSTGYaOr+H5CH9ULJG+gi6RLcNYmr+ocodUtNz5g2UwqwcfxHQ/3PxER++nnK8xF+68HWksv1fDrV
	aI1xNdfllfTLTo5oTME98Jin3B5A9ekKXUXOgUPKvvhGGgz5rZcnCkSYOt7ExK1R+ZiD317zS9/N6
	2+TIQUq9eYjCTy2akGfbHXq+cmdV9Pv4pF0w8EBXTXMSTl0bqDes5rg3RL11T/YwZ5kNBZ8gr1xOd
	dx4BAv6Q==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:46994 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wz6u7-000000041xs-3NGs;
	Wed, 26 Aug 2026 00:14:31 -0600
Message-ID: <a84ca75d-a902-4a98-b1a7-30fa82b2f35e@w6rz.net>
Date: Tue, 25 Aug 2026 23:14:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/77] 6.12.106-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.580275153@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
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
X-Exim-ID: 1wz6u7-000000041xs-3NGs
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:46994
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAtfBgLYuSOh7jeKv+5tdRNMQdDJUypuvnMvryHYY/CMPJ9cFq1JACP6hicpoNDxnq1LOWUkGKGFV3svctvCWUULiaiXirw2PGVf4cNEyXLm+Phnt7Ld
 e6XJFXAXkZ45wnw8Fe7o4cR88cH79NHqjw7YBZhJaaWNWgltvQ57oc4lQSlXqB5oGWjFtuhZwZEp8w==

On 8/25/26 06:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.106 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.106-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

