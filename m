Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5123EA74
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 19:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M7Qltrsr"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-462a1a2717aso1579073137.1
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 11:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701114940; x=1701719740; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/TMOaAh1xttulN4HpcJfcDREcNIucjhookb0crER2fo=;
        b=M7Qltrsr6DnFyt/wAzuAryNNY9boCUiTgHBYWq9gdZl0b3kpGFRl8el1yeMUOmZfPk
         bzk/bcO6jdvxSEKrNEIpC4z9eoyR1RrpCD5JkYHTYXxgtQhNbjKMGdF95cOLAABl3Dau
         DxLsFoYxGIzvBSoJdROcu3EKMq8Q6+kwdFN8WyKyOwLc8gCrzomQAvBp6LtybAPFUXWA
         F1AyMuGu7PFBLbKM9bSt0ERU7+Qt5vM93WPnoT/Zq7P/J1oOxl6Mw0iG+ErYhgWs0kiO
         vVIkx0gLAOoRTYdpEQo0LOT+i1t8m5NKDI7AGa2UQEQVRrCxtYiXpKSPXF5j8eEKdLC0
         IaBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701114940; x=1701719740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/TMOaAh1xttulN4HpcJfcDREcNIucjhookb0crER2fo=;
        b=hcv6lvzEe/+pgMULFMwadT+IHZK2I82TmSAx0baMueanCX5tX9/rSNx9UsRarJYSPF
         hCkwmh68B0eV1QvzjjKKHsaK0MgZKNpFNdTF9r7EyM1Ph18+51wDT17DmEJiDMXPAyuM
         3nBw9t4uNJC75T5HK/TQe4S1h2bYdPnpprggCYTcHsGQgDCVYb7nMyrXtNwwnDJFPJus
         Z7XLLEnrlJhI/9m+AGVZGqmpjTPT6C0fe4wBRdoTeciFMN1D5slJqXUO0Q1QZ3fqfil6
         pXA4QIaAzVOdyrBm8DvzbPWpSdqwnWdjfXHwG4sQBhOXqIZbA6smu98Ie42nHUQNW3q+
         RdhQ==
X-Gm-Message-State: AOJu0Yw9PUGFTLRcU+W6m/MmQu0kfPtWEmet0uNZqUZtRIrqgmJxXISl
	UTMYzMBcLChPiHs1pg1G0LozgP4R6iN4tUmBNE61Yw==
X-Google-Smtp-Source: AGHT+IF1mAFvOGAvsDg4pZ0R8M8hiRKSHtJN0pBMxbewTkFnpMlzKn4GXJ7+GoqmrN8fTu0r7ShP9hBxdVV81qBlWn8=
X-Received: by 2002:a67:fb03:0:b0:462:d592:b078 with SMTP id
 d3-20020a67fb03000000b00462d592b078mr12137866vsr.32.1701114940428; Mon, 27
 Nov 2023 11:55:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231126154329.848261327@linuxfoundation.org>
In-Reply-To: <20231126154329.848261327@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 28 Nov 2023 01:25:29 +0530
Message-ID: <CA+G9fYudTmZ+t84YLfe2wTXxORpTFBp8p9S=NYVOMretu-VSyg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/152] 5.4.262-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 26 Nov 2023 at 21:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.262 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.262-rc4.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

[my two cents]
[May not be a great idea to test latest clang on older kernels]

Following kernel warning noticed on stable-rc linux-5.4.y with
clang-17 for arm64 defconfig.

> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
>     PCI: keystone: Don't discard .probe() callback
>
> Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
>     PCI: keystone: Don't discard .remove() callback

WARNING: vmlinux.o(.text+0x4e2a80): Section mismatch in reference from the
 function ks_pcie_probe() to the function .init.text:ks_pcie_add_pcie_port(=
)
The function ks_pcie_probe() references
the function __init ks_pcie_add_pcie_port().
This is often because ks_pcie_probe lacks a __init
annotation or the annotation of ks_pcie_add_pcie_port is wrong.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Link:
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2YlCuygCpZ8wNd4DS=
0txeyTovV4/

--
Linaro LKFT
https://lkft.linaro.org
