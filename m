Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A372D22069
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 19:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KWDCtBmW"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-45db0df090eso626844137.3
        for <patches@lists.linux.dev>; Fri, 24 Nov 2023 11:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700854795; x=1701459595; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IFaoM2nPbmC77v3546G+DOzaGeOySECW/jienI0R7po=;
        b=KWDCtBmWD0azwo6mY4wkTeVdEgs/naGTinQP9P08Wmzy8DqwLz6x2r992bsY50pU1j
         a23vaeALmflCOVWT7b2leLkJhyMbWxVW0I8is11Jq0AV+y9H2Ad+anY8bd0OE5sO9K7S
         L9A9g2eXld0YLP/WV45nY8CFLmwu8XZeZGksnDM6aFSGhiG4Gf/PbuVjrlyyFYC40txk
         yEgqqTzqwZ+em/xmpbcI2aik7YECAmoAuhrybM2vig/2bCjmNH2ez38ZlSJ2JFCMTtpx
         m3a/lSCxXGFCSyglCYQe377gzMYmw30AeNo6jbKQgwsEcD2TR7wkunJetcht7loFs+Bi
         HR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700854795; x=1701459595;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IFaoM2nPbmC77v3546G+DOzaGeOySECW/jienI0R7po=;
        b=h8/TJEqLhEfq7GQDyfMTevvxTFCBPj9jJa++sObcUwLWT0l0ZITTQEvUcp72VKkYVD
         PYZYIg6mExMJ5xAs5148RVs4j0pEjXuhkRbt7m3V1XXQBE1HUcAjFumT0o9TaHS+STi4
         Oz59LNXLB+vgb7577eifQ7NqRxfu/2RrTlaNS9z255O/MgQuyQLcqXzx+A4+givKpGbs
         eQkUxdg3/2G81En/ax0GC5z3m5l0ibJ6sG72CIGsYbw2xkoYAEP9M1NrgspAtcL/JVGI
         j1v3La+iRIdzoaczdrmB3DhWKf02Y0wxtgs012BuRnXIK1LGnsYR9hFFMm47qXmfZyBs
         U5uQ==
X-Gm-Message-State: AOJu0YygjgmZAaGGOPbJdzJl0PMuDRbYGza/B4ApBpembcdSQlZlzdnN
	y5FExr+LXNP2YFaGpASvq0HxX1pfGznpVJlXD9N4Ew==
X-Google-Smtp-Source: AGHT+IGE2G3fpION1Xr2Bdv7ckqaMoBQrZm3R4iwiuD1S/Gq234WQt/q1WgcB8s0vAQggepOJ+sFLXYnm7wW+HS0NTg=
X-Received: by 2002:a67:af01:0:b0:462:ac9d:fffb with SMTP id
 v1-20020a67af01000000b00462ac9dfffbmr4041899vsl.13.1700854795287; Fri, 24 Nov
 2023 11:39:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231124171941.909624388@linuxfoundation.org>
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 25 Nov 2023 01:09:43 +0530
Message-ID: <CA+G9fYuVgqVc57YAwfA8MK6_Q86wD=RznCYKHDf_tD3foM9Y5w@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/159] 5.4.262-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	=?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>, dima@arista.com, 
	linux-amlogic@lists.infradead.org, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, Kevin Hilman <khilman@baylibre.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 25 Nov 2023 at 00:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.262 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.262-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


As Daniel replied on 4.19 build failures,
Following build warning / errors occurred on arm and arm64 on the
stable-rc linux.5.4.y and linux-4.19.y.

tty/serial: Migrate meson_uart to use has_sysrq
[ Upstream commit dca3ac8d3bc9436eb5fd35b80cdcad762fbfa518 ]

drivers/tty/serial/meson_uart.c: In function 'meson_uart_probe':
drivers/tty/serial/meson_uart.c:728:13: error: 'struct uart_port' has
no member named 'has_sysrq'
  728 |         port->has_sysrq = IS_ENABLED(CONFIG_SERIAL_MESON_CONSOLE);
      |             ^~

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
