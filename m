Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786872A1BF
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 05:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765948548; cv=none; b=eF1KG/GpR7ss4XL8gMS9ZQhkOCiunyuA+QzqoSd/z/RtIQmpy1I9KrWTE1mA6oCHo1+myL4yVFuF7o+qxos6P+3rIw2sXN62VJBDB8w7YTeGLIU4chLqc5wi5JYKVGJ5h9FaQQf2sGFdLA62Mgi6DCieMYVSt/1LQKekitNGEmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765948548; c=relaxed/simple;
	bh=IOeWnFTmsWe3jQqsgKETidfuU8CGeQ4+FYNjO1UFwes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fwPP40I2c+G4Sgn94Ty/BEGrVd49DljdvJuZd+xIsikr9wRR8Ac+PXBLyacpV5f7+29ICNff2Q+BY/1+2p9zNd4P/u0Dysd9kZEhESSqfJkPFIM4si0U3xbieuquHG3VmtsU8gWPPoCS3X/xdPINUOIzP4Qv5aNvY5jJCzQZQ4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=FZnl5meI; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="FZnl5meI"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id VexXvtVBpVCBNVjsxvECoC; Wed, 17 Dec 2025 05:15:39 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id VjswvhQKZN3K1VjsxvlHJk; Wed, 17 Dec 2025 05:15:39 +0000
X-Authority-Analysis: v=2.4 cv=UdRRSLSN c=1 sm=1 tr=0 ts=69423c7b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=ciyYlKHp58QNX2skcAsA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=WaZLHJYB7LlCaNtNkpGJhSKfpn53a//YxGGNOlegVH8=; b=FZnl5meIZvGyX+u7W5W2hS4Hho
	Lp6iQADKzRNzpy5vuiglGiwTvwG4a6enRaKq2LYQSiWvJj82AZmfXDR8yr3eUdqQkeHVscd7PAfFs
	+v/9Nxjn+S/0vbPqMJgQylv/y7hu1jhxskbjzmo0tPWCNegHgTj6cxCWpWgdpCVBr7yFOXBO1K62L
	xuVuZYWyTq2ladSwkhGjxFYQHxNpY8H8vQPV9jY03cQQgfXZ5uiPeC6cP8shNltsbJOHhKQnsjvv4
	CnvLRwlh4w6k+4ygSl8zNKKYgThd0h2Xk2fSdb1SeWX6WlPTjmojVdkBwSS6y+JPUk+XdN/QXkLuP
	zCyVu88w==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:55286 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vVjsc-000000007ij-1mRe;
	Tue, 16 Dec 2025 22:15:18 -0700
Message-ID: <1f08b109-5a44-44cd-8899-cc3cd7560166@w6rz.net>
Date: Tue, 16 Dec 2025 21:14:53 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/506] 6.17.13-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251216111947.723989795@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251216111947.723989795@linuxfoundation.org>
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
X-Exim-ID: 1vVjsc-000000007ij-1mRe
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:55286
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCP1iYYI0siFrYXNR75RYWCRBCPOQWE6dF4Zvrz0Cy+dggWpHosqrfz4ybEH3N6EOvpmIUKomuPjwIltNciZyoaE8SiN5oa+Ta0RlUykFGc2v1JE4+fh
 GMj3H9X4xtWSeSDIjAfj/0nuda9ZUGZnNgZ4Bn4aCmV95aXJWtf/NRGamFBu81TDtli5vkUg7LZNEA==

On 12/16/25 03:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.13 release.
> There are 506 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Dec 2025 11:18:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.13-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

