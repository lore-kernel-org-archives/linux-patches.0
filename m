Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6FB2E7631
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 16:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780331664; cv=none; b=LixCknKBCwUZObb+FMwPflbqIPJKGFq7WkOAmMq0qo3kC+JItWKtIVz4OxXDHSv09GU723AIY/T88VBGQ0ayCGiYmiaP8uPQH3f6cnRh8EyI8hZp0D6/K+lMx7/yOTDm8YQMIFm+ZvfK85/xtIblXDQADbnzU3M5g65bJSNSlEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780331664; c=relaxed/simple;
	bh=9va04Gj4TZWVzfvnJgVPRuChJfeJ8W9Gwo7jtNxSdVE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=lm521n5+iduFRFd9jiTSddVGHWRNwBf5dg5Y+E7gF+Ub1wKt1maoMMmyeFxGKuDMtW5ulZxNA/2+UGtamTEzvtGDEzeiH0LebNxGJcQUO92sdW7nAbHwR4KtbxjddD8tHJixDGopjLe/zAUkyOikTa0NXqOaL//fy7yCRUc/jeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rC2arPqy; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rC2arPqy"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-9156b74006aso56552485a.0
        for <patches@lists.linux.dev>; Mon, 01 Jun 2026 09:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780331661; x=1780936461; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MNAWf7f8TEsVni9T7N4RVk0OisBxfJyU8zGQlhBLT4Q=;
        b=rC2arPqyM2QVoFAj79VyXKTBpbaexvaASuOKacfx8RFAKY+lltrKleTikVO+7A6+mr
         7NGsJ3ArKuYbD7K0VflSxhcyeqZRRuVFOqTsEqJ0W2MCpqktG5qMsiu+IQnuh0sbVfva
         lX4qEDkyuuri5jJXB5hpB4ranSodJ2vPKpJxCC1pV/MK314v1OA2EeNdnnONsLn+EktT
         9nOuoQwPuDBUkvyQVlnn9Q7y+ojMAUJiMRav3nfIFUWAdJXP7RAsj6cTxyqOPc9d2daX
         CnHF+cYQ/fhyc33sjEQqPMk41C0lRWDd+tyL1n6ZsJCsFbP+PQ9DBVlcJ6QD3s+aGM27
         +tFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780331661; x=1780936461;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MNAWf7f8TEsVni9T7N4RVk0OisBxfJyU8zGQlhBLT4Q=;
        b=IZehQqnHRs0I7oWdJq1+GWTVpiRrqB3b1WO9MiM4OEdOJ81MntyGYUYLwCZsgMtFe2
         4qupUUXcMgI3D9XQX7qMoLkbKKEDm7TXV6w0vmWyJmrHLqwJ3e0+j6oDjOjEMRSx/FeN
         lYhLINfBfC+s+D2+VlvgkxhSd9WBnyp7cZcX6BeAncJmTfb0zzzQgrh+WskTDg1tJ/Py
         R0vdzMspjuhUxbK0oFfK7T2Sei3PrsjwImGNHOixfda9XYkhizVYShX5R7ivDhXc/uOw
         iPIKr4/MFdp6d65PbIesWY6dRTRorxjrAZHfQ+Qc6jvW+ubgdwaR7iN6dPQYgrlSqeK4
         +r+Q==
X-Gm-Message-State: AOJu0YyoJKy+ZztLitXgB2YJygTrVzJDFQFRUtWqDQmg0qtWZBdQsRwS
	wRlVLgW7PiylcReJgrhFoAi6fSuoJYJ2tGCpBW7KG1t7hBldW+p/Oc4/
X-Gm-Gg: Acq92OE6XYZdoGHOiSigzrnUNs+IeJXSqzSVxxu+yqtEC+Qw68WQZc2KKXVF9NObKfR
	IudRUM4HjsPW5MyghbjDnoVirpYZt9ezcqvkDrZEz8+dEOXtZ93+2SEsfvF68uhF6Z+OghIstrT
	46fzohdu/tBttKCw/FVO3NiVuC5wEVVZ6Rheoy8ADIRgvzHq6CoJhzTOo/tzVyKxXKTPsLSeAw3
	06OAOLBQUWJotR5xmLjzJBY/nsDbdNYOY/NklMyHgDgy1DZfWqM6CAyOMDp1Nv9wiCOTWmnTNOo
	NdVWHm2pT+QV3XBTvJYwwu5WC/6uHOVwcmrmBep7BP6IbcOKz+Iper11PwahKXLh990LKKEvbhn
	f3CJDz9FcBDypOafFlK0/gCDCAuGkWKX23FSlw137RIMRY9VnMrS1HGEDD9/5CzRXEN+bgqWFjt
	HEM+Qa0aO6qNmlRfJXwyQ3yS2aPCuIfoegGeU9fohCICOMOSYSS+Xr0Tnz/gAP
X-Received: by 2002:a05:620a:29c1:b0:914:c316:45ff with SMTP id af79cd13be357-9153d9e993dmr1703808785a.40.1780331661355;
        Mon, 01 Jun 2026 09:34:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9153262d1b4sm1058346985a.39.2026.06.01.09.34.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 09:34:20 -0700 (PDT)
Message-ID: <e5de9229-8f67-4de8-acab-7b8fe7281aa9@gmail.com>
Date: Mon, 1 Jun 2026 09:34:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 000/589] 5.10.258-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260530160224.570625122@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/30/2026 8:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.258 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 01 Jun 2026 16:01:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.258-rc1.gz
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

