Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D70339A1
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 07:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736233535; cv=none; b=HTcO55472sbXrP5zLrmhwQ2n4JgLneoOpIHZALkoqFnvDgj5EjukJ/Di+9ctp0RGrWnGrZH5kZMo8keODoAuJorTIcG2NuDtC/ZpfRjWAl6Jcb0Q760ifEY3rVdy0PpYZkVOX2BBAjJZ5bhy0cYLO0trH9NyGq6kJRTzL3Q5Xqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736233535; c=relaxed/simple;
	bh=CqLMM20rLouKfhzzIGBdW9dbvIYXeyrwAoPSzn14uJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=etLIbq2YI/7Ji/mXY9xYESDVxF3BMValW/gi6U2TUI8zbgyVSgnagVwZ2dH8OIi2gm0fTrzDvJS8GKNL9Tjs+PqZsXOL9FELSC4xnQ2Xoi3muwqoN4wpCG8jO/CnlSWLlPj/mQpDW6GZMqoCTvbE7KjA0q+rnU4wUiD5JBZxolo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=P7jnvmn/; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="P7jnvmn/"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id Uw4rtIXBCqewVV3d6tun5q; Tue, 07 Jan 2025 07:03:56 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id V3d5tNE3jGJ47V3d5tqNM2; Tue, 07 Jan 2025 07:03:56 +0000
X-Authority-Analysis: v=2.4 cv=b+R54cGx c=1 sm=1 tr=0 ts=677cd1dc
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdSt8ZQiCzkA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Uk4BWU77kqCWID9BT9MYYGsNLeY+4Zym2edfkpXliIM=; b=P7jnvmn/t9zM9Ia7QlKjVtQ8lD
	6/W+dNF5yqSM3EifSPsTmuOhqCwNbmrFuIUMpbuMikSZfY2Jq5/AuCXYjijlAoHY3bk1D3jxac1o1
	VyONdYGr7NbXcp6abgVQKZ+Cf5v3pAL5XhUhJbFmDAQbyYOlTUdtBCeyik3q880qiyr7GqXVRrPJX
	4twFBAFT/HH/b3CGUWBr5ayd6X2/bkM6IWy063j3IVnms9ZzR0Mwbs9MYyVIYJ0mVbo6+9GbTL7iz
	XphjZE9GP03rRpg4VY+9g8TIq/1Sqovsy3fDX9VEyg3cNvXK5D/2Lo17P3du9Tis6MGmy5T6+F1UH
	gmu4Gp1A==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:53344 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tV3d4-002hdG-1i;
	Tue, 07 Jan 2025 00:03:54 -0700
Message-ID: <8f15c7a1-f175-4d4b-ae32-f0e01914c91e@w6rz.net>
Date: Mon, 6 Jan 2025 23:03:51 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250106151150.585603565@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
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
X-Exim-ID: 1tV3d4-002hdG-1i
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:53344
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLI8/jgQ6LjSIls07oPxhAeKzZk6Nhqu5HnW9TbqeS2MiVBwRRBknrbt+DdkgLEGmn8Gty2H7q0YqiCKqvEJMh6o6mqQ8hG5cw0Ve4v8aAo18AoreHsQ
 dln7cAyu236waDpaPdFCNOZ/cuH+/fzrs8KIZLhgvA3QbB6S3hB9hqq4mUYVbwdy81jvQJHJ5YXztQ==

On 1/6/25 07:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.70 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.70-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

