Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7F31C687
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 23:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708643610; cv=none; b=Pb5PTK/TgSN4M2Z4hTVT13aCaxA1Yy6/PGQqIyPDRYERvQj5yvXzmsKYxgzby7eD4rAzpQpVxgg1DrI+ObVzOf6EZW4fsUe4q6wS2P27HU06ea+bzrFV4NDeffNA9hBFYjbm3L9G8o8U2M78XDoZpYc0ADyIeZY6s1oF3eUonXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708643610; c=relaxed/simple;
	bh=y/jZuHl6NUzjAai7o2bI+i7qcLC9Q25IhiVkgk6OeBI=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=nPg7nWl73xBo8UugjQYInnkiDoekLxDEyRHFW3ytCtX0Otoj3XVp+dpZW7vTdzQAZzFiP4g633Z4d6o0nJsmm1buOBryWqfCSBumHJd2IFvJb6MwWeyBLgBjT6E02msGvpqZZ1QR9Fy7sIpBx2ewReZSGqyRkzbGxCRwKkWp5q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=A13lClL4; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="A13lClL4"
Received: from eig-obgw-6002a.ext.cloudfilter.net ([10.0.30.222])
	by cmsmtp with ESMTPS
	id czgkrR5Iu9gG6dIFmryrPg; Thu, 22 Feb 2024 23:13:22 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id dIFlr82RHYvf9dIFlrf93Y; Thu, 22 Feb 2024 23:13:21 +0000
X-Authority-Analysis: v=2.4 cv=UOTbHjfy c=1 sm=1 tr=0 ts=65d7d511
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=k7vzHIieQBIA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=xVAsXjOY_3W_6nlrMEoA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=f2oyKlKeSKZqmQ4ISDZxnOvntf0l5tdrQzymgi4iK2I=; b=A13lClL4mgogF3Bd2pjqqOJuMG
	T4ug6gIcahZCqtXjlaMTuI5HSEKho5PLJjIdCLZPwem6IOtGpVZvPUFCc7//TxgKS7rBONtHh1ku/
	ksrXp/Lr34+iGZq88bHNF8lxYnYRt6t0YF6SVh7EtPvRiJx++CIw/69beSaE7VJpaDi4hIyvtBoSW
	RN9CY5crcMs4pzNeIG9jnuwh3G+ju08cdTWz6cL5rPrvwvI6zWSAUv7uRLliZAWgxSFmgfvoNy7gK
	NGobUPmjkeEzD52359jTxDyJvJJwEwEhbsHbg/Rh4B16UOKPYjDJ+zzzjlXppwsEg8XR5jsMAwqxY
	iYCRZnpg==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:47430 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rdIFi-002kzD-33;
	Thu, 22 Feb 2024 16:13:18 -0700
Subject: Re: [PATCH 5.15 000/476] 5.15.149-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240221130007.738356493@linuxfoundation.org>
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <7bae8767-51bb-3549-e859-b820b7b261e6@w6rz.net>
Date: Thu, 22 Feb 2024 15:13:16 -0800
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
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1rdIFi-002kzD-33
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:47430
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDVn4iIozdOOThJoMUxbKNcXAHlhJzGNY8qDckRyWWnN/wPivW19PD6IKafsA8UXo7cydZtkhabDT9xAMQjU+SKenmrRbkfHe8xI3mG8D8RHgNEJd+NI
 P2arqM+wUmPcXUr8m/xWPFYOrPpQ+gLrgthdQyIuE9TaeYhh+kwId1DOHmqOOJS+La9YidyCquYXnA==

On 2/21/24 5:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.149 release.
> There are 476 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.149-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

