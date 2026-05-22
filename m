Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E695C21146C
	for <patches@lists.linux.dev>; Fri, 22 May 2026 01:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779411724; cv=none; b=W60vd3vFZsPNZmIKV6OR0HDrMXkYitqGpY9zeKWBDyPoxnTUK5+Lpz1iW7dXpHNArSgi5Sm0yJQNH6DZh4Os1YeW1ooypqx7VInoVoFUXL5hWlMBO5VlMvrGo35miYnnazk1khxKsc/BUaJzTlRTauIGD+E5VLDv/tzm1mTR5U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779411724; c=relaxed/simple;
	bh=1OyVvXhLQ4VYQ9vShb5PrvEC+k689rkMUO4al5l2Xic=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l6dgz/boTJym4RAhZn1BYv8Ie0DgeKZa9fY2TolSFK/J2C+DpgTqAIcoz6jCw/HJc0UvvYs4Pz2fLRW8n/kXmC+zD5JGQz3O4opfbzDWCoJjcW7NxVK68+ivren5DPAR98MIFCLW1Gkd3rJQ1qNsmw9qrz4WZvrw48aggxXUB8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=d2We5MY+; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="d2We5MY+"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id QAUtwpI1ugwLnQEH4wsFTw; Fri, 22 May 2026 01:02:02 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id QEH3w1hwmfpvWQEH3wmzOU; Fri, 22 May 2026 01:02:01 +0000
X-Authority-Analysis: v=2.4 cv=Y6j4sgeN c=1 sm=1 tr=0 ts=6a0fab09
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=SLxCzBMg3mTjROeNQ7AA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LYgk7s4wEpfL7q1IYq5qVhocvxy7KjAN6w30eZRqImA=; b=d2We5MY+cq5WdKYfTMLjoWfbmA
	nfA66Mp8BgfF6VD/EbYGWz+RD1vhqiQLSgwjmQUBX1ku5xbQlBn3fU4O9K4cRKxdq5JB4J8Cdb6N/
	s770uavI67zQdlobOqTryTPftbmPY8YeS84BeaDQWYQF7NILOSfQY3JwA4ND5NEa5kDUkIckhyJH+
	gsM9oOJsNLBuredeU3Hif8m/NDwXxLG+yfp4kz/qjNujq3eI99I8AE1y3gbFU/XkC+KdaHbW4grbx
	kQADLbvgimxLTIH16jpWEG6OqwLvp/sn7GlP9K5VlpqvqHWfCu1qHHhEt85v+DjLZyRob01n9z/I1
	k3n++G0w==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:48270 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wQEH2-00000002b24-2HSF;
	Thu, 21 May 2026 19:02:00 -0600
Message-ID: <93ca7a60-202b-4d9c-a5ed-749888f390fe@w6rz.net>
Date: Thu, 21 May 2026 18:01:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/957] 6.18.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260520162134.554764788@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
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
X-Exim-ID: 1wQEH2-00000002b24-2HSF
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:48270
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFxvObMk0Rw8pWaQ9VikVhzX9YxUWA4VJjfLFHtnBjm1aP7y7FODcghrxjMZRhxAST7nvPbPEBoFZtZHhCEIat6W29bklGQVOhpnu6FjcKJwqCr3xM0g
 +GHm6+ExdU440P8Ne8oifjezlcg00sgbsKxGF3uciIwnTyUe4ecdBA4DIq4708M1nWbttfH82nSd/g==

On 5/20/26 09:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.32 release.
> There are 957 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 May 2026 16:20:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

