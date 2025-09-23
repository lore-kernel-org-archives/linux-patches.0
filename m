Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DF614A0BC
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 14:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758639479; cv=none; b=VdfRs8bybPFlyIR67VufTN3LkfeGtjXzsNtJ2QY/1yFTNKBHYIeBEMpVIm/4mBvpoxVkbe1Y8OgF7lnLqRuXg94skdy7c17BX9MPMG1YObKVdDPDKQc0vxqJ+NaGwQMyWJWhrNTULt33GRXjnY/kSY0QyB0FkmXT/PLcEtzTIR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758639479; c=relaxed/simple;
	bh=fPgKhAXLtq1r+0p7DPCWl4qoTyUKru1c3B+IZWuMy88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CPU1n6HxtBL8YTcV0bV0Jfpg0hFEAAcVcuPpwWV+7+JHVgzfoapFgtT444lq+T+GcryqVFgEpuSfZOLmteb0YnMLnYP/lepLI5Vbsg6UY6dN6dk2ue3K1O9YyeUFY04HyM9WKmBCNE9Pzpq6z/ySFykcyZn03aKrXogHKAuvz5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=yPYHckoK; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="yPYHckoK"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id 1042vXgDUKXDJ14SpvEDJI; Tue, 23 Sep 2025 14:57:55 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 14SovJ0oFBc9y14Spv7557; Tue, 23 Sep 2025 14:57:55 +0000
X-Authority-Analysis: v=2.4 cv=ZcMdNtVA c=1 sm=1 tr=0 ts=68d2b573
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=H2e1TcdlFpyve7uw5OEA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Ei7w3jLwdGgrHNAL8l1NYLiV0L5D5a+WqLWXWUhRPtc=; b=yPYHckoKdKLF13hMR+iCX+JnES
	56HwZHhvEjHgkfo3bBgQiuhYzH2DlEKKbY7DTZAA3C472eWkWojSMLOyUnGfj43rB0iwFVHCjWpmn
	/bJ/ziWb0nplp6aD4IDd0AKhTQTEfoDP9DQebeZd2+xAhNUGvtS4IcvqZ2LmwsOOn2X09CAq+OwH6
	kuwbPz/PqMlifKb/CafzZpxY7y7GlPC1FYauLFuljO4r9d+bDcJIFmgQr3MUUPT9ONF3UG1Ya4VTb
	60Tp7sQSVSx+aG1VsxaOGdOYdEP8PqzlLGRKCikeVMOfpTcSVvPwmJN3z0gSeW7tdexkjdUESaLPn
	KHKo7gvg==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:36408 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1v14So-00000000s8B-0bpF;
	Tue, 23 Sep 2025 08:57:54 -0600
Message-ID: <a4cab218-3c25-426e-a5a5-fb49d89ce544@w6rz.net>
Date: Tue, 23 Sep 2025 07:57:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250922192412.885919229@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
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
X-Exim-ID: 1v14So-00000000s8B-0bpF
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:36408
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfL6DtO8UdVMk6hT8QVTB1Wy5DNAgS5ktj6NzKf4q1ooRGjbdbk3SOR7DKB6+ALmbGDaKGWpWpzwvzhfjoQubceDBfwgAf9OkrONBUTPUJDfY5pilUeVL
 ZDXakHhPhfSZ3B15hTa+hpB1PbJDcAbbvYHjYmtYAh3QowpCBmLp8HssgmvEq+sLMIzTQCvgOJTqeg==

On 9/22/25 12:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.9 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

