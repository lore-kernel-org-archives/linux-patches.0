Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A412B2746C
	for <patches@lists.linux.dev>; Wed,  6 Nov 2024 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730904378; cv=none; b=XNufBKhN5y4bwbtgpe2wqEPp9XGbnsuVzApfC6PirBz2n4wSm2X6vXtfzMQMaSYTjT9roS+vPTKIxR1aGlPsfnwlze6I8ool4tb4Ux5J89QphEvMJ+d65Cj7QVthElvzw/zkX6c30oJK4Um3vegIxYPaDQGk/SVqdIeb+WRZeso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730904378; c=relaxed/simple;
	bh=ZI8tqYqA/5qWxMC7iauvN1ZlEqc3lZWFob11XAkNlwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VYoMsUXSBzT+Gfl45hnMj17wL0/7eeS6vgqatVPCUCqHXN+8Bn5bUZPSj+2QZ2LvuHUn+92+jtyW+XcZgdCzUtbStZcDRgh12RQ7lOaDfSSZKtTxe3NJPJVKorE/mg5FMP5oB5Kd1PWS2gImREhxhpghWF1fDTUg2Iz+azaq+YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MeHY71KW; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MeHY71KW"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-50d4a333a87so2397384e0c.1
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 06:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1730904375; x=1731509175; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TFQcDGdRJv/pC4Fyxt1M1yJ9o6fC6hnhjRlfAcbSaC8=;
        b=MeHY71KWk/6DZBOHYQYgrZXn4LP5gQ4yysB87eAGBM5mSGlSJqPbM/4DzlcG6F0XFU
         4MRIc5owodTpZ5fAMeG4FHTZbwfFdIjhNz07n7hPEC3otCCLPEvFXIFR/NwM0CdXd5Am
         ptHlu3YcByFodCina9h4m2sA7vP5UMe6c8/6oyt0i/Zfs2a3px+l6hnBFuaTskMLCHQ7
         qqKgHlbBRdPV/OpgUXX+RhvvC+iUCEDeIOihuh/Far88k5IJGXQ7jwWwS5jQv7bao24H
         JjwVM3m2R567dfoqbwe/JVOpQE3cM5eeVUBf7M79K3HkV5+NAc0pIpnraQeqQVwylnKD
         QukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730904375; x=1731509175;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TFQcDGdRJv/pC4Fyxt1M1yJ9o6fC6hnhjRlfAcbSaC8=;
        b=uss+RudGk/eX2L4gAJIEPbDJocijezFDBcH6lywXsrf3kEPSz0+1alvTYD3wswzxdq
         V1+DTybdHLFLBL58ii6yt5TW8gWYgA65f1xqACB3IMdP0i63oH5xaJuJvBvkNq8KUWoL
         C7YEFpfQ7ZQ4FBYdiced5tnyJGbT8uWgT+t+t5AWSlLOQDHE0ly2qTz02KpCWX7JOCHj
         KZqQmJw1X7XBR47mzpgVydIDiI9D0THIDBwpZC9uIUMyxvar1H4n5au9wQQemYlJyu7G
         UiAxLawUtWIV973gRISWTIKSANjusNEtjzmvgOcgXKWD8DrMqMn7mm2Pc50P9GQg03sA
         5ytw==
X-Forwarded-Encrypted: i=1; AJvYcCWTzfTkFdsWe2vpeugOuhNCbuhixeUaIwwkJADdkMvHNuBRC0ga2TU8ofQIi50oM1BbYtoQFGGa@lists.linux.dev
X-Gm-Message-State: AOJu0YzkXQOSyiSRJoR5c1bLvmpQvHsQKaYdxDhPmVb0LI++/UczNHEO
	ZCCbmWDhaTPS2UbnBN8gNiBUWilsti61InB8ZR6FGktHwTTvlPW9EgPydCTgrZOTfOByTIeQz7N
	YG/829G+kLoDfXDvqtfg5Pagv+Sb08y+90lvvGA==
X-Google-Smtp-Source: AGHT+IE+bC+mXxOOV4yU15PQTzQJXdiY4kF8XY5VkBdvqe3TfXbtpkxhhgCQs3GJaaxDzX5RCa9mZTFL7EWHaFZUumI=
X-Received: by 2002:a05:6122:3d13:b0:50a:b8aa:93c3 with SMTP id
 71dfb90a1353d-512270ca839mr20179755e0c.3.1730904375506; Wed, 06 Nov 2024
 06:46:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241106120320.865793091@linuxfoundation.org>
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 6 Nov 2024 14:46:04 +0000
Message-ID: <CA+G9fYu-X4w24M9NgwWU4=vOsMxq8CzmCGo+BC-=t9e-R0NwnQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/350] 4.19.323-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, 
	broonie@kernel.org, Wang Jianzheng <wangjianzheng@vivo.com>, 
	Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 6 Nov 2024 at 12:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.323 release.
> There are 350 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.323-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The arm builds failed with gcc-8, gcc-12 on the Linux stable-rc
linux-4.19.y and linux-5.4.y.

First seen on Linux v4.19.322-351-ge024cd330026
  Good: v4.19.321-96-g00a71bfa9b89
  Bad:  v4.19.322-351-ge024cd330026

arm:
  build:
    * gcc-8-lkftconfig
    * gcc-12-lkftconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
---------
drivers/pinctrl/mvebu/pinctrl-dove.c: In function 'dove_pinctrl_probe':
drivers/pinctrl/mvebu/pinctrl-dove.c:791:9: error: implicit
declaration of function 'devm_platform_get_and_ioremap_resource'; did
you mean 'devm_platform_ioremap_resource'?
[-Werror=implicit-function-declaration]
  base = devm_platform_get_and_ioremap_resource(pdev, 0, &mpp_res);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         devm_platform_ioremap_resource
drivers/pinctrl/mvebu/pinctrl-dove.c:791:7: warning: assignment to
'void *' from 'int' makes pointer from integer without a cast
[-Wint-conversion]
  base = devm_platform_get_and_ioremap_resource(pdev, 0, &mpp_res);
       ^
cc1: some warnings being treated as errors


Build image:
-----------
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbkOSx8FRoSUpBZX23UatyPIP/
- https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbkOSx8FRoSUpBZX23UatyPIP/build.log
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbkOSx8FRoSUpBZX23UatyPIP/config
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.322-351-ge024cd330026/testrun/25686486/suite/build/test/gcc-12-lkftconfig/details/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.284-463-g21641076146f/testrun/25690547/suite/build/test/gcc-12-lkftconfig/log

Steps to reproduce:
------------
   - tuxmake --runtime podman --target-arch arm --toolchain gcc-12
--kconfig https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbkOSx8FRoSUpBZX23UatyPIP/config

metadata:
----
  git describe: v4.19.322-351-ge024cd330026
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: e024cd330026af478986a90829dd6ff03e3c1f92
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbkOSx8FRoSUpBZX23UatyPIP/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2oTbkOSx8FRoSUpBZX23UatyPIP/
  toolchain: gcc-12 and gcc-8
  config: lkftconfig
  arch: arm

--
Linaro LKFT
https://lkft.linaro.org
