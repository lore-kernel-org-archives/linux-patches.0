Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970963D1CA0
	for <patches@lists.linux.dev>; Thu, 22 Jan 2026 12:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769084238; cv=none; b=KcUQcnuERoa+PfBuzhKbTKNWmYuoRJQnJAJlZh4CLMKOrJkAJydTN06Vu0x6ySScVXR5ipnRniRWKp/Mi0rjTlhDDSnULa+l6iFdwsMe1xynTZcmLi1XAXJu+CQbsFP/wAVnAUZoW4kjQifJYVnGCZseZhpFs59/q3dnJT4UdDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769084238; c=relaxed/simple;
	bh=q9EBgoeDh3CesMZ8olmBwoUWXmMUvLuaFDMebD5FQs0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F1iyo+xJW9/w14sEZqrR7Tsx27DDvM2ewWEhLxZ+UCdXYdM2Pob0aPLltoPAZ1ZDopry7Ee0RrYJYMifxEIquzfVpx+5bLexdC0jnrh1hyoC6o1uCVrs5LmGCHlcwbibVYX+Jb3ONSh07O0Ady+gJC8lhVqaMSSWn+G6qfPf9+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=PH1ep2gK; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="PH1ep2gK"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id itYBvPQmLSkcfitcgvLN4X; Thu, 22 Jan 2026 12:17:14 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id itcfvP3s7N3K1itcfvhLzC; Thu, 22 Jan 2026 12:17:14 +0000
X-Authority-Analysis: v=2.4 cv=UdRRSLSN c=1 sm=1 tr=0 ts=6972154a
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
	bh=rMO7aR6ydJIJM4uJbi7O2/H8O33ZBZ8hVvOLj5PCbls=; b=PH1ep2gKa7cP9w59nYRA1Nnlky
	nf6TyMqQmM3FyQNONQKA1l3IZsnVCdp0jBh+SY3EunqOp0b/gn4cm0HLQkqGEkTjIy/Wf4S+lNXFx
	6JMdb1DDk10J+InIZjGgLgu4ZTHs9kBzItyLYykPNZKFAVG1Z2+1z157rD2c77SSOQ1Va/m+raD6c
	4znbbQ8cauQ058guLY962bn9jEQddkFrP80ExJVkMGyhsSZ14hPlGubN/MJgSAsJ8VlemISOl44ax
	EMcpzPt6hMyNhKcTLBP+HrXAWEwIC8g+ymKkUu9ArhHjIU3OL/PNT2doUUXPN1+CCcAUFSUw3u+fg
	frZpPEiw==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:40170 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vitcf-00000002Zro-19xv;
	Thu, 22 Jan 2026 05:17:13 -0700
Message-ID: <acc63ce9-f5be-40ac-a2d6-2d209b1fa9dd@w6rz.net>
Date: Thu, 22 Jan 2026 04:17:09 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260121181418.537774329@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
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
X-Exim-ID: 1vitcf-00000002Zro-19xv
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:40170
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCKCbjtMCyxbVVM6xHtnLc84W0ffZYbuj1f4vOLPpxgYuIvGl+eFwnarz2CoDp8BMfyHCR95rvWxo/rB6YoxZpjTAh8WUb/dKZtxX3nxw7xqEKNkVTb5
 L2oJ5/TVY7V9bcFuALpeRfr7l9FExzWbnmUXQvRSkB55SxeFpG61lTlJhvyY+6Fy9nwE4z4BwkAY2A==

On 1/21/26 10:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.7 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Jan 2026 18:13:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

