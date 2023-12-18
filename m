Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A813F3788A
	for <patches@lists.linux.dev>; Mon, 18 Dec 2023 15:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TSrxbTlk"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-46680f87c48so130318137.2
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 07:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702913065; x=1703517865; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=934EXAPlSskNDkwCLvhH4lxnOhTgFQ/8JULAzlCcBCM=;
        b=TSrxbTlkj5XUlrOCpAYL3tYaGG7GTc9H6t8yDCh3ffcpof7LjhI1XKjfy0xh1Dx5Bd
         gEEKwRGP0jhSBb58BNTZFwFr6HswdkNb51uuVjsO56FazJZgZsIm49yUGLwmeU9VD/Sz
         9EIuILBVIDm0gUwXPfhEl4t9L2/BRax04WPQTxrL8nEQmjM8Df7GkVkHsexlzjjZ265E
         z7RhJF6sLCcYtK7rxOgC51lCPDjRMFtCX71XzVVLYiKScykXpa/bUv1tBg8LIJcP51jf
         c/c5ozTyDrQJnkoTY8QjoWvptStJHu+TRKva7cc9GNrG8YhHVoy1qAN8ozyH6UyObt3u
         NcBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702913065; x=1703517865;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=934EXAPlSskNDkwCLvhH4lxnOhTgFQ/8JULAzlCcBCM=;
        b=J11c10Sb1dT1kM1EhQIaxD5A/xvaYuLKkESGs9ty0BLxGKL0+oAt0ByT2wL0wROedg
         7HeYVrkghXh0UlozZ4XDmt9onFwmYNx+NmDL6GFQqvz/vlWGlgrn0UJRHrCGVCEiR+07
         BWm8XpxFC0cAzGUyVTkGpITwasLuKoJlscqVzsN16QWYHDFW2H0bbAuTydcN2kUL7MoO
         syJMMBMTUKhzndK9ciCAKvMuvfMqyrqBKQA2m3iaMzHwtnQfs0USakShd4bMKXeCss6D
         Cc/en8Se1+DNJdIDUnKeIA91HwEUSqibdj6WMGbHnpKb8xpQijcfok+HwdsK1cIYsvQD
         FYDw==
X-Gm-Message-State: AOJu0YwPP10hp/v4wgk1nqlOyRvfIGBZyGgFIzYHky7Es7wHEcF+wHrV
	Q1xEG54KpYiWSqdgbRY42CcAohM4w8jv5rh11vo7Kw==
X-Google-Smtp-Source: AGHT+IHev2d/CWWc956Aeqrlu90bQQ6d2AnDJV8RqGGjgwWCKecX1tOm530gj19HmtDth76G6ZDQvSyX8iVq97Nkoko=
X-Received: by 2002:a05:6102:508d:b0:466:98c7:9b9d with SMTP id
 bl13-20020a056102508d00b0046698c79b9dmr637242vsb.0.1702913065450; Mon, 18 Dec
 2023 07:24:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231218135046.178317233@linuxfoundation.org>
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 18 Dec 2023 20:54:13 +0530
Message-ID: <CA+G9fYszCtMbbrurrjqpDzSa20ZX5mVdQ+RZv-KdiyLU4o5=0Q@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/62] 5.10.205-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	Maxime Ripard <maxime@cerno.tech>, =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>, 
	Daniel Vetter <daniel.vetter@ffwll.ch>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 18 Dec 2023 at 19:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.205 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.205-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


commit that is causing build failure,
drm/atomic: Pass the full state to CRTC atomic begin and flush
[ Upstream commit f6ebe9f9c9233a6114eb922aba9a0c9ccc2d2e14 ]


Build log:
------------
drivers/gpu/drm/sun4i/sun4i_crtc.c: In function 'sun4i_crtc_atomic_begin':
drivers/gpu/drm/sun4i/sun4i_crtc.c:63:44: error: implicit declaration
of function 'drm_atomic_get_old_crtc_state'
[-Werror=implicit-function-declaration]
   63 |         struct drm_crtc_state *old_state =
drm_atomic_get_old_crtc_state(state,
      |                                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/sun4i/sun4i_crtc.c:63:44: warning: initialization of
'struct drm_crtc_state *' from 'int' makes pointer from integer
without a cast [-Wint-conversion]
cc1: some warnings being treated as errors

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

 Links:
- https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.204-60-g0b1eceef25bc/testrun/21731369/suite/build/test/gcc-12-lkftconfig-kunit/history/

lore links,
 - https://lore.kernel.org/stable/CA+G9fYupBYRYc5eAdHt6TH+xfoCRE31=FpDMS+-QY3b6rKPOQQ@mail.gmail.com/

--
Linaro LKFT
https://lkft.linaro.org
