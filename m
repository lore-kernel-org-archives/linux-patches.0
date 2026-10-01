Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6BD4A8FEB
	for <patches@lists.linux.dev>; Thu,  1 Oct 2026 10:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790848922; cv=none; b=ddAe8ZSrurSlYeIzLu0I32Ebu/6oNaGSwyx0cbhuDjOoDt+wMe18kzkHKrQCmxsXNlIVs/2wOqjK2BXjw/PqzC4RwOksSXhjj6Us+5nBc7CRw1zuFatBzM/6A0cgbcgpnLgFLBYvdL8wroF9bEEFaJiAFvNRudMYz4AKq9qa2Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790848922; c=relaxed/simple;
	bh=RZbcpZy2o4TMjiDecnxuaj4Mz2ZrT64tfLLlaWElnbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rbt5f58mXW2UA9H3MxB1MOtuB+pK25BUIRra41hf5MBfgy1T33ugKkmCms9j1wRnjdcU+4EMHKoHYTIU1BDXnwoVJcjbxcKfxrBMSOqJe0vwV8alM5+u5Cb1PVh8X9/dL9f0Uxh/VUmPjqGEwcR+IjExyqSpiyoWq7K87/W1p5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=EoR8kDdq; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="EoR8kDdq"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id CBYUxA9aev0ndCDaSxtSLM; Thu, 01 Oct 2026 10:00:24 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id CDaRxw3zqFNcnCDaRx1Lil; Thu, 01 Oct 2026 10:00:23 +0000
X-Authority-Analysis: v=2.4 cv=K+UiHzWI c=1 sm=1 tr=0 ts=6abe2f37
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=9zclH_8YtXkVf-sGJcgA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=uBQLWf+f9/8BuMaJi7gtHG0+fW0Cs7YW8v9nuBmCj/o=; b=EoR8kDdqlkD02o+RYMgG8OfUoQ
	xObsE49GW0NsAE6lCuxGCf4FINo2oTKexJoxn0p5x3QwNYxNqO2KLa6yBuTQ7+1BUAgGNj11G0NTX
	ZQFt+KUYcM8OYIgBCkxBY6BMgX0TJUv9CMH1gRXedhcVduUdyuaCRlo90N6uzkjIWeDyU+4PgaTDh
	a7OoqDH8PyKCIF7necZx4r580ptDknz4L5eWi5XhBsWnUZXEpnwaw3R0zqawVYY6PWQ/Mz387aRWK
	Mn5nOk+E6RLf2Nszrb9uk/eEoLOx+VNiBN24Rku/5HO6qHOGxvMXXR4Ic5gSQgoc9rZbMSC0fcatN
	xz+7RMMA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:38440 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xCDaQ-0000000209j-2Mg8;
	Thu, 01 Oct 2026 04:00:22 -0600
Message-ID: <53e468cf-1b10-47e9-b881-64ca43422820@w6rz.net>
Date: Thu, 1 Oct 2026 03:00:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/395] 6.18.55-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152340.591469096@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
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
X-Exim-ID: 1xCDaQ-0000000209j-2Mg8
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:38440
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfH8BOzg6/5RHYMvNBnw4GwlSB6wHmPQHoLJsGY/N7WkthaeJp3akdi9Bh1ZXq0p5fylxL1/8NeB08sIGNCBw3lnLSE5kxHXtJ0ijMmNy9qgAF7bLpafv
 Q35C3H+NdyoUQTA3cHNGf/eAKMyMn6H+naDhddXzO1BofWVjNSR9UO1lDut2iklv/IUN4xZrKNZqHA==

On 9/30/26 08:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.55 release.
> There are 395 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.55-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

