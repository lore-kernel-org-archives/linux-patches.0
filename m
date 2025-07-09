Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BEE2877CA
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 09:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752054738; cv=none; b=rBmQHmHhoXDQJVqnZtTPllj9iVQPrJleLsUcwsgY6xwtja55OQ5tXiGm/ZF+N8jBK8Mp5ww6qvEwbm9Bk+xIJp27ZYIsu8BkeYTODVE8y0ONwpq+uuFcny4p6WYQohsl/1Wf6+xjj6wrY9L1v1okI0aRu56WQutE7F4QMLetbtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752054738; c=relaxed/simple;
	bh=A9YwGZZdokPFbQ7Vzo0hhFyvQF6XeBycydFK7Nnf9Us=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rOwZPpZGKYtUG0Hwz707Yw8zuA6oPgFQ48CHXuYwIywpUzwzD3BprVjKZpldMTXsCh2fM3oYxegR9AqmvobpPjz5F5A+d94qu4PqGXwqdfnLuih+V/4wm38GF3yijhndzys3Z4ryeSj44qR1iXP944uijyVNSsDNCrv7xzxSEvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=w35Zphu0; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="w35Zphu0"
Received: from eig-obgw-5006a.ext.cloudfilter.net ([10.0.29.179])
	by cmsmtp with ESMTPS
	id ZQJMu3cTQXshwZRTFuWNcB; Wed, 09 Jul 2025 09:52:09 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ZRTEudnfW68lZZRTFubNHZ; Wed, 09 Jul 2025 09:52:09 +0000
X-Authority-Analysis: v=2.4 cv=QpdY30yd c=1 sm=1 tr=0 ts=686e3bc9
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
	bh=utcWr1KM/dmcMHpzs+cyHVz1H+ASbPEmF9dp1y+cR+U=; b=w35Zphu0n9ZOaY4v89CJj2NS/n
	tqoQDSPIN3oO0aJJEJelRqzSG6lzNGXW3PPK915lifQ6bEVao13xJCIH1AeXoppLCK6i5vmBu8jCa
	12mQJWd4XQPbLMYnCtgzaJGSXepvjBYOWMyu/+rHFriCkbVEMGR+bjaklI6JmeHrbheId/l9jI8AL
	zjdkenW9zLgMoUNap6LcpmW2ejU3EEPXJFrOXXJAIda4zLWkXX2AePzkE3aHZAmSNN0yQSf1LGQRM
	MBySimmqf//MwD0a12pnWh5V0Img8EJdiIePu4lU22LwcJy88oVvh4sSUMjai0QEYPLVzpnIQC10k
	GxcK42Fg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:46102 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uZRTB-00000003NoC-48dC;
	Wed, 09 Jul 2025 03:52:06 -0600
Message-ID: <0a02f7c8-cd0b-4e69-af61-ab20d2c37c63@w6rz.net>
Date: Wed, 9 Jul 2025 02:51:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/130] 6.6.97-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250708183253.753837521@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250708183253.753837521@linuxfoundation.org>
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
X-Exim-ID: 1uZRTB-00000003NoC-48dC
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:46102
X-Source-Auth: re@w6rz.net
X-Email-Count: 56
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMnFVh2ssOboddD/BbKiHpASwiLLIFw/Q7Mzneri4aQAX7lo8eWehDdh6t+rHskqUgkjmzZLFRguNRFjvHHlqpt3igY9G/MhkPOvC7P5IDCDdh91iOqA
 9SDlUBkZzm5f94LGuwehS10eBYJQvPOMy8XdfyWKLJKauweJejTAmMwQhutQIMRhTMrqONMfZtpWng==

On 7/8/25 11:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.97 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jul 2025 18:32:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.97-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

