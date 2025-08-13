Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE741303CAA
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 21:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755120374; cv=none; b=lLDMdva2l30kBBpriVr/2+Dmy9+Mr2yO/+CpnxCd5u4XQh5r5bKt+79Io7YuOglMUKYlxnzqrX3N0+hFLlPvqJ934D1gH+PdNeqcdGIjGQ0mFfklTfPNC/h7N1vmzfv7cjGYrPj40ugKhysD6JJIFS2apxVRSt5QR9R7L+Ey63M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755120374; c=relaxed/simple;
	bh=CUuTpfuHCB+eRG1AWBHWojLhG8qGdVAxW2UOnezOloQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LgjpyOGol/bQl2FVcXoIBgF+bCYPJrsIlPEgLZ4BIodC8fKuBFc4IQMJwOCIC/So3Q/Jy7XzKcHkFMY529WSNE8W7Ow+zgZnfY96YYFFMEiZxPzZ+TeaRyQrBYa75s8J/CPzMsgVBJfynPlT5D4syHSgfzp/ER7Kqw/WowEY2Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Sz+THJc8; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Sz+THJc8"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id mH9nuyKYV5wATmIz4uTGeF; Wed, 13 Aug 2025 21:26:10 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id mIz3uCD94rnsYmIz4uTefb; Wed, 13 Aug 2025 21:26:10 +0000
X-Authority-Analysis: v=2.4 cv=OLkn3TaB c=1 sm=1 tr=0 ts=689d02f2
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=WC0afu9dXWEslweZtVsA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bmS8nLb6K65KjptA10Fee2ArgRXSQ4M8a50W6jTXG6E=; b=Sz+THJc8oVA+tU56Fki/E8NqEE
	seW3RuK7K3r/NRpb7/oNhbji8Qs+4+68dCmSgnS7pRNSCk0B/k4xXwYYhZ+9zNBHDb2OBPymxToFN
	5Nx1YvKp76LPaH6T7fJfCqS1eHj8dQqeA4SBo/sJchwCl7KbOgfh/21X1AiNbk0mAFMLFqc+9z6uc
	YCu7O4YTop7gZhOJtVyAcM4sK4sclEGIhNvDjZs/7hZBQiwAVJvHhQRqO0buQzgN60mT+uK2V3VoK
	CusfcdFap2ejFplcVR8uZnjyt5FHLjwpXhXuIWjzbO/fPpZ72vcE4pPiLmAmEWRn7clFADKd2kiAJ
	cKljbliQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:53242 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1umIz2-00000001qyg-2xfI;
	Wed, 13 Aug 2025 15:26:08 -0600
Message-ID: <98aa5eec-53b1-4efd-b142-f7b185df566f@w6rz.net>
Date: Wed, 13 Aug 2025 14:26:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250812173419.303046420@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
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
X-Exim-ID: 1umIz2-00000001qyg-2xfI
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:53242
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFX6OkTWFlj8KcPqN9dCCSKmPxPQy+j1jFq0lnUQCCi466970N4cfVn50YkyPzSik+/n8ppqRadbOu1ALp8w1b1QUic9AjfaQmRLfyG7f+7bDqUo6BS2
 dDtPxHPltEULAxOr0JwYswPxvNc/3wCuZzYKXQbSskmlLWYibS05K2QaBD82S4orHRJmhmc/P6HdnQ==

On 8/12/25 10:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.1 release.
> There are 627 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Aug 2025 17:32:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

