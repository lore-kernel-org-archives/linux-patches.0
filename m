Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7064410940
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 17:49:00 +0000 (UTC)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1c09673b006so568765ad.1
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 10:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694022539; x=1694627339; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EiLEqOiUuFsG5pLs9DQeYVreWHkGWHR7/Vi/UE5qiQY=;
        b=jUPpijJdMuzBBJI1x9ctXxGDtoirRKchtDeAY0JvCBenIhRaiZit6cvTh58RT2uLdF
         NbeyqPmPcedF6B02r1VxxHUcWTzjUr+EVTjsGK0ycN8FOGjVnPEohr65WDZIRSrVOg6y
         Vu3lMj4T9ieixmT89SQ7e28YfdiXnKsJ3p1vmbKWuUgQHYSRYcgHAQDDU7LE3PSzDgbg
         ZM2IX7Zeggmz/9wZGHuSngx7TkzO2t4rZJAaWr2jiLyLtvMcOw87i2Nmvqix2qNDjJZy
         i40/7vrSfyhY2fNbslu04eqUPGo1iZw77Z0SrtTijlfCHY8gZLHBCgAAADh7ecPcRlHE
         czbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694022539; x=1694627339;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EiLEqOiUuFsG5pLs9DQeYVreWHkGWHR7/Vi/UE5qiQY=;
        b=B7O2SDEDU53GxBYhxZVnw4qbgmOSPlihrJu0WrOyqxPrY7I1IsUlaUCutKOeVS8gjC
         I3KiULplsBUmdClACFPdVXSPd17gymaMPqnx2/iX53UzRFX5pxrzoSYxEcTy9V+jkQPU
         GcYsogvzby0PPraMorH5a0Jg4hCyM6kMSMQilyAJhni8PuEMj+fWaGScDxAOk8DdFeHk
         QHaLrGECqlkZCk5buyt1fNmBvd4rZh1H/qu83Ydv1zk9yNVGVytUIqy9jPYmfSkfiR26
         fzE5TXVeiSScKKzrcOPDX6EyCZk++CZGuf+62ei0DVGNL9yDph2BWcaXMMfcWpBBQjgs
         jJqQ==
X-Gm-Message-State: AOJu0YwWZWLS/WMkNcSOaLW2me/U1O+liBke9fgUD9R7xL/zP2B7NSlb
	bix4X50vJVLy87C7xOzwkoGL/cRC0XP+8tR6iGhWyisH7UI=
X-Google-Smtp-Source: AGHT+IEmKaf0FLqA6/LpyRqv2kGRO3n0XGn+C8UOUCXtgGAJCZHSs9vWekKIk4GT/fkG5UY5pvPReM7MtqrUUUPzh4E=
X-Received: by 2002:a17:902:ce90:b0:1c0:98fe:3677 with SMTP id
 f16-20020a170902ce9000b001c098fe3677mr16562580plg.56.1694022539570; Wed, 06
 Sep 2023 10:48:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230904182945.178705038@linuxfoundation.org> <a3a98d35-bc3b-2619-c616-c8e74b57ea9b@w6rz.net>
In-Reply-To: <a3a98d35-bc3b-2619-c616-c8e74b57ea9b@w6rz.net>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 6 Sep 2023 10:48:48 -0700
Message-ID: <CAJq+SaA2M=7gg5UikGrHrjb-h=7u0xBcQsJXODrzFvAPU5uY3g@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/28] 5.15.131-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> > This is the start of the stable review cycle for the 5.15.131 release.
> > There are 28 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.131-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
