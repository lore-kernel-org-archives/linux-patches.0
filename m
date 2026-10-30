Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.202.169.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793404603;
	b=lr9UQrobbsrrrP5MW7PvyiswV4Z+ezAQf/2v59JfIFQWL7787/Q4cXcX8YRKnXVaAGsF
	 dPm1gs5FrgFcYs29jvg3krxAUk5vJ8jcQ0rVe2EPM01Bw1nQbE6b2vPsIhurdQFs3W+8J
	 jqoiHk+Sn6OLmSjEJ0jsesHpR+E05cGwBkVawxgAqcMXXt75UUN3Huo/K9UdL8lsSFu33
	 o2dU/eJNRh/8RUnURRQL8tKkZz7IB4mUkbiHUnLC+WxzF8+3RB1PYmkf+fiw6ZtcHqkgg
	 EhfKAD3O9h5hrRXbdPggcWOZsSsSDInM4sE3JWhzeAIK656aiDkBDw+oByAWqwKb3OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793404603;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=tuKOjEjKEOS6GlJnkqOXy2dtjd2kG7cyiYeWqqFjOA8=;
	b=Fl2gPFN1JI9jlykVM7yS41QGNOXZsqFKdtwMRyvcF7cEsmItVpgq82xhirh9tHjDb774
	 78MRm1faLYkKFXYPvTLRsVl5Y5hkRXfZboxk6fLhImWo6X5rmRbkVeSYUn6LFetEGIQXP
	 KNuR2Te7ZAVdmM420TLntuzal3spaDL4SnEOesMG++INsrLc+3KpAivc9JdStsGUW0irh
	 jlHfxK+6oaAfz7pDkjavbIhZcEFlxAXi4+kXz+BphDKgxcUZ54D0guPLJsAqjfkAp5dwk
	 z0mTLcf5Iuu2Ustfr+1Ptfe/dUGf0dRDGK5YDKiZ1YR+YLgZ4RSMfhz/bk72rEQFM3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=lsNL5Lff;
	arc=none smtp.remote-ip=44.202.169.37
Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1180C606A325
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 23:56:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1180C606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=lsNL5Lff
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id Mslgxr10kJFmFMwSgxsH7h; Fri, 30 Oct 2026 23:56:42 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id MwSex4jdS8LLeMwSex3oik; Fri, 30 Oct 2026 23:56:40 +0000
X-Authority-Analysis: v=2.4 cv=BenY0qt2 c=1 sm=1 tr=0 ts=6ae52eb9
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=UugJSfOUJsejIDDmsRwA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=tuKOjEjKEOS6GlJnkqOXy2dtjd2kG7cyiYeWqqFjOA8=; b=lsNL5LfffEj8u7hIbI+Dr6zUiz
	Ky/lRqktBDRf2C9GN9XEI1It6oEgmUJcG7W0UcVZabWKR97TT99vyevoOXmPsHy7qhA5QhDivbZc9
	6PNNAAeGVyIVLnRDSU2Zw/96iE1wgNTzBg3iz38DhQ6x6L/zp6TAO5wFjuXOvXg+SztjwF/5rXEjU
	znDcqpRO/Cp6/B93AcaFircvX0qyWFXVjYtwfMOWSYHe6JjM1rVDoW7Pen8nsDSO9aNZ8NoCpbvWS
	INdxT4hhDGAzkWEdG5XGfM/QUbZ4okwIKkTfDP+6C7yWcMuo9w4tgvSBcNPvmYY+NHpMIcWU0Zy2U
	Q19/iu9A==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:55120 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xMwSd-00000002X6Z-2Tik;
	Fri, 30 Oct 2026 17:56:39 -0600
Message-ID: <b069b9b7-49fe-4a39-8f3b-c72f90b2d774@w6rz.net>
Date: Fri, 30 Oct 2026 16:56:37 -0700
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
Subject: Re: [PATCH 7.2 00/10] 7.2.15-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261030121255.257615100@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
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
X-Exim-ID: 1xMwSd-00000002X6Z-2Tik
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:55120
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLhR6UuzxtnOMGwluuWCQOebjIkjT63PoWXHvhABzsR2Ei2j1MaFvq1hgfZsRifJOl0saGHx+sF+1HbXMneMWVzJ0G6LI6Bl5liFMcw+SQyroKOMaSYX
 Xeqmypw+c7zCErQkqSqQiybqkT3F0qPk/S9LjYhyCslx/sfSgK9J+2djLhy2p4WcKz140SsTSbWpnw==

On 10/30/26 05:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.15 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 01 Nov 2026 12:12:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

