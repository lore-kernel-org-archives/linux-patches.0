Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B345B230BF3
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 10:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741687990; cv=none; b=XnUYw5I0LBEQVbnZWeIZKC+I/KOOGU2sgVJeJVRXv0G9LBWgaoQvisGdgIvKaAYXox+uqemZ2db5YPJgMhSBKd+qbFhM7hAjLU1k5wjBq+Mw4S+u4ya5qYSj2p3IuPryjbVY/rMY2zgGxZyR2eRfivpB+WkbPEChoI3GFVL3sK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741687990; c=relaxed/simple;
	bh=eKZ21sAfzTBNzYWki/MIvFoXRYxeTYoWGzwrhM4B4YA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cabIj+Jskh80sXQiHOfbM3gZNfq+I7MQvGBWZVbVQKFfyUCSTwqLjXGaNITsfdhOsfcXcHZkUyGMXxbZ8PeSALn0a7OLKfp60Ne1vX/gAVoeTTdTF1tFlZJrwYojwGgmnzI/DySbT4ADWxhPVYscVQyat66efybi7i2cCbz6R+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=v38GcD+o; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="v38GcD+o"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id rnyXt66qtAfjwrwbetOObm; Tue, 11 Mar 2025 10:13:02 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id rwbdtXWz1dQylrwbdtxZ5P; Tue, 11 Mar 2025 10:13:01 +0000
X-Authority-Analysis: v=2.4 cv=McOnuI/f c=1 sm=1 tr=0 ts=67d00cad
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
	bh=c9ZH/a8/3JJBb4/soWP2O1bASmEOVWhEZDkVB/Rb6R8=; b=v38GcD+oSGsQ0DQwnq3R/bbbPn
	dhUusb3SXIcH/Y1rFzkkgUoUTkB8jyADUWx/Xp9dZbXjvfdJmGgUePl7BJgcp6+zcbU5pkltkbiTm
	bEqsvl/3AkzjO+3U1kHQlgB5+5wu0FAjt3tEFUgwAJMfoKO6F9bwxJwKa86aKRaDigPxhvQ4Yg4Jk
	vIY+1zBLRu+3aj44ngGSLqYAzRtsN0UoKuzm+c0kw6pW1vr2xb67I/h9ZZCTUMm7AwM1qhLzdy0LK
	/I9gZAMOzYZ9h13X5FfKTuWU3Xv8IQw+o9raQrDMmngbbdNYtsTAVdgAIYFqRx/Co1qsxxvNzmGqU
	QZLhwriA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:41848 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1trwbb-00000001VIl-0O7N;
	Tue, 11 Mar 2025 04:12:59 -0600
Message-ID: <c958fd6f-9381-4571-a1be-b2080122f78f@w6rz.net>
Date: Tue, 11 Mar 2025 03:12:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/145] 6.6.83-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250310170434.733307314@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
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
X-Exim-ID: 1trwbb-00000001VIl-0O7N
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:41848
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfP0hBGVmvdk1CKF00nEzPFFVCU780OifXs50RUqSPH4HfRzPCi5fIkFrqD3HjZtRqgJyX2/d+rfqKZ/bfJW9V7zWZyaCvAR13ZClG15OBiw0dpmLgQlO
 5q7AhZgTTPNncBOTfWrmTesVTnpJqu9Xyv44p9rQsCU5w/nYAwVwwVcykNNKxLxV+afHVzzMgn6nDQ==

On 3/10/25 10:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.83 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.83-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

