Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3DD36D
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 08:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721984007; cv=none; b=cFjEZ2qIjeJmbo/rE4tbaMFipi26KNUOIWt/ez5CrBrsySZc0L4sLhx31wYu5nYLY8qopTKxhyTOmQdgezOzpqi1YhQ4j7vTs93kzEeszL/RfIKeKCfkJZdqsnYrtHbmovUYTOGSmBOLDn2+kiUvNy2ZCbB4rhMJIv/CuJkH6LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721984007; c=relaxed/simple;
	bh=UbHmbXTSxgUY2nzS2PmbCImabSXuVeF5fVGN80VuE/0=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=GbTJ4dU9BlMGbiIkrzUp7SuHNnIF7aXqJE9DBjiOoE+piWW+wV325tRzy4jirKAmGUVrGvp7uYG3DajyC4Nvb1GLXcJC0Hh8Che/mf/xiSxjf0UKfs9kJIpQOh/8qUKCWGoT+NZuEQG2aGjDQMuFjYdaC941RxtpzK4jiWlbocA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=rHfOGqne; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="rHfOGqne"
Received: from eig-obgw-5010a.ext.cloudfilter.net ([10.0.29.199])
	by cmsmtp with ESMTPS
	id X92Msl6fD1zuHXGhTsdbgI; Fri, 26 Jul 2024 08:53:19 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id XGhSsooaYbFeFXGhSsOK52; Fri, 26 Jul 2024 08:53:18 +0000
X-Authority-Analysis: v=2.4 cv=dJKgmvZb c=1 sm=1 tr=0 ts=66a363fe
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=hP_FQLMrEgTDVdh0MfgA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=b22YtEOfbCEVCDsNAFWQckf48VPhg8f9JwUPFgjX/oA=; b=rHfOGqnepvhwU0K1sFa6jANzyR
	6iinYJexRpWmuyomigmewEKjttcawzHSi/q/xptpvq9xSlRjN7NN+oW+Ap0Qw/bGhh9u6NLbnTn1+
	KiZBVFDOg/krlNpXaQAbG7CWfY6625fZBKtP/dSmP5FMK3jL9Htp2duUQO388WlVrIxN7OqSeuezR
	xFAK5VaavfyD3IoDEegFkPbzR5ps0VyKV8sKCJZ4M3uuUtKl4f+bGDEKXVOt4kkfFRmLHoPlQ4uiB
	Vr/D97zgJ81eOTqb13nJz8umgH/fpidN0OxKh6OYPmOmtHOv04Nx8MFXgrQ1kIy1dsuhh5LhK20by
	Rb7yNWXw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:59266 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sXGhO-004CXG-0P;
	Fri, 26 Jul 2024 02:53:14 -0600
Subject: Re: [PATCH 6.9 00/29] 6.9.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240725142731.678993846@linuxfoundation.org>
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <4474a6b8-7546-0037-1188-469585e22e97@w6rz.net>
Date: Fri, 26 Jul 2024 01:53:08 -0700
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
X-Exim-ID: 1sXGhO-004CXG-0P
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:59266
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPAmye+BvITEvE/H0gfuMBDqcV14fWsG5MO2N96P8wOstrGfqj0uIJBPAcRPiN4hIZ/Nnp/EhFY8o/Dc6aQWSOXG76xY7Sk78BEqpMJar/1B2PA2wZ08
 DSTihALFZv1qb1nzX7diJX13kcjs7yVVm3g4HUgyAzeTqVHHkvVKJEsWKLUXCIIYHnJq6cH+3wnSDw==

On 7/25/24 7:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.12 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

