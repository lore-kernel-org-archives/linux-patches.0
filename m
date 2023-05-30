Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE53125CC
	for <patches@lists.linux.dev>; Tue, 30 May 2023 17:01:46 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-25690e009c8so1374114a91.0
        for <patches@lists.linux.dev>; Tue, 30 May 2023 10:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685466106; x=1688058106;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Skkv5yRuNOgDdy/LQmjb9R5cgeDnPANnKwqfWUb6vFw=;
        b=IWRT7UiG45FdKVpcwaCBTs/EE9DkWxFI1d3HZuU30E0O9+UtZF37JI6tUlSJfxcx+i
         srJhaOOxGSNo3ASCgH8ZOewrMBMiki6zHRg3hquezGOGkdrY9TYtmXEhVchMp2FKnskg
         GIRPZRzdUJ46qC/nUtF9d4dcsnP1xsxefjVbKfUDjLo8fZVVu6Kp/qKZr96zbCDOsR+Q
         oOiGKbnhU66vVWkpe5OdetKht2VA7Vf7laA+bjXu6gmF6wHRsocjymfFovyeYoLSiNFs
         wCrV2Nvq5AxPgeE5v46Wrz7e3atmR+F4KdrOtsXU9vb7n0i9itYafZ8y2B84jB8JsZqj
         Mweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685466106; x=1688058106;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Skkv5yRuNOgDdy/LQmjb9R5cgeDnPANnKwqfWUb6vFw=;
        b=OvAUjMzPMnMAnV0GKMFydNCdCCvgN4XGaKs0ACv/XX4xQycLZasHQseGuRC1pxVSLA
         YX/B2EmqDf0GNXtJaj2AlE96qyl0tiSVLOcVAH/lER3+Xm1ra0oXiSScZI7FWuLfkb3+
         YuLm/DuD0teJspq4PPMEV+4kSfjJL9N0n++7WAC9oP6nyZfX6qUPoN9Ozo1T4EZDJI5C
         SI6m65BASugwM702ZgMbdzinWxesoqEKvRekxsGHLoyNylyEyD4MzOCeJzjUVi+caD5R
         XyEUTbG8tBPva+pPy6IOZiN+eA3A0NRF61XAazczzXBRlgBwXmY3xS+CZyuOb5v40WIB
         Fn7w==
X-Gm-Message-State: AC+VfDyQbbJWZtflebk4dgTKeLHCwf60FxZufaWVD9nK19zJ6tFESZqT
	2FN/6RaHRm6xJ6Z3a4vHe/ceMmZhCg234rEobSg=
X-Google-Smtp-Source: ACHHUZ7IN+ieDWp57f0DN2bS38aflUVrfKQd4EC54pasDNTk2e8cjXweqDiIMoaAgQg1M4RGqk4/bSKwltDH4BitA7A=
X-Received: by 2002:a17:90b:4a09:b0:256:5a84:c837 with SMTP id
 kk9-20020a17090b4a0900b002565a84c837mr3030534pjb.39.1685466105740; Tue, 30
 May 2023 10:01:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230528190843.514829708@linuxfoundation.org>
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 30 May 2023 10:01:34 -0700
Message-ID: <CAJq+SaDYbXd2ocgx8CUFW+y7_AH9BFoz0Tj099cqe9BGYqSrMg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/211] 5.10.181-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.10.181 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.181-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
