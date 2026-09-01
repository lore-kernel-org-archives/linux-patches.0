Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8DE46A5F9
	for <patches@lists.linux.dev>; Tue,  1 Sep 2026 22:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788303212; cv=none; b=aGrLbbi2P/Zs1Q5V/8AAkpNxaqsJsahOkMhRz3Oa+NYgGF9064RB+IGogJig7SBbLaq0EQ6ceToe7Hkz2EN9yAbZFE/nh6e9IRGt/jfn/WLU8aAm5bNvNr91vL3jmhGF/oyzZ2i5ogLDo3lxRj1jBCad+szfGbXzKVTudQRge+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788303212; c=relaxed/simple;
	bh=/pEWUEVmYn/xmHTn1dysLjNcIA1fu/HwQ5Atvfk5KQE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n8mRxOmljgsUdC5zjKlH+pT/YI7JurvZew/MX+nr5o0NTNnbS6i2y3SGUlKCNq9lU4JM2OH9uoX2RBDlCAgoHxAEshGagm38iIChk7bR0aApVeytVeBQAWMcpHHlYEZdViKEvGftSOTvX7A9QWvUXqNAbx+t8nrB+kVF9pVOLmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=yFYzczDR; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="yFYzczDR"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id 1WWSxUDRrLvgb1XM4xcQeu; Tue, 01 Sep 2026 22:53:24 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 1XM3xDEJPn6N51XM3xVZvC; Tue, 01 Sep 2026 22:53:23 +0000
X-Authority-Analysis: v=2.4 cv=LJJmQIW9 c=1 sm=1 tr=0 ts=6a975763
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=y2ERv7ko0hlTFnYyMTsA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=9hmRTXzlOOdNH93iw7lSn8ol92qUBIFTmesIqS5EOkg=; b=yFYzczDR0g7RQH5jpEM81SRS9E
	scyTARwoeg7E6BCR09LJ2kO6mrNcIf9av32+hCFuVvSBYofEKytqhn31pvsClt1foyDMipz6kU+mM
	e4PZ3pvysZ26C8yMynpJWIBC12R7uI9GAaJUfOSVTpcQ3hIPdvA7rofE6+TfqqwxGchMgG8D+cR67
	HyhQ8nZro4tDNOQGUG3sOS6hM5MdyuT8pJOwV+nO4vAraXHmr1u7RvHtHXIThLoHVqydoXYS3lcNO
	jH/TFTw7lWMro8Hjyfw+D+uv5M+PlCtySOYXlmu1VP79DaPme+dlDj/Pkt3u1aq+3/FF499Y9JqsT
	mgAPLXFg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:40396 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1x1XM2-000000028bj-1iVr;
	Tue, 01 Sep 2026 16:53:22 -0600
Message-ID: <3c61a9a8-9104-4205-b0bc-e8e4b9a33ddc@w6rz.net>
Date: Tue, 1 Sep 2026 15:53:20 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 00/71] 7.2.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260831133359.055927882@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
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
X-Exim-ID: 1x1XM2-000000028bj-1iVr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:40396
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLC9L2ckwJenlzb0K9e9Q+H6rWeSbyXV5yCWWXm9QqAObGPicO0r6yLWFOHfFoZn87ki9ihkSYDl06pbrGcZlUcQALblJqkqYluw7F2fW0kTyRA8QZG2
 5wb7/KeRo222tKG5Huw5Gvz/kP7o1gZuSpAJ4wscrZO4gVXiNNXzgWUVPWcmHXUTE2KMxJ3Xzl3yQQ==

On 8/31/26 06:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

