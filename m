Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F394D372
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 00:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731715482; cv=none; b=aBp991ubtC/qiNhd1KbyRTDbv2JMxW8llJDDRdSqZMKOlj7helO4YMjbJXcQOLHuicYFmHxvbSV0RX1n19dcnbljfENsKPWHulwwi0JaUu+QahIWZAQIEmONBrdgNkor72Eauzbky4/jMwcNHwQDvIKbsqzeTF2Viex8UOuc8Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731715482; c=relaxed/simple;
	bh=nH4M1ToS9QL77AjuKsqaHEfbNdH3PZ4PK27Q7Vy4328=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tqj6pLXduYYIjVOvTAnStk51cJmoopdVxyB65bhnRcr47UVjIKm+29SlZOKpYOP0V62hjOvlwDdzTXe8GcdZVPHLlpuAOjjkYwwgwz23QsePblrNoC4G1j0R8Matah+uR3GducPADIPN9AOD4lXQJQoZuFedV5qYK0ZrfpjDyns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=fmCkryPD; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="fmCkryPD"
Received: from eig-obgw-6002a.ext.cloudfilter.net ([10.0.30.222])
	by cmsmtp with ESMTPS
	id C0c2tqqA8umtXC6IptObrx; Sat, 16 Nov 2024 00:04:39 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id C6Iotquo565gFC6IptAqPc; Sat, 16 Nov 2024 00:04:39 +0000
X-Authority-Analysis: v=2.4 cv=Z58nH2RA c=1 sm=1 tr=0 ts=6737e197
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VlfZXiiP6vEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=l_-f7-u7_j4nK6mRNekA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=KAkP90sx3WL+xDM1sT/g1ujnDhqW8zUUb2cw6TQDKls=; b=fmCkryPDyVn38rMlwFZ+JsV3IK
	MzZKpu2nDmaACXeR7eV6jhGZsSEF0WmXLhQyVN72PCZWZ0hZ87zPJ2UbxvVRjPhaz5Yc+zVNy5kxA
	ZA6KDvg3WXVDC9teKNyLk9GLdLGueR0OC+msEd7u+9bNaABeyNxdWUbMB1HTG2FwGYR1cnd3K5NUz
	iZiRODluB0A59JzDMsD0/lceTao4BrImArkR9hMwDedxYFu/Bh8X3tJvWsPZ2yw9wauL+hGRNENh4
	fXhQYzPxZgtGVOFuZg/Tcy56BHvgsckMymQ9GKUSEA7Ca+DON6iprSuTRGG0w5YwIkAkAwqTIdjcT
	7sMQNTVg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:40094 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tC6In-002rB3-36;
	Fri, 15 Nov 2024 17:04:38 -0700
Message-ID: <93a0a69f-9b81-422c-8d4e-c2d5b474ea77@w6rz.net>
Date: Fri, 15 Nov 2024 16:04:35 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/39] 6.1.118-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241115063722.599985562@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
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
X-Exim-ID: 1tC6In-002rB3-36
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:40094
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLRPN0h5x3l/azBg7SEP06GdWpiR9Yrdq+zD7ddIYGpa4O+eCbXz1EvMkH4kwu/M0jmecNRTbBa8lEG/L8SdEekj8oDz2yTFZdEKcQW/wt5jQSJNDYKl
 +E6mGeayh+hHKJewhrA2d336ZRlzJ3vsK1/yF0ZJatfDF8n/Vutq2moXitayyGl964YXdUCl9aChmQ==

On 11/14/24 22:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.118 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.118-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

