Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.89.44.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795773054;
	b=d7R7BSDmEBWkluQP8T6MnNVPcWjsnLxnKGP4UemJPK+BjErAfvZFA6b4HphkV/pO1vGI
	 f7wnKrBzrhRYIdYzcbUFgUAdT+cVodUhpUz5jMY/IQ4m556x2FZL61p1j4rQEFpGt42bt
	 FmZZ8RbE/jbVXRtL/LFB9o5iaFGtLFJTuEl1YFoFeIKkmeCplXUSdB1YzNhKEaz9iz99a
	 FNSz1ofDqusncmK759lp4ijmdl+CZdbg99DG4ELqYBxJG4ieffcadJ+IRN3yl3Im9TGdp
	 sttiLcvUUiG0FIlKn3l57nNA4MAmGhddQZRLLnmEVsxi1Bqq+FXkqkSYedYgDOgD7wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795773054;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=RSXrQLNW2s0/hlrSN4h5G8iLSM/6lAnsqJ3mo4i2tVg=;
	b=e6ck128fCfIX8/Nh0+RB9dT4iKZv/a+fRDTP69TPmpJ7+0Uhgt35Mb91emHzhMYU+HLS
	 tOBbYQ4RaAFbpBymsRwvshc4ntNlCQO7+aU+yBJfEfcRS9aXP1U6ty6EVFg6epnTHt0a3
	 5iEbSVfPPqZedAbgJsTX5ReZK4BQK97BCo4wD3K73a86Yp3a1tFsaa27Vk4xRsRoNvWhX
	 qjnPv2BUkYomgAhfSstNcdpi3LGRPuOvubuUJJSG6sasDygq6+62KXC6dvI2Fj749/NWf
	 Dw0jBl8Jn/DF9x8xibAjnGuu65wJCPZPwjz9CMjofXS0lVYH5HT0TDxSdPPMamEgKTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=MUbuZDUt;
	arc=none smtp.remote-ip=35.89.44.37
Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29823606A337
	for <patches@lists.linux.dev>; Fri, 27 Nov 2026 09:50:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29823606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=MUbuZDUt
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id WlE2xG0DnVK9UWsbVxWhbe; Fri, 27 Nov 2026 09:50:53 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id WsbUxFWyd0288WsbVxNa4Q; Fri, 27 Nov 2026 09:50:53 +0000
X-Authority-Analysis: v=2.4 cv=a5Iw9VSF c=1 sm=1 tr=0 ts=6b09527d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=5gI1kqHO1WKH8RX1p00A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=RSXrQLNW2s0/hlrSN4h5G8iLSM/6lAnsqJ3mo4i2tVg=; b=MUbuZDUtOElybvGsxmuZe26h6o
	XRj7TvY1zVGcoApIi+z82rOjq1NFfbBrn1OBZptLlN+Pdnjspkt5WDrbiYQaveNGJDxsjO3LVjrKH
	9SbKQ0jbzwykbXn1EkJLtWoAIeWNnavMKrsRUA308l0E79UnXUQ0MacTrmq+uw2nRocGZrmKNZF+1
	X9COdI1kqsAekFnaGxmiPqLlCbs2jYPt+BiwFMVXzzjj9toulW7zfYsE1EAbzqbGcD5EF5afXDK3H
	7p5KEdTcVR58m5FWWOgda6K5lgogDDtiWVMHY0DvGgwe4ze2rAfdK5WDE87QwStiR+azTOnxtC6Kx
	3QRQ9aJw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:36792 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xWsbU-00000000IlN-14B5;
	Fri, 27 Nov 2026 02:50:52 -0700
Message-ID: <dd3e38bd-78c8-4d03-b998-6c3bbdfc003d@w6rz.net>
Date: Fri, 27 Nov 2026 01:50:50 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/318] 5.15.227-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261127052515.841545444@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261127052515.841545444@linuxfoundation.org>
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
X-Exim-ID: 1xWsbU-00000000IlN-14B5
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:36792
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfP2KMFJDmGh5Lu5Wuomfx9t/81mzmVdEBCGuy89CKLWtJjxaNbg7R+7FiJWNtkE5KcSp07o9r6BgzSSvGuPzfFbhE6a7r31mIZ10e6g7pXszAX75ynbF
 ITZYp5+arIyE5esB24TBkQ7p07Hs/W+H1ZYTjMDIiKm3guGBU4Hud8sRAoGeNGn9gqJdJ/Trm4EY0w==

On 11/26/26 21:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.227 release.
> There are 318 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 Nov 2026 05:24:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.227-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

