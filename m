Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB74835F602
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 23:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789340408; cv=none; b=DuQouiM3NoX/wuoV2k5AxdndYrQGmbvEfd+1GHuzCXBZg2aohgtqITMMrsAW4oet672EM1VAN587dR0g0SPQmB6tLxatxlqUeuiqx5wZO4yi1ZhKNwTH+gV6dL2wbjCQMlROMvUa8zJ+tx6sPZtgd8MLaC8oECt1RNSyeP9/qSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789340408; c=relaxed/simple;
	bh=E25GtAn4WzVc2FZV9R5oZdwwb7KG0qqFAtxVTjM8IXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ae4kgW5pYHSShLAO8MdEcED+9akc2HU51ZfQK/L6ad+J7mSJfwD4HeZAU231sqdlljT2lnWowwHylGSD3VbLS4g2WngboVmJlsBgUbImnZIaoDA1mdQ3LeQAbxUoPq/uJziHTx3wGoyefvjhH7USMzLyx+XH/mENYvSdx1oqM+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=fFKUjyx+; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="fFKUjyx+"
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id 5nYpxDXtJLvgb5tB7x6IOw; Sun, 13 Sep 2026 23:00:05 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 5tB6xpf7ffDqY5tB7xf85U; Sun, 13 Sep 2026 23:00:05 +0000
X-Authority-Analysis: v=2.4 cv=HKbDFptv c=1 sm=1 tr=0 ts=6aa72af5
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Y4NyFCxO9-uqU50Sy_0A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=mLYvAt0OcCY+2SqLeYDe4lTxu+rpN11hpHmIW/uE2Wg=; b=fFKUjyx+Hp0jEGBlI/CLQFov7F
	nP/d7SzYA1W2+hqkArGjhqgktOMnRRRO3EiSqLPCgONIf5bL4GxTwIzhghyT/IOtk8+CMURdwDUKh
	n+PkgTETtgyPiFpLTadRyZdZbcX+XsFC+74lKbVhjK4lMmKutih+vEtaCReG5tNCkx0Bo/vUZ1fe4
	HWYKgX8VVEB45aup3JtvzfFCxI/4USvoXtPRxS1QJnWqNZyC0gypp62CoZSyCeMiXr7eRTF45Hm6K
	L4Jx+MvzTVIDXMhOfJp6tC3aWTsxp6yupMQ+pqjBneWfnqBCH+4gpnTpsXIquKzJY7cRQHYAQmFDH
	MxJLZb6w==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:35474 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100)
	(envelope-from <re@w6rz.net>)
	id 1x5tB6-00000002IDG-0TlR;
	Sun, 13 Sep 2026 17:00:04 -0600
Message-ID: <d0e20d32-456b-434f-bc37-518ae18f5811@w6rz.net>
Date: Sun, 13 Sep 2026 16:00:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1376] 6.12.110-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065607.535295758@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
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
X-Exim-ID: 1x5tB6-00000002IDG-0TlR
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:35474
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIDU2Wj7Mlh/PD3xEB/OXmYIGsvJoeNjMpQhZkJx3S6RKTXO/TRnjJL1ChFu7gmybZNHepnR71Aywyqd3sPYglA1wz888KAM1th/CfcIz/1Q8jN1UmNx
 +oHfN2FppTJbFHLi1dZvQvj6OYaS95nlbncl3GluxOfIlyMz/jlo9goRhm4cuIuxlOje0Gi7zAeUgQ==

On 9/11/26 23:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.110 release.
> There are 1376 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.110-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

