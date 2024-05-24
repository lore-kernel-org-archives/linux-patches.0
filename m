Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D561E9475
	for <patches@lists.linux.dev>; Fri, 24 May 2024 08:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716541182; cv=none; b=cDX8KHKCbAVognj1MPKjSPY3gkfMZ+JPMC7fS2yN2pnjl6xRWGnR+4mdXHsl2LVFljIqt/GQ4vV5RPEnxAiBm59F5Yqf8R8Ubex73405G5Svv/oti7/j/4tglHtzrmQwyRP/fAY72GaznrU+sO6hsma1/MC3et5fhwwYnoJb+XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716541182; c=relaxed/simple;
	bh=zHpc+qxtONUw0wwUJ4wmIXG/NriOH96j4U6RN6GB8pg=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=qyxfzUxatvnMUfUncuI9PjxD3x8xsjj1ECSdXEJGbQIFicId8/2FI3pCmFkH7HE/V3pTQBIItRRlzZEL3sM9GEN2fCuKgqw41fQARGZo1ZdQpzMJcVq4OBg/GniE5reSLX2S8bKKRA/boBFQXf3HLeyszgmVEbFaNpcdLQeRAY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ui3u4wwD; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ui3u4wwD"
Received: from eig-obgw-5008a.ext.cloudfilter.net ([10.0.29.246])
	by cmsmtp with ESMTPS
	id AP7tso3SAAidIAQlxsP9o4; Fri, 24 May 2024 08:59:33 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id AQlwsxZwwDAxWAQlxs4Len; Fri, 24 May 2024 08:59:33 +0000
X-Authority-Analysis: v=2.4 cv=D4tBKORj c=1 sm=1 tr=0 ts=665056f5
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=TpHVaj0NuXgA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=BXyYjBD0cXuZo9oD7aYA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0gf7r2/eflWxCGXjTMWMn16pfPrcTB0I/nO5t6cKk1s=; b=ui3u4wwDMELcZU85CWdsumJw39
	hHmap6xOrfkWgfBore+rZ+nh0AwNEVkfOiN+JjxIXEgkHryqVmdvTUzuPHYQvF44Rd6yKEMr4mOz9
	PaZ+n7tShDcUa9Wbm2JjfN+ZJgmYIJKmM1FqnmHdURpYKEWzdTjtEjGHEb3U1PWn99CT3dk/F77GA
	QHlhq/73zQJX8ZXzNxoZ9LXCXHU8qLNr1NMf/D1Y1rRSy6hQ5MnzwkJy5eC0BmpJdJ+hly4JCguDz
	6NBZOC3QD7q9b3Qklqpv8DVcHptHufGiB27v6d7G8KnbpshCaLzA4bi7qIHLkHrR0edCCPmrWDHii
	gAnMmoHQ==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:39716 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sAQlu-002uOz-2m;
	Fri, 24 May 2024 02:59:30 -0600
Subject: Re: [PATCH 6.8 00/23] 6.8.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130329.745905823@linuxfoundation.org>
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <bb0d45ed-9195-0d5b-2068-71a772042d7d@w6rz.net>
Date: Fri, 24 May 2024 01:59:28 -0700
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
X-Exim-ID: 1sAQlu-002uOz-2m
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:39716
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfO6UrvhguUrKE1sWjH8K8fvQdI07nzUjjrcfmkN8l5/TIF6s6HZ1bZo+8O0k0ahyj6cOkb8zhVkmQjEJIk4MhHys9hB1506oLk/FBiE0GAbE6TMO6geE
 S5knPEAlkZW/wYr8wVzEwFEq0RxkqDSbZMK8vgAjAwTdaAlnAUGJv4/WMwkyizj9/Xnuo/J+C3BTCQ==

On 5/23/24 6:13 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.11 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

