Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B01182C6B
	for <patches@lists.linux.dev>; Thu,  4 Apr 2024 11:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712230255; cv=none; b=bMlG/AOhJ676OUyTiKs0FYb3WFgKuuR5K9vsIaJd7ZL2KKDpZRU6/aS0nf/dMu2k+Wbsxlt18QXBAzh9DcJdJ+ZKWaL14YOa45pm6+XcF8OLps3oO5l00cB7rkXVXOJ1N/Z7CkmKDJkuFXjlH7HkRjtyD6uiNBZ0C64BPgKt64E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712230255; c=relaxed/simple;
	bh=hbUkkTO/U4EMpnbOF6FBCVXqVCPGG6PylWE9C7brf+c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tdFwUZ9mHRF2Oy0MfmQps4PGe/KHJtet257SAAHIkV58XUFCWC9CMNmC5R/bZElVFXi+bkz3M45jIKERI2q5B6z+LdFcMeFeTR6C/pJX+qlRe58KoNcw72X/UcO2kChtiTbMZua5raWDvhqAkC26rlgOkeT87VeOVlCuC3zwKwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=KDNJo+C/; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="KDNJo+C/"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6eced6fd98aso444532b3a.0
        for <patches@lists.linux.dev>; Thu, 04 Apr 2024 04:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1712230252; x=1712835052; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5mGpLNN+a7Au2G/EYQDoNReDpzvoncflKDPE5zOJmE=;
        b=KDNJo+C/6ED+4Suc5NTNI4HM+NXRy6HrH62fY3ytKQ6u5dNhZMv3uRBFZ7OlrX/iHW
         +0BrMsXIyojay/j80a7YFpZ1C2c/9MsmyjdpXlv292DDiBSGsZmfEcs8LD6q7ePpl+ip
         Aq6jJ8hAW61koN4zt0ndb7JDsLgDGayIyKv00AX126NrxghXeBzr0YGcJTY0fEIBdjfq
         E9kKLyEMhN9QeJnktFlTmBUR92Ui0kYdxguaXtTHK+FUc7BqKLveQxNZ8u/V4njXtWL6
         11JX1c2wThnXhfQgEG2I9KbHGs+LaYO47PFPbIw/CSgKRjRaPzmtLUX/yNPc/WvW3Qhx
         snCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712230252; x=1712835052;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J5mGpLNN+a7Au2G/EYQDoNReDpzvoncflKDPE5zOJmE=;
        b=OWySA7TBJ5BF4jSnXX8/pT9OccdjT7P5fxV3ZIiLk50s3W9arACRZ+PmrzstaCatkV
         /lerfNINXh6VP+diYp66Rr4/9q4gsHRBxbc04iuHmOKPXiNiI9uCyV7O6vIc30xSVn1O
         9SDM/IHqj3ZNOjLpEVoeU+cqx3O0tUfzw9QZSB499Rjdxh0TMMy0IduvgmA7dSUnyTC4
         sKghekD9QT0Bxi09yKk8KWZGdZz2T1gSqrvdLHBOK8PQ5F9Lrl4BeWxV3N9QDgyA3tk3
         Jrp8LN4Jx7c0efAUFjE0/VIf521JjWeKdrdrxjEXSgFwxrB4nXE5UH7XelmCrIn1mZ+O
         /tMg==
X-Forwarded-Encrypted: i=1; AJvYcCUR6xCIcryS2xpU7DH6pNL4W0xdOPeqNmpLfx2TIKUetCgUwy7Mh7qFEK38CvlH7QMg9Prjqb+tXngGann9Tjnhprf3InvZlA==
X-Gm-Message-State: AOJu0YyF6NRdKGbdKwVhOcoybTjbCPNBaS4eGzFNBZ4QwpEHkKBQHJvE
	0ng7tlo3cWktCZpHSSOwJlehNkfLOogzCXKkjbpoF3QsYWCGiWTZ4m4QZJtTFz9wz0U66ZlN8cG
	yyNd6MAoURITmhT1WVtA1C3gKvtMN/SLEJa9lRQ==
X-Google-Smtp-Source: AGHT+IFN6dZWmAgrAkglzr4sW4NjlCbAfdN8/hIeao7f5iZTSqTUjUYfMiqUfdOryXKK78X9Ck6xcqvzBuTpgIOCMWg=
X-Received: by 2002:a05:6a20:dca0:b0:1a3:aaea:a45b with SMTP id
 ky32-20020a056a20dca000b001a3aaeaa45bmr2091520pzb.39.1712230252503; Thu, 04
 Apr 2024 04:30:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240403175126.839589571@linuxfoundation.org>
In-Reply-To: <20240403175126.839589571@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 4 Apr 2024 20:30:41 +0900
Message-ID: <CAKL4bV4EuV2AHv8g6HoRVmQXtS_ATE6oHE40gvUQd43bUqTGjw@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/11] 6.6.25-rc1 review
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

Hi Greg

On Thu, Apr 4, 2024 at 2:58=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.25 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Apr 2024 17:51:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.25-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.25-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.25-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Thu Apr  4 18:22:42 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
