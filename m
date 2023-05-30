Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C0D125CC
	for <patches@lists.linux.dev>; Tue, 30 May 2023 17:00:41 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2567b589d3bso1601826a91.0
        for <patches@lists.linux.dev>; Tue, 30 May 2023 10:00:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685466041; x=1688058041;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=x0qR7smAkK4kDLopfJWgEbFX/81Ri845pzZXPCnDXIM=;
        b=TlQB0g+aA3Uzr8Ge+7dBgVQube+GQqQ+9O945+kHFjPAmP1pKvggR6ejjw64IuOnho
         Xt/vuMKzO80foYf1HHi05M/aZdyM6g69fVgvYHHyYyEXPYZknDHr0nOAyVHana2fRLZD
         ffMdVtAs0xmYahUI+rsVO6ZABNzFxqY/KSmrupxV83cJPtFa8l2Pa2pDd1Z6dtEbpSEe
         rKyeoQgo30Vlkudh6c2qaP4GXalR6TR7+eSXoaYr16m6LZPDPKSRFzasZBGX0CZhk+Ru
         +BtGlLBJ2GWQJM1JB6X13jCvk0P9AvcEjyaa+di8IejClb3JZu2qK9rVOtTzH5apNAWe
         fy5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685466041; x=1688058041;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x0qR7smAkK4kDLopfJWgEbFX/81Ri845pzZXPCnDXIM=;
        b=Rl093ddl/hl0JixpW1Id4WelM+tzfTQfrxe/Ju/nrqmEeDQdZNtMIVYStMhdueM/LY
         tQ6KJot95lWDczXJVRkB59fFN1XDJ2QtKWZlwOaATswBy7y27SU9StIPAHw6AWQeopj6
         FNUMQOQ3kLIzSdIoLyOizcQdB5Nh72eXF+reh20SK53ex0AdSc+0tNartvk5EAW+GoPk
         6GI8it00gbtfKkd7/x6lFcFKPsFmxCzSS9XDHIGyk5Y7hRZuTTs8DnCFoKMxfHH+JnQw
         PgEL7+9C1WTfnA6SHPTkEzQWGTw7pAl2rACDNp6l/JdqM2vh1U5qnPwMlpg1xwvUrayH
         3Eyg==
X-Gm-Message-State: AC+VfDy+Kr+CmiR7ibZvakqwoKAbbLsNiuzCWuViI9sKwHRjAYzEkIZ0
	D1rtVnkl327tgdj4FDBrWHe+p1zYFvCNc6JHCw4=
X-Google-Smtp-Source: ACHHUZ429R5dVpOqWe0cVfpWG/0kSCoroolR1a8nyQU1biaJEVIrOT2mzmXEFLwW/GtirmmkddG1uovcBMBYvSa5LfU=
X-Received: by 2002:a17:90b:3715:b0:255:75e5:b456 with SMTP id
 mg21-20020a17090b371500b0025575e5b456mr3346109pjb.1.1685466041252; Tue, 30
 May 2023 10:00:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230528190828.358612414@linuxfoundation.org>
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 30 May 2023 10:00:30 -0700
Message-ID: <CAJq+SaBTqE+sYVGLoOZmv0U9DW=4P8riPwzi2Jwjd=7VsqHviQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/69] 5.15.114-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.114 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.114-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
