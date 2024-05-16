Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DDB145A0F
	for <patches@lists.linux.dev>; Thu, 16 May 2024 11:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715860695; cv=none; b=QTLDKvUPoUhax/ju22vUR2TK0/k3cpIkp7Toj9b0lt+2/3+SCc9RD9eX+MFAUaW7R3hcN6lemYLW4uqZVNaGF+3zCtaoSxUnnSNeknsii+/1a1UechWtKRTLFUrmboi42xDMaVXz9/gEoIukxYtqPq3Byq2lmU/HmUODy2qUYZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715860695; c=relaxed/simple;
	bh=ZD6fdGcG8Vh7cSxSlm4IT/PuId4g528AT3i6ACO2HWE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P6IdeDGQOrkI5e2NEyDx2ivbFxpFebvEKPqDhGLyBADctS3PGD1L8lwzNh77+pkPd/zJi5uO6iSEU+RBuXo58OCZ1KS+JPSjyf+VvZVoTRyHtwisO5IX2d93k3lrOGrVumzq+I5u43ThasZdcbbXSo24gR2Hqozc3nrW8Op34Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uACATfLh; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uACATfLh"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-7f43f469775so1833945241.1
        for <patches@lists.linux.dev>; Thu, 16 May 2024 04:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715860692; x=1716465492; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LVLsiflUzOkxw62g1k8tSvDQS/0/UmSfYYflXMvKM5w=;
        b=uACATfLhxgaCgcwCMCZv+2DiKDimyDxsRw44pk1b959oJGN+H+ogLnmU2T+av4QI1f
         Wf8fgKRU/UKX3qTIDKuTg1oMw4Vp23VVK3m2ktZmiLOYyXPZ7ev3Udrx4LZie2mvH/sf
         VLBQAKv4ZFBQfPNJcj2nCYJ5aRiDzi5ONmSeQh5o57aXdQqyQERmFD4k5GBwe6K1Gjj+
         HwcRxhbQn3Bgr4FNuzzBjYt5E5Op/sEJLKIz0IZA22EauySOusQ/NDKEqFOlHf89D/F9
         TNk7MjEUxEC6dHCSIgg/NEuLNoV6yQWl6xo7wdn77u3fgNpNJDl0N35NsHXqSCAlyHxO
         qcpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715860692; x=1716465492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LVLsiflUzOkxw62g1k8tSvDQS/0/UmSfYYflXMvKM5w=;
        b=h1iD7EFsKiM7eIjfM8u+3zJrqxQCr23h2LE98xR9WvZqwmXS9uk/sbgc7fqvTfTc4X
         5QJjPtGqf6C5D4vxVSu/Q75Z3CX6SZ8ZJuvCWobu08XjLNKUY89JNlUCyJBcL4jgfWq2
         7HS9Dd04Q0NdoxSiwbww1SmegEXwNQCeZtTvIGm4btO9Jnvk7oQYP5bOrtwGKuCrzXfH
         R8jwVQoXcv1m19BJ2hHD27Hi3aRXlvtCQj1x3YgIz0H9sI2G1aKU7lOxkomMK8WCdIrB
         v3mVFODEtsSD4sHlWBIggU/AR81pKZRcJ4N11KioART0JO0hwVKsl2N+H7BJhmtwa+g8
         IgXA==
X-Forwarded-Encrypted: i=1; AJvYcCXLYwyyj69LdkKwTOx9OZXbPxDtIoa4RGaMKjn5JCXZpIalJBuZHj3YDxjwoFLy5RqNktTIbdQOLfag5KG273a/juUYXX/x9w==
X-Gm-Message-State: AOJu0YzUQ3Mtw5CqEYK9C5HxUUgWSeseXSEwMxc4Z0GNM5R8hKwBv6gm
	RaMTUtzg29bj+KE9dUvV1WERkAfKXG4ljTdbfZgeKo16u7CMlzGCVSjxsqp7eaXElcv50ljLd85
	89bMnE8PnSDAdChQ3Qr6yRRuFQMY7dRQSPQscaQ==
X-Google-Smtp-Source: AGHT+IEnSexvZwY287vVwa8ydg5RBnd4iYHY/vijHZOwtIpC7IUKq3meEbllweVItwMl5LJPYcEeoHu8dAXmjWLzQQg=
X-Received: by 2002:a05:6102:2914:b0:47e:d89:6ae1 with SMTP id
 ada2fe7eead31-48077de8685mr14056384137.12.1715860692420; Thu, 16 May 2024
 04:58:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240515082510.431870507@linuxfoundation.org>
In-Reply-To: <20240515082510.431870507@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 May 2024 13:58:00 +0200
Message-ID: <CA+G9fYtEMG8t4rKgyDdC_xPNZOoXy43AjaqL6a14uAZSgcEf7Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/309] 6.6.31-rc2 review
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

On Wed, 15 May 2024 at 10:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.31 release.
> There are 309 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.31-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.

As reported from the linux-6.8 review email,
Following tests failed on 6.8 and 6.6.

kselftest-ftrace
  - ftrace_ftracetest-ktap
  - ftrace_ftracetest-ktap_Test_file_and_directory_owership_changes_for_eve=
ntfs

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Linux:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.=
6.30-310-g0b94bef0cf16/testrun/23929131/suite/kselftest-ftrace/test/ftrace_=
ftracetest-ktap_Test_file_and_directory_owership_changes_for_eventfs/detail=
s/
  - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2gUuHR=
XnZeVFxSJj1ZDTcnIKTr7

## Build
* kernel: 6.6.31-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 0b94bef0cf164f56b5f7d93015069017f1678f70
* git describe: v6.6.30-310-g0b94bef0cf16
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.3=
0-310-g0b94bef0cf16

--
Linaro LKFT
https://lkft.linaro.org
