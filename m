Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD6614EC6E
	for <patches@lists.linux.dev>; Thu, 11 Apr 2024 14:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712845274; cv=none; b=fu0rAhY2o3owrrDenG7v56B/K6X2o63jr0Cf/bEf4RiNKH1mWmN0WBhB92Nup/FN8nj2r0WAjrrzCBiZUCl1W7Dk8oc1sV1wm2YqwXRRVT9QO4O4mF5cf+eNtKqCxp8KA68V2qZS9fGV4kzMUVR4a2JnnLGvDKfoxdLubcNQNAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712845274; c=relaxed/simple;
	bh=AP1yIpkD61knEsXHPu2ftMhehlLmX7WGkWX4C57FbBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XuD9gGA/Zbmi7Q4dkJPKfQC9lY/upBVDfXiQWxhAMCEwwRYr9acGF6Ch8uZAx1DJISewkTI0XwYmFFmhsLAToTBu200DiHJFw8BAkzWNNJDNCcY6pCCPd3ogo5/mI/kuoRPaq41GLyPdHg3EPxZihj5ZP2q+yF/sbOP+dyhg2AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DX+SZqL4; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DX+SZqL4"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-7e3555015a8so2867406241.3
        for <patches@lists.linux.dev>; Thu, 11 Apr 2024 07:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712845269; x=1713450069; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zNDwMXzZA9w/Ig5nKNfRn6E1/CKh9mEe7H9+Vh2hNJk=;
        b=DX+SZqL4dfu98IVhsjLhe3wbUYPlJqYGwHzK3u7p8OB9ZgO7NBeFcea3fcr0AYuv6k
         LhDMGDFn8HxBNhFRtsWDLVfLCiC42pBPfFfV8fl0gke7C9/PYz3TyLcD1J1SB7n8PyyK
         uuY1VokR5o1GF3HzRFiQk6RgIqaHSSkJsNvNW73SfUJG24Ao9EL+QSbV8jx1BYF39m0D
         O8hvt8fT3VmNwghqeHiQqRq8f+hVEDJM3cj+rRcflBohN27i6miVylGNKvGbFJM5ceNs
         6BdrKY7dZI4cpxccXFS1xE0t8FPtdDXLd68z0M5lKhQiXZsLzMNAw3SLqYz5/SD568aK
         /ZWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712845269; x=1713450069;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zNDwMXzZA9w/Ig5nKNfRn6E1/CKh9mEe7H9+Vh2hNJk=;
        b=MDyaABZEcQLe+OHavkkC1xYR4xpIvM/7WxSyT7RLxFbX7oRVkpI9mM93b1+NQ8WTFq
         F0XayaoJOfB9LN6f7+Uqajj5G9PdU9D6QmG6Zb4mzyLG/t2Qc9PV4XkqrYbanhBvvWbM
         VPeMOQPSU0f8iBneHV3oJINxhlCEypEdwU7SLQuO+og1Nc3cszVZyFxMs/H52ZfdNXLS
         0+mrzbXt5dOJsSWcq5eP9OlpL6HbAkCXFJV5E7LCzAvr7FiDaUvG8p941LsRMaQ/GUaC
         L0I31QgWgyVwFZAYwHlXLWVsOyoZoB7OKbZ+yrAQvFlobXpbmx7PptVmAncLAVdpT/+c
         kf4A==
X-Forwarded-Encrypted: i=1; AJvYcCUdkxhx7gFu98EVWmyAHh3heF9SPsVP8DpYNaNv3gjm7KNTqqitUaq1xkwCedYwvlXycok0g4FoI6u9F81L2W8+O2sCRwmnkg==
X-Gm-Message-State: AOJu0Yw1Ca/QIfgJ2SuZJ1U1X938xNVPzz1z0kW35N4RrSOrBmQrycp6
	LUEMOYGq33Kh9hNlw5EH7w1Kx/7+ZZMlm0mW0025jdIDXQOOuflRvA1oLnwIdbBINTwlS6OS2yR
	dktULpV2Ca9oDapxTV6RbripmfpQ6F8uoy6QfXA==
X-Google-Smtp-Source: AGHT+IF8/NngFSDZwNmkAlmPTYphRoq7xTTCiaK3Q+0SqL/mTmu76XOg2HqetJzuAV/Spk74WCqBY17Kl/UR4GPRGL0=
X-Received: by 2002:a05:6122:4d04:b0:4d3:34b1:7211 with SMTP id
 fi4-20020a0561224d0400b004d334b17211mr6042749vkb.3.1712845269210; Thu, 11 Apr
 2024 07:21:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240411095419.532012976@linuxfoundation.org>
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 11 Apr 2024 19:50:57 +0530
Message-ID: <CA+G9fYuwCn0D6jzrn0dBKsa+X0zUBUMiuRqcYvc-qkKToXK5dA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/175] 4.19.312-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, imx@lists.linux.dev, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Apr 2024 at 15:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.312 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.312-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The arm imx_v6_v7_defconfig build failed with gcc-12 and clang on Linux
stable-rc linux-4.19.y.

Regressions:
 - arm
    * gcc-12-imx_v6_v7_defconfig - failed

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
----
drivers/gpu/drm/imx/parallel-display.c: In function
'imx_pd_bridge_atomic_check':
drivers/gpu/drm/imx/parallel-display.c:222:23: error: implicit
declaration of function 'drm_bridge_get_next_bridge'
[-Werror=implicit-function-declaration]
  222 |         next_bridge = drm_bridge_get_next_bridge(bridge);
      |                       ^~~~~~~~~~~~~~~~~~~~~~~~~~


Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.311-176-gf0cf5f6110a7/testrun/23411280/suite/build/test/gcc-12-imx_v6_v7_defconfig/details/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2ex1v6eevudbi33g4ozA7hJ4fvs/

--
Linaro LKFT
https://lkft.linaro.org
