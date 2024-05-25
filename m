Received: from 0.smtp.remotehost.it (0.smtp.remotehost.it [213.190.28.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78163138E
	for <patches@lists.linux.dev>; Sat, 25 May 2024 09:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.190.28.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716629757; cv=none; b=XWkwG38n95eJnt5SwgHtfEpL6x+cCBRvdxclqivpKxElTuF2OyMUb6PD2KM9gwT9A7TQMp97j8wrxvHPY+lJ8u0Ktdy+pxkB0tV+caJ9iRGPbj//pUcHuCGp7kwShU7rCQyHXQv1bqVGxy1Ahb8zMh9y+dvyLPjLDigQah4j+TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716629757; c=relaxed/simple;
	bh=M0R+1z3DK0h60G/oPIyYQDPmLrcLTvb3ohK1sQJDcFU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=YS50zRMpQEfUoLQruFt56foCJ/FCVmZDiSvoTrplvG4FRbg61BWfmJUdHNwsEyoNwwjLWRY+RU+vCoj8mTs4dJeotr4B64MzlMoSHftUD+nIifkbOCXPWvXWC5+hlrQRhqSqUnxmuk18poy/edqgNlOhWwj4BcL8/b/2fT3OsYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0.smtp.remotehost.it; spf=none smtp.mailfrom=0.smtp.remotehost.it; arc=none smtp.client-ip=213.190.28.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0.smtp.remotehost.it
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=0.smtp.remotehost.it
Message-ID: <5e6a5a0c-180b-442a-88e3-f084bc48a45a@0.smtp.remotehost.it>
Date: Sat, 25 May 2024 11:35:53 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Pascal Ernster <whatever@0.smtp.remotehost.it>
Subject: Re: [PATCH 6.9 00/25] 6.9.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130330.386580714@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

[2024-05-23 15:12] Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.9.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


Hi, 6.9.2-rc1 is running fine on various x86_64 bare metal and virtual 
machines of mine (Haswell, Kaby Lake, Coffee Lake).

Tested-by: Pascal Ernster <git@hardfalcon.net>


Regards
Pascal
