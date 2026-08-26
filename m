Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AF6A59
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 00:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787702555; cv=none; b=stftLMvmARCDpKWD4Y+9dyEqkizrSUXxvSiLgharnHJv/ytWZ/7dCB32el1J0I+/XRTLZ2uRWNJoDTcHgh0rgdLjGQmENs1wAVoHyi2oNbFagXVuXc1YDBiwRL8I3bEszo1d57qUMZjkWvQVD8aNJF+/TtG1aKfqUACjfUG4jt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787702555; c=relaxed/simple;
	bh=3Qzgcnb3krqYX1TRCLm+K+5/oXakkUWqY4aiFmCuYVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDOMopwivFEL53sS7P9nqt/afPn5i1Q4E5l1Y1SmYdPiGKyX22iyuT0b1HXXSTHSe+5v0ECDMoV8RyOnu2AomEVjJdOGkmseIFH0DbclygDyfj2x9Z3TXw06JyPH/9G3M3HTTL3dT2d+0piJiLQqmG87ne2a8uCMMTuHVxBmR1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SpEwMr6V; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SpEwMr6V"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c2cce930cso4551951cf.0
        for <patches@lists.linux.dev>; Tue, 25 Aug 2026 17:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787702553; x=1788307353; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vHASJ0p4N+FbxqsXc0cBSjdXno6a8UBOq1hc57eHVdw=;
        b=SpEwMr6VpsjS1XuZ1TjVWUBmCkZvw15c+jz06T7+WvumG3lYWUys7jRk4OOW5jwbNq
         mht2MJLt7JMLRhEI9Q3y+ZtaR1f6PDqYzLs+xG7jrWp+RQ8tqfoU8n8UgRsHaSsqI8wb
         n1P+P57a8j8og68wJRg68Fa5uw2xLM5aPrxP/oOE5QYD7RHkB4o6XW/SML4W1nKZI8F/
         gMZO6oQLrlyMpXucjOLUKyICPdOvjil4IjVyNh7bwSPonJmD+d9BSO4IpU0cYukKmkXw
         V5Fp8KIs7ZS0Fesu69Smq/8irHdyGZ0cqblTCKtpkizT5fWEp+GaNyEEi9ojZQq/swOV
         q7cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787702553; x=1788307353;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vHASJ0p4N+FbxqsXc0cBSjdXno6a8UBOq1hc57eHVdw=;
        b=nB4ifjNunvOy/cLYZJ0uDWppQG8SzYE8P/yU22LxJ9m2eHO1da7BX3xv1hRhnfdRgP
         eWNDrXkpsFDC63qUcqBQz5ldmKRDiy1l1180dhiU/rSW8iO3Pmvy1YBoFaRjDR+pp3KW
         yfFas7tC9KZf6cKWQWdPf/ZhZd1GIofZmpqBm6fdl700tIRE8hJRMUq0xOArWWR+j6TV
         d1Qs7cgpYjllKUGvhAzQIL67bfbIAM6Ur2VuRDaQh9sJkbGJz/XYEZEa7jAix5LTR/v1
         XpkG3weTC+GPs2EHh8FrUm2XcicBaPeCZF2OKSsXBQdx2994O1QvgVzCHEwe0OZDuE1U
         V16Q==
X-Gm-Message-State: AFuF++mtUK+xEa5UqH+iYX9CqquillGru1fMKHbH8bzpDGUhKBjTvv0K
	mIebOeA6yHZmmS9Gv4JRWHPK9rmNQc8FmFTnIGslnttZn7mUtVgJRCWE
X-Gm-Gg: AR+sD131+vlMVypgUBx+x3aPhTlv+1WCHLGUgeqfouSLn6DsopyfNkLcJYZPCT4o8J5
	/rvdcW+14meKXIKL8o36ywohdeR22VR8etfLviwgxqCWBuNYHcEwqCvt3ig3eWM14jHKa1w/prz
	xcWMQOa2bPvtL9UqkUgx+pckCMj+tH61lJsTVCE580F9f2Jl9TbopFZoQU31F+aQ9Sud53b7KWN
	LrNEeWYbCOyeF2r9Z9jc1Y5G97S3vfgubklyGlLIQKeYtpwvQ1F5ijqWCJYU9kQEsPoTaxgfRwz
	DnaaW2H5czLqvXcVNb2h7q48FhDiL2tcsOs5URVzpO7acOO1x4klPZzFMlqaLLeR2+zlq7+SS6R
	tp7PkusWKypRYtgq8d66flOC2jNu4nLjlpzzlZv7mtdL3XRsp/VQGDIa+KtN/wClpXSueTOeP8H
	vQpnrGLGLwGzyOM2oGHx8yuMNGOaA90a+LAM4egEO8UTPAWZLxCVX3gbFhP0mBTIKwMUbAahUpB
	FDNG8YbhJVIKzss2kx1gt1XIA==
X-Received: by 2002:a05:622a:1c1b:b0:516:d83c:edb6 with SMTP id d75a77b69052e-52e422cdf84mr32079211cf.12.1787702552384;
        Tue, 25 Aug 2026 17:02:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc650a197sm11302996d6.23.2026.08.25.17.02.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2026 17:02:31 -0700 (PDT)
Message-ID: <221f5c82-3dd9-4552-91ac-3661675c6eaa@gmail.com>
Date: Tue, 25 Aug 2026 17:02:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 00/82] 7.2.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260825132541.560541185@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 06:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.1 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
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
