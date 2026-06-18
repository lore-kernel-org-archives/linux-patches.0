Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C722EEE82
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 07:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781768953; cv=none; b=ckgKaNsdDDRBqKqXKp5bVhsvaDLwNQHRkYKr1lUZ9pxtyBJwZ2ujiFNn7qAIZKWhxwtnuTGKW9e4et0Ejbqj+FXBLMcz8S7ZghqhbdZWGWZGwVapMaA6sRJZTyUlLZaArFNrh5mXDUEr/zYORynVVOVA9VBSGcZQiQwEag9+VhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781768953; c=relaxed/simple;
	bh=rn+zy/e/ZeAC44w/v/H7qg6arj7K1GkOCEd7mlpFdvI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R21V8oqzbdn4QgtR0vPQ2awbcfyF2vktyAE+whJiNj8+0yYLp5AKK7tbtbr2tbgf2q8iWpyrUFdX+bkQzWYfUSm5Xi77oxSMZRYw/McA1gI4KZVcTlevAVFyWXqxR6N9Nyoa4DTzyLymlnNY9PwO6fTWmBxbgg8/qm2uF8of/Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=OgYu+9Q+; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="OgYu+9Q+"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id a51uwA6a0KSRRa7Utw4EoL; Thu, 18 Jun 2026 07:49:11 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id a7UswCVkMnfJUa7UswJoFx; Thu, 18 Jun 2026 07:49:10 +0000
X-Authority-Analysis: v=2.4 cv=KajSsRYD c=1 sm=1 tr=0 ts=6a33a2f6
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=m2aUGJL5Bn_ZWkTGInQA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wovJ2Y92WH+qRJQhXKzR+9Q1ewYt5crlA4w5uU81weY=; b=OgYu+9Q+fAPtjBv/JLnJ9Nubt3
	lg298Wc9jGWnKNNHCGwvjrfIYdW0Ue9jaPAEsvAEvrDvb/ipkwg/hkJyLdC9I7r/f/I538OyXUo1P
	YwRdQ+CTdqJrpEwPJ46WWadwHhMkwHwfOwfhr77UdJKSk6xsj6C3pRKi/FBunHuJNY4pJuZQZuMsM
	DDTpNACo2LBAvjIv9hPkvFBK4NFfSdKkxp4E1wClVTzjyxSHEDdmd0D9tR9aUomABWS7otWqPXPUn
	iFa2Y+Y3R0S5z6ecFo+Rzv4btQRehEVdw6+0/vEH3sHxQfizsxE8/69G0aOUnLFXeXiU5oWG7CPxv
	BcUUtg4w==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:58930 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wa7Ur-00000002GGG-23f6;
	Thu, 18 Jun 2026 01:49:09 -0600
Message-ID: <4ed1320d-2e9b-402f-8684-d798a7d41e45@w6rz.net>
Date: Thu, 18 Jun 2026 00:49:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 0/8] 7.1.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145523.335696673@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260616145523.335696673@linuxfoundation.org>
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
X-Exim-ID: 1wa7Ur-00000002GGG-23f6
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:58930
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHkaBDzxewjJY4zJUh9dePdfpJA91Y0Ihr4roLfUx/7QwmJ2wMhCYd34F0uhROvAIA54eE2gg6qHaDecD9+VXBEYEwGegvizED/t+lbBiJXhgMbvjqXs
 BN3+e3eRdwaOAsQ7+5t3/koBYsFmi94490ZegWkq/pdbVt4WPAwHG4/HtZnjGk5Sp6Q37ZSW5NuL4g==

On 6/16/26 07:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.1 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jun 2026 14:55:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

