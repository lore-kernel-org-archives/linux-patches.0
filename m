Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011CA38DC0
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 16:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721926143; cv=none; b=gpeTLuguludf626mK3otKpN1hKboPkUEEyRrqcm1rtNi10ToGaCjAvylOPWTl93e0ia0+zuMpO0SQIl/xxX7FH4QkrW5MPqAIpBEmaAxm6wjUyWb3MesssYDe9rc1pn9jGQwGsnWkKPfN+cS3V5gbH9Sq+ibpDb0ur/Z3vVCu8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721926143; c=relaxed/simple;
	bh=zl9tyaX3atF1FD6Oj4CMVfjVeFukwL1OauJx8MZgj8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SL19WBiDjOlenWFhFl7Bl99wJHlxlOpsqHsmDU8EYY9AYyEYKfZxtWIw+BfadpAZAIl6XFqq2I69ZXUZY/D2Ufq9BqWsbzYJsRwmtkfu7rBVAldJ6T8tn92DqJONcZo7DJCvIg5WCfPjAXxSMlTvLtpixu98pHYQRBSz8unZ660=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Kusow6fH; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Kusow6fH"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4f2c8e99c0fso361554e0c.1
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 09:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721926141; x=1722530941; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jKCeuZLzTZnQ+M0GtznLWK7b6OnFbkvquUnPvitUBac=;
        b=Kusow6fH/AwUNezIE+zC1lcwd4Q2JFrUS28LDRKmpQgQxoXVE6Ub1iVKPpfYvEsF47
         O8IJaGMvTVUPtBuOTQpEVIxsQbpJRBBjojHt3P+T26jKPMlp6wGpgPedXsX1wMDsL3J2
         y+OaWMraf2/BmUPM3sWlyv/XN+aXF8raDhaqgsSXR9Bp/0EYrQKd9Xnarz1Co7huaPHp
         wNF1cXsUY0MfvfS11sT9E8iU6Sy8U9gkF++2wjnuNik9ZzbbDRitrqKbfNljSK4fmEi/
         EVY1ZE6nf5AU2doSNLdo4W53IybPfqbm8utGyCLBNALcX6JvAMA8Un6SPEtoYCFXeSfg
         FVzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721926141; x=1722530941;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jKCeuZLzTZnQ+M0GtznLWK7b6OnFbkvquUnPvitUBac=;
        b=XCzF5OSXtaIC0N0guW9gF2TBTHgIXnruf+/PpcPBv+p8qHiVcdb2hC7BJGQEXvnZt9
         6la7ILz42ogaNIpBi7mrP3iUVtvbkQ9xLjTKL0DnWFYZv47qwTfoazAtpuIeZwozyX2Q
         esBJnqqa2rWpdkTNeJAi/kn/lS0wzou1LKlt5ZcvrNLSAewhOQHejPlYiI2qOanIa80a
         ZnvJzipCNHYnQBBlt34fHMPhRPa7MSGW9rjE1mV/nToRzIhuvZZAZpAaUE4ad7PYPfiF
         8xcEZlKMSiWR9W9b+IRMXrP3kyL4rAIP2gapESn1gXWh4CnwfIYSX59oUV5koaGnKc7z
         CyPg==
X-Forwarded-Encrypted: i=1; AJvYcCXQnilIQfImrMxDN83wByDjz5RarSDe4x+bRRTj4rFd+ZsPwLBCzW6NNNEjxjMcq1lZ818cLbBuP4fIx4IZP0ToQm8k2qVIwg==
X-Gm-Message-State: AOJu0YxDF8ek2C7J6XMB9U+c5pZyS9QYHzkBYjRhvN1w7IYAu0t+dt7f
	vgfdP2JUZVJr/YQx/l2MG8+4Q4VHaXlUTKBiDQah4cxwjllCmJpaEWByA7cxgq6kkPMh47XFVgw
	Fkckj4TGZo82MXkHfwCfaHnmpcA/MhHhV9V7jBA==
X-Google-Smtp-Source: AGHT+IH+sca/eScSSpr1hspS4ecSOGX3fro/SHs8Yt+aVmqnAYTWGrfofCR+92nWoCEokUgsHg1b91tdBPwJtE+Jp5c=
X-Received: by 2002:a05:6122:1d4a:b0:4f3:828:7a47 with SMTP id
 71dfb90a1353d-4f6ca2da2fbmr3128684e0c.6.1721926140905; Thu, 25 Jul 2024
 09:49:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240725142738.422724252@linuxfoundation.org>
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 25 Jul 2024 22:18:49 +0530
Message-ID: <CA+G9fYvCyg1hXaci_j-RB4YgATb458ZqRjJSye4qub9zYrmL_A@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/87] 5.15.164-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Anders Roxell <anders.roxell@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 25 Jul 2024 at 20:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.164 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.164-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following build errors noticed while building arm configs with toolchains
gcc-12 and clang-18 on stable-rc linux-5.15.y

First seen on today builds 25-July-2024.

  GOOD: b84034c8f228 ("Linux 5.15.163-rc2")
  BAD:  1d0703aa8114 ("Linux 5.15.164-rc1")

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
-------
from drivers/net/wireless/ralink/rt2x00/rt2800lib.c:25:
drivers/net/wireless/ralink/rt2x00/rt2800lib.c: In function
'rt2800_txpower_to_dev':
include/linux/build_bug.h:78:41: error: static assertion failed:
"clamp() low limit (char)(-7) greater than high limit (char)(15)"
   78 | #define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
      |                                         ^~~~~~~~~~~~~~
include/linux/build_bug.h:77:34: note: in expansion of macro '__static_assert'
   77 | #define static_assert(expr, ...) __static_assert(expr,
##__VA_ARGS__, #expr)
      |                                  ^~~~~~~~~~~~~~~
include/linux/minmax.h:66:17: note: in expansion of macro 'static_assert'
   66 |
static_assert(__builtin_choose_expr(__is_constexpr((lo) > (hi)),
 \
      |                 ^~~~~~~~~~~~~
include/linux/minmax.h:76:17: note: in expansion of macro '__clamp_once'
   76 |                 __clamp_once(val, lo, hi, __UNIQUE_ID(__val),
         \
      |                 ^~~~~~~~~~~~
include/linux/minmax.h:180:36: note: in expansion of macro '__careful_clamp'
  180 | #define clamp_t(type, val, lo, hi)
__careful_clamp((type)(val), (type)(lo), (type)(hi))
      |                                    ^~~~~~~~~~~~~~~
drivers/net/wireless/ralink/rt2x00/rt2800lib.c:3993:24: note: in
expansion of macro 'clamp_t'
 3993 |                 return clamp_t(char, txpower, MIN_A_TXPOWER,
MAX_A_TXPOWER);
      |                        ^~~~~~~


metadata:
----
  config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2jkA3TgHM4HJPklKlKvochTS6Sk/config
  download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2jkA3TgHM4HJPklKlKvochTS6Sk/
  git_describe: v5.15.163-88-g1d0703aa8114
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_sha: 1d0703aa8114ca7fa386273d01ed8a7e1b66d335
  git_short_log: 1d0703aa8114 ("Linux 5.15.164-rc1")

--
Linaro LKFT
https://lkft.linaro.org
