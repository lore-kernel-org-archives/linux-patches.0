Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8B42FF66B
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 08:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775721840; cv=none; b=MhubSLjQw9qpqj8KDgbTwGIqEvniSVamQ//R60KB/bTbvEf/JCPWA0TK3snGVosY/vWkdjkF1JAQPLrpFqba5vm5GdWAKUHCMOr/3bvIR75Rrmz4o3Bvs/X7oSvKucGoKWTc9RFYhLsWVK3/SEeI00H8ZH9awQkRfM21LqOdbaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775721840; c=relaxed/simple;
	bh=MQpWjFYIajbAxCrwByTclgTRDMMIvaTVyWFnHL1Jrt8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OAbdAzsGdHb8s9Q1ZdMMjzpt5WyPGksgWYXiCx6sGALiJ66U0mXs0f7M6CruVGxMwvsJ0hrr92RAwJxLq2Ggap9/GBJwckN/UpPOVXlqcNMI18KK2IUsE6B61tZByGRcl4AxKTdP7kZqIN+pzImxvXvvvpU9Tq4HLM6n9haojP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=trH5gDiy; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="trH5gDiy"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id AhUqwH4Cs4RkpAkMowbkt3; Thu, 09 Apr 2026 08:03:58 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id AkMowNbNewWe6AkMowVkVW; Thu, 09 Apr 2026 08:03:58 +0000
X-Authority-Analysis: v=2.4 cv=RfSQC0tv c=1 sm=1 tr=0 ts=69d75d6e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=K1P1GM0TCK1fAeP+My+jghIbyZVp4HsU0bpEQHMZi4A=; b=trH5gDiyBOs/1lNopblFXPX1ny
	MlKQqyqimAbo+iRz/KBSKOm5cHZu4hamsUfwe8tX+Yr5WMVsbI7Hhg3QZtpzqYFq7KIhDjdAuGPCZ
	Vyb+lwLU4/5JAdlYOk220rQWpjZiCe/JGR32NF69hHW1lOL7r+FIAfHyzvK+tUUJBnGCHolaAo9EP
	F6sDNSifWiEma0fgCOqTk+pf4J90afMEBG4HSqKpBFo9qPlz5pHHeW8JNMqdQ6MK6NcOBdk98EdSW
	+e8dYmuVsDpGa2wu2HW26HIDEl8OVKHkzUD+JMxG96T21Ykpx6eMN3IsszOFQRcYxnMCCe8qkISUZ
	NNns0iog==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:54850 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1wAkMn-00000001xaL-2MVS;
	Thu, 09 Apr 2026 02:03:57 -0600
Message-ID: <3c357768-98a8-441a-bdc1-2049671864b3@w6rz.net>
Date: Thu, 9 Apr 2026 01:03:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/277] 6.18.22-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260408175933.836769063@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
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
X-Exim-ID: 1wAkMn-00000001xaL-2MVS
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:54850
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFaSGNz+zcNXdTdmq6jnBYAFxNSmUmBMsSiL0tr22KWPsP/iwNRHrVDaZezf4Uj8eOnnsmsBrWBN5Tgbab/tJTrzp8IqS8TseWr9xY7mOXDJCtPMOT6U
 45FjBAy8gaOdlt3/gy8VENPy3MjtPwvKjrBm/IHhp1J7B9zhhsPtnCYR1ZEpPcgM0jRKstB0JgRzjA==

On 4/8/26 10:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.22 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.22-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

