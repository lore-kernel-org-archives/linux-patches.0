Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92F61DF977
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 19:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736190043; cv=none; b=hqaq2zcn4wTfXC+LC04sFJ6YfqyvrtXTUFEEDQXrQP9jKhHnKJ8JynYKfEmmY9i9IDsUjaReLDG8FiGY+hizrAiXXLqXQX0hBzwJQjawTWg1yUYy/ENKVV4pJx3hWdsq890DsMJ+d5Kl/GYiOSrN7ee//1ooSEe4ge8Jz6BlK2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736190043; c=relaxed/simple;
	bh=B7rVRS91AqCk9yDGpsv3634h2LOcw/WLlfQL1LFLPMs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QOWf9koAVH4LdGu2teJ2KhqXNVXaJnEIihARTecuIQa8FTqU7QpfLeqgwRMya+6KXSr/utVWN/6kodY/MfK1RtL7ntJwL8DXEOiE+P5JsQtaZubx74aI2uCluLXpd0aRknWMOUPWYpaH3r9MPDLzSA4C+UaNEoj27fAbe5rw/eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iWBJXOAq; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iWBJXOAq"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-4afe99e5229so4149784137.3
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 11:00:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736190039; x=1736794839; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/SamHPw263yrqg1TIgcL3Fr0uDVcwI04kQhRloNiwTU=;
        b=iWBJXOAqFh8ZRZmIc2t1a3yBbOXGlLpenexyi/AN8EMs1pSoVr+Cnn36gBl/Id3kxI
         9voixMfD+9Czycc7a0lleGdbDS1OFao++kDRZ466fLhgRZU+4nv6Wc2gYhJmuNJsvACu
         tHQk0PmdhyJBcGfvVY8UzmQuLvtmm3jA/KOk5F242muQPhXP+qV4MaNsD12HtUHo+DQL
         QTLGP+ayIbDMZKIlxOS6xHvXSUUP7OH4HYI/Izzj2hAj+MQyDBkd2XI+FNpTqmmeMr/T
         ImlpYJ0rC3lATOE6qY3xSdUdoVXbAR5VwwqTli90HALQyf3MCxCh586iA2RwLvy2fFZi
         Su2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736190039; x=1736794839;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/SamHPw263yrqg1TIgcL3Fr0uDVcwI04kQhRloNiwTU=;
        b=IGZyBX1gf7BtqnQ+1yh3A7itRrDlzCMcEyZwVmooV2f48BUj7haM068iXi3NiUhuLP
         VoUe2Jw52s08Eak9zgTMklNYLk3RLCpdlztjohDkYxWqCMZ61xh3OZ+9szBQ/uEN41G0
         MWvKsklHj4c4CzpkqPhQBCTnQoTLZv8JOhIEWgjUaS02lhd147AFlt26JF22rh4+JRO6
         SXXOp0bZcw0VrfPatV81+WsYnjB55ixS/RxTqR/zYauW2I7eIs6QSWyhFfl8bUij8aWZ
         4aqGnQcgYZ/EUSnBrW+L5WZQQDstvNdwZ8KlM1sK5GV25+8ju6Qk1JW+raQKJM1M9S0I
         3B/A==
X-Forwarded-Encrypted: i=1; AJvYcCXWxIIfJSAsMnYEowuGMi0gI52GXCuNbubKdK8IbFMg3whnWeKEqa+8AIx+8wJvPFf7XGkAIcmF@lists.linux.dev
X-Gm-Message-State: AOJu0YzwBiaLaoPgb4cwZqvaMkIjzJfjtLcjP/FdMw8rL3iVs/8kdwZY
	LyGrdzfbxXoYolx/2HORRESxxEXSHv5qJY2O6ONbhKKooklHFhN7J5BeaujviLJGp2fD76yo8GK
	44vH6SGYE01iKlkpjNkMCNpzJCBS5yIeuMVcXxQ==
X-Gm-Gg: ASbGnctj4zPcL2JmAqgHY4PUFDy30dNSAEqwwVHfkPzM/YJUSq1b1SwaEEcCkWJxEzy
	CQiqgLs1yN1fg7shIUPLqR5TdwAdxNhQMMKUmOucvvUUekfB328BAvX2092XQGne5o6U=
X-Google-Smtp-Source: AGHT+IEfg6L+vAJ+W155bbYhFlBN7EQr9HoPXCxPpXMxSiDpusoK6g29Za4uGp8RgqzdfD1PvvZDhU7iPn1gVCTFucc=
X-Received: by 2002:a05:6102:3ed4:b0:4af:a98a:bd67 with SMTP id
 ada2fe7eead31-4b2cc313aaamr52272787137.3.1736190038068; Mon, 06 Jan 2025
 11:00:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151150.585603565@linuxfoundation.org>
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 7 Jan 2025 00:30:26 +0530
X-Gm-Features: AbW1kvZgDTF2dX-LsDqh7ToTptDXowuCxSxrU1wO36mVYDFbBVHHVuYoi_0Rmp8
Message-ID: <CA+G9fYuJA5eUxunLVyws_J6YNuZdyVUjTGGgGyPwFMgCHUpsnA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, linux-i2c@vger.kernel.org, andi.shyti@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 6 Jan 2025 at 20:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.70 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.70-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following build errors were noticed while building the
allmodconfig builds on arm64 on the stable-rc linux-6.6.y
branch.

This is first seen on 5652330123c6a64b444f3012d9c9013742a872e7.
GOOD: v6.6.69
BAD: 5652330123c6a64b444f3012d9c9013742a872e7

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build error:
============
drivers/i2c/busses/i2c-xgene-slimpro.c:95: error: "PCC_SIGNATURE"
redefined [-Werror]
   95 | #define PCC_SIGNATURE                   0x50424300
      |
In file included from drivers/i2c/busses/i2c-xgene-slimpro.c:12:
include/acpi/pcc.h:23: note: this is the location of the previous definition
   23 | #define PCC_SIGNATURE                   0x50434300
      |
cc1: all warnings being treated as errors
make[6]: *** [scripts/Makefile.build:243: drivers/i2c/busses/i2c-xgene


Links:
-------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.69-223-g5652330123c6/testrun/26613311/suite/build/test/gcc-13-allmodconfig/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.69-223-g5652330123c6/testrun/26613311/suite/build/test/gcc-13-allmodconfig/details/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.69-223-g5652330123c6/testrun/26613311/suite/build/test/gcc-13-allmodconfig/history/

metadata:
----
  git sha: 5652330123c6a64b444f3012d9c9013742a872e7
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2rGGBoqD6FxSfg6IKJLK43h9cCM/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2rGGBoqD6FxSfg6IKJLK43h9cCM/
  toolchain: clang, gcc-13, gcc-8
  arch: arm64
  config: allmodconfig

--
Linaro LKFT
https://lkft.linaro.org
