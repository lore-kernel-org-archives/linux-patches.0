Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B32D2E8
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 04:03:16 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id s18so6704960pgq.1
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 20:03:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=viIOhCYTnJ1HqrNbM7zDtkeN6+E0N7cvZ2uLR5Llo10=;
        b=qV++WWFj7HtM9LTeMQzCYC6F/jD7okWIcIvdh5dGunXPzSTNaHLO9OCLWul/tVsRJ/
         0nUEFRQPRkRGfYLAi2iczhcnmuToKhqAJ8YOefo5v1xprTQGruAjrEFJsjN18bCenXzI
         qX6xB6J8kIeQ/KrsP56KxYMFQ0JR4dvW/7hRVRb3wNi5qFeW59IVt3jubiTq7KF6pMvN
         eFkXNPMeuuutVImSnEzXZukRiDJ12uV0EOQcJHTQX2kPveEwg+FqEqo1mPNQb10MuwS8
         juWTOL9ka474BclXc7HgN5+KHwp5dQx49LPd1IrHzZuBjOCyzkxSaWlxi4MlF7RKLw3R
         2/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=viIOhCYTnJ1HqrNbM7zDtkeN6+E0N7cvZ2uLR5Llo10=;
        b=MndweMSGTUO/Etn2w3Js5TV7JlSFub4uhK3ia8d4JJ53BkC5WdsVAfSz8OCltmykxA
         Sn/g9lHuI9JDnPT2snOhrGNEfxdNjbDtu35VVjin1AmDvWJxonNvgSE/LutScxH33iiJ
         ByZEPpIZmtk4BGTW8/c43uR3xav78zeculcnJ5XN06qtLv1JUETZrBSCHcz2jBnNqBA+
         MXv+43ZO/FrebOCSqL7KkBAlWnev96JMCp5XN4jahmUywFkV9t+pl83HpRmhW4z7IKMd
         FOBfBOtKcm1Bao18EsaaSRi0YehacCtUUPYx89zsPzLy5/pLSiO7uMTEJXCOu5TrYwJh
         vM1Q==
X-Gm-Message-State: AO0yUKUOAiK5CjJRkhgdQp/z3YXB8aEOAjh+ffDBRc8tFQgwRsSi9qGU
	e5rUuNdwJV1xrESqQt457QnKHgWVizaR5A6vxA1eMw==
X-Google-Smtp-Source: AK7set/w8xcr4dCuaVnpbOhj+JEvdqJCPjC50BRKBFEBFqec1ih9wU0y8DYJ+RDKMrdBKl51cVC9UbOdly7oGibm7Ng=
X-Received: by 2002:a63:3756:0:b0:4fc:d6df:85a0 with SMTP id
 g22-20020a633756000000b004fcd6df85a0mr2289484pgn.1.1677211396278; Thu, 23 Feb
 2023 20:03:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141542.672463796@linuxfoundation.org>
In-Reply-To: <20230223141542.672463796@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Thu, 23 Feb 2023 23:03:04 -0500
Message-ID: <CA+pv=HP-KdcdU4bh-CjAEOGkrmofAj=v6hCf0bva4bUhfAaT0Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 23, 2023 at 9:16 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

After making some scripts executable[1], 5.15.96-rc2 compiled and
booted on my x86_64 test system. No errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

[1] https://lore.kernel.org/stable/b1552656-7af0-42cf-017e-df919b0d0585@linuxfoundation.org/

Thanks,
-- Slade
