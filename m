Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90AD30216D
	for <patches@lists.linux.dev>; Thu, 15 Oct 2026 04:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792040357; cv=none; b=LDwSbShMRR7LMT5aO1/xwco2cHBIIef1vcRyt4rre0b/5rboV2lQpgBBjPtysl3yFDKw8VLqmdXU3DT5mGjgWwQAPMQHXYt+xy75mjQ8ymzc4ka0qKa79Vu0HGswHjA6Vo+0dGzD7NqCC+bKb5xBaIkYh7M/7D8GVm6/b4KR8QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792040357; c=relaxed/simple;
	bh=FtOtHetixsPWQ3Z+zGmjEH31xi/VxCFdFoLvi+3Jif8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YpwVQcDos21ydLO5KkmuX51jjzWFV4rznd/1R8iegT2HG73iEMFfJNOpc/i8IdLqwoM9OsyLALSFnZj84Y1qigedL/vAc90qppgNkZ4VjSrf5mguyUlhqFoHePWJ5sB+ii0qWoYlzXkVli1kw7djS23DjE2jameTtV/KTbQW1zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ozUpM48U; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ozUpM48U"
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id HDUXxJpoMLvgbHDX8xI16h; Thu, 15 Oct 2026 04:57:38 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id HDX7x8IcUP7wgHDX7xIEcI; Thu, 15 Oct 2026 04:57:38 +0000
X-Authority-Analysis: v=2.4 cv=NMzV+16g c=1 sm=1 tr=0 ts=6ad05d42
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=_kS_R5bZiuQTXeyLJeIA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=vsBsGNikXw5pstylM6RA9bsmHSV3hOgxfeTPA6wB2/k=; b=ozUpM48UgP14YWcJ8/x3Hg6Fnf
	O929cmcYtEqJm/ABfdD1OQTNwgfyP5lKW6VC4pfJouhLAnUsaCFdglQHfQcsR124HF0hRFex+sFTm
	A0b0kzB8g41Mm0lxDBrK3KeLmN8lQwLJv8T58g9StqWgxDC6UtUJs3EQ518PQ1lBUT0ItZYhea6dY
	4jdWmcKcc7WCrtYVvtkjFRlrf5iEka77bsBJu01GkPEJ1vSnDiJRRkCjKZbfmpuAcJSW35B1r3kph
	kfNxg8gRYEZoRmBjCtl4X5eNNeg7PouVCEd0gzKl7hUwdbhfIUYkxmlgEFMsci/EiJ2PZleW2a6JQ
	/QdyUEdg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:41226 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xHDX6-00000000xbc-3Ma7;
	Wed, 14 Oct 2026 22:57:36 -0600
Message-ID: <72cf3085-4d87-4ff5-abfe-dbc4b32f77ee@w6rz.net>
Date: Wed, 14 Oct 2026 21:57:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/284] 7.2.11-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261014123758.782265692@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261014123758.782265692@linuxfoundation.org>
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
X-Exim-ID: 1xHDX6-00000000xbc-3Ma7
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:41226
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMpICUHzh462OLUopI0vazcvR+PhWxXpeuJPVLWYKmWYUAoouixusWSvb8Rz6mcw2ff23lUt7ZOn26XCyae+N8p+KZujC8qdgYtoyuSTsrHuEIXuPf97
 xnJHdMbU9NMSDRavlGnvVKX80PMWbrxSht0S7NBlYWG1hADi50r6cW6UBb7EMiGHLFebshsDwBAOpg==

On 10/14/26 05:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.11 release.
> There are 284 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 Oct 2026 12:37:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.11-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

