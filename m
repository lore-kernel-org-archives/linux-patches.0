Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2246282F2F
	for <patches@lists.linux.dev>; Thu, 14 May 2026 00:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778718452; cv=none; b=aVXQ5BKRBTtRLx+Wt8C85QWBGiNt0cik2KL9qtU+V4n6IGY6V2HGp0BGkek5peeAcuDnukkiAIGPUBaJq3xEXHQ5eYmYsTlFwtwyciACpLpL6TxLcG3Mq+ifYEpDdfx7icJRgmUPjlxBa2gdD3yANvXY4xhFQGn8AdSDK4D27XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778718452; c=relaxed/simple;
	bh=T3IUJ5N3cb2X5Ao8jYR062oCSRceiv9IXx+vsdNY1qE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XQcnv7jXkeQs6ITnyMnOXa82HcW9aLQcpvy11u9C1ICUlHvPOooOr3xtHoHzz7u3Jew/Mq/AXvj94WtleobbxR6CFOSJR/VH9hp8aOI+TKIDOE0Xw9TduTob7Xm3YVQTZF6sHIPY0N38RJynmLEs96gpb7VaKtwkr63x4CsjxvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=c6j2511d; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="c6j2511d"
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id NGDTwVD7anv6VNJtiw0GMh; Thu, 14 May 2026 00:25:54 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id NJthwl5vTsO4mNJthwjSVc; Thu, 14 May 2026 00:25:54 +0000
X-Authority-Analysis: v=2.4 cv=LreSymdc c=1 sm=1 tr=0 ts=6a051692
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ytQjkP0ak7MJFOk13KBVfWAL/1oxQ+ny/1N2uZnwIOY=; b=c6j2511d25Ed8/diummxpE0BiS
	faTPJrImi+X2jSWn2a6+ZpCNvPBgG2Vji7Ju9SoxPdr2C6oPH3Dd94TecEDPB0nmqPmkP0AegLhri
	QpqBgF4ZqFRpfXXUHcwFeoDxSI9njIBuUf3GVeJ773+n0RlPysGjO5Nuqw476wTiOP4ZW4/gu7xC4
	LhxrgDJlX+cAyBcrLmevvjyML0+rrIodV3bY/7VVRRnDP3kl1aexYPXtwirODBPbs31rzzkc4zAxH
	GQB8rgpP/KMHPO2VUh6+8HoOeET2k7Ce/zb/Sq5Gw5qldZXlxLokkk4MhtuqjHjgnOCH9e3Ucrd/Z
	zLsJy6CQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:42948 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wNJtg-00000003P7g-2mze;
	Wed, 13 May 2026 18:25:52 -0600
Message-ID: <a519a32a-22b9-435c-a282-b6abccf8e1ef@w6rz.net>
Date: Wed, 13 May 2026 17:25:50 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/305] 7.0.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260513153754.934923793@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260513153754.934923793@linuxfoundation.org>
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
X-Exim-ID: 1wNJtg-00000003P7g-2mze
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:42948
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJv5AeAfpJxtLay7aIJMWSC2jcOspkc8L9CPs5g72grxjH/0np2ll8OzdZUr2RXies/osTT1Gf6W7qBoe7aU1zZ4dKy8lfz6hB0Bbxuw8R654LOz0/CR
 x3KDMhORZwESLDBTzyc6FJWn0tu1JehQlnj3iiqz/eHlKXBSfHbrHqrf6jLa1J2RSKsOxh+7BMIr2g==

On 5/13/26 09:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.7 release.
> There are 305 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 15 May 2026 15:37:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

