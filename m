Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384F049B1F4
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 23:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788304255; cv=none; b=iaXZoIKZcKP/8OAdnSZOZWOOiMiuuOMFs4xcYDF6wncigQtkovczxPaj7FG4QYwXAGTPxmHk2dml7AArgRufyve3fWkw5RMF7KlsdnNBxCASn2PmWRtYYUQET932xIzGVtQTYZtpLI0OyEtwxjULgijju0Bft/weX0N0hmviZdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788304255; c=relaxed/simple;
	bh=wBMd4fIHENzvBSRUGvb1FPIIhmHfPWYxg7oALLNPn34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aeW8yCglA4kpps/8FHVsROjZuu2ExF06ZH7W8j7skbYVlluHe0VtHH4rlxrNe1sKg0bXitL+yMh26SjKY4kPhKQl/SS0mHCLcBWeJuWE6LvqlUQw8mZbHE+ZIbpgI6wuxDtcwdEs/yY0TqmX/GkpxCQygzKsDEMixCizyftKCfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=BA2EhsCY; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="BA2EhsCY"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id 1O5sxXqkcJFmF1Xctx1WpF; Tue, 01 Sep 2026 23:10:47 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 1XcsxukF7F2DA1XcsxaL2i; Tue, 01 Sep 2026 23:10:46 +0000
X-Authority-Analysis: v=2.4 cv=FaM3xI+6 c=1 sm=1 tr=0 ts=6a975b76
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=y2ERv7ko0hlTFnYyMTsA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=n4YW3Pb7QSixyCGGX1J7LUfSplSoAbAxwvNEiX/Qm3M=; b=BA2EhsCYB1ZSxBT6zQDVo02UX0
	fiF2JNskn/xZDSi3aiP+AqsPIebBf3+7YEbpCnnmYL028fzizem2ByI++eqfyjk4L9ol3hWsZNJsp
	uRvEffB+wu4S0KlipeSLIusf54mjFbHYrhBBWr/uHqH3OmuPT9+3BEQVev3zCHJS7tuO66BDc5VnO
	ktawIswNhry++M7iAFZvSPV1buwRaUmjcDv7pF5Q+FWmU/+DpIMZ50uDIIu1N0dWFjO0xP0uRs+fg
	PqMCbAerF/qed8cmsi9xfclMYply5AMnFqiD0kLjgJlKnUQIicjtHkspgHnk0j1vwsovyvo9iudY5
	cUwynn5A==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:60948 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1x1Xcr-00000002Iz6-3sLQ;
	Tue, 01 Sep 2026 17:10:45 -0600
Message-ID: <055546e8-d001-4827-b675-b0aa4d5cc7a5@w6rz.net>
Date: Tue, 1 Sep 2026 16:10:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/99] 6.12.108-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.740409777@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
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
X-Exim-ID: 1x1Xcr-00000002Iz6-3sLQ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:60948
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIVb6jiY42Wo10L6WIHZq0ihXKxQlTN3nmJqEfnj3UGgfOY//K4w8Y/JF+FqB5h0epcSG5RR3e6v0aRWbIKd8i2UGEmnnWtCjSfnhK9AbEqrFRaVyJ9J
 9bfGBovTILjt6Unx7UOGPMyihm07fPXIPtP004uLfAqfTFu0sxxkkgmGcbqv+4EDeoU2SdsP3pfj5Q==

On 8/31/26 06:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.108 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

