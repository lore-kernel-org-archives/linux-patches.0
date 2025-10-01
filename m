Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137DA278E47
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 02:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759287105; cv=none; b=t21amBC0OIzZ4VQ8BYPfhjV8gItEJzHtqu6UEoNKGgKOgaihp2c8MaMABZgspKg6sVWV5TzJiwRSUaYATuLeJoHHJ2VmfzXzWiYzAr4fnwXWFy3d5YDz9K1oXEAFMC3W7faycAsjcg2Ei9uz1Uag87+It/XWI1ZB2IBh/1ypQVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759287105; c=relaxed/simple;
	bh=6b1u7Kf4tUpTJtfjwYX09Tl0CgUkm9q+GcCPBq3fM30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LdhD40FYcrDd1T3fzZSWlkyJiq/QOwFFvBgE4ENzn2vP1DvfPxLEP+X9tWpuU+Ncb+2wW7GkR85IWJmzcoSow4rJhurRY4luWb+d9pJneIzrHh2bryd4Dfb1G9pBCPOmTY66z1KHMGAf7QJsNswqwp45wXPZURxB/EmQKswKSnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=NXdUirV4; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="NXdUirV4"
Received: from eig-obgw-5003b.ext.cloudfilter.net ([10.0.29.155])
	by cmsmtp with ESMTPS
	id 3bMkviQGMSkcf3mwKvTc8E; Wed, 01 Oct 2025 02:51:36 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 3mwJvHeRPtssb3mwJvw9Y1; Wed, 01 Oct 2025 02:51:36 +0000
X-Authority-Analysis: v=2.4 cv=Hb8UTjE8 c=1 sm=1 tr=0 ts=68dc9738
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=De7t3naRBfxtA5xB3EgA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=NoMfgL5SRwsCbyB8kF4RpQ/eQkjRjzj5D558YP1Kgp8=; b=NXdUirV4NbuRsh6JECz6kncklc
	Keqttp0xUVhtF1u+FlUfemd3AjIXAzRtPQxLAPxaFOiaHQ6LFCr8NTGGAvmevwfWDMb5OYisTeAqS
	LT04J0K0COkRL+zD+cp+DaF0E2RAoYVdAsnLPIhoq1Nw2mGG+ghnhK0f8fpV/dn15RaA5nH3f0Svj
	m74hynn3ySsnwl6ZdmuyppoDwasszK2GIlEJAvINdLdl+n2R9aILE9XG+h5kbNQEmonQAWYI7RTx1
	iqNY4uhcYn8oABLdepwt4F156p/Z8q+UA/DeylcGw/TNfDsIpGUpj7TthMS2GJlxRm/y1uXjopQmG
	NQ8ziPWw==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:33322 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1v3mwI-00000000Wl6-3TSP;
	Tue, 30 Sep 2025 20:51:34 -0600
Message-ID: <56349cc7-cf88-46a0-9092-fa2e0802de33@w6rz.net>
Date: Tue, 30 Sep 2025 19:51:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/89] 6.12.50-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143821.852512002@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
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
X-Exim-ID: 1v3mwI-00000000Wl6-3TSP
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:33322
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLOdK9U97TWqKPMZF/SIDbzq1TnAXON2BrfaFSPaddJ0EgKImCpi6+gJjaILzXWANpKl9H9hIRke1NM9A0GRTdgcfEsT6b115lhMfx+CWhMqhqGXpRRS
 Jcw4vpp27UiSb+6C3VQA9iPe2U5/2C2xx44tvaRjuswB4u6b+UQWiGSNvPm8ouKHB8iEWfns/kFjiA==

On 9/30/25 07:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.50 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.50-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

