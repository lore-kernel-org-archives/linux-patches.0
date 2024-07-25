Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA36D12B72
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 05:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721884782; cv=none; b=l+7jlOJbBob/sc/E5FuPtDEOCtY/qNNWDYobdTrG6XyumtIuzr5VUujwUCzE+QhBF3y1lbIFisMJ+pB+zblyEaLmHW+vubrBWieXcqp5aJl55Lrupq8s7GcwZYEaMevaDE2LdgL0HPTHlAsgfRklRXoy4OPNcZNwKbB6oTYm/wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721884782; c=relaxed/simple;
	bh=ZHjpwkTDyz7BEoQAQ6I+4a+ZAdQUlWW45v7hAWCnCNs=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=ZQCf84n+upNxF+OwYM04DK7nLA78jX5frfagwF4YMzTbaok8jXmXxZ0MaN7VfGfE8E643feWNemSk9yW3cD2Tn8YtFsbjt9XUs6pXKZgBBKqHcFrvVO2b9aFATczSR4tAqcsH2Rip1gUo294M/md52rHRb1UQgiS6YHkjAbd2cY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=TMCTFQUd; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="TMCTFQUd"
Received: from eig-obgw-5002a.ext.cloudfilter.net ([10.0.29.215])
	by cmsmtp with ESMTPS
	id Wq3csu0Uvg2lzWqrasLOpP; Thu, 25 Jul 2024 05:18:02 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id WqrZsb08YeieBWqrZsYgra; Thu, 25 Jul 2024 05:18:01 +0000
X-Authority-Analysis: v=2.4 cv=BoBWwpX5 c=1 sm=1 tr=0 ts=66a1e009
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=TJP467otscr4N1wxSb4A:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+7+8NFJBZn07NjChmXzieuGlhr6iVn598euCshwhFA8=; b=TMCTFQUdzAtzSAkiaNhJp9j1jU
	Gskh2/JkafUIWgCCbilD41hm2z0LZnib246GW2Q1VESJVc+3i9xNLMYwgJRu0MxKsbmqwq1dkieaP
	opO4pHhaKWStLBGEkjpp5oAQ0s7zjVz10Q1nUIk5ZazLsLkwCWBaSbFsIWUjXVMqy6mtQL6aTwyQt
	GZAWKEVZ1cF+9EkVMmtxNPn+ycUaLvBTwRWcmdbxrZ8mbkMAInyXws1Z2aRJYe02O5ZqpGg//duy8
	RydY2sW+5msk0tJW/+1ViJiAzgJpht4zoufOgtpSJKMatF7rDe8Lzjt/5+urEhM32ybnCzoDYOQeL
	ErL25aKg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:59058 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sWqrU-002vxC-1s;
	Wed, 24 Jul 2024 23:17:56 -0600
Subject: Re: [PATCH 6.9 000/163] 6.9.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240723180143.461739294@linuxfoundation.org>
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <81d445ce-9881-414b-010e-3d2d34f75274@w6rz.net>
Date: Wed, 24 Jul 2024 22:17:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1sWqrU-002vxC-1s
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:59058
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfF10EmatjfS5g7JDBbTKJuG6QSwsQZ9E0nTxVm0nRkZp8drEk4BDQPR5u1xQ59BIThOUTKFzm8od7TEWslXr72/BovEqE33wAdshsZHCV+/GLi0eh95j
 emxiONugYRIJ5UgWWm0RJY/WrhA28E1CTzhzb2djDu/GcuShtBx2IOVq2ojMrH4fEDqJN/+qVy6KZA==

On 7/23/24 11:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.11 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Jul 2024 18:01:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

