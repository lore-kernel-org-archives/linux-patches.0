Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F007405D3
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 23:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MVUXuxQY"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6d87a83ec27so2467001a34.2
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 15:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701817873; x=1702422673; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YiM0zcsyKgxywZKVKK//YeSGcTecMKDV4q9GcI5jqSY=;
        b=MVUXuxQY6YYlLWhDTqUfUKAUL1OIy3NpIjUqzyQb8PzFm25hTv/yQmMVo6m9wbQSHq
         1deomhYjbFEcRyy2qlhMyKYp3BLTHWK+npiD/MuoGu2MKcrARCmetdRltNZw0XuhL8oP
         RFu5JGX/zj40G0uhvYlcT1Xf15eG2GQjuRbiYXdLgaGCnRFHf/zwdLnIKORDHCmZvizt
         IS5XU5iFQWMBdPApBLOFV7NskyiYProlgz/ggdpNf0Gcox0XCRp/EOG3bVxMVsj6XQl8
         WWbc5TLtmeJMm8ll45s3qvPn8rqmFmNkpLdE2e2OcPxz3X4fsOCuadv3EGq0jK1q605k
         QUMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701817873; x=1702422673;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YiM0zcsyKgxywZKVKK//YeSGcTecMKDV4q9GcI5jqSY=;
        b=IVCQ9ujbt7hfst5S8dajlAYeZuFKlEhn0LYp44yMTPdgx/QHKsjenPZuxkKCaeJczN
         tquaU8e7rDxNPvYP81XAjJwVbE2nsz0ivbda3tdDBmiZ+knqeUdNVu+6YDCsstlLr3Er
         X2PGcSc3W3r1BD8JLFZnk3SSLrwKCcQbTsw8o8mKvB68gcAK1OjNFET7WyYAmVafOk6v
         8lAlHjfCo8IsWPBCHaqtMdp4UDdx0J6qsmlEnk1hIiNEzadLgyMGBaAsVnexwT7TH9mu
         djf7hklxk+XtdpzLTYWtrhZpsJJLyBmvrDkrr4DZjcB64Cz1fAuOuEAU7K/mP4CmBEqi
         /v7w==
X-Gm-Message-State: AOJu0Yz3CE0DeCS+IaLwgpxA5DrfbPsdEiG03/CvFo+1DjZVRXKliX4i
	xVH4Mh0eTcskMIAcWxH59Hqa9MnZlCCXppA7pKY=
X-Google-Smtp-Source: AGHT+IF7QP4s/HHKdsuycE0FCSgtY1QW4Ox6ohusNAZPotQ3vuUN/JIJv7KjFnCHt2I9zaSwkeBR2acaW3dHE2xDyp0=
X-Received: by 2002:a05:6830:1d6e:b0:6d8:74e2:c08c with SMTP id
 l14-20020a0568301d6e00b006d874e2c08cmr45346oti.62.1701817873218; Tue, 05 Dec
 2023 15:11:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205183248.388576393@linuxfoundation.org>
In-Reply-To: <20231205183248.388576393@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 5 Dec 2023 15:11:01 -0800
Message-ID: <CAOMdWS+9VcHETK6qeYP2QKut-=KM_W4WPb-OcpdfWyaiTBUgRw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/105] 6.1.66-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.66 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.66-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
