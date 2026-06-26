Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7173A377EC2
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 11:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782473060; cv=pass; b=rmLSBweEjM3bDVzL92y/V6ewkY6Z4AplH5FhWfLCF4X8T2DhkQ1vCkEiIpZAIj+s6Dw3frQpQ9W9mT7OvEp6l481MDhWHe/0mjTR3hfd5egJ5LdhXlz544HJy+ltCo45zHgllou2iWRCYuPfQa+rFfE+5kPTAahXBCVHGzF+aiM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782473060; c=relaxed/simple;
	bh=xZ/R/Zt7PgmJhxoYoeK4UlmlerKBzAq/QB/jVDYuvU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F+rcuncyg2j71WQfb883oZfmwOO+FRjUX1yb6gu/LlvNdb/6eylCrBS5V7WPHHETbmswaz5u/hWFO2zDd0uoCh2jWPhpHrdBErjfhrmNuQsXAdCE9wZwjH9FcFVZEIBUU/VEO6oK0Yjkl+lNOYs7rm00kPa4QMOO0Q4k3Im6AMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Isgxt6DN; arc=pass smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Isgxt6DN"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5aea5e2a361so598586e87.1
        for <patches@lists.linux.dev>; Fri, 26 Jun 2026 04:24:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782473058; cv=none;
        d=google.com; s=arc-20260327;
        b=QavADZpT1etYM8Z58MJU9/3MEwEDn3rOU2yfqFSeRD4p6qT1eoZfeFZFb+02vduGi1
         IF2dqt718kAeYDHsmhh39Mt16V6rejWiPjupUw+rkM5N/f6bqJ6++rIKnSZZ6/6UqQlr
         xjZXScdn/xKpSb33gHLI5u+y5A4q0PbPLi3qzpJHBypywp6igjpo0Oj81g3N/WPR3Txo
         aOrV5I2LW4m0R8j3AJJc9tKnGgQ53yJr7OgshLzf/pjTAlfXOgpycvE3CB4sBQeT0FQK
         xzRLMFQ2npgcqu4zdpcPt+zX+8HeR3uvpvjRum29dQ1s5SDpYIm+GRUhi8U+6Ux+Z1vE
         lryA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5n1KTYhtjeLxiVXkDdVMmsMn8AUalKdq3qTEM8mYquQ=;
        fh=+0/V+eCLJfHIxyreSsdMiGfZXt51e7M+D3rEyw3dfd0=;
        b=LW3x6NUTimDBYNeGbnml+69gaP1pje4MI3E41g3fAtcAK5cJM03giwNwloglMeV7kp
         F4VPqCkkL08J1ysk1mdEUE6wIrL1faeYVn+4YpnVqVZ0uJ+ZAHdwA4OgqKyR2Gsv0Km8
         KtWAmlU1jm3M/LW+he2YAJv7lQbxHaNQozAZyDnV+r9DdF+VQp40sxT5ZSe2m7GwwFIb
         Xu8GCbmfcLfLS7bzRleWoX5rCMLF6/HcEf6l/NjJU8QMPmYJgXZwmV7tqxqLDCKgvCV2
         FbL18vyRQP7vKC39EnJ/ur88ZZcfrYtDaIbczWTFzd5EeeL9WspyL+Evf4d4UpIKsGq7
         qxog==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782473058; x=1783077858; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5n1KTYhtjeLxiVXkDdVMmsMn8AUalKdq3qTEM8mYquQ=;
        b=Isgxt6DNhM5NoWrTA3mGXdBEpR3GVZU6dRpSl0kG0kpgni6iVYfmvBWCsTUUAkYiaz
         1jweyH/lw7GBUCa0Fl6M5+5nvDpCrB2gAszkggHsYeRUZqyK+iTutYiZQ7cMMh2pwg6h
         yLHS3nlGJcNcDNn27U99fMPdpKi5L1v1ajRyf4YrH5jW3XMptnTq6yemoEKFPtbXZZJo
         7nGHZsmgR06pBCYtFog/Smtf+jjDFpGmuP1RIgKTs1gxByjbfpkhdAm45FssCcXTE15I
         oS5+e/QIna/oZk5xz1gZDIw4G5RPqOB+l68sSU+zVTE24n5WnLqhpZzx9YI1NgoIshQo
         g5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782473058; x=1783077858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5n1KTYhtjeLxiVXkDdVMmsMn8AUalKdq3qTEM8mYquQ=;
        b=al0s+IeFCjVctV/fGQN708ewGlWr+zZ3mOeeV1Jq+nKijEFMcm9NNWwQiYumgrVAhM
         b9VKAi52Ij92IxFflsJFIFyo7/uXk0LZz0eaXh7TOim52umz7zxz9fZTf2/0cRMfjiMS
         GYkqbov8vujfFdkuF+YHWRJmlwWfr3i50lAdXCejgykeLKQ890PG9Zns48VXRmse207Z
         +++U+lXgvUcQ38NK6lb5P85JU2WyfSsIS9NaqejxuAHTP4R6VmEssqpWJIYX9BLp07C8
         8Ar+uBIevgyhubNlwUPMiRZjF6oTx12d9cLAHHmNe+dHyPeVzcqxKziDLZpEupc3trM8
         61Pg==
X-Forwarded-Encrypted: i=1; AHgh+Rp4+HmNio+H4TrB0RGApivq4Ft6q7pbdQXuYa8dOpegouR3Ns8xruxN3PJVQQAtT4hDozUqRu69@lists.linux.dev
X-Gm-Message-State: AOJu0YyKyySGVs38zJaHiDVv/bpqEFT7Hv5H0DQ64AZXA9e+ou1gkMUu
	ieKml71LrsXR4ZrfazMmOqop7Ny2q5lbu7+vSFwjj5nBYxcOW3DY3OiXZSJzcOH981qZNxxUlro
	71+tD/RF34dueBol2cdJr8I7iZ9UVVyo=
X-Gm-Gg: AfdE7ckKzA1Le3ecMS4YL8uo9o0Lrl/5FN0edKRf9L7OeUC+651vw/WXcr9uAlAXXkT
	UjW57SNYutSye2uaycoZsPGtMmWYUUiP8gFrfsEENB7KNPixuv/lob/8g5RueC2L/oLFlw8hlQO
	qgQz8Ce1wNLAFKdMS4bGvUc+fiG4d/BpOquJugtRo2NgbgUsysVoXJ+T9k/FpTwoeNxdI+yiAWk
	VWe24G4eXq0Abxuyk5eDx1/6K/BmqUaRLGBnr1yw9gQ/MlO1Jii4C7nsh1qYIr194/eY2QDGRkw
	Qz2XAkxTw1C2k3AKN9ZI0iWKtkprMg==
X-Received: by 2002:a05:6512:1192:b0:5ae:9c52:b9d6 with SMTP id
 2adb3069b0e04-5aea94ca463mr29530e87.46.1782473057477; Fri, 26 Jun 2026
 04:24:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260625125637.527552689@linuxfoundation.org>
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Fri, 26 Jun 2026 16:54:04 +0530
X-Gm-Features: AVVi8Cfmrf9dbL33Y63jPkddocZUucSkF5t3z0qFMUseZDAM1JLI1giLXR2lfeI
Message-ID: <CAC-m1rqnH_xB35szbw0BDWpit7FBjiCx3++YRYwZmKhi9KJtww@mail.gmail.com>
Subject: Re: [PATCH 7.0 00/49] 7.0.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 6:39=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.14 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.0.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
Build and Boot Report  7.0.14-rc1

I built and tested Linux kernel version 7.0.14 using the default configurat=
ions
on both x86_64 and arm64 architectures in a virtualized environment.

The kernel compiled successfully on both architectures and booted
without issues.
I did not observe any regressions or new warnings in dmesg during boot.

Kernel version: 7.0.14-rc1
Configurations tested: x86_64_defconfig, defconfig
Architectures tested: x86_64, arm64
Kernel source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: 3fb5acefbc963081c2773b7adaf1f2ed05fa47e9

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
