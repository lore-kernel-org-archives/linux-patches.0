Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747702135AD
	for <patches@lists.linux.dev>; Wed, 28 May 2025 09:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748423218; cv=none; b=ObKWphDO6HNLa7Sarfi6ZgfcsUunMnC8bEpbN4eTF9o6WJf8b9kngihvnDUwtYNvQA7YilfenmEVDZPIA7d3R3uq8hMtXvlTjj8u1Vo4aaWr8fwzfTqjgyajH3VJVQDFHtw9jM2SX4LMPvet6Pee+HphQ03uBYSp/9FmxT/W7m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748423218; c=relaxed/simple;
	bh=rs6PIvGPcHrLv/ovucbB4V8gMKGPAt2gjljEKfXGzW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l1MduyHZFI+CIZ5FQ092jPsu47DmYqmB1drWxdS1rg+dSwhcylPaUS3N9MHK5EnUvx+qZAnrdIr4zgAVCszG7JnCKVKJ25Uvx2tqu2UPD021XrQDeWkzpS4OKKtRkiJz+y/KzXjdn2mDWL2U5JZd5A1q/BzQ8VjPQrtsLuVMxko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=jD0XFiqd; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="jD0XFiqd"
Received: from eig-obgw-5004a.ext.cloudfilter.net ([10.0.29.221])
	by cmsmtp with ESMTPS
	id K4DDuFumZf1UXKCituSMwC; Wed, 28 May 2025 09:05:19 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id KCisusMQzjrgqKCisuCntY; Wed, 28 May 2025 09:05:19 +0000
X-Authority-Analysis: v=2.4 cv=PK7E+uqC c=1 sm=1 tr=0 ts=6836d1cf
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=5E2gbQE8QDOJjfjLMUMA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nKwsNn5rJRhi0owYZFN+Q60hsLqiKxH83B+Fzcz0XYg=; b=jD0XFiqdAqR+o3a6crgtabCEe1
	21CZumjLpddWBzvMlEibcPTboVLEpNyckM5WKw89z4b6M2N6UPdlnQ3YAaHZtTsMPP09NLERiInJn
	nmBcrTVRw5ShjzVWA5/EFywENNebdVeHe+39lNYej8ujievcgHxmmyfLZhq0oTyNi+adWgg3BXLO9
	ux5lYZHD9xHE9wVtbionRNdBEL2vzn+ozjF5r7I1JZ6BJshnFFUOHpwqY85FHOXDKF/KjeG4KJdyn
	5FDc77PiY0g6FbtlyZBnoL3DyN7mnASw4WT7WXAY8veWRTBx0ibx7uVv5oEIo58Y1Nw5HUcYuyYPl
	DOLMkvCA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:54484 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uKCiq-00000000JFF-1igv;
	Wed, 28 May 2025 03:05:16 -0600
Message-ID: <48e5d458-c2f9-4968-b9db-5c100ef9b185@w6rz.net>
Date: Wed, 28 May 2025 02:05:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/626] 6.12.31-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250527162445.028718347@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
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
X-Exim-ID: 1uKCiq-00000000JFF-1igv
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:54484
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNCwFgMEzdAt+wr0Ze2vvLek2tU7IxmZhrQ5auRQrcFEq+33JSIvbVe5yieSb7eNUtvl5ElDWK+ZfSl4L1B6TLrLATU7EdAlNBqfJs4z+PjLd5qwIc9p
 PqGjjeJ0wtqOHfIQHZQPdiYO/Dp3pLCef8RbLP1A5QmW0zFoWaYeCZRTaQ4oDf2/eu0dcHROjPR/Sw==

On 5/27/25 09:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.31 release.
> There are 626 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 May 2025 16:22:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.31-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built (with both gcc-14 and gcc-15) and booted successfully on RISC-V 
RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

