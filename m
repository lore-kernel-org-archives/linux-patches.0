Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2BA1429C
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 18:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SzZ95rjQ"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5b9377e71acso84498a12.0
        for <patches@lists.linux.dev>; Wed, 01 Nov 2023 11:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698864788; x=1699469588; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yW8TpNJSIE1qWH0YiVY3Z38EwIsy1hXM3CPZpRjT/DU=;
        b=SzZ95rjQk/HnO/sdYoF22zHSNt1a1CAEOhhdIw4hiL/4s9BEIUXerBTvkl9YlddBmW
         elgqTmi0O0Js/GD+oFUFdXKf4II2hOMwDplxk3TfTUgP96qozOoF5k9htlR0dB0hbg7C
         /5bW3213L141790plqY3wYbVMIXcXbjp6r8h8wQWrFn+YKc9O8SzQ3YVb8Q0Reihg6cN
         EOgR/v4hP8B+Ga7OZUB2eTMwaDWTNwYOVFJgDiLb/D1YnWq5gn56o3IU2BkNn5wmGGzR
         GUJixhzA6avndRj/Ua1QDCpZ/FZcqAUyqmjd070VE4kWokCGfM2KTNMrfRZKnuw5j1be
         9lXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698864788; x=1699469588;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yW8TpNJSIE1qWH0YiVY3Z38EwIsy1hXM3CPZpRjT/DU=;
        b=Dn6DiQNmZuitIRWN1cdBC0nx2nLO3i1OXTG9hIcJgKx22N/qcmJnvAO2wiHR8ooXRv
         LZqxd0r+GPvAO9GzLYXIVycT4KoZx/FUl4iHOfL0Gx3cypJKPdreWY/omNVZYALFyy1S
         hGKhxeKHC6a6KkoctLKA9CLMprqhyCHH3PdNDN1zVazUfaDGxf5vFQJ5y98u9+OJH/bz
         tl1b+HXiP4sjuVH/zqJK6wBeaDvOiGaJHr3lS9fIz5T13xM9KaqinUPqAlnWyJb8qWa6
         HYmE+nv8MbP2Dfu/SenIuEWNTufIQ9v0pwqUVQz/+halnBomIbOatLfuw/1DqDke1suE
         Z5+w==
X-Gm-Message-State: AOJu0YzwvUMZ072PBrN3+tSltUbaL3Ukng7KaZn2UlyX0DgAeczjy1sD
	ZcJouUjZSeSntQ6DQw4CFkR3qRt0/NNiv7/TvtU=
X-Google-Smtp-Source: AGHT+IHFXl0fP2VY4xSOBs/SAJIh9S88OfmR+A44VnFN2JhiZYKbQhDSPfkHSgyjGqx3Dpbu8DcYwy3C43465SoUQwQ=
X-Received: by 2002:a17:90a:de84:b0:280:18e8:6d4f with SMTP id
 n4-20020a17090ade8400b0028018e86d4fmr13764565pjv.12.1698864787756; Wed, 01
 Nov 2023 11:53:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231101120147.190909952@linuxfoundation.org>
In-Reply-To: <20231101120147.190909952@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 1 Nov 2023 11:52:56 -0700
Message-ID: <CAJq+SaBmNdJ0jh0G4auPuFBdo-Essv93b0zfjFsR-bdv5m9HYw@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/111] 6.5.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.5.10 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Nov 2023 12:01:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.10-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
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
