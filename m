Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437FF34F270
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 22:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786229929; cv=none; b=OmV86skrbQJIz3pAp+KDfykHprPuyBSk4iuZg9Jsxj2ZsVjGBFbbTYTMrXfRy/OCL7Mo17Qxw48DoyVEQenzc81KmKPY1HHTOS7FFpzR72FQNrSN4d8J8bWOYHuZAWVvZ09pFQpJNz3lH8W0lDb6E9ie+X617vk6/zyVUtgJJTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786229929; c=relaxed/simple;
	bh=R8bc9PlhzTnPCkb8lLLbnfPvQeqi4x1Nl4UPiq1zDGg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZKSnWe7EGFRJhF3KZNBn9dDiy8NYnmJctYrkaxNzcFaTuvV3t+U+3PHcjtXS6F1pbB8A/MbTukmV3IetRqQ5QyKr9fAXDXH5Iw72l+wwg+VmGBD9ZQIJlittgfMNHjIRVWaJ1yJYN///csbmLWHCjt8Td62SOM1VgsauHe4Kpqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Xp/5bqzM; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Xp/5bqzM"
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id sVPvw7TvEaC0Usq07wFFvJ; Sat, 08 Aug 2026 22:58:47 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id sq07wgM7TlaKXsq07wbYpW; Sat, 08 Aug 2026 22:58:47 +0000
X-Authority-Analysis: v=2.4 cv=GsRC+l1C c=1 sm=1 tr=0 ts=6a77b4a7
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=hjpOfzOB0llcEQ6DyonEzXHEHf1qFnH79M7EftMlipY=; b=Xp/5bqzMtlXthDpqd/zlMCVihn
	8z4XBSPJWSIOGveaOisYLAtJm6nSyirs2Aad8YH9cVGvOPhW2DCFnWb2c/HC68xWSjCX3QZ7PpKPz
	8MjnlgR8MD/CtoK4dDHW/O2jltMPnOQ3mQ/L/2VVmNnVdv5EIilCpfnQm39vwVZ4p6qw4yzOEme9U
	qjTmcBS/iui3zDE2oqciRl95rzYNjh2BGJBkP8vUe/5yXNeQdvE/ptQ6CynxMCnYluNWbwY9oRv6L
	52y1bCgeoLelrT8WcdtIWmiCHHA78+1u8Rl6XseSf1NW9dmU2M+1F9QiVdeK6HAU/jz8aTN7n1cHS
	5dVR2PFw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:33562 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wsq06-000000037bM-291k;
	Sat, 08 Aug 2026 16:58:46 -0600
Message-ID: <dc109944-206d-4e89-a268-6fcb05e7219c@w6rz.net>
Date: Sat, 8 Aug 2026 15:58:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/261] 6.6.151-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260807143415.358597922@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
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
X-Exim-ID: 1wsq06-000000037bM-291k
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:33562
X-Source-Auth: re@w6rz.net
X-Email-Count: 81
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGRb4BvnkeXFZ44RAGEK/nm5DimDjkzaQYXJg+lAHxYnur9pd6tmzLc0i4FOSDmIjbhB/nR9+E3s65hlyFqczOI4Y0RTJ9ZufKUJAH7kJ5484Z8O+79w
 cjRpriD9XHCDJrzEy+ZrdgGNy1JZw4Rp9AOpewkj3+sLkvDcaRqZ82WXHc7D1SonTVbDo84Zyc3XNg==

On 8/7/26 07:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.151 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.151-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

