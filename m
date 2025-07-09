Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632E8286434
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 09:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752053934; cv=none; b=Y0DOivyVX2HCQzornQrep7cL6FAw3gafaRcJKaevRAtNw93iqcMvjnljfdpxFBiDGn5ksBUveZjDJQYL+1gT5BAzcLtg5tFl0dq2xqL5HyLFdvqsDHtOo1jctFPUG/wi/ddaUmhiE50VoMUrCeIaAr9NlazH/BhXrVrbVE9GRaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752053934; c=relaxed/simple;
	bh=H4OnBJVqXwfDUzYzPYvdVWBHb6VvtCowknKTbOF1QoE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Yhf2ppYdWOX3rL9BHY3oewoad6r/2RwBOpKsOctVRXOfPtN0C03LqBV0cxgXetTBUMd0lL/rz+xmV+WX8zcIcNV1bx6sfIpRUNFiM26szka8qcXfrReRJYkN8NCTiedAhzOQaN1+92OEf83XxKgFRDQwiFkrWtBNVRa9cPSn3a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=jRsN09oq; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="jRsN09oq"
Received: from eig-obgw-5008a.ext.cloudfilter.net ([10.0.29.246])
	by cmsmtp with ESMTPS
	id Yx18uHqxqf1UXZREpu6WP0; Wed, 09 Jul 2025 09:37:16 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ZREou3XrxVUGgZREpuiYYA; Wed, 09 Jul 2025 09:37:15 +0000
X-Authority-Analysis: v=2.4 cv=KrNL23WN c=1 sm=1 tr=0 ts=686e384b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gE1vxVXB2Bhw+dHtLqRvAZ/c6Oc1vDnTp8FjguomwXA=; b=jRsN09oqdMaoJORjPNjiX7ReU+
	rbOQNXxvM+2K4wYB6vDRaktB46G6nMJf2vAEmAzdBWwOp1mIV5kx5aYRqx0L26ZXjsMnZ+q0lpTKh
	jfE8EwzDd5AMpbSWFMZD0xLW4zUB9M2f0D9/AT5BwBNRrtkz4SXJfkoxTV3KMLxDRYTlhvGYzmnoR
	LYTu+Pkssjx+3H/Ii2wszMDwNFF/ruRXv9GNCcWWVWON1Tgr1V+AqiYFK8SYdoPl9TiieLl75iEyN
	kQrclzRVYNyhc3c7eoHSz5jTCgB7tUrTQPr/0mRcjG8M5oY/BabT909gbUKFXjgJQVM5dwibNy0Fh
	jEHqxGXA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:39178 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uZREm-00000003HIu-0my6;
	Wed, 09 Jul 2025 03:37:12 -0600
Message-ID: <a8ced942-b16b-40aa-ba85-a0d110ef3ed7@w6rz.net>
Date: Wed, 9 Jul 2025 02:37:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250708162236.549307806@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
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
X-Exim-ID: 1uZREm-00000003HIu-0my6
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:39178
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBOZf6ODdA7OPWKzDNG4pk3es52L5mAJc/ibabi7/6hpBIv33tGWxdEzQW1L/6qYVFluUEMRkbEnVpUdLn6STJbZxlKFew2liPyhgimhU9bmBayw6+9P
 x1+QjzjTDvDCmwEsJrMcD2RuNdTCep645hI2uG8vnaj4eosC86rCtnqb6UZ7sal63GhrRs7le9psFA==

On 7/8/25 09:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.6 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

