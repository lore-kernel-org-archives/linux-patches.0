Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE80C11721
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 00:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708563362; cv=none; b=HSRgTUsZrf5SIGAQ1WaXjGRUw8C0TWHQDUp8Fc+bUHZKx2szk2rHaQniYZjbXgENOdJMJuha96D5f/aZW3fIheA5PVGQbJo3EZOX1/B4lzkxmeBcfp8sM7NY4n/Plwc0cJxQD9ZYW0JUH6yrWATFPdqexHdgJFhU4+p8SvNH1EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708563362; c=relaxed/simple;
	bh=nOygF+tulfpl8khV6zhERbuIv8CNCUxTUNFrXzNgoOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WwXCbfwYqtR9xgDVTUHBJcwW2XWHrLFpICI9Yhi9gqwQvaT/JxZ4JQ8oA7ed9tkkbSUXriL+NcrBRpwTIwDZnDBfpbQdcS5bKDN35Xw9G/aAtX1AjFdT54+wV6b8S7ZSeR1gUhYr+fMmYwU0Y+S2KFRiWTghcvNxIvKZE4SCGQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B1QO824b; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B1QO824b"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-29a430c3057so164338a91.1
        for <patches@lists.linux.dev>; Wed, 21 Feb 2024 16:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708563359; x=1709168159; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WL3spPkKq/SZseTrtmjIOQn2serUsFfggo7i5+exlHs=;
        b=B1QO824bN+Eu4njV/MS3y2RM1lKKA6toHz/fCmTQ5ON10g/i+ExYbAPG/ZazIqi82h
         HZu4ENz5ZfhZaAE0leEhsR86w4W4yOdD/y8rRpSsbjapr0oJEKL49b27TAUwjYzCkaW3
         zCeq7s5gZDOdDFC7HOzahqBwen1vXg4cvbcwH7I6BZklFwjZbZaqlVIJ8NcW7WUxjxpW
         awQJ97ujY8SOEv+ihyml/cTumAVK+kvh9TXQ7uL6rBsW9Ou7kzGHiHENF0PHy3b+h3gT
         Q2vNem20hRUUjngNrNVCXefRScqbPmaUg/bQoqYjjfYmh6YX5KbQWhHuH1kidfnnv+lS
         V51g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708563359; x=1709168159;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WL3spPkKq/SZseTrtmjIOQn2serUsFfggo7i5+exlHs=;
        b=va4I0l539J7qbFciusDUbzovOF4g3wGRgwb8nzYw6N33+5bh0r7om8PAIwgIIORuWv
         SFrkn35/toFh3+L5rngD+8M5me4ofXdp5MDh+0lD6Mk0aiTUK8DNCuH3A2WjIlVToDS8
         gj1F1QoGxvMmJTJF54Mx/USOW7wyO7AXmS16REVzQgKrMxvOCygIdhjwXBRHEDfQmmMR
         I08nv2OYnaJ8GvkTYCdFmnFJzcA830M508Nw2tG1B3QCPyHUYluLLq8w4p08EGpuVsT1
         fUD0fy83tbtsB6IqJ+pW3/qTz8OVzpHevr695hegPeJdW0zSpfdjlVwkJlIZQlQ95qmv
         IkuA==
X-Gm-Message-State: AOJu0YwHB4d+SOU9BkxaNcAyAhWQy3NW4CsHNOZ2BX2CfaVODENNe06Y
	fj1BuHz4AYWoC8iKmS8npMbs2t5Vz1oytyDnK+rg5pbq8u1uHUeC
X-Google-Smtp-Source: AGHT+IHGHvOImUTZQjA9JE22XMBCiWU5J8YqOmsuW6Tu+Y//TfZ5zD/Q6DNg/mCdyODiXiP/9aQMXw==
X-Received: by 2002:a17:90a:bb03:b0:298:a28a:e58c with SMTP id u3-20020a17090abb0300b00298a28ae58cmr16493010pjr.9.1708563359051;
        Wed, 21 Feb 2024 16:55:59 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l14-20020a17090aaa8e00b002997f192d4esm1629662pjq.1.2024.02.21.16.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 16:55:58 -0800 (PST)
Message-ID: <24a0eb8e-9007-4368-9ce7-7ef11c8e07b1@gmail.com>
Date: Wed, 21 Feb 2024 16:55:57 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.7 000/313] 6.7.6-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240221125951.434262489@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240221125951.434262489@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 05:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.6 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
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

