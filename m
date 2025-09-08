Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97203310655
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 18:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757355279; cv=none; b=eXl5Lxwm0I0bY6/BAYDBk+TFPGyJL8PSRWLXV1wuLGQOiMQ/BDzTIXVURdtW6SFVBHpQWHssOSaKJpWGDBFMvAXdwTu+Ty1HQt1ModHcfeENix0LHzyKf1RelplOShIceXIdOGPP+wWyO/bpLSdJOUv80nhynGLn3e84TuwkTf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757355279; c=relaxed/simple;
	bh=Dd+pgApASQAzgj9X3zonS77Lm1GUV+22MQ9r9kA15iE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ft6QpqF6LA1XkfNfvsxlwredmVdj6X+poRcyKkIYmBwJkU35ElO+Tw4LvVoRHxMOAx4Sd/HkxrAxGyi3MEUWpVAXKdSBr0Rg1Xo2GpQyCxUAeXaHFZsCcVLL4ZhgtFP6NiWOWykqXPYJo3dBBlczjPkdXMICW9HjKv40s3W6UhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FrM6maZ/; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FrM6maZ/"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b523fb676efso549963a12.3
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 11:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757355277; x=1757960077; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Aa8ggLlyMVJh/eLNB7/vORTWXIRxgODsZo7MWhmnGSU=;
        b=FrM6maZ/bqhFdDI9xp7DLNRkMz5ftyJTAWHLJqeePrfu21JZ1Ac9OkI5ztrqjaVEp7
         s/vcqraHygwk034k8T8InXz/lzg59/0wlZgsI1uab4QxWoi9pqsSM74aDs7OkjOy/i7L
         EeK1r71FoM8hEmpM2ITnTMOApve2KCEjraFavlVIYW7VySCIYANVSH8q7o/G7GL1kxV1
         ek73ylRcc4ogg+jJ41daymBWKTMsYt/hOhIk6vz1xf/E7bx5g0y5hOTx0ntOmRNXZXri
         tE4Sr6D1STY7BNyPyFBk2KTz5De2G+R+lq6SycmiQLbhGZChtoqlnyk5hSyaZUH6phzz
         ZDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757355277; x=1757960077;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Aa8ggLlyMVJh/eLNB7/vORTWXIRxgODsZo7MWhmnGSU=;
        b=A/qaFNl3vJXxIM/weI0GmCA0/HYiS2+KTfP0X05OvoKUuc47pdj1X8rWRKFS662Zv9
         +wxuUufFrkiWCW8Uxo3kmVte8W0OfiLOsmAe2NuiIj9jZp/K7rywr1aylGAIoEsihjPj
         ZtUsRB5Vkvfk/oCjSnqIKPfqptI2PmR1tlsEH9sighVDuGrHOe14vsBqMhB8ya5jiRve
         BOSryzdnoBARuWIiYFr9LUgfkzKEsIPb7REgx9QSVra8SK9Yrt6co/NX/NHVjg2XKJhb
         S419Xig2ScjxwMbDF+dzk196GpGNI8vZkiftZPqV7KHTXxvlvAEEBWAU8VDS5Rp8a2Sy
         S6HA==
X-Forwarded-Encrypted: i=1; AJvYcCUz9j3UVDT83jKwf4Iw1IJN1tt5jECFaR0DVqIjKMxq4iBDesjL9XnNjFc4aZlMA9wKvW1K+xHl@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5hRH0zEpgTH7gjylhneFs9YDb5+O5oPXyACufTvQHN1d8YBRk
	uw5Jw55kt69O/fk31Dhek3Dr/rOOA/QJITeOhY27JwH+1Rp9anHBi/VARbfP6QPatSalCsan6PD
	a15r31yzeLlW6tArj90Sh6XA6ERL2kS/Z7E3SFIcmuw==
X-Gm-Gg: ASbGncvm5uHRiXniOfDdwU+E4BvJnbwGLD7IzOvYMR8QHxXsBGyJ/QXy+zigq9LvEZx
	6jTKWMRdP3DWEW4G38pNbP2Ckn07j2sxBbUJOd46j1I5LJpnfCvGbooX3j8oW4drDBGGz9LM+Mg
	82o5bPYnc4YMlCoX5DVmyDxfVxmzPF3ehKlv8AM3gPOOiKhIXZ+plSDurUk0pevE/yjHuTJOHad
	22V8tqk+EEW5s945od8QgFiAcITSsYSigwgi+w0zxNXqHSJv6K+bG/0wJtoiFEZxx7u88OEdJUq
	Y3W01+o=
X-Google-Smtp-Source: AGHT+IErypQRC4wzGQeAuOgUtnwtBi2ya2m51s0FvrrM40iFGJDv512kzAJrOm36DfnNRSDLy6uFdTKbm3aJAXKiWZI=
X-Received: by 2002:a17:903:19c6:b0:24c:e3d0:c802 with SMTP id
 d9443c01a7336-2516c896521mr127705465ad.1.1757355276936; Mon, 08 Sep 2025
 11:14:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250907195601.957051083@linuxfoundation.org>
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 8 Sep 2025 23:44:25 +0530
X-Gm-Features: AS18NWCueKZLivBwekubKSawy9W-Z7KRPjuA564ID06uBm9Hh6QXYlMBZZtS8_g
Message-ID: <CA+G9fYsX_CrcywkDJDYBqHijE1d5gBNV=3RF=cUVdVj9BKuFzw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/52] 5.10.243-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, Netdev <netdev@vger.kernel.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Sept 2025 at 01:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.243 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.243-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


While building Linux stable-rc 5.10.243-rc1 the arm64 allyesconfig
builds failed.

* arm64, build
  - gcc-12-allyesconfig

Regression Analysis:
- New regression? yes
- Reproducibility? yes


Build regression: stable-rc 5.10.243-rc1 arm64 allyesconfig
qede_main.c:204:17: error: field name not in record or union
initializer

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

### build log
drivers/net/ethernet/qlogic/qede/qede_main.c:204:17: error: field name
not in record or union initializer
  204 |                 .arfs_filter_op = qede_arfs_filter_op,
      |                 ^

This was reported on the Linux next-20250428 tag,
https://lore.kernel.org/all/CA+G9fYs+7-Jut2PM1Z8fXOkBaBuGt0WwTUvU=4cu2O8iQdwUYw@mail.gmail.com/

## Build
* kernel: 5.10.243-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 910e092353351549f4857c48c68cc154c84305e8
* git describe: v5.10.241-89-g910e09235335
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.241-89-g910e09235335

## Test Regressions (compared to v5.10.241-35-g4576ee67df7a)
* arm64, build
  - gcc-12-allyesconfig

Build log: https://qa-reports.linaro.org/api/testruns/29791464/log_file/
Build details: https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.10.y/v5.10.241-89-g910e09235335/build/gcc-12-allyesconfig/
Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/32O3Hlq8fZQUSOfU5gyju24xQit/
Build config: https://storage.tuxsuite.com/public/linaro/lkft/builds/32O3Hlq8fZQUSOfU5gyju24xQit/config

--
Linaro LKFT
https://lkft.linaro.org
