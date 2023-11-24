Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832142511F
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 19:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uskigGB+"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-581f78a0206so1147927eaf.2
        for <patches@lists.linux.dev>; Fri, 24 Nov 2023 11:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700853334; x=1701458134; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2MveOECZmWaMqUFClvcSgbtbFksGGBQJiQIt0r94rRA=;
        b=uskigGB+0tWszqppMG5ud+CGAQaFSDYj5EX3oLwNjKlvpuyDcITHCUeHG5tIuOAAZp
         mZYXXkN/3CsHGiiFqbqn814xCUd3W9HfRoa1wYBOyDV09m26iTGtvmXmaes5gUrmqfNH
         pfwEwlXy/8z7sswG7svtzHofMrsiNYu+2o+1BLGa34A9mvuZuw2d9U14OB3RWD1yyrcY
         DhLTvW33i3mVUBCRwgI6juygczcSz9JvMuTwhyLb/OZnfXnYzFguf0xzHcuMK6l2jpig
         1zVvuoOBnMyGY7inlNxS2M6U4QBAEGJPDHRTXaqoOOGU3RfSXeQP25uCjGkj+L5hUihE
         z5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700853334; x=1701458134;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2MveOECZmWaMqUFClvcSgbtbFksGGBQJiQIt0r94rRA=;
        b=R28p3ezyPCPW0CzWIv9igVy0tvT3RoArkewgWUakM9blnlmhLURZ6VV49Kxr06wE7z
         5Z2LIY4K01W3pjs0veuk7v2tk/Tay9HSkB8bWIyLTUBInZJBm8Eu2J2bxIlEAgUv0mv7
         GCn7Xzv5Q/HTS15oVKeLEqGqGlxbHE07uh+lpTST/h2xdBCD4HttIft+6xkHbtnhTEm6
         dZGM4UUt9kr6KiclOilucuTTgmRdxgu7q+EOmYLCiuhcgAXrnNyjyGq0Ufz/8JPdCt1o
         ICeg09/7mimkfUY2f2OnfsEMeil6mDKwE2FYEySo7hR5FS1cj12XcmILbCz4k6LYS7DY
         utkQ==
X-Gm-Message-State: AOJu0YxhllasEFlNLCxz5vEWyK1XO+y8ODnUM4uMDo4W6giLUWhborr9
	1Pf+mNKw8U9h0Z86ukFjkm2kZ84hcX902hQvGqj8kg==
X-Google-Smtp-Source: AGHT+IEnWmBT7sz0OtChNm7SYIKXzLwrJzaYutL5Cr4YoEx+Z9lPQzssPXUErmDHSGOelffPe1qHLBX232hzer90JT4=
X-Received: by 2002:a05:6358:e48b:b0:16d:bc40:3055 with SMTP id
 by11-20020a056358e48b00b0016dbc403055mr4793780rwb.19.1700853334076; Fri, 24
 Nov 2023 11:15:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231124172024.664207345@linuxfoundation.org>
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 25 Nov 2023 00:45:22 +0530
Message-ID: <CA+G9fYt27vXw5po2gtEqi8=hJSR7Ge3+XAS+fAHt4MiHbEXfpQ@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/491] 6.5.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 24 Nov 2023 at 23:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.5.13 release.
> There are 491 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build warnings / errors noticed while building the
arm64 tinyconfig on stable-rc linux-6.1.y, linux-6.5.y and linux-6.6.y.

> Zhen Lei <thunder.leizhen@huawei.com>
>     rcu: Dump memory object info if callback function is invalid

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:

In file included from kernel/rcu/update.c:49:
kernel/rcu/rcu.h: In function 'debug_rcu_head_callback':
kernel/rcu/rcu.h:255:17: error: implicit declaration of function
'kmem_dump_obj'; did you mean 'mem_dump_obj'?
[-Werror=implicit-function-declaration]
  255 |                 kmem_dump_obj(rhp);
      |                 ^~~~~~~~~~~~~
      |                 mem_dump_obj
cc1: some warnings being treated as errors

Links,
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2YdNC69sBYUq3cp4iEDo4eom9RD/

--
Linaro LKFT
https://lkft.linaro.org
