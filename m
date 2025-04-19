Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4B5CA4B
	for <patches@lists.linux.dev>; Sat, 19 Apr 2025 01:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745026805; cv=none; b=MwkZaDUgP+CibF0uFKHGHQvZoFmmBzvRMdwabImhkz7kvXgLR7b5xNL6XYyzZmvR0ERublBYTvV9nI4dBk4AyY5Brh9BlSQv/sH6NhwQqPxsxg+LJ0Pb6rw+nxT0W7w94EpCKtgkRz/Bfc4PpauWSAfrZKid9DOAOSetDBbBMwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745026805; c=relaxed/simple;
	bh=pjbMhsnDJiDcVlV597R8ezaeAn0+5HjfbvSJN3qfqHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p1PY76BD16JYHijiQdQJMyRgjPZkJrz9Ybzwhv2en/fpu0pCM8qvwUOqldsxNWV+RZf963ReGc4ICsHki6zNv2AafQVrKFtwB3/GdtQKnunnX6lW9fhnRzD99z9nFKt5rgQfbvV/sm/vkcUkW6M95Ufyit9OvvVgeg+IZbbd/lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=2j0VD+IN; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="2j0VD+IN"
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
	by cmsmtp with ESMTPS
	id 5oA3uaJFWAfjw5xBaub5IU; Sat, 19 Apr 2025 01:40:02 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 5xBZu28C6p8Cw5xBZu8r3k; Sat, 19 Apr 2025 01:40:01 +0000
X-Authority-Analysis: v=2.4 cv=V8N70/ni c=1 sm=1 tr=0 ts=6802fef1
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Ro7idKd4BtU0TkVne+lQsWOXuLWCVS++vWMksVF03wM=; b=2j0VD+INL1NyVHzSis8KGNfWPO
	2bKAGPku7RTp+imMTcT6ZfB3u5f+OGmDS2OHlRXoG9rzm8KsFykKgRDHuWsgh7DK6AuwG7l6eSq18
	SpRoR2jyiemh0mWZ0nw/pDHx4P9HrGeGFon9jxwCI12shtPZD4YuLAgqQKGm+rx7zge0SIYdGc/h6
	+VKx/aoZUOxv3pPyHc4tjHGAxJEYgdeNnYh8yhMzd8WmPO3ULUu6hMrlS/3FmT/C9LfO3iLxlkkRb
	/tlevdTPkF/F01TT+9ftfGHJ9RUMbLFd8KwWN98TaVUZxPYAcgX5hyx5Pm9YtjLQ/yqIwCmU/N99j
	JKvw+whA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:48400 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1u5xBX-000000009TE-1MI8;
	Fri, 18 Apr 2025 19:39:59 -0600
Message-ID: <031e3650-08bf-4c06-b1e6-2551c095c89b@w6rz.net>
Date: Fri, 18 Apr 2025 18:39:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/392] 6.12.24-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250418110359.237869758@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250418110359.237869758@linuxfoundation.org>
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
X-Exim-ID: 1u5xBX-000000009TE-1MI8
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:48400
X-Source-Auth: re@w6rz.net
X-Email-Count: 55
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAwrmYaleBzNicrl4t0+lWEevNIKSjDv4iiIETuLL1XGKkubmGU18ok+zsrkK48/hceZVyp3JuYiM2xsVUct3mMGP9QbjqpIw74R3wNsXJrotpSGuRkr
 R7PN27CWK2Qbizx2++Q6P46apzX+j7FCDKVOaqpAaGlmGOQ+TJJq9yJ2eUZDitCTSXuuiwX55WqLYw==

On 4/18/25 04:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.24 release.
> There are 392 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 20 Apr 2025 11:02:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.24-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

