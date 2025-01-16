Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4662381AA
	for <patches@lists.linux.dev>; Thu, 16 Jan 2025 08:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737014554; cv=none; b=RZbk2tD828eIRoJo0IkaqGqZc+R4d5U9N6N4FkYzTsCHslaaHdpI+ksMMtijQU/rnI4Pza28FC9EJktfpzjH9f/m6pktZmFZLCFST0CJNx53HgL0PkiWDRzjckoMd74j4BE1sqScUffbfhfYX7vQvhpTM0cHmzXwATUJ/RtdjA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737014554; c=relaxed/simple;
	bh=xESsO7IrVCDj1T4kGQjCQ+cyzv4pfXZRGNM9WFKdlNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I7DINOgANtosFl06c5yyVsXyU/GObx+jMkl6YAgOuN7xRCgbK8hl9QrcU3lErvGyQ7KD9u85qkQ96rKizzaRI2fqHrtnb+y0dyF/b986pKMBPRGQnrVGlmt9T164QYeiDOJrK/XE6RTIZr1y3NZWBqDfasDs3vJRz6jrb4QLlZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=I2Sp9GZ8; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="I2Sp9GZ8"
Received: from eig-obgw-5009a.ext.cloudfilter.net ([10.0.29.176])
	by cmsmtp with ESMTPS
	id YFSGtQKIEjMK7YKoBtQTLj; Thu, 16 Jan 2025 08:00:55 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id YKoAtwGOylMGkYKoBtZy5j; Thu, 16 Jan 2025 08:00:55 +0000
X-Authority-Analysis: v=2.4 cv=Rt/DLjmK c=1 sm=1 tr=0 ts=6788bcb7
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdSt8ZQiCzkA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=tf+d7fWnxGiaRANB2zdEhJTQbJoR0ngmnxinW0Rk2dk=; b=I2Sp9GZ8aEUSzwObswuDS8APEQ
	Ddvus2oClIwiAFdbBWXES2O+pJcNh3mYTLefm3jlTod2p65QhNzECMhSpYHvP9uzD1fvQeEsJwl4j
	QdYG6O7doHvZHpJYNzx7IMTnoWg7Z2KM0yKaPxocyL+WB+E3qj8eE8xgxYBc56s501hU2eSqRmDRB
	u6J2IUw62NWwB31Lacg8/S/FOAZGF+LNLGGEF5WRSzvJ3xKpk1Um/uLRjmgDHbwdBYLNRQJ5VPgdd
	XFd9SQO410PANnqHIP8Ta+xF4SWuD+MgIAQooaopiCe/uPycgmg1WXS9Qe1aRv8ZVVYd/m9AafxOu
	BTMd6EWw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:40436 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tYKo9-003YvL-2U;
	Thu, 16 Jan 2025 01:00:53 -0700
Message-ID: <b7dda222-970b-4866-b120-c1e6ac996b76@w6rz.net>
Date: Thu, 16 Jan 2025 00:00:51 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/189] 6.12.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250115103606.357764746@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
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
X-Exim-ID: 1tYKo9-003YvL-2U
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:40436
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAr2uwaCDd25R+JCeA42IjXm725bPRhWwARNpX9uYFVZQgzuMY3suKj3DYlb9Tg+zhOYJ8vjuhDfRNfVf6mvx20Uq2eU2kYGBIytd+U6iFpgiFh7DfzE
 /K3jHiosSOnPhloPo+A2r3ptBlrgXH3IUOfjzDOhc44DUB5Kh3dJ/vmcGjbCGVV2L4n7jgrCltbPXw==

On 1/15/25 02:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.10 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

