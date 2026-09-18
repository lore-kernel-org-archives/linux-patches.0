Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537CD41D108
	for <patches@lists.linux.dev>; Fri, 18 Sep 2026 08:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789720837; cv=none; b=US7gU3KpukoxFxUtFwxLSUb5xEkPZGCTiUFB3E+x9qF+0LvcPeKTjOq2RVNCrG4lLeriFLzPHSrKXzjrsqHcOgTeuvs17LtQa+iNlbBtTcxWrUgKckYJrtbvs95JEBOzcK7r3MGE4rAqnk2LoYyk/j5in74AzLH6Blck3TxoYlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789720837; c=relaxed/simple;
	bh=GE01ZJk1Dnk5jP3hnMdHMT3hWSSM0IaDfbBRWneCa4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HXdbIIAJRXaB0zTDQIuM2kRZ53WAyWTwVEHeaTLvN91BSCcQ1GzI5X9V+cUei0yf0KVyTzR22BX8QjiJ9AwLMYXQG0C++ReflpeOLvmfsuLMbYHON6Y2ZVL2eOCR6BHsnEhtM3YvsL84NUn5CKsTnSBvAeYAOTkvW4Tqd2Spcog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=JGUETni/; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="JGUETni/"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id 7O6AxIfLjv0nd7U8zxCFg2; Fri, 18 Sep 2026 08:40:29 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 7U8yxlpnmMB9V7U8yxGsy6; Fri, 18 Sep 2026 08:40:28 +0000
X-Authority-Analysis: v=2.4 cv=d5D1yQjE c=1 sm=1 tr=0 ts=6aacf8fc
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=qhrrstFoYj4ExQeanoMA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MjnUq/dY/fWPJe3QMgR+iwGz28UusEz4Z6VVJBzj2jI=; b=JGUETni/P4Wn27DeM/P4APGYSU
	jWVbOTTzbhJeduk3s1TAW4GPoQ7MSzGs9Bemrr4XHFnaHcSm/yGIxLY3ifO3+AR81Bkq+PG7z+mBt
	j5SFDmGWIRC3+R/Lv4SHUe0dhA923rHgSez7hIRXnPsV8ZobBSeGUyin860DbD6TrQoMWlxlHzDJs
	18RMriKCDpHLUOPI2bsWjZd/vJ7ONtfTqJM6GFyKcfPMEjXhxG2QLO8yO1xQ3S9JSeBIZofGLdl2L
	puM+UjVL9BoQ6RVjf69S3sCUCjqmzOKlcHKXNlAQK0imqYauEZWIZL/rCUKYxZlgH0N97ZV2ZeznL
	dMEK2m8Q==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:33456 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100)
	(envelope-from <re@w6rz.net>)
	id 1x7U8x-00000002hF0-237G;
	Fri, 18 Sep 2026 02:40:27 -0600
Message-ID: <86ef5c9f-effd-43a1-8f6f-c6118b5e8c82@w6rz.net>
Date: Fri, 18 Sep 2026 01:40:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/733] 7.2.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260917151350.597953846@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
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
X-Exim-ID: 1x7U8x-00000002hF0-237G
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:33456
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLXoON22+tz5kWTl+v2doyHWvkJ8xXR1p0KrjAQcxJFI8F4LHZ2neiGh2BeXZtZGRvZDmEwDB1m1Bqusw+dHooy16wn6N3GeL215PHQ//q77m60hJS5f
 unLxzBezeqOeAnjjzKXkFDpHkw4arQlWm1nT8yUdxen3MlGhW8p1GW8xec9RebhS3RL6+DLy2bnHhA==

On 9/17/26 08:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.7 release.
> There are 733 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 19 Sep 2026 15:12:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

