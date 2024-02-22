Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08A93D97D
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 10:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708599350; cv=none; b=lklrdcWy58wNgGq15xlOAulEqAkQXFeQl7jvya5biesfDcyDQR2Q+oy7XP8ndBgRIZh7F+ITtx9Wx6c4qhCbQEuwbUUpQ5xR/wwmjGcX2dL/ztnLMYjIYvGiVqqLWQj9VzGSoe+URxyqqEC4S1Agzxds7D2Ztn6+0z133d+xcgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708599350; c=relaxed/simple;
	bh=439y0CawLDEh5lyhHpxtilezXhVvm/Hhbvki2S2xLNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JCzvkHDRrWz/EyoV+mD5YNGXfpMcpNKwjwIXohkoj7WwasKqzAHdoBxyo3/o/Ik7C+XWhuGiVurWA+Zw9lijNn1VIAvnWTtFsB99PF2hUutU6L5FCdeUSVjQgBjFD5BEJPDrKeSRsQ3LZBW6UsnihUixXWTTbztu4ofknemf65Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Wgds7ujk; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Wgds7ujk"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-4cb26623d8dso820141e0c.1
        for <patches@lists.linux.dev>; Thu, 22 Feb 2024 02:55:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708599347; x=1709204147; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FM4z7DIQDBcuDFxLdD60iofNC7omQneCJjVmeyaqoak=;
        b=Wgds7ujkzcOOAFr9kdvV0wNFt0VsiOnz3mM/N6ejhIAa2sZuGrRQ0P1ZnkoXRhGTax
         3HtsXnZctILx4Ldx3TG0Ds52rGLxMZTnedEjeayUFnDvt0fc0PxC91K4o2EeJIIiNxH3
         RETINVM3b9cZgaaTdRuZz3SOU8XrIg92KIjnib6zzxkrOvmGGjtIKJ7FD9ywU8rcC5vc
         iHo5BFLotxEgcBx5Nw56Mxjj2oeEJQmL6K0Lx3SLUbZjACLQ0woWWV1NKJbjmPW3YcmP
         kP9lWlSbVg4wvwKvMVkxelx0Q+T6CltwCkhjaDjq2iPIP4Km689ST4oj90ZPbAD90NCX
         SBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708599347; x=1709204147;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FM4z7DIQDBcuDFxLdD60iofNC7omQneCJjVmeyaqoak=;
        b=CUNRQ6ry0yI+6cKB+IbUAy5k877mHxhymVpL24nFb/A0TyB8gN4BTOKJa3OlnUPlSG
         mULsS+NcEx2UIzb37bWR3OT8e7IL4v+OLN0hIpfciNQQOmVtXEsQlX/+6NuFo0vxQgn7
         2xNbzjXF/fKMkc+Pvvwh7dRfjmrHLHcoYZwOB7iWpGx4tW0a2YDXdJDyZuqRdjMKIhz5
         W9ctQ3t7dTo9NCSpb0LrRDVNmwfpUYpNNr7ZG0dAibp2Vdloi7ifs/61X9ur/9K0he8n
         XNeUB+nvN15IuTIW987jVnVEqTH7lUGLaByp68jaS4IOvckCasn13DHu5RB4ujLp1u6H
         aZKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsk+qXrgB7xOB+E/fzsx+pkIZV+u2bFhzu2Bf+QwqxfV1EzdSjwPDkfVOBgNc5kGjTjqbfWfBGYyf6GP8o/S5xoNEc591Fhg==
X-Gm-Message-State: AOJu0YzvxowEXdUAUYUtvmkcTF1WE8a/D+A0oAmWtNdEUEMF999e7PxV
	Z4OdRgbxWNBoeI5/QIlY//zX2ONy3YyV7okw7nNgjvcBo3FJGrLZZgkXtrR/4UDzKi7hRE+9+8x
	ekfb/+Kc1Gty9pjOGcGRKv6n0eZliewK3xl849w==
X-Google-Smtp-Source: AGHT+IEp/h0CWwA7NPsOW74oY68F34eSvRnb+Q+eHPYZkQd2Rfzkx8nC/J+bPgf3qu+051y3j5tLOkn3980LYQ3YEBA=
X-Received: by 2002:a1f:d447:0:b0:4c8:90e5:6792 with SMTP id
 l68-20020a1fd447000000b004c890e56792mr12587102vkg.7.1708599347459; Thu, 22
 Feb 2024 02:55:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221125940.058369148@linuxfoundation.org>
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 22 Feb 2024 16:25:36 +0530
Message-ID: <CA+G9fYua_rKjdmKMgYrRY_HRyMWPdJNz5=O0K4+M9P9wBWLPcw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/267] 5.4.269-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	Beyond <Wang.Beyond@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Alex Deucher <alexander.deucher@amd.com>, Sasha Levin <sashal@kernel.org>, 
	Felix Kuehling <Felix.Kuehling@amd.com>, 
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Feb 2024 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.269 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.269-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The i386 allmodconfig builds failed on stable-rc 5.15, 5.10 and 5.4.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

ERROR: modpost: "__udivdi3" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
make[2]: *** [/builds/linux/scripts/Makefile.modpost:133:
modules-only.symvers] Error 1

Steps to reproduce:
 tuxmake --runtime podman --target-arch i386 --toolchain gcc-12
--kconfig allmodconfig

Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.148-477-gae70058cf980/testrun/22797307/suite/build/test/gcc-12-allmodconfig/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.148-477-gae70058cf980/testrun/22797307/suite/build/test/gcc-12-allmodconfig/details/

--
Linaro LKFT
https://lkft.linaro.org
