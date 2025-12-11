Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68609279784
	for <patches@lists.linux.dev>; Thu, 11 Dec 2025 10:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765447372; cv=none; b=kac2PVPmhsdmIX5ICm0tybN0CWTZzbTjCrfrG0yHre0zQsPTtWFDzKii+l63r+Qjy/8qHP+hHVzqYWuK3OutqyFIlyacaEvUarSZboagdjhXMKzXjpwfGSEBdbR7bN8f0pioidvfgJ+VzDmjLWidP21G+fgVt1tzUEvHZHXgz+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765447372; c=relaxed/simple;
	bh=dXaw93R+o/MRj9zr+K8C4AeIIxYVXalR0ZpE/LV15N0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VeVCZ/LV/TDvy018tY53VWnz08M3BIIFuifMxfCJSfBspa1c9tkxKSQWzoDUQDnCQPq0PcLgXbsBXNQUz6OkqF0nQmpjzab+g4BvBI/oBxZSK1IoS6L2FhK7oAoWD1hdY/hGSxJYMWE5zTwnZ8WX8P/tZi4Gnm918yaa3Pm1l5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nSDF8yGh; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nSDF8yGh"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-594330147efso756522e87.2
        for <patches@lists.linux.dev>; Thu, 11 Dec 2025 02:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765447368; x=1766052168; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V4W+SY0l9++XGnbu/FMYs0nB91d5urXymPiJIGdOaOQ=;
        b=nSDF8yGh2uejuh2LOcSbKDkhHF7lXiydLjNBvyqV+GsDC3jAw/KtY0VObjN9R+kU5O
         gyJvxy4ZwkG7pzkpAvw8lgIbpVkizTT4VbyO5SH01t+bgpThBCpX6DdCystbbgN3kdF2
         +6uiBNaHs1XwdYY85ZKsdos10U/TLKl9Yb9Iu1epG8YqF4zS0dkv2hUl05auS6wZwRkG
         58c9kkz8MGRDPaDhWOIBN//gY83afkJc2fbjzG1C4bzDFIJvGLSk57jjgcUv3HtHDk4M
         Mq4QEpiu3drgQGJ57sa9Lil+XSHFEQ8XgVBjZt3HaEI9HeoK0ZZJhdPUKEvL6AHDpqrY
         35ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765447368; x=1766052168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V4W+SY0l9++XGnbu/FMYs0nB91d5urXymPiJIGdOaOQ=;
        b=JsRJmBzT8xBkGnky1DWt8ezDvSiENh2T+5z0Zm26wQ+Qn3Mf1+ZeZMniPA4xvqDTkn
         J8Gg78cxnDuMYlATrVs9hpJAo0Xjl/jlGkAkc3YLN2CCtj3DUDuw2pwa53LIg2e/DFqF
         Y5n3biQU1PU4iL6BuQOthDZ1rAHE7CdFLztjGLRdxx0lRFKEbIrHfBHfB1xsJ8KGPyQ4
         LzN8KIL3qiVDpIb2A8Z2XZd2Xw+OGGCHSfoc6J08Wm/59QYk0nIPWiAQn334uKLSjpnk
         uQlU+COFq0v2irh2xVZ6o8pItxFDUD0m6NUv76BS4b2gZGn/dO6s+3ePw4/02aseORYe
         mNRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTb3d8u4FBZetbCYABDS/ivr3JTQ1v1reYdGBHIRyXttb6DwGx34asuDXEcS+X3l9xFab8Y9zV@lists.linux.dev
X-Gm-Message-State: AOJu0Yxt04n7nvf/hFa+gKxR5pqf14NaIv+PSUemerSXlklAPszZWpEx
	AGgaAuQppA0NCvY1t1pPzi4JzRD281lsItMppyJz6G+N6QcCyG6edJ/hRG7vHbs789cvVoNizAo
	H+gQuGuvtBcGB2/802wINUTXWK5KPkmTxM29y
X-Gm-Gg: AY/fxX46WW0juv+PHN2FLAgRzUj+qBHJH3KqoCTmR6EZaQ5s8n/oztBucNrpJniqEcZ
	2TM2WpMfsHcvgj0zpbNl3BkDWdIpHBpPC6H+2A1yEFQgRABRzhdc/uhKrMBEUsAxvFjy0L8FRMI
	xlamg6XSy9ZuRR2Adz1w6sC96MKCTNcYv6zuHKJJzvoweRuMKBN4DNbxLnzaHVd69CxAt0WPoce
	P+ejAJJ6pU7U1RVQ3ES6JZgQQRkpWLucb7tTcdDav1nEHbViwNAIJXWxSEcN+r4LHXLVXVh52QZ
	OUEZlLf4UfSIJxPr/u5UaGXi4bOCy4BrHMTN+lx5
X-Google-Smtp-Source: AGHT+IFIlPAKzLFZDPIpgnt0sLPNEYBWRYuk5a0n+3NKzujEjvPba1ZFRDRDx5s1nzLXH2bRjLyNmsVwJKpuoHx4iOw=
X-Received: by 2002:a05:6512:154a:b0:598:ee5f:82a8 with SMTP id
 2adb3069b0e04-598ee5f8378mr1509180e87.0.1765447368155; Thu, 11 Dec 2025
 02:02:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251210072947.850479903@linuxfoundation.org>
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Thu, 11 Dec 2025 15:32:35 +0530
X-Gm-Features: AQt7F2qrOVU3vTssdHqmPCZo_HyxgtJqiWoQWtPxVkOk8fQOa9WGH63jzLbcpJE
Message-ID: <CAC-m1rrpPDjF=kCXQfAaB7BVOAyRRJSCs54GFffxzhs_g7M-8Q@mail.gmail.com>
Subject: Re: [PATCH 6.17 00/60] 6.17.12-rc1 review
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

On Wed, Dec 10, 2025 at 1:05=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.12 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Dec 2025 07:29:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build and Boot Report for 6.17.12-rc1

The kernel version 6.17.12 was built and boot-tested using qemu-x86_64
and qemu-arm64 with the default configuration (defconfig). The build and bo=
ot
processes completed successfully, and the kernel operated as expected
in the virtualized environments without any issues.
No dmesg regressions found.

Build Details :
Builds : arm64, x86_64
Kernel Version: 6.17.12
Configuration : defconfig
Source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git
Commit : e7c0ca6d291c41a8a9648a5016ce9b73e492aa3d

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu
