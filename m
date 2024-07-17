Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874CE180A6A
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 13:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721223842; cv=none; b=NwnUna/pGeZCCGo/cxjdI0t3vX8NO/E1VAriimSB72SupICVyl8fppzPIYbOnWy/oir6EqWvuscy7qSeHMxyGLYst2qtqpHHpbeRHxtQG/dey0vhUrOHLeqonxf9SKl348RDoSs2sObOdtMSLsD4r/R9y60bJMxHpfQKJw6f7M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721223842; c=relaxed/simple;
	bh=fDqXoGDyPat7FKpYZwqPWdsoGsj0SZZBxvAhOf6cc2Q=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=lJSGuOl/obtXX7Sr3JTLhBFgLsLPpvk0mrKOSwPXE7GHlDPU/eYJegeC/UFn4+7fKY9gi/OB88+eteWK3h226XgOAv8S5y33DHLk0ssGbVTCIfQPq7DCUS2aYSM19jO0Tt0adF2sagV9L5X+kCf+Szod+IA5mrh+isJo3mmMdzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=sbqc196P; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="sbqc196P"
Received: from eig-obgw-5005a.ext.cloudfilter.net ([10.0.29.234])
	by cmsmtp with ESMTPS
	id TNYms0H6cvH7lU4wpsEmpz; Wed, 17 Jul 2024 13:44:00 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id U4wosyCIteCxMU4wpsSQdj; Wed, 17 Jul 2024 13:43:59 +0000
X-Authority-Analysis: v=2.4 cv=M/yGKDws c=1 sm=1 tr=0 ts=6697ca9f
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MQlfNApVtpLswRFhPCVk/4dyoY9CiRNmhu9z8r1bf9s=; b=sbqc196P2oM8bpXWQvYd7B6Ejg
	Dql6/TtxJDfq+AVZ7QH5w6mpgnF3oF5URlnrGDa+a3QntujSi8Dv2FQG1I5xqEQwXRPgokB5ziZml
	kSv/9F8GQIee2xqrQGgE+KQMGzbEoyvQ2hLXzqkc83i5oCaH1gqs3yKTFy7xX3A3z6G3Ag85JdAdW
	L2jHO7+ttSloCxh7yRmBw89SJopmRToboGV6QudQBk5FbWRZjjYAXZm1hPMzoFj4BfFkoTxsttc3s
	I7I5bYUp9XwxFL/7CTrtsxihe4RlztmqwI9Jkjge+NBufbiuoamy5QaVVnaVJ9xel7mkNiLFtw8Qq
	VedEnDFA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:57976 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sU4wm-000XCE-1r;
	Wed, 17 Jul 2024 07:43:56 -0600
Subject: Re: [PATCH 5.15 000/145] 5.15.163-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240717063804.076815489@linuxfoundation.org>
In-Reply-To: <20240717063804.076815489@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <7011f03e-52c3-5929-145d-34e7e3c1199e@w6rz.net>
Date: Wed, 17 Jul 2024 06:43:53 -0700
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
X-Exim-ID: 1sU4wm-000XCE-1r
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:57976
X-Source-Auth: re@w6rz.net
X-Email-Count: 60
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKj/9U6MAY8r3gLbedwk/fnvjbLiCImnDZWSNzzqfxunQnqREWk+I2A5lxbtkc0xmPnIPid65ZWTNwMRjRj6lsdzuBywCX3ylYxfRX+MyK2wYO3ho1bb
 wZd5M35uD7MeReEbHVYy5BbcuHz3e5vFrMpJfdjR5rYwjpM9ZHno0K/OAOh5l0FhrI7wn+Fhkdaxvw==

On 7/16/24 11:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.163 release.
> There are 145 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

