Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46712BB13
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 21:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720041290; cv=none; b=dsBn+cmMRfliT8msGASStvM8UbO2nc/wij5au6Q0DAVWmh20S3LQr33MNbOXfNN57hG0s01GkEPeghcGifOHTZe3Ap2EuzTlKT98U+boBIwTgoBpzd+vIRlB46dfKJZ7+2n0w4dT17/VBuQdAmx7CYbF+9Ox1lnJLvx8Yjs2yLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720041290; c=relaxed/simple;
	bh=voYrdbPdDbhbmyIRqBPJntYOUm0DARjxPxAKwX76mmY=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=JCMrisfE4THd3ljo+WRQ3dyEhZ5lS8LHfVd8DW3SemOdS9FdcfRqNcrX/4zG3Fgg4/a1LTxPnd44sN/zoLnhIrdZDj2PCt22I7ATkfRiLPAItq8LD5Kkiee2PsvD4EtD6kbkLcIpvbjfWfxWyi3DC83LUhpiGQpQGKCd08+0/qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=lbAFnwpk; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="lbAFnwpk"
Received: from eig-obgw-5010a.ext.cloudfilter.net ([10.0.29.199])
	by cmsmtp with ESMTPS
	id P6SUsYvQZxs4FP7JJsZZn9; Wed, 03 Jul 2024 21:14:41 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id P7JIsuy2kNoTfP7JIspdyJ; Wed, 03 Jul 2024 21:14:41 +0000
X-Authority-Analysis: v=2.4 cv=Gq5E+F1C c=1 sm=1 tr=0 ts=6685bf41
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=dM-kR4knkKEf_V6v5WMA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=/aQwcjusGogKCbZOLVYA3pnyiVRW4FVkyjTbotPvRUU=; b=lbAFnwpkySI/+O1dIHLGZzLlEl
	PiahoqkFhxJAvLRB6k4z+kcZC+ugWbbxIj1I+9y7PMxFxqBkhx0QxPCNgKjxX9ljsvq8T/fPskKBk
	V27mo2vKwM4e8fNhdNMTI5TQqow5MeXKJrSV8MARKdSB+uAY5vxFF9H0CtWrBsN8wcuSYBESdBvry
	X6kaDkHeCJcnOfNE/VG2jI62uxCieY3XtFOompEZHVghDPXjU69Lpu0tSnOrCY1AM6utw+u+As3yQ
	on2p/u6wS1AahO+p+Hu7OBoaCdmmZsRJtTI7RlDR7/0DilpNZtJxiyp2huQcnChRhv5V6fM01kl6/
	qcZw2zQA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:46966 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sP7JD-003a5K-2X;
	Wed, 03 Jul 2024 15:14:35 -0600
Subject: Re: [PATCH 6.9 000/222] 6.9.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240702170243.963426416@linuxfoundation.org>
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <e0dbcee2-747b-7e83-f552-a2e8b07bcacc@w6rz.net>
Date: Wed, 3 Jul 2024 14:14:29 -0700
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
X-Exim-ID: 1sP7JD-003a5K-2X
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:46966
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMWJI+jE/MTdVAJ62/SymlO9L9cej9W++RMk2P9/ySD/96PS5Ipm3v8h6L+/i2MKxuDQLEqdT3mxOGiZKNqx8p0u1Gzeqb5ReqyI6jwwRrZYQEeXUNza
 NSqa76I3RT7Hlz8sG40w171ZWexAU332xXNJDqYy9U9GjjSere4e1LHC/ebB6RJY0zUXyf4ReZCJwA==

On 7/2/24 10:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.8 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

