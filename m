Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25CB1B393C
	for <patches@lists.linux.dev>; Wed, 21 May 2025 01:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747792400; cv=none; b=XXCzagzC1bDIwxeDdR56qrxzBoIMEDCJneQ5iUrh5+snktwRdLgpS6gnmRfPI/ZWGiB1wrCTXLJwe/bTwrLlTT30AaK7Ny4z2Lx+ULLBr21dMFdE+JYC66vBBWLR6rSCty+Ap+mKsUryddGDunSuRBXDmMmpBMVgCB7QhJIE8qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747792400; c=relaxed/simple;
	bh=BFUsm+CtFzkYoOFT0IcD/3GeiYNyfD5Fu+25O0J820Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=naLpJtgTQAY09PlBv0iw1KuJVX/ycMHyC19hHwEjV10kWYoRtmQlkkArLMFr2tXYh/Ie3eMIQ+mqpGeaNvPXb6nb7wERY75jZGdXH+g9Qz/+E11ZB+dvaNP/kiIOwxHHnTJvbxr0YpvRlf3PaLFDVpHWtcJ4TroHkSECsQgwcOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=FaJoIMIv; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="FaJoIMIv"
Received: from eig-obgw-6008a.ext.cloudfilter.net ([10.0.30.227])
	by cmsmtp with ESMTPS
	id HUaVuFynqAfjwHYdxuh7No; Wed, 21 May 2025 01:53:17 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id HYdwusJycDd4SHYdxu8uef; Wed, 21 May 2025 01:53:17 +0000
X-Authority-Analysis: v=2.4 cv=CZUO5qrl c=1 sm=1 tr=0 ts=682d320d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=qfBMeBQ8Qh9mIwLNFBIA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ljAXeLh7IWEQrb6v9uD9cqDfEuhMh2lQAo2hYNlKG1s=; b=FaJoIMIv0K55E8uzkpiEFPbuwZ
	lvGAf9cs+pn8+TtkEJt3FYvJzJ3Zea/toWNenhV3Am6nSzBGvyVjf+lgBxLVcFlIRREcrSsMlp2gL
	0XRzSYqKsxiQ5VhKP7lxKP7CBxiXbKgz2gNU9X1tKXVRo4L3zbLBJmZ57nzP3RaChBz6PKwCXz6CB
	jtO/GZFR1OEjek2aLUF8iqAWIxvjM4Ym8m9RF/xqr83zQDzX+sIdki8bSa2V0N+7CY1Hf0f3V0s7H
	4VSQFpSdLEU5QGMXdX7tLG1ms21DSLfib04AeZYMOOFTa8V4119K4n8mzPQ2bl3r2XbNssRjJhR3G
	0AmIZ9iA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:40880 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uHYdu-000000010dX-3Ca7;
	Tue, 20 May 2025 19:53:14 -0600
Message-ID: <769775bb-4dcc-4181-a220-76fc28aae773@w6rz.net>
Date: Tue, 20 May 2025 18:53:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/59] 5.15.184-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250520125753.836407405@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
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
X-Exim-ID: 1uHYdu-000000010dX-3Ca7
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:40880
X-Source-Auth: re@w6rz.net
X-Email-Count: 93
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFJavWwjXG5pJMG/bC9pUgdVLilkcCg2SEbQ5Y0vHxv3dUmH347n75JUEYdb9nYRtJR8iBKPPBDmyx+o1gj3vNjL0ZjOy0eDkZEZ0omxCzE8eH6zDtbI
 xpwVa2qwZbC8REy+LtLHbRZUHak7plvV3HgXss5GERG64x39ovvBuAskRydLkdy+IYCky7Tuzb/8mw==

On 5/20/25 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.184 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.184-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

