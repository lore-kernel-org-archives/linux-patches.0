Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA1917C7AB
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 17:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720028909; cv=none; b=bp4l9zEj03MyjBHLUWb13TZZt+aLNL+IdZTQESRykcnYtg8FGGr3X9G8FHj1CYRNWnc1GgcYfmIp09c1ELUvf59yC0FykJi7Ly5tPGfyVxWrGDJ2Pz5PdGVc0KWypluHpZ5uEcWo6aACBsQxlpfY8dO2yF60YI77UxZefxeVcjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720028909; c=relaxed/simple;
	bh=N8V2R60Um4mvF/DP+2QgAWbUsTYcbkQA65824qtqEKQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qd9p1c4LIiNZgL4EHI/iz6WKs+PQ0JS8U0FIn6KHQJetwk+lgvFvMU9SpCdBqG8L3zlzxOVe8zQyuNRJknAPAGO/1Xfcn7/oh0GGgi7nkYhmxr8HWrbk14brkbtdWnx549+U+6fdNF7UxceIJzqJVwnORFQsdvssCE9dZZFjI7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F/vYKa8h; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F/vYKa8h"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-4ef66280cd7so1810172e0c.1
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 10:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720028906; x=1720633706; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SjTTtlNb0syE5KHwXFKv4dS9jF5tUNRtWjSxSGgYhH8=;
        b=F/vYKa8hZFB30vI+CraEJx8zC02hp9vvVn+e5oP4W1fp7vLrvciIxv7F3EPE2rS/3m
         Gu0T0ljF7xNY73uGrqvAS6Ma1SUrHKK6LOq5pTCfuGdNy8fSAJkB5QccZYbcuNAMmUn5
         3qus3SpBtP+9SLXzDS7TCu5OE4RFYlHp7BrdPudww9XYuHbVZeCo8gwHtO2n5lKEJJDr
         dvHjIsPP9PqB1OABktAZ+4pZFYNSYE+k6VWP4iHDA3hnmVcXZ0tTCLTD1G1CPQ2K0nh2
         KQDajccrzcZ35OfzBZpnT/fYoKQCzjnb43v/qf/OXitvAyNxaTUT8YR7M5HCfzgdFhxD
         kBKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720028906; x=1720633706;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SjTTtlNb0syE5KHwXFKv4dS9jF5tUNRtWjSxSGgYhH8=;
        b=IYv3cGKXpOfskEXa5Qx2+uifRu3Eu7iVnx240/+1tYOT1raAQxk6R1htTNVpULR3jx
         jq4pzFM7iIKk78LIGtBvMrm7DSUw+68QoLGBj4SRBTrvvkED79g7fpEkDFnEGH2ZEX4j
         SdExXq1T0dpMJpX9boPDo2yvXbVVOwhz6Y3FPAYYBROta4xYPmyUat7T+AJla/29zSL7
         e1RDfu9CHCz7ftGLo/hABDzjzxdI0G0BkqF/TfxD6NI8SgcyCsaEF/rlrI7p3+m4nsES
         OvLSBIEjFcQbAWJeqH4LUZR8SfZzwkSTzZDFMSWlGljUmXqlNVvwKGpVHg2lTBEXzKan
         Y99g==
X-Forwarded-Encrypted: i=1; AJvYcCXqJ5avLnYojrGMKODqYYNtjWviXBs1sPK+/rq+Ei868U8+5pE3uP3Vfq2QNgMLV4IzZfC640Ugq3zC8nk83T6m9Lr+CriS0A==
X-Gm-Message-State: AOJu0Yzi4OGkFHOrXYMlmaQKmDSWeirTgdThm8ANRx0M6e0GcjFw2WO1
	+IdQVyH+D66BiyspqDZi+6UZ3eF5cjt21gmrf/SqMq7FOGE2Tgzaib2MvPFegt8MIevxpzN5kd6
	r0e1Nui1R/O5HzfbjUs9ayfMJJuHy+ujp01AYaA==
X-Google-Smtp-Source: AGHT+IHq4gQLLZyc40X+uhVEaroOxiBVWeM6dpArotla1mzYAwd70XY8Y0gppC8vzwEKdeysF2KmeOOv9KP+gfgSVoE=
X-Received: by 2002:a05:6122:f0b:b0:4ef:320f:9f13 with SMTP id
 71dfb90a1353d-4f2a55043e0mr15627099e0c.0.1720028906555; Wed, 03 Jul 2024
 10:48:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240703102841.492044697@linuxfoundation.org>
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Jul 2024 23:18:15 +0530
Message-ID: <CA+G9fYvXVQ599HH3ZYfNEZrZwacR-0hzKCqrLa=+ON0hDTwwGQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/189] 5.4.279-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jul 2024 at 16:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.279 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Jul 2024 10:28:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.279-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The s390 builds failed on stable-rc 5.4.279-rc1 due to following build
warnings / errors.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Regressions found on s390:

  - gcc-12-defconfig
  - gcc-8-defconfig-fe40093d


Build log:
------
arch/s390/include/asm/cpacf.h: In function 'cpacf_km':
arch/s390/include/asm/cpacf.h:320:29: error: storage size of 'd' isn't known
  320 |         union register_pair d, s;
      |                             ^
arch/s390/include/asm/cpacf.h:320:32: error: storage size of 's' isn't known
  320 |         union register_pair d, s;
      |                                ^
arch/s390/include/asm/cpacf.h:320:32: warning: unused variable 's'
[-Wunused-variable]
arch/s390/include/asm/cpacf.h:320:29: warning: unused variable 'd'
[-Wunused-variable]
  320 |         union register_pair d, s;
      |                             ^

Build log link,
 [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.278-190-gccd91126c63d/testrun/24509933/suite/build/test/gcc-12-defconfig/log
 [2] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.278-190-gccd91126c63d/testrun/24509933/suite/build/test/gcc-12-defconfig/details/

Build config url:
  config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2ijXtfDw1Nbem1ANR1V8mLxfNeR/config
  download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2ijXtfDw1Nbem1ANR1V8mLxfNeR/

metadata:
  git_describe: v5.4.278-190-gccd91126c63d
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_short_log: ccd91126c63d ("Linux 5.4.279-rc1")
  toolchain: gcc-12
  arch: s390

--
Linaro LKFT
https://lkft.linaro.org
