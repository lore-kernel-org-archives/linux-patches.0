Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2665C38171D
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 12:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769084612; cv=none; b=AZtQXRZscfVx5txBGpFGwKjYdUavjpjqbGsrvDTyPD7H509cNcxuKEzKET/M4VJQou7BGRuYqnSTlGEAGTKMwg/VAMMU0ezuDdPrSiiEufrj2Q3mDIGinzCFhf4rx3URS3ndWnb3sfkFceOe8sSks7Od5iEq8JLbVJbcuChSGcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769084612; c=relaxed/simple;
	bh=62/tc5Jl8yhCA3TTJShSNQNW1PjM0Y6ceRHuymeQSN4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=auAETIsyYOfsOiovIo8L/8Rx4VY4kV0eEs7KqrTaFmC7a51XQGE1ltpQWiqzjfR0Qi0IeRKUk+LFW8UuXxaIrb6n7mMaKLgQcpRoRkhct4QO+qKTdNcEKQd87Vc1lnEK3bynczV6toQEe2zqeiMRxljcIX3bKrbLf9PKHfXayP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=nQjJ4fqg; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="nQjJ4fqg"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id ihBOvKrrQKXDJitidvjfpN; Thu, 22 Jan 2026 12:23:23 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id iticvLssoK8vziticvC1nF; Thu, 22 Jan 2026 12:23:23 +0000
X-Authority-Analysis: v=2.4 cv=cJDgskeN c=1 sm=1 tr=0 ts=697216bb
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
	bh=kP7N0LjBwUmm6fcBzzPGsdAWo+L37DkvwarY70LbA/4=; b=nQjJ4fqgRrjs7Y4ALkPKW6/8n8
	Mg7V+1sNtlm1F7195d45tP7JwF7aNjxd8MBtzx8jEwPQ2jsayonUBvqf3vGPAnCV8BbX1pc4GFE+3
	1IIfmJeoIihwOTysSQTL3DF978RaZQv1wpx8tnWOpCgr1qy+hczYMSZe87LHewVqqmDgyWahwi9bH
	6N6gsxCrVt4Ud6eapq+mTReMY2MYhuJw2Thba0axtOYt/CfcL8PBmv3zGJ0lcGxCelTRrhwCbniAS
	YExGGWD5djKV8r9jOH0Kd1ihm0xIiiYAgtMTSA3wPnS4I9dBACl9u21XFRIJYFxG707hlJ4cSxlm2
	7t8hEGww==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:35854 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vitic-00000002bwx-14Ks;
	Thu, 22 Jan 2026 05:23:22 -0700
Message-ID: <385c51cb-f9f6-43d2-ad6d-b4505a80de00@w6rz.net>
Date: Thu, 22 Jan 2026 04:23:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/139] 6.12.67-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260121181411.452263583@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
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
X-Exim-ID: 1vitic-00000002bwx-14Ks
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:35854
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMA+jETVxTSnVcVOB4OfW44HTdEJcvygC0lT1BkxCRkHKlsya/ADM0/mGkOQqzmr7VQ2hXg0EFwW9IdNi3YqgDa76n6fCCIOm+vQGuX2MA9jDd0fPcv0
 UB52jen9l/5Mr5gxlt1Q8QQoBf/0tgm69vqaN7WfRSMK/PCwornS0Rm+STdka+L2LFoVbd4leWPs0Q==

On 1/21/26 10:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.67 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Jan 2026 18:13:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.67-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

