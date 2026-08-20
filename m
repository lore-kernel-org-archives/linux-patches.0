Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADCA48423E
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 17:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247988; cv=none; b=svLPkys3LeIbvegG9ufy9eQIOzw/+bb35YXWgdxQQRmZCgMKHDv7PPwwoUlxfGoG7Hb4rBMA+nWCd1w42eRMqXAc+bR6iJgd0LeKrm4a4H5Puu26J4t+qs55BJTJ8yGaIjttEl/ZgsXzqq0AJ8Tyf36Rcr5HDSZ7+lMCg4PpfPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247988; c=relaxed/simple;
	bh=C3dn+iU4ngL3PUMHzRX+ag0ZBYM4ei3bU/3EcjL9fck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i6IB9tAg99f4x84ewSyCocpM09xKDC7Qc1/lWah0D2VNyBIcWlg7nbcJgLFEysL+kgXy/0E6AfPejLHm47fA8LXVKKkXSu8xy5m9hKbye4cFwOiOhn18LrLrHs91hiNGuraJ53YO3fsEJo8S00vQLcWCC4zfkvb9Qh//Nt8qzbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o2KiEsR0; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o2KiEsR0"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38e88b60121so40385a91.3
        for <patches@lists.linux.dev>; Thu, 20 Aug 2026 10:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787247987; x=1787852787; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jrqsvXw2c7nqIiVFrO4n9x57Nm6kA6WYNIkLs4SBxW8=;
        b=o2KiEsR0cLHy0vEQXTpjXnQfFzSscBhql2SqS3N+JOFrzxZOR16SPZIb86Zu1SCbDu
         gXJXjbEMI4QGH09lU8vZNwfB86NFYFh6MaFPt868OF2Xl65YcBJ4c4SbNjZDNuHPDL0+
         neUZHFGwYfwJCYiWm7ffByhHs12ETEXTLQZ0OesHX+ryTybftdaEbHuglB+o3emKiyio
         oliQ5sMl++l+XrzYxrl3VSifAvXhI/Jd3l7Zxy4V8btEvbUl8fnjPHWN6/RC+tpDZgM1
         g04Ilert0/A2A+f2oiyMl16rWAHWYCg2RKj7XYB10NplO47JnIEz6O3LIBVRQpl1Pd6Z
         S1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787247987; x=1787852787;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jrqsvXw2c7nqIiVFrO4n9x57Nm6kA6WYNIkLs4SBxW8=;
        b=fDXybqc7G2ZEVnip2gMmulIHK9z6CvvOSjCZGSb0e2xPVFpZ1eMFMQhnWzskcG+qVo
         SX0omlAMKhrsMYr7Bsb5K2hTj4SQy9AxCGsSIoZIzK6GjkxIrxgrc4PqEES9nlF5mrud
         emKYkecYeFz1TPQ6LA/vnk2rlWDs7dWNtL7qk9LfMetHIPYrG1vv6iADklE5PSf4Q1Sf
         SpvZkh1nnuMf514zgTh3ackiyFL711vhjcm2BrK/ElXyqeYIA3MCjYAgEOW0GfUcvuZw
         GTgmhqw9HGsyFkxTvY7dt+apToZkuJ0EA/i5hApmR84jgBBQNtosmra9dJDnh6eJpnhJ
         vw3Q==
X-Gm-Message-State: AFuF++nSVstcQUNOwmFSPZ4rXVxx4bNdTpFusffvq5c1wEJCdhwBHs0f
	yvYoWffBktK302b2ZRAnnvM7DLUZAyi1t6BWIi0g8amq9GQMWAjNydLh
X-Gm-Gg: AR+sD128v83Aiu+r2itaOyPEnsfeq/o/sCTcnCT8Zmx4TC9pqxm8dkPd7VNTGckKxrl
	J0Ok0G0VRwFxXAZaInFlAMIcMoWxWLSmXcs6qChb9XDYQ8fsGO8juhjwtHCl4v+CcaK0GZAHBAm
	+5POft/ouQhxlSqnpVbzsuQmXfG9RM6evDpEAquqT7zdqtY0ycKGIDoGk9gAiKYYgTgc+/OjyEA
	4CEu6Rj4G/QMedgLe1ByrER7Zp1RcedCg//1TWsq+fhoXSXQn4VmzC6tSTP4JLXnNYiZiGcw47/
	fNtP7R5DRYT6+YvnEgc0MrJNtcwoGnJ1j57mlySC5F9Ig2XuOEwgDRfUIKTecd69Dc1LQ4k1/I1
	O7tksh+bayG+eZp+5MMrFwxkm1m+6OTWJDwcmVnCInz3L6VUfD1xQyrfZszMbVYr+Aidda4r0so
	OiXECGlS/lX4vgpm2F8lwZ8klIdCgTCUHoYcB+CumlXlDS0c5ZaWj//GPfz+7wod/mQpBwN0X8g
	0TF6ya65XuUuQSDiynP3a78pA==
X-Received: by 2002:a17:90b:4fc2:b0:38d:dfd1:7a8 with SMTP id 98e67ed59e1d1-395c33e1194mr504386a91.2.1787247986770;
        Thu, 20 Aug 2026 10:46:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416ae5f1ffsm29418162c88.13.2026.08.20.10.46.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 10:46:26 -0700 (PDT)
Message-ID: <b08c8f55-e802-430f-bc74-e6ef76939ad4@gmail.com>
Date: Thu, 20 Aug 2026 10:46:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/235] 5.10.266-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260820145216.426568665@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 07:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.266 release.
> There are 235 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.266-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
