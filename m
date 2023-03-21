Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C8AD306
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 17:55:23 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id u5so16852357plq.7
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 10:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled; t=1679421322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O2f7rgn2h3aX/OgonL+LZ4pVeZntbx1pC+H3yOOxuPo=;
        b=POoPbVQzBxPUZ9UVHQFclfZPqdYhET4djBJsztO6uaI2Xh59alX2Y6nwES4W+JkJB4
         7nQ48aAarEIbKFczycMLb/dMh+p1c2KwRNUMNhTcCQ8hMO8gXPv6iPaRq7f8+31+ZPdV
         iGpsXdJ8M7bwAqddpnJNHPtPfG9cLUqrcxk6r3RyD2DWV58X5HpA0nBurpDxSGR51HQ8
         UuO/OarnuvLM+MglRW9T0uQznVVXi0Uyb7olJa69yKDPsWYO5JTHKC7XIFeE5kvkw4BO
         1iB2NgswFTkUC5TQUw1/HGNW4D0BAc6LcyFeeb5gTiGZJ4pfNpxNqdeDsO+jSY24m52q
         jamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679421322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O2f7rgn2h3aX/OgonL+LZ4pVeZntbx1pC+H3yOOxuPo=;
        b=xDGJEDxOYZS/WahgSWcbbgVzKu1ULwI8QxOCfIuag5y6nl9BOKt0/T6vV9zLslpaiM
         dGImPeNxOCiM4R6r2DsTKzs7Mq/7fmqjYf4axnSQylYkkcGZcRKq9Xfn1861jNeDT7qC
         a3dJTaSoJvYX8ZP2XOx+UrpjO5kbaAjXJDgsH7CL5Q3FGo35G1dOiMDLWqDPSjJE+PN6
         OvvuiuNnA2QUbKBihmPZhwKQeXVdJwc9drvL4xThoUw6No4mmt+hAqqpQmM7f7Avg1KW
         nOlI6JDEASoz7FZB7koiI8Kee4/jvhLXEXXTu9JdByA+nu/XcXiMB7/VFKwjMvBl3gcI
         TV0w==
X-Gm-Message-State: AO0yUKUimHTu/DLwUFp2d4aCAOvgEdHQEBH7gmjSwppQsdLeUSFSHITg
	4DivNrcaou2Gx6n77+V1tJOgozEeCP8n7T8UM4t8/jFMZr7Rt3QZVbyKnhZBl3SGezng6r8DL1n
	pS3sd2AhXnA+poQB6F7rAslDBixgG
X-Google-Smtp-Source: AK7set/L+0d/V5U9z7rXu+z18lp6xAoVqf1aZZt5Bgnm0x6j85D095LBMwxBvdARwmaE0pXegdHoYmXQkVGkYgWkLoI=
X-Received: by 2002:a17:902:e892:b0:1a0:7630:8ef9 with SMTP id
 w18-20020a170902e89200b001a076308ef9mr1383862plg.12.1679421320553; Tue, 21
 Mar 2023 10:55:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230321080705.245176209@linuxfoundation.org>
In-Reply-To: <20230321080705.245176209@linuxfoundation.org>
From: Slade Watkins <srw@sladewatkins.net>
Date: Tue, 21 Mar 2023 13:55:09 -0400
Message-ID: <CA+pv=HOMuAfbHwkp4BYMeoJk4sL=bSoF=rGcYeXnLHZm2HsbzA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-SWM-Antispam: Scanned by pmxgwmtau.interior-mail.sladewatkinsmedia.com
X-SWM-TLS-Policy-Status: enforced
X-Gm-Spam: 0
X-Gm-Phishy: 0

On Tue, Mar 21, 2023 at 4:39=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 08:06:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.21-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.

Compiles and boots on my x86_64 test systems. No errors or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

-- Slade
