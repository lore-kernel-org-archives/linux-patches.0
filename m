Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B937C21340
	for <patches@lists.linux.dev>; Sat, 15 Jun 2024 10:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718447599; cv=none; b=s3S59sfKYwnrqzQ5gzFISm4E9HrwpfuT7XlIwYqprLaE8o5WK0+xrGY+c2QTY+9ZXZgeiNlfKnZwqHcSo9S0rTG0ObpfQG598iB3LgmBSJrxA2Xn8r0vP2Zkk5FqYYAeXJiH3SohJ0n+EfOoxZfwg5qJANg638N1RlxVrC0Ebv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718447599; c=relaxed/simple;
	bh=EU1gnY2BkWspVSzX6qx6GxRxGvIBOpUKnTm4qkB7WvQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HhmYPdzQJGBJNsl9eQaSav+h3nZr+Gff+6OU1YyU/hjmI99uK0sIipskZRR94EoW/Pjq45VyDVNeTeI1IHHni8uu8VN+r0UkQBtsvfo3k0Ziq7zlCg9mUAxx3rEZBmFIRzEoiyB8WzaBpmrmAKUUXjb2dRZYXBzUhlKlpkRrwsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OoRqrYVi; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OoRqrYVi"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4ecf2fff1cdso781613e0c.1
        for <patches@lists.linux.dev>; Sat, 15 Jun 2024 03:33:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718447595; x=1719052395; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kNhxJ8lsLsKUcd80cpqGpDxPPP4z5jSyvizVwaYRNvI=;
        b=OoRqrYVihwaLrtUxHM5TuTVk5GIShnJKDAhe4rZk7v50ngYsa+HshhkSfcFR5GDqgX
         pATCAvBahEJy5iXAxa74klJ0B2lI7vro9s+W2fqcIOTSUBEiLB1kqeY/ctRd3lgayxMG
         5r9Xxa2ev9v41ba4Ed7xTgaB9IrII0BGoSi0kYCijHspjkleFIOFHBSF0FTQ/5oUmt4l
         pIATh31iFQMC0z1oi7FpmZwvodx0x25r/xKfI5qB0lnEJZXM5Trzy1o52mvI7hx4OJU3
         D6KCEGBaf6XK95/Jg886d08MWeiWenZtloj/xuuEaI3FcKnLMWm79CECdA/4/EmKX/AM
         Jsxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718447595; x=1719052395;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kNhxJ8lsLsKUcd80cpqGpDxPPP4z5jSyvizVwaYRNvI=;
        b=dHMFmboMCDa8ni6yvLLXDoQsuz2zTIdoVumlAyKqJljOwbJiWEhg04DBLzNK8cY3Id
         1utOWvw6ds9CaHq1k4mpio6vqg5s+VSD6teQSqOuOYfV1vqJYi77vWB2JVaeelndRdtw
         +M/G/4iQFdRt6+93bpyhaXNz9MdG0dJ9e3nxB3PAwxaI75caR87k9Gb3b7xMc3gXarWT
         J8C314aVSyW1YYgqV6iNWLLSQyhNY8PeD+IJNukHkNPcViqBU0oGPJ6CmlHe04eHcYoX
         zkZX0JJLc9g1Oi+bHseMUBbTou0UWS/CH4rtbWb4rtJTQX9yWdzgb8GfZi/QbvIxOV7D
         vGEA==
X-Forwarded-Encrypted: i=1; AJvYcCVWdCLNECBNWMq70EEdCk+g2A254yd5K45zbbTQq6M86KmziQZQFtEdr18l9KpqnNr9d3jYBgPQWjq5lHPuB269+hkzX1fVZA==
X-Gm-Message-State: AOJu0YzEoZ9hEUZLe38o7Sny5ZWs1mlcZAjanmljDngiqso6CRL72dtu
	ayAtAqjhb+gHxAZ9IDt5UYcWwRM8yfQHk/BeXSCnQBdkxOcdzh5lXSe8FapMguhIWpBAwbXgugR
	hI7oCNbaTNySvCCwPilpZmHKjZqMm3anR69ZYmw==
X-Google-Smtp-Source: AGHT+IFoy+c7kUP3aO8IVTdrE+OfR+1MWmkP5LS3gnb3gO/yPNE0qycgoNhwrdcWokJHmP5uM9TdHffodXQX0LyhX7A=
X-Received: by 2002:a05:6122:218c:b0:4ed:682:7496 with SMTP id
 71dfb90a1353d-4ee3f7548f0mr5464427e0c.12.1718447595513; Sat, 15 Jun 2024
 03:33:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240613113227.969123070@linuxfoundation.org>
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 15 Jun 2024 16:03:04 +0530
Message-ID: <CA+G9fYtN0R0=i_oP5ZfUxmBuqatTOY9XDfKCw9wjsQVo=YRAaw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/213] 4.19.316-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Jun 2024 at 17:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.316 release.
> There are 213 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.316-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As other reported,

The arm omap2plus_defconfig builds failed on stable-rc 4.19 due to following
warnings and errors.

* arm, build
  - clang-18-omap2plus_defconfig
  - gcc-12-omap2plus_defconfig
  - gcc-8-omap2plus_defconfig

Build log:
---------
drivers/hsi/controllers/omap_ssi_core.c:653:10: error: 'struct
platform_driver' has no member named 'remove_new'; did you mean
'remove'?
  653 |         .remove_new = ssi_remove,
      |          ^~~~~~~~~~
      |          remove
drivers/hsi/controllers/omap_ssi_core.c:653:23: error: initialization
of 'int (*)(struct platform_device *)' from incompatible pointer type
'void (*)(struct platform_device *)'
[-Werror=incompatible-pointer-types]
  653 |         .remove_new = ssi_remove,
      |                       ^~~~~~~~~~

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Liks:
--
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.315-214-gafbf71016269/testrun/24321970/suite/build/test/gcc-12-omap2plus_defconfig/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19.315-214-gafbf71016269/testrun/24321970/suite/build/test/gcc-12-omap2plus_defconfig/details/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2hp7W1xcas5CN3psaeGX1n8sAj8/

--
Linaro LKFT
https://lkft.linaro.org
