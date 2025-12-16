Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9611F32F74E
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 19:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765913731; cv=none; b=qXwH3LXqrfNvwsdiT654YB7dxcPX+HLXQyxv/p21SgRpCfe5uHctsHpdPis6jBWIoRK+RQ/oWTntmhdNLH0THBhRTGMf0hlrhTeTV1F6N/xjCW/LWGycX0OU5KCdJty6u+xCA4HFZI/MM9yBZEepRmbHAovXjZIfIkY95KYw4+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765913731; c=relaxed/simple;
	bh=Rakyn03cAn4ws+rNLp8303TuvZ2Hh6/IlUu4Bqrn6HY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RkPzLE6Dv9aQMfYenWggIfF/1js7sj/2F7LBT0NUUwMSt0put6pp1iCmtIzW2ZsQC7IXQ30vgiLk+PYb1wSU/qyLcRRYq/k8mbDCqjsLst/OQWvOEl6L/s6MeWK2CBRiECdf/6RemUP61FZMQwTIo7oDT4Z/1BuqVbNQo7yr7wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fBZ4iLj4; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fBZ4iLj4"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-37cef3ccb82so38153521fa.2
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 11:35:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765913728; x=1766518528; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2fiWdyTxHzyXdHV/LzIlNud4Xk0jRxN/vsFndQKWzkA=;
        b=fBZ4iLj4n3Vt6pvLQmnUgfQFckB6gpXtdMf1YZw8qoVVIZKGpGlq8D2yGpAqSSmdU2
         FBzqQ5fQ3ufOWdmqr8u1yRR4E4kFCwIqj9LbzezYp8KESoOwP3WIJPzBpdkrAQClCNTJ
         raogS96Uxucfi1z23/6Ro3TNhl4DMOie1DTQiJRcT6vkWMMsWTE7PRom4QrkS+xOxsy2
         TuSOysCq9LdMVujGxHyLb9GnGsOzdKz1tWgmWHGxH0DJArGPRJdMMpWbT0joiv3DtRbz
         jnf5YBHmgB61CQBvDaI+aFRHEjQ250uUkQOOh3zm7cGrgT1EUhZfVFJjmD5cwybkXPrq
         RyWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765913728; x=1766518528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2fiWdyTxHzyXdHV/LzIlNud4Xk0jRxN/vsFndQKWzkA=;
        b=gJrFlZBTI4sXJyzpi8+dSdrFvDzwru9GYBYunWoSyhErB6+f0Ty3/h26D9hQ2Rh0q9
         5rKDewlrQku6mF97jOLLdl1CgNpHg5qylGLAQBr4fNjtH3mbc3qp/hWwiso2iq+MA0E1
         3AVi8RhO/JGowRu54lGiTlrxki/2t1djXUbanUlxZmSyft3maUHvpFaUbg0vippDC5et
         i+qcT/U5dMLtSB4rnuk8a2UTHUwP2cz7YIVsQ39lCPNL7nmBdd79uIsdXqYmNXJypKmm
         1buOCiuGKrhom5hAm7lC+f2rwabbKq5iLGGKaCK9fixStGXOgyM3ZAgU+Citx1zAN5Sb
         kOew==
X-Forwarded-Encrypted: i=1; AJvYcCXWoiFeJ9nEjCFaNMhzai60VMuFncCFv/3SPcZBM6GlAWBIL+oJYtmNmMqpSPqBsiX/HuLrwcEM@lists.linux.dev
X-Gm-Message-State: AOJu0YxiXGUl3yxNzLfCExbiq18Itgtmdqg0P7sN8G9g7quvpSY+yOIY
	FEkw9FZD6BAATFJxzQLZJMKy+w82jLo0KoCqadUrZSGbDzcnBwlFmRD2vvNdbw4+cYSYTi0eqoH
	wOr0FaRnNbavwIT4LY3zc3vwM226NLa4=
X-Gm-Gg: AY/fxX47vSTdunk3W7nKUdAM/LtkQpwv2gzq+J5dSclAXira1A4VfnUlTfGfcb6hZbE
	OWOXrcRgiPJZRSfLH4v5uwlKrnTzuY2pevH83Txftxtzf5D5w4PUNhVmMsqyPDVYQoEXYny1T8a
	D4ZXmGC8poSSk7RouXOvHdAw7I15bjfOhU8RSEWoE8A6glUSxkxA3s9GBoRwPJ0+qDrJIFz5Mgy
	hcZIArCdRK7rsn8jxFkI7TDl2UYEJPz8+CjD65rfelREuFXtnEML4LICfaDOqYB953WG4fuYVIQ
	cC36SgTMFeH/ZN1n4unX9KdXJiRW+kAN4WWVjng=
X-Google-Smtp-Source: AGHT+IHZM8F29rp+QN4MkCIOrX/NB2E/euo2QTu/DopKbrenIZ+1+TQWP8v7tZWC9LQE2K4BhCvnHd3cxZ3xPZC7bVw=
X-Received: by 2002:a05:651c:1549:b0:37a:31fc:1d53 with SMTP id
 38308e7fff4ca-37fd08e3424mr53192691fa.40.1765913727332; Tue, 16 Dec 2025
 11:35:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251216111401.280873349@linuxfoundation.org>
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Wed, 17 Dec 2025 01:05:15 +0530
X-Gm-Features: AQt7F2qKOKbFXjxASAe-Bch2wX46L0eCWZnOy9xsLOGgVArYPoja3obSdP1hc1A
Message-ID: <CAC-m1rrxiEimyx24MjZze6doMEN=EevwOMb+VPuiy1reh9Cdug@mail.gmail.com>
Subject: Re: [PATCH 6.18 000/614] 6.18.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 6:32=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.2 release.
> There are 614 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.18.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The Linux kernel version 6.18.2 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig).

Both build and boot processes completed successfully on arm64 and x86_64.
The kernel operated as expected in the virtualized environments, and no iss=
ues
were observed. No dmesg regressions were found.

Build details:
Architectures: arm64, x86_64
Kernel version: 6.18.2
Configuration: defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit: 103c79e44ce7c81882928abab98b96517a8bce88

Tested-by: Dileep Malepu dileep.debian@gmail.com

Best regards,
Dileep Malepu
