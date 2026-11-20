Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=35.89.44.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795146539;
	b=nudoRQfJpll8r8E5++kOkXVR/WBAZx03A6WGlCl7pLfPoGPyiGzECPPvS6hYBos9T5IO
	 7daNUqHzgb48RVZkbgztS0J9sdk9Yx/8vAvsZVenXZmMisBZxm8Fme3KVUuJWZcAbKRQA
	 4NzTFDvDoSkrZyaaClra1NzlGU7lGfN/Rz4XV2394X2fjqWyrzi3AjjixRA1xyKXJHLOc
	 uGA23vD4Ipm4SMjrSmycwkD4MH5D6D94Idurxj9yoleZZPqSp6l77pRSrwjPw5FWbhP2p
	 2Dq7HdjdxAlgaikQqDvZvqOZNF3WAgxbYe1VOdefYL2JlgHgmZDD1jwkCit26B7WW0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795146539;
	h=DMARC-Filter:Received:Received:X-Authority-Analysis:DKIM-Signature:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-AntiAbuse:X-AntiAbuse:X-AntiAbuse:
	 X-AntiAbuse:X-AntiAbuse:X-BWhitelist:X-Source-IP:X-Source-L:X-Exim-ID:
	 X-Source:X-Source-Args:X-Source-Dir:X-Source-Sender:X-Source-Auth:
	 X-Email-Count:X-Org:X-Source-Cap:X-Local-Domain:X-CMAE-Envelope;
	bh=Zco+vsDiuTkuchE2V0It04Q7u5Lrw1KXwk/PEY7WmKY=;
	b=jMpqFnJ1r2BZb1AaIL8orzK0Afj9Lm/iBEi80KvbBnfvs3RWYxaBSwH3xVDjnKqQj/8/
	 HLOKoJy0i06w7k25BQc0etvZgi6sV9C5PxRnJncuH7no2zotbPBLFJtzglpWKbOeGi6tI
	 /YsIQhX8zwPDTlSEhmtnzgHYKCzn9iEnYUBa6ELa4UNjp2SdQM7VoWmUBV/Y58vV0u6Wf
	 QP8f6qWa7cAQsv5Lf0e7V5sKr7BTKlFEJYTdYDgtZIwVYua4Jn1YR4L2EfMoGE0c4VTPb
	 Qa7dwvZt02YGVcRKFm9h8goXUjnOWGHnHLmgeWXj3mHzERHdWDRNXoQB2rF7QHqVd7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=w6rz.net;
	spf=pass smtp.mailfrom=w6rz.net;
	dkim=pass header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=y89H6vHF;
	arc=none smtp.remote-ip=35.89.44.39
Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21597606A33F
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 03:48:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21597606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.a=rsa-sha256 header.s=default header.b=y89H6vHF
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id UB7hx5Mw9yb4YUFcPxTGxf; Fri, 20 Nov 2026 03:48:57 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id UFcPxBQQY3nNNUFcPxKDLe; Fri, 20 Nov 2026 03:48:57 +0000
X-Authority-Analysis: v=2.4 cv=TuLmhCXh c=1 sm=1 tr=0 ts=6affc329
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=NwvxdXf9XnxnMUXhnXUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Zco+vsDiuTkuchE2V0It04Q7u5Lrw1KXwk/PEY7WmKY=; b=y89H6vHF0TVfVCSC15wAKsTxRR
	2Rg9Ul1BM2HyE5MjlU+FsqZQwSFtulpTXykeUo+qktbNZPsLP1cbgBtH/pG3Gpxemz7wwAHJCuBB3
	kD3ymuAmPv/cGa2C0tHTtn5lhxHLpqDnx8mcRXhyXLCKWGLI2E1PqsF/kA2Iu20x5nmQ9/ZTWdjpD
	GwA9nY/n+oIrBYGldA0qMw8IqEXT87Zh1afiA8W9n0nXNnNDoQhLmNzVIdkQSGSwZ/gaNDaAxKle1
	f2yR5wIwj8FvEZUD78fiyExOMYxQ6FUJWciyuZyDVmc672ZPN1uBYCtKRux6mj+xVBOsxuIzDfvaS
	tqMZ9M6Q==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:52370 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xUFcO-00000001JNu-2GMl;
	Thu, 19 Nov 2026 20:48:56 -0700
Message-ID: <a05b808c-3046-4850-9f34-8c399b6c5c9c@w6rz.net>
Date: Thu, 19 Nov 2026 19:48:54 -0800
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/2857] 6.1.193-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150201.293410965@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
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
X-Exim-ID: 1xUFcO-00000001JNu-2GMl
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:52370
X-Source-Auth: re@w6rz.net
X-Email-Count: 98
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNNahooy5Y9skDoGhT9nRcquifctNqgvk2eWb36GL8zQ+olTPyrLSSCX/0y9y0s+sH4RUiYq7rv/nT4Hp3psyi0jOxzmjpiTfhYDK/d5pdUeQ8wl42mp
 NPCUfu0kdh0haWC5SJKeRtQFvqET9efvBgndW0dMG5vIFkduKHx74Y8HwPF+fwpxPOWQKSk13W4uxA==

On 11/18/26 06:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.193 release.
> There are 2857 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Nov 2026 14:55:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.193-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

