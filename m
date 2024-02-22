Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7402D46548
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 11:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708602590; cv=none; b=trsFpRD8dGfnzlbRSuH7MQH+J1OxWaXwkPgkZXWbyPPDaQ7qKKcbj01GjHO3dvKwVsDrhaNpfji7iqB+AH6klBDjSFOdHuI9OPu4BRUXq1lQpipeNhBDKj+JwMzuYYchar6H4978oPrh/bV7FxMqTs8/Qru8EgeDKUXBaFw8NYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708602590; c=relaxed/simple;
	bh=rwjqj3F5DEjDpzt7Wk5cef+rvi+l02SyQ3twXyL6rZs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aeDClUW5gPh08b+4pbp0vy8HBN9iA/+6w67/CyWNzLg5FnyCBbSk1DPoIWP4ZY0oezPzvAbo4e9QdLTVWF2gcAOqDZ2tPUMuTrD8ECg0NlDmkBuBLWXqT1yUYKJIwkytISoTdObRFxg2a5C8PY0nwySviaJOO5ShnmN9PXgAtTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mjuEszbm; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mjuEszbm"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-7ce55932330so3123445241.0
        for <patches@lists.linux.dev>; Thu, 22 Feb 2024 03:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708602573; x=1709207373; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DXZywZ9bYzEPOeiOcQKWFDupoTVmbm/QeWT4cQk2MjY=;
        b=mjuEszbm/nPsZhmglAJXBJYwnj41mmzVRwy5gY7om2Rz4EABZ0dlnQY6DlFcsjFQMX
         gkwFzlBIxVOUf8Jb7Y+sagHW9lY0IVCS3GSA68EOWf7Gdo859dNiWHYvH6acsnogqlWt
         0V1K7rzNQ/HTby3jyBwRinrlUoKHo8brEoFYjHOjl9q7BZsvrxgRNSw+2lhT+oXsxK29
         6dLQ6AnQsmEOoj85/zo9OgmZX95bD5Xpgo+tWtWZaSCLGUthgUuEAzflBIF8tcHCqLbK
         G8cWIyQqKji6AFufaVdk8E36cmSl2M/+gl4a7BnJFWtG4aM5GWJ9JW14dpwlU0b6hqNm
         5JRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708602573; x=1709207373;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DXZywZ9bYzEPOeiOcQKWFDupoTVmbm/QeWT4cQk2MjY=;
        b=mTwKRprTqKXiJvpCiizq6CAl6pzh0iKq0AZPnCg9VXlVbD827xMR2E+m/Yq+F4mF6L
         5yXC8y0/lrNWjs1dqLoy1jBd7uSgw3zJ0+nnlEvw5MwH30RJm1feIg2/9JeocfjB1+pI
         lEN9kHAwD64sXscKVbH+Z+b5u56BW1YWXwYcv+HyRMCbFcviQoXy+MVQoYHGp7yVXVLl
         wkXCoUHgd3Yy80ml6/3/OmrbyoIvFSRO+1VGod9Mze1ltlrTzqF+/95xve8UgYJkxFcS
         CJVaEcF7kxqlIWTm2jQLwrwN6JzGBTHz7lFGTTDppfE7+yxY43ucvDxybe3rvIPMEmUj
         SD6w==
X-Forwarded-Encrypted: i=1; AJvYcCUEGGF7hyaINkUVFEqyV8iD01bi6z0Cg14Rd90xHH+HJqFrPbVI4mNiWSwr004Nz+tXT2XE+yOhb1dNeyyXqgReNg1kgFXn+g==
X-Gm-Message-State: AOJu0YykB/o04isAjmXFOHQs0JtACmagDsIJ9ICySvjXNwLZiCEQSjCc
	YeOeZbsneVIszTW5BHC6yyjWRQjdUgJ+aFSUdEE/ydmhosbAmzxzVhPtgiEnUPwhu58FVtoWH3x
	XtBumPHxbOKHE0kRz+ND5mgYKOI77/fi+Um/8vQ==
X-Google-Smtp-Source: AGHT+IGta4b8AQTI82Vy3bZ+I0eDJVomcLJAjLz5u0WRGMb36VgNJK8SiwxwZrfdsHu4htq+oh8pRtOm5apzgwmgUh4=
X-Received: by 2002:a05:6102:2334:b0:46d:3208:aec9 with SMTP id
 b20-20020a056102233400b0046d3208aec9mr14251737vsa.8.1708602572983; Thu, 22
 Feb 2024 03:49:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221130007.738356493@linuxfoundation.org>
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 22 Feb 2024 17:19:21 +0530
Message-ID: <CA+G9fYtNZrQYiZaR2CChtA868kwnrz4byqnvt7g-0hW_LXyWfQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/476] 5.15.149-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	Beyond <Wang.Beyond@amd.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Alex Deucher <alexander.deucher@amd.com>, Sasha Levin <sashal@kernel.org>, 
	Felix Kuehling <felix.kuehling@amd.com>, 
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Feb 2024 at 18:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.149 release.
> There are 476 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.149-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

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
