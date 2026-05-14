Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA3C1A7264
	for <patches@lists.linux.dev>; Thu, 14 May 2026 00:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778718718; cv=none; b=qAhpkpphVsV5HB6WbrVMf9bJLbdoxJKJwHMBGA+lGLBr9kyVaSVI/Jaxr0PJ9vae9PhLxtNTScXRs/Rd+bkQddS5WhoKH51B/dWs8622nic7El1Z1szHwnZJ9UdrZydE1tOt+hotRDJx2qlKWfSALatmhEFIAqktBLYdbQts0H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778718718; c=relaxed/simple;
	bh=wZkbfA3BZqIzPbEJi3WLfD7bCz1CwxpNOUn0dUAFt9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ljHjqth/LmVAo5ocJumNKO5gYhDYgCBgi3sGbSxyc6p3DMKh0Lyl16KVxGfPqnXSm340Pt8xz/f6OzGVQRPrC0vjEaigimTtPC78LbYYfSGK/hygZ+ZYIDZrTo9ZsOxJbrYI/otmMeLAeTDuABoF3BL5+XOr3tlkvGlB+jLr7Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=FF5FZVt/; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="FF5FZVt/"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id NF9Zwug3WrDqVNJzTwHdZR; Thu, 14 May 2026 00:31:51 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id NJzRwY3XPcvlfNJzSwLTnQ; Thu, 14 May 2026 00:31:50 +0000
X-Authority-Analysis: v=2.4 cv=LtSSymdc c=1 sm=1 tr=0 ts=6a0517f6
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=pgtPAZzbatkoQm8Ki9vqBtf9SXzCQ6yrNtKRHhTSMIA=; b=FF5FZVt/qu6FXdNJKv3OLz+ivB
	39oXihsSplVCosp4zVFhybszREU1kKxuLKSZBkeNl+FxFFQ1ObNUTLvUEfnhkKPNvQlzJP5t1UHS/
	pEKSImk5nc3Y/4/Hsb9Pe2TdDI/QR+zU3+JOfhjlu0IAKgogVWiiiE+XMhJfPt0YA1F4yCGx89cIg
	nkSEeVPxOMJQkVuTOVqthqLEBzNHxTjWeWyL+PQRnT8jmN7lXVI2uR8ftrJ6WrEwpJ74WtF6tjFsL
	epUKoIzUov4ChtXYvabisDWkIlw5y1DUGmF02nJ0JLpBw7LzMY7Fxj/k45G8xKktRKziTY4/wYt8M
	JS8N8eUg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:50344 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wNJzR-00000003Qz9-17GZ;
	Wed, 13 May 2026 18:31:49 -0600
Message-ID: <8eae9756-f2d0-4df3-9106-243c742a841e@w6rz.net>
Date: Wed, 13 May 2026 17:31:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/268] 6.18.30-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260513153744.746440810@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260513153744.746440810@linuxfoundation.org>
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
X-Exim-ID: 1wNJzR-00000003Qz9-17GZ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:50344
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFp9AEapgT8x/yY9s99rVM6at5q/R1zITr4dVDyMMfP3L+3WNQV4fwxt7ns6Xw9tKaqzaR8T3wLOgmtrS/xtELFRnd4gGVJQ5Ma1vvDmCN5RMTIKhRFY
 qm10er8bcjc3jsiFg4Mg1UPHyfGVNKJ56pKAsgwSYzyj3S0vz8iQffYc1ANgTeKhAg9o6FbNXY4Kcg==

On 5/13/26 09:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.30 release.
> There are 268 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 15 May 2026 15:37:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.30-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

