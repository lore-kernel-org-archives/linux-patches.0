Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE81A158DB1
	for <patches@lists.linux.dev>; Wed, 15 May 2024 18:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715798804; cv=none; b=hKWtNpNJSnnn3mx5yuNK5dwJieJYnN/xaRWn1JQHSQPiJ1MZzRwR4o+l0faNWd6J1mnNFZm8J5PjU1HnjPrbHsGDyYpUMLyo9M5iZ+TYaEtTDQQBc3Ea+NfAjUJmCyafkdypfvVQTZ8uwgzONEuts8mpBiFn7xlLZQ/4HMe8SKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715798804; c=relaxed/simple;
	bh=NLm/A4aOGodHk7UpTsgF4L2V1jE/fd6Fmr0C+mdAMyg=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=jnnsGvRbTGYJEOXkn6OtfgjMWcsKxdPF1ztdL7glKDXyLgscPXNYuvoKWI7jhdgSw8CsXiFk9sI0ihgmIS1dfaolUmbMAPU6cI3uy/0YSd3tVw+PkHI+I+mL+TqL8nzNNFRDmIp8uOQAPEwG+sUKb2Yc8jnWDTwBDpTV8p6TTb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=riIiIv4S; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="riIiIv4S"
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
	by cmsmtp with ESMTPS
	id 6unPsA4dXSqsh7JcesTYdY; Wed, 15 May 2024 18:45:04 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 7JcdsujvPuv6X7JcesXq2d; Wed, 15 May 2024 18:45:04 +0000
X-Authority-Analysis: v=2.4 cv=YbZ25BRf c=1 sm=1 tr=0 ts=664502b0
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=TpHVaj0NuXgA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=rpE1f/Avsk4JtoARdzzHoFOQIic7ENEEYSuxgA0GeXM=; b=riIiIv4SdWqmVDS/LIpwOOrgsx
	NiGlzXGrmTs8crBYkZnPzDLsCfONUXHXzWEwSj5GZ2R+xWwoVsyxYxFxnKDGNdNI5thXXm4EJ+3Pi
	gFcqhNj0PRlWqNK+2GJY1Jsk7rOfmBv2q53PzpbdA06b+10qcItPukGr1vM21+MUjDhlfdnrsc/bR
	Fw51ouMdxn/V2wIlV2Ar1OenKgiDeToLmW8jul67Tk5xO8YPZYHVj9LhStwFXULgrsOKN/CerESye
	lEFEyN10IOMXXYHkie06av+3svW9maxyKp5C5dU6mpVH/1/gEaKgEH38XGn5K2HhHfubG9Afz6c0c
	TJnxKdvA==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:35780 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1s7Jca-002K8O-2i;
	Wed, 15 May 2024 12:45:00 -0600
Subject: Re: [PATCH 6.8 000/340] 6.8.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240515082517.910544858@linuxfoundation.org>
In-Reply-To: <20240515082517.910544858@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <d56f3d69-fe6f-83e0-127f-c30085ce34d4@w6rz.net>
Date: Wed, 15 May 2024 11:44:57 -0700
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
X-Exim-ID: 1s7Jca-002K8O-2i
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:35780
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKyBWFGoepCchDeT/a1g1ZpgM/qJpqBS3u5pnLsHeKHeLjHA6RdNrzim06jcbDyYXsodE0Jfa6JCJO5YkAZtQyQNLjTc9XBNwW2qvRQJ/YbJFGCP3xOv
 nwV/UcG00MLLU2fO9cYsMwjk5RvaFAPOe7L7xnaoY52mRDeW/hX97RkoBnFzxRVqgWqDuhD5CL+QZA==

On 5/15/24 1:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 340 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

