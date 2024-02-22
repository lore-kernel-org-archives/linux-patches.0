Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA27381B8
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 11:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708602803; cv=none; b=fWIUb6/aGRctWUWRw1SumQj7efWRXjtmRaoYThgoRFrbMMn9vxm/a9l7z6QtlDxMHN0gkFC5BqIx/J3MMZI9FyIYP6qEcb8laTvbEKE4xX38FBkcCcQYIz7Zc6BvPbI9Kv/SRa1ri+Apl2NN+riQWXOHXAGpOg/JNc+G6sfjKho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708602803; c=relaxed/simple;
	bh=DqtCVXd3K6o8XwOjhMFp+W2TlXwJY9ec3AL5OMYc8p8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F1fCbL3t3ooEHDBcgiHS0iUxhXKAjoolQFm9GNmccuG/wvtUUJlxfyLdx5rnyvpscYUXhe9wRw8dUbHsK6Dt6o/Kidt2kmwt31A3oPibL2xp/owyRPi7PRaKZuZ28Efm+vbz21lb+bnu3JGJ2yA/RRR6a1sIB5ReJg92lzCvTBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wXgK9yGY; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wXgK9yGY"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4c01076b9faso910619e0c.2
        for <patches@lists.linux.dev>; Thu, 22 Feb 2024 03:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708602799; x=1709207599; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8U6oZWtdBlqxrlpBkHzojkkfHCgCtDDcP83kB8UZ02g=;
        b=wXgK9yGYl1Os9sniLzYO75gcRqPTgLAcM9hLn44M3slBhjf8IUrodO8NwJImvSrkct
         gbf7v6LekaqN+9WVajmuqVRfgw5agzbXJPTWfbPYPONPxgVEkijraUFhXM/3uhcox5pv
         WCjPTXKa5Q0C+nltZkxnUSPPVx+d9iVIgILeb9xaLdrC0pga5H1HOeiqMih9tm2i97Mg
         wmJebPZMtRmQ1HdK7QC0lqseXdjbVNwS4ddtP4IkMF/5VCBbxnG8FF9cJCO+6L1R+6VF
         J7709qqyC8Y4UWqo+sF0Js4doFBFxTUb62t8U7oDaFxXXrWf81RfKor+vaLKRvkRigNL
         mMYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708602799; x=1709207599;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8U6oZWtdBlqxrlpBkHzojkkfHCgCtDDcP83kB8UZ02g=;
        b=mwEiwclcoxsuHXchdfxWpxPO7e1kwKEPn+XDk/eRPfX/iveponGpBcxm6kTKnHCKfz
         tD+rjslxLDIlvKYnZEyl3abpYEmeMB8gfDS2wqycuCGwXnjFdi2cTjLI9mLN6ZIvER0t
         jK0nlygpMm0AwupIICTeCwqGWp+O0CSPezoK91YW4B/3N8i3O0QJuONSCR8JW4bxxatX
         JJR1BPFHHIySg4Y+sk/IEyFp6kDhcvausm1OtHS8f42f3dByfkEzxvzsr1VhqqaeXsBt
         pv9HkT039duBDXkfgEHz/5Ui4PUMqVJdC6HSDB3GLOk12qnsdxkkDZ/Ko9DbVqxvYwuT
         S7uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtk4aqrk2EBy5jErRAWgqEYaHsTju1ggzosTuMCT5/R/SxOwCHmw7JP/a/xzFfq9BN+dqNm1TEZf7JQydrf+JiPTZMfItR0g==
X-Gm-Message-State: AOJu0YxrDVLTPB8q37Jpt/RrAYXGTAh0hrPOFaALljn15vLKax3YIRz9
	1p1VuCrIsw7V1HIn/WNbUWoAXVaNC0V3IeSf8yluIPnQB6tHNEMexcQdY5MEWCM92iuTzGyZBGn
	BklIIvk6f9k3DeGJnKPKCbWXVL6CXTBx/AUJlog==
X-Google-Smtp-Source: AGHT+IGP3nsKeDdSkq6Krv45GcMwiPqqieAaRTPq1e3wSY46XuEvaAAzEwmjT1pNKM+4zywJhjwm6P2I+8S3jTvvYtk=
X-Received: by 2002:a1f:c742:0:b0:4cd:20ea:35aa with SMTP id
 x63-20020a1fc742000000b004cd20ea35aamr9444912vkf.8.1708602799232; Thu, 22 Feb
 2024 03:53:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221125954.917878865@linuxfoundation.org>
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 22 Feb 2024 17:23:07 +0530
Message-ID: <CA+G9fYvyOG+U1z351dafUXuZMoF1rgpGsvTHTFECB==2VZVPpQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/379] 5.10.210-rc1 review
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
	Mario Limonciello <mario.limonciello@amd.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, 21 Feb 2024 at 19:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.210 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.210-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.209-380-gd2880f0e0d6f/testrun/22797354/suite/build/test/gcc-12-allmodconfig/details/

--
Linaro LKFT
https://lkft.linaro.org
