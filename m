Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD87D35B632
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 08:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775724469; cv=none; b=JMgc1hPl/obRx7jYc9UxJbsnanQ9p7H0SdvBel+Nbr/TAObzFY6xOeUEvGDGaXRrs/yv7Gj9IlqdZVldVgfWD4HrVqbQy98E7kSqKUhumUkahjpzw46rAjM64LTBgfpabg9U3qjbfFqswRte21UefgvBWLt2pJviqNHQon+gd6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775724469; c=relaxed/simple;
	bh=nj6HKfqxjHw3WwNm27jTPN7qsxJW/k5QWtpZvLQfzKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H4uy1DevB5RmPW78LbfY+4NNre2y6SagM01eRD4q8KDl9p5SHH+8Ov3FndbnxAPakXzQmKfQBTIuO2bouYoQ3f/my0It3Q7c0PHL2oVqdhZxI8g3Q4XJM+t1qbOn97ta2DJBrh8CLekGStlfsJPCqQRKsM4Y+EOVBzay7qYUwzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=SqfWHJkJ; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="SqfWHJkJ"
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id AiiowBPBWc9KCAl37w7NxI; Thu, 09 Apr 2026 08:47:41 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Al34wtAypMrq1Al34wanOv; Thu, 09 Apr 2026 08:47:38 +0000
X-Authority-Analysis: v=2.4 cv=W+U4VQWk c=1 sm=1 tr=0 ts=69d767ad
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fWvATM1nQwreLV739XyejETsHmhygsOlTM8MQxua/F4=; b=SqfWHJkJA9gBTGwDLxLx12zZaA
	Bxdeuey6DTTZJBXJHTPscMxShHUncRR9nwVo2fgp/dYeCbDBkk0vo//u2GUsvNRJPiVTpyYioCCmF
	eK3AcPtFs69l+qpRhRtMlQfkJMJyOi06kK+ONNyxvX4IbbRR+QgQPcoa5Rg4a1lQMYmo7X1RmOIU8
	Zy169B7rcQEIIx/BVp35YpqaDUakUqph7z7kEFNzlM6RgboVvxUuIS35BWia9cgUwQI3nm2tq2tgg
	iZR9EF6aeX8whqV2INQbUxs7ojgMRgrhFq6tfO8jyRIjWZo7cWkikozx2UcbhXeia+t4vOEBzhe7a
	7jdYvBdw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:40794 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1wAkNU-00000001yCF-22eH;
	Thu, 09 Apr 2026 02:04:40 -0600
Message-ID: <f7a3125f-df28-46be-acd8-e04876962228@w6rz.net>
Date: Thu, 9 Apr 2026 01:04:39 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/312] 6.1.168-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260408175933.715315542@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
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
X-Exim-ID: 1wAkNU-00000001yCF-22eH
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:40794
X-Source-Auth: re@w6rz.net
X-Email-Count: 100
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDL5qADHME6h5ZMJ/wUI9voGsvHmbzQYXfI6TGmFLUZocgoXVoq4BvvvmF/+Civ0I9KkFAMMRNSCp/wJN/NGw53tMbMZOFH1q3nWipKEVlJnp97bVQgv
 u6K5Q9i+nrCNJJiU3ojShs19niUHoXASjEfPay2m3BSMtKCpVDDcBLVtuVzZMZSDhSWEiPMPTj31jg==

On 4/8/26 10:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.168 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.168-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

