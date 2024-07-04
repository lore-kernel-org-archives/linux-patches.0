Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C3B4962E
	for <patches@lists.linux.dev>; Thu,  4 Jul 2024 18:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720117876; cv=none; b=C/L8PJi5UnGRs6dxPrdM5Lpjqr7UCO9Tt5uB5Szv/B4H1a1q4709kOhBZ5Yk7jxlPY2SvjEQRd+rX1eIl6QuU2Gv7oXS6C8T4cJYRyQSe7H554k7L/gzvuPOju2FXCZHTCy1WhWyYwx/sGunwfXqEn/9cJk6zCoJf2Fx52INVqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720117876; c=relaxed/simple;
	bh=AgQS/DVDrI3+TiOXvEEotS5qwSgKZahU4Qq3oMYHwNE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IJMaT4jlVuLOZwOl3dqPjVLiMsN3KZECxVBFX580TOcngvSuk59WGQEb9wb93s2qzvAFK5Sn/kogWzIA2tBLnJu/F4fh4obTPaBkt4mQZvaCq1pe0+U3QoUTolyz/J7vcFDo5qQwK+YisbR/GaKL5VBlNw9NymPF1Cv+uGkJugY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Yw0T0v+l; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Yw0T0v+l"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-4ef75bc9a61so250064e0c.3
        for <patches@lists.linux.dev>; Thu, 04 Jul 2024 11:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720117873; x=1720722673; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=74ZA+j1I1EFqnPAhMsUNbwVbUxlYztRDmLLqYaBK4kQ=;
        b=Yw0T0v+l7hEyzW08WVFDnB8IBB/T5vYl+b/NuRV35Qp+UniOlmLT5lCe7F/vqeSFwk
         V6cXgXydokIMnn9R8IqJtRFeVKQvcYzhSDOGBVyURb56NznNCn7ko83KFwgHTHGXwUX1
         fqlFsuB1j217EkqzZxswTwVp/VMbA0oau4Wwuv1WlV0Xp+YmCl73leOWk5Rx0aVLfvVF
         puxfVZC58l9q67+CypqgtYWky264T0OFmllsCxhriRev0jv0mP+XvkHaVXPYEc4/srhu
         V89vXGGCcgD51QE0LJsURmvuO0yRAYzFE8BVqmKVnR8ImsqwNwmWwxgzVwOlnq5Hm5nn
         ZbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720117873; x=1720722673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=74ZA+j1I1EFqnPAhMsUNbwVbUxlYztRDmLLqYaBK4kQ=;
        b=hoJmMTBE8lFYonG1Wp8KA4C2zgpyfOmjc7Fax7VfRoatRf5Z18NMTXPfdCajrAX0t8
         jQwCUTKjNSh7lf5iK4J30eKu3ulyK3bpj4xNqHXKMBes1N5o8bvqSyHjwjmtvcTFqOvy
         jIDNoVHCrVgMeG3DZegQgYVYZbc3Kbw+51nSO4T7El2kU6yIMW5BKdXOKcqf05PgV6zg
         J/7nOkKql2lwUyVhPdYle3+alRZfUBIbw0/RSju0R0rjVhaQJIk1ChX7wnjapSWq4pSi
         NXcEye2yz+C88Z5W6Eg5NkM5t9UhtedhTx/Wdo3DBSVho++5yCRABhFqP28GaYUUV2ZO
         86mg==
X-Forwarded-Encrypted: i=1; AJvYcCWUMxzwrOWN6aKHfkNbCYU235aovHPFD9K7+usaEHJdKj6ANSwBC7vgfcn8CbFQE2Gs/QVEJ0xw4kvs0IJzb8MD4MPRmyssdQ==
X-Gm-Message-State: AOJu0Yyzmt58LwkOF8AdX1PNxEMs99OkibgWiiXhF4ClDxaAfbsKwJXM
	v7kMaZzsHTOW4iM1CuVnClNxFlp8cyAefkur7B/xcnVfzppLg6ENzGIMu7hZ0cXvfCgpMK45rj2
	xAjZD0k7ANgJUipk0kpHh2D9jZ+1VRL5AwG0wxA==
X-Google-Smtp-Source: AGHT+IFHH4qjAo1Foyl2FUb4fk5DO3d/le7RX5bROz5xpVRaqmNzLEjPmmLVbIq6bhq14LQtW74/pb3csuS6bawJL44=
X-Received: by 2002:a05:6122:3a1b:b0:4ef:5e40:2cc8 with SMTP id
 71dfb90a1353d-4f2f4022896mr2884333e0c.11.1720117872889; Thu, 04 Jul 2024
 11:31:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240703102830.432293640@linuxfoundation.org>
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 5 Jul 2024 00:01:01 +0530
Message-ID: <CA+G9fYurwddc360a=u5=Qr=Ys59Qy3PqrVYO5qoKvwGupaD2SA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/139] 4.19.317-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Jul 2024 at 16:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.317 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Jul 2024 10:28:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.317-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.317-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 485999dcb7d90b9212ab9cde5bc707548f0dcd39
* git describe: v4.19.316-140-g485999dcb7d9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.316-140-g485999dcb7d9

## Test Regressions (compared to v4.19.316)

## Metric Regressions (compared to v4.19.316)

## Test Fixes (compared to v4.19.316)

## Metric Fixes (compared to v4.19.316)

## Test result summary
total: 66635, pass: 58258, fail: 354, skip: 7961, xfail: 62

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 102 total, 96 passed, 6 failed
* arm64: 27 total, 22 passed, 5 failed
* i386: 15 total, 12 passed, 3 failed
* mips: 20 total, 20 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 23 total, 18 passed, 5 failed

## Test suites summary
* boot
* kunit
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
