Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE0B22F169
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 09:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741687143; cv=none; b=njLamhybJGEUzwOAr2o7YUrLfWWvAZjZMybwuGUV+E6Eq9Epsu94jmLQQH1GulJLIIj7JfTNT3EEKC2YMzPL+shA4BS0QaTFjFgGqRxWcvchc9r/pA1jQZI0yaRaZrYTNz3xfxFPgvfncSUTN6/YvTnYHUoI0kblECi9dbIrnAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741687143; c=relaxed/simple;
	bh=L011vDdYdmYjXVONp7IA/Gm904T13YMP/OfTTpLO3rs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GIcDhEDicj54rDHSbIvHSPBxtb3foZGX5WL9rw3AMc04l/j0JYJxDCF4kbUe8flzAv9Jtg+DbCsnhLQNVk4MSewtwGRsuNvef7jvxpM8NOiIGXxsghV4nXu/h054dpwFULMP6XEgPeBTMdjDm8XhPlytz37d8rwcD2lqeLJur9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=qynyrUdS; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="qynyrUdS"
Received: from eig-obgw-5002a.ext.cloudfilter.net ([10.0.29.215])
	by cmsmtp with ESMTPS
	id rfY6tH5BGWuHKrwO4ttodG; Tue, 11 Mar 2025 09:59:00 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id rwO2tLCOedY0frwO2tQTWs; Tue, 11 Mar 2025 09:58:58 +0000
X-Authority-Analysis: v=2.4 cv=NoUacNdJ c=1 sm=1 tr=0 ts=67d00963
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=p6iSWm5Sq2tICbf3W7WG8nFvRBVm0hU0R/EfCXFRGrM=; b=qynyrUdSJSHrdiWh8OhLAZXx27
	BEHXIW42LxIoLcVomHiuZC6XMLcIZDMZ8C26IKXj9kwkqvteU+HWmtWfMBIZWlYLjz3zj0sVfIcUJ
	BtnN0MwtqB6LKPk3+HOhfWW5+TngU0AspGIX6VM2WQm1zw4nUWR8hdeF2cgljbuGoOPGxXkORxUtr
	Uoc1r1HdoBHkgI+uBYbtIPzh5Ws5bPzVJu30Cnks2I/AjUgVw9kZJh+RmaFkXaxqrZgx7lsVISY8M
	yfUOGK6TgldSsGGZIYJvJvWqSSbc9l6DKgwqncI8KwKgml8zCsLKOFJE/KtNGEzHQ5cWz/xoa04Ur
	D8ZwdKzA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:58536 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1trwO0-00000001Q3L-0yhX;
	Tue, 11 Mar 2025 03:58:56 -0600
Message-ID: <769be520-094f-4ff2-9cef-1ba0b5e29454@w6rz.net>
Date: Tue, 11 Mar 2025 02:58:52 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/207] 6.13.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250310170447.729440535@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1trwO0-00000001Q3L-0yhX
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:58536
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGDLMI5I969JpY2zv7Pi/Xst6NXjZgiZkuiUkG80lvF/14jtRArAGPA0yaczdxjtS9DMagD0pHYpZBAb7bIT+P7vOFM9F/MD4lVmEZdAiAeEdlTkTzSz
 N6wyjT57cimq7qKA8V6FRaylEJfFk6Wk+hTaTQVQJNt6NMw85FgqjpoqIrBlnSjBHRKTcHbVJFhX/g==

On 3/10/25 10:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

