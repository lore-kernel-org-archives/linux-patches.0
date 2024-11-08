Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C14D3D6D
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 02:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731033124; cv=none; b=dzmdnuM76dd97JR9d1AJQ9fhk5uXlxSvB39Mqfkco+xg0V1fESIHPEPa9ZKixAKr0IYKeLTe1ofBvlsykXao3NWiqitbgWdUI/990iwQt++LpGLIaoLrqe+my08dEl2cFSqWX0hd5OvOF2fVWUkHwL+dk1ie6LUdR5F07n8ADDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731033124; c=relaxed/simple;
	bh=JZxU7EdmSyU3mDjSFBFW+Lsymc/oEijZ96r60AEVT50=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=h6l6b+55SOIDMy3LRMqeXhJDSX7wuKvs9nZXt9PrXe8HgJWDENriRPIEBeAdHtmzpifYaZxr9/0A4i5JWCeG5/hL5HXA+tIlKjTAUJ0SjoFnpsWpwhzOrwDnGYLxfOyJb1m+4suICf/uQx7MmKxLE9YQrYOQ9bNppmv3Ts8w360=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=1So7GurT; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="1So7GurT"
Received: from eig-obgw-6001a.ext.cloudfilter.net ([10.0.30.140])
	by cmsmtp with ESMTPS
	id 9BE6tLg79vH7l9En4tkmVO; Fri, 08 Nov 2024 02:32:02 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 9En3te0AI2Zy09En3tpKvs; Fri, 08 Nov 2024 02:32:01 +0000
X-Authority-Analysis: v=2.4 cv=Q4EZ4J2a c=1 sm=1 tr=0 ts=672d7821
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VlfZXiiP6vEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sIkp7sDcOhjFBrpxN1Wrnx14UkcVrWM+xwL03vB8BB4=; b=1So7GurTkCANW20i48CgVBuSiz
	QLLTwAXECn2sJvuHFeN0zGtBQtVjihii3fX6k29hEvh7vvD4PC05p3C/1iUZTXoORGzBD+HdzjJsC
	wj1PiiSFBh6jxlguyA5KnnmWnY1lEurhGY/2d654kYYgkRhx49GMfr3X/NE2VlMXBggyICPOjb9l4
	8qz2+x9o4ZOEV6cR+Eg1u/UW3Z+eghbYxmDeYbLINJXQmWrKHaUwZFM9dBQuvEh+xIkQqb02IgrE2
	sseDMMZPuDQdlQNLoMQIbKABtNeUHI1bUSOFy2gUvb4hFkevGWmTqGpTu+9HxGQs9Tf6mw5hpRlRi
	3tSluimg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:35506 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1t9En1-001YQM-19;
	Thu, 07 Nov 2024 19:31:59 -0700
Subject: Re: [PATCH 5.15 00/73] 5.15.171-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
References: <20241106120259.955073160@linuxfoundation.org>
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <9392c4dd-25dd-b828-6a2c-1645093dd758@w6rz.net>
Date: Thu, 7 Nov 2024 18:31:56 -0800
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
X-Exim-ID: 1t9En1-001YQM-19
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:35506
X-Source-Auth: re@w6rz.net
X-Email-Count: 60
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHV5wM9IVPJwEOErks2wp2Z1lQbpbyQcQLffj0NbNtytPxHI4zcBGfau6vO6RgDVCuncPQyi0n45g7aHR8b71dLxlQrrCksXxsb06Xh4xnXFkjNMLYBK
 tFEEGf7Gryu49oMmCUWnk6q76JYPObZKxVwB9jjNccL+1RReCRwl9ugtqet41GdXTSQia63BFaM1WQ==

On 11/6/24 4:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.171 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.171-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

