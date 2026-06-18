Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151403AF66D
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 11:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781782380; cv=none; b=HYJsgeselTZTHrAZEXP0UAjzl57ob96qNCxvp8XQVFqqo3nIIursOSijQf+PzjEEUojy30b5TEsZbp33xxFAOnQVdXIZ56Y+8mczmL4ifRZh4B1FJEVcnU+5wbY25uHF6ZCSObfuJ2izxgzchBQsnJ/Ihy96zL7924AVxLxWcls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781782380; c=relaxed/simple;
	bh=0ocKBah7H7wSGcmRtvd8nVZX1kQbbiXVYJX7QrZ+W18=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jrFuofWdtvMdvaIgyoTMdi1xIv5+ETaxyCSODzQp9F5iinGw0gIWExbgiF+Nn0v1fop1ShpqXXWoB4rc/hglpQTz4LZC4WpzJqSTBHON0rv6HFRiSSOx9WpgsuvJ/5GxXSwQwJCxbAP0vrCWN07l5Z2lGbSEZSgblcyalIVqMTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FRKoHiRr; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FRKoHiRr"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4908b92904fso11092825e9.0
        for <patches@lists.linux.dev>; Thu, 18 Jun 2026 04:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781782376; x=1782387176; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5rWjb3dkCCJpKMUvJjiozK+b/VXA/rC9ER59IM77iGM=;
        b=FRKoHiRrua8H3hcrlg4is0FJC7ILM461bh8ZCpVcG9FjHf+S/UTYNJBeEazz/K8Wtp
         tDuSH/lrYM369yOsg1h/JzSHsQp5SOErJSLjCSoF3vjAeHqZ1pRwWEK3RHwxUBFp/CFJ
         uJYk0oVW31Akym1M84ycI7r4KAcb505Z5Eu+Q+pPdtLMAH6g+EXPafWRM78oPlJ1VVpY
         7WtpLH64S/PUZRMn/MwGeMm8rpKoP0nCr9+uewnKwHYnyshOIgrOmcqvPSkANcJIbVrk
         /N9KRR2iNC1NrCliBwsNv6+4qsUUvtnI7nVqWTomvkHYSy1M3slNY+7FN8YuDdiN1VyN
         8Mcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781782376; x=1782387176;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5rWjb3dkCCJpKMUvJjiozK+b/VXA/rC9ER59IM77iGM=;
        b=pYaP6e5eGReLY5VoyX7iYm8Ap86D5WSuwpF+tfcjE9HaTF2TOzGvg2OU6CD0viqkbB
         Emd+ew6dB5F2mfKWbDig5IgCffIhnmtT0NVjqlOI2ecO6RAY5eeluuzo9tNDl6yVenA/
         Xq4WRDfIF88QNh+AipWMqWrvwiWnmjkQOmQQd/4T1bcl45ThEOlqXK5xo9XWOK3BuGPX
         Ga8Uq1Z+ZWOvXoO8jk2JAXxOMGs2wDM7BoTPvpnQBw6oyjKbNchFah9TTwjCLsf7IjwV
         DND31hTg5t3UXAGBIEVJfibH5b82sZszA19jKdgC3U/HV5dbQt7qIAnJViBkKou7DxC1
         2Rig==
X-Gm-Message-State: AOJu0YxQLkG7flP5kIA1pyutKMyfQXCLIOsVNqrkfQb3vP9qy7QU2Yh7
	5QOTDm34ZDfHweVXqQSFQyTYO+vRhaHVrUp8tMZoht32rHvk36RDYysA
X-Gm-Gg: AfdE7ckoeKq6KJLYFcx2O6a7G/2F1a7B4bhW7389tG6GURWVQDvjqXGfv5QUyqdiCh+
	NzjJQu+W9LG0nA16YslSkdncjUT2GYTcZ+HDLyU1o9TOfHUfhJc97AqPwXI/i2ifQ6wTBuNeYOO
	S/umBlQQC4Cld0osYA3CWY6nZlecfkCz3CCb9hIApxthlFjDbrMI65FT19nemt49Gh/sfcyK6XD
	DW2zM2r+42r3AS5W/PZ1T2OmhX3wokWWSYUZFVQhi6RDVDa1P63KJjxuCs5ZXvJKSbKLlq7mH/5
	/WyRsojUbHKPTYiFdnMc62j+afMx1DXqPxjelWsud9HY6ufWDj0RSsjKdtO8Vxq5drOFSrnzwjJ
	nYXCCiiZhDcQ5sf5W7YI+9JEvW8evPIoXEpFxRx2Y37qM1BJAVH959Em5fadm35/CIlq5STFagU
	39LzRwBQhe3k80GzgbTnBEGVQFwbD4LA==
X-Received: by 2002:a05:600c:8b56:b0:490:b8c0:d470 with SMTP id 5b1f17b1804b1-49234127e32mr112124015e9.19.1781782376153;
        Thu, 18 Jun 2026 04:32:56 -0700 (PDT)
Received: from [192.168.1.21] ([41.140.50.249])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa47da9sm287756915e9.5.2026.06.18.04.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 04:32:55 -0700 (PDT)
Message-ID: <fd5283ba-4bce-4984-817c-ce6224e779a1@gmail.com>
Date: Thu, 18 Jun 2026 12:32:53 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/452] 6.6.143-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260616145117.796205997@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/16/2026 7:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.143 release.
> There are 452 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.143-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENEIRC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

