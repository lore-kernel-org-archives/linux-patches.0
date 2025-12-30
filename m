Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9772652A4
	for <patches@lists.linux.dev>; Tue, 30 Dec 2025 11:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767095242; cv=none; b=b/DwDRJ+L3TQWxr16Xsh5XDQxgkTkuW9POn0VmRz7buekRrC0NmLWbCJl3FdEnntrP2K5uBwZXcNZH/MLnWIaHBQ8CjDXW/7Rn3/wMOrdE6Nbl4lD+pqw4/YidL3d07Fbq1uMhvYxZRFKQ9CVudn1qQ8d0cDO5xaBBLTHXUcK54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767095242; c=relaxed/simple;
	bh=ydYmR+4NH6imAHB/A+6sjTzkZ2/rUu9eXDzBb2mEwDs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q3ac0H1PUSDjZ52wtv8uODLQGUhnYGC0IKKKT4crpV9lqUxEVnxWAQiKPxhs80+ixcMtrylCpHZKsD5mZ3RdtRXpgbsS0FKw69rWVx5qfswZ/z25C/m+SzvGZ0/vLRIKfaVtPOnFKUCDYrRCoNv7h22BmFZCqN94+kjCBOpk2NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=tHGs4XCk; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="tHGs4XCk"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id aSm3v8vphSkcfaYC1vUeRd; Tue, 30 Dec 2025 11:47:13 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id aYC0vzLn1HSQMaYC0vVwfY; Tue, 30 Dec 2025 11:47:13 +0000
X-Authority-Analysis: v=2.4 cv=GIQIEvNK c=1 sm=1 tr=0 ts=6953bbc1
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=9nhuh6FM6ySeoKIcjOrZtP41M8RFPDrCNYAknK0hNy0=; b=tHGs4XCkRdyGjlX9RQ2w1eSi2a
	RgoXMPyTwLkdz5HGReyQhu+KCv3bpgjhjXFtvMpSIUXEzuJW5SafW5I9Uldi3nfyglx6t4zU//YC6
	ejlohvfF/W3YkQy6pkoYeBpFfYf7pwalon2iwGtC3AMzDAMbTCPOF9mmPMbSSrebteZ/+Ri3Tv8zQ
	rkqDsXGSK41pfe6A3dbYTQeRgoktpKlR8cLkqNrKKoQHhNzsoHfjHU68Icbu4uMQIY3+jgznf8UD3
	damuRv1VrA2KjM16N//k9Z6BuhfzMOyJoxnj0r4R69J4t5t1i2YmHnb2o3Si2rjCItOOsvNkmXk4Q
	u0hzFT/Q==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:38088 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vaYC0-000000028hZ-1I4F;
	Tue, 30 Dec 2025 04:47:12 -0700
Message-ID: <8062d0ca-d042-4e77-8654-b15adb483600@w6rz.net>
Date: Tue, 30 Dec 2025 03:47:10 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/430] 6.18.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251229160724.139406961@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
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
X-Exim-ID: 1vaYC0-000000028hZ-1I4F
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:38088
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfM17AtmwbdlV0PtI55w/NRME7urjDebMiTUl/6UYwUeXNWRkrP8Aa82ohwyeKoxsmm/2ipnkWwygTWmeAxQRWHK75V8FQLUTX5iW7KYcsveB9UXLzuZc
 N+b5R74vsdzeiMSJqXMbsC+M5d4QsuSddVQF3UnHZnDDFA+amJmQbQZSsdtKMuAbyBRtmLYxTr8NWA==

On 12/29/25 08:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.3 release.
> There are 430 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 Dec 2025 16:06:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

