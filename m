Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61998C15B
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 04:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705638666; cv=none; b=QVo9z45uqUbSMElGxYQlpp3Rjc/t9GDGQaJnT6P2dv8prN9pU02kHha2Zo66HLaFzZGJwOogNI0c/oRKrCs0mI9rrDfcloMYlTC4RW4hP/4CmTLvXIiN5k1iX2L5wdUzyi4uxKjMewP+3sgtMjVSXHbqFtVOU15Tw5HgFbwVuqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705638666; c=relaxed/simple;
	bh=yYYIxoLS/fTY0SERJ9JIVKX7ri9WHPUupunuOb2ocG4=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=Y5vQTddyMsC4AEgAs7Dw3fyxaCtO/AFb43y5H8lziO+wrG76RLstQ7f2DZpoI6H+a0FvY9ChdjdoO20iPwLvDFpVOBy/E2zUihnNrSHZNS8SRYCteFmhHtT35i4bHzRikbynMwYjXA1zgSty0FgZB6UoKijYcnXJMGsIJT/ZR8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=idP2yh0J; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="idP2yh0J"
Received: from eig-obgw-6007a.ext.cloudfilter.net ([10.0.30.247])
	by cmsmtp with ESMTPS
	id QcYNriY8hoMN9QgWurRdYk; Fri, 19 Jan 2024 04:30:56 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id QgWtrixqPyxR5QgWtrJuU0; Fri, 19 Jan 2024 04:30:55 +0000
X-Authority-Analysis: v=2.4 cv=JYOvEGGV c=1 sm=1 tr=0 ts=65a9faff
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=dEuoMetlWLkA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GOK2ftpeLzD+oWdoQAJCQkkPzUkEAfnVyOYW/U+5zoc=; b=idP2yh0JyCEkggwxJvTCl5d3Z/
	PqaumAc4o/AxRH7PXFAVR5nbr6TeqS/YcF1f3AGI9/fcg5bH7hPGoc/8B0typya3nw7jIzrtj4JJJ
	eJAkeBwLjf03MDZkmAhbqBF1TdyIpq1r/wnRynudHiJ8Gdit0nGXa4XvhSeQfj0D9oNChA2StyP4z
	6GB4hsRP82Wzb89VV83vTC6ibeXvn8ho+kUz6J2FgH3DC5zshjxg3N9Ljscwp6ndyu08yl/E67Nfd
	MLo1j8E+1xx9OCqPORTejm/DuQWU6DJtMuktHyMPK2/qrhhtzcbbBh7wUh2fFOkaw0PkpsjXUvqxc
	PS9U70Mg==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:35842 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rQgWq-000ehB-2P;
	Thu, 18 Jan 2024 21:30:52 -0700
Subject: Re: [PATCH 6.7 00/28] 6.7.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240118104301.249503558@linuxfoundation.org>
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <69ce639b-0fee-6eb7-8f12-35aef792e243@w6rz.net>
Date: Thu, 18 Jan 2024 20:30:50 -0800
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
X-Exim-ID: 1rQgWq-000ehB-2P
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:35842
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfOpZO3+nCS/Etpsf85LVLL5dgtERrtsGu2QIr3462Ron8g0OHtHBKO7nXSitO2i405PRu6faR84E+EzE5p+VWvH9rtSIPFqrItCSEwkGpUB56I1Bk38C
 NOX3fqiOizWMpVOdIkd5RVCBvVcUCcSd7mPK9Nk7CH1ptfVfNCi8ZnN62wo0etFilt8UNIIdJXLQ4w==

On 1/18/24 2:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.1 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

