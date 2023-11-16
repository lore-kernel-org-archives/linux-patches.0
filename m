Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC398364DC
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 16:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZPkPhEEw"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-5bdc185c449so789515a12.0
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 08:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700153215; x=1700758015; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OolimXFjci2sq0iqnv6FTsXghgRy0JeCTvt6M1ohGfU=;
        b=ZPkPhEEwIM+L7xcSE5blJJSA9YCmoBXqRF+Sj1JGcX1CCOrZpFCLbvkuNslFP2JwlQ
         5JB5ehu/rAQuzuiIqgijC88sM7Z5XjbdCNk9vL+5AS5k4n4Z5rw/SYBfmXE9GSoPPs0t
         sTa4c+hLZ5UXh5UhK1eaDaGRRryiira9NO2WoTzLHj0cGpZV9pPnJmv+wWTwV4VjXvre
         rruwcoQvmkVN37UmxpAUUIT0UwmRVZtsU+G2ObOiSfG9FphRPnXF15WItHTo9bVQsxIU
         +jRhEG1O8Z5DjT6AG2bQ9EfU3n3VfJq2fl0c74Us1mZC+UhnfGjPiH/M/apY3rE/yquy
         iUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700153215; x=1700758015;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OolimXFjci2sq0iqnv6FTsXghgRy0JeCTvt6M1ohGfU=;
        b=YTk/YDupYUUArVY1eOvSnxU8IK5AOPONJmTUk1cJ67tSuIhdmLDrTe3uf1PkWUa+X8
         QOL+Jy3xclWT3cji6sCU4sFI5jUewdL5+ByNPb3btQo1gPh4HMpUm8BXUmMPoTgnnnoA
         9Wec4WBKn5SZ29CPC0wGyhIsNtkRjerawwDa9KoebTOMvCCQqBLe87HiwKAfKa+vguvA
         rnnelDGNAEWSP31XHjYuhI7p7HtFJ7FWY5pVuFXlnXiEQA2pcTBV9Bz/+qz+DvcXjrDc
         7PqHsrTPCQROBxwVPYVm0xoMS/8UflcYdnjKiIpPgy/juKgVEa16ClEbgyYMUivqUTKh
         co4A==
X-Gm-Message-State: AOJu0YxCkTI18F8Mybqn2L0qGgr29ndK9p2F62l3FuddhmqXMWucSq9/
	euhAPe7ZE81Iq6rwLNDGAQMLGl3zpXKQ1xole/o=
X-Google-Smtp-Source: AGHT+IF5/SEQWJEREMGPHUCZ1LmNZM1iuxnvDxRQDsGxq6HYPAtPUUhqGTz0d14cg9BfIQnvICXiZip82B4crhq7aEs=
X-Received: by 2002:a17:90a:6f84:b0:280:1a19:6dd5 with SMTP id
 e4-20020a17090a6f8400b002801a196dd5mr13185462pjk.36.1700153214846; Thu, 16
 Nov 2023 08:46:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115191613.097702445@linuxfoundation.org>
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Thu, 16 Nov 2023 11:46:43 -0500
Message-ID: <CAJq+SaD5K8eH-vrhTDM47P8pnb_GjxiPN4cTp6dKji_cO6okqQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/603] 6.6.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.2 release.
> There are 603 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
