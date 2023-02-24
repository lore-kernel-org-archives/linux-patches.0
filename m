Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73DA524F
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 11:19:05 +0000 (UTC)
Received: by mail-wm1-f46.google.com with SMTP id m14-20020a7bce0e000000b003e00c739ce4so1505201wmc.5
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 03:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tGKVuSFSyIN+VYM66MS5xfSSck4EN9wYEzt34f5JQKw=;
        b=mbpUlxIaMa70rNVw3Md4WNc09iKHmlkQCkPddVUBT0+YOJ/yAxJxXxOIaFN8SyoQm0
         mDcSt5M2nz9dvoAcv+O0r0IwPAJZfEVqg7x7Lls+5el+UN7AyLVLSypjY2AQ64NOKG/O
         6l1Pg9nWe0DtZTAQKG3FfOZBlmldflIW3Nop1OvHkS3Pb2wz0BqK0NYrG5G0fdbBnSvs
         wqO3ZD1CiEUfs7GE2/MWARsSiGRvgQewZP4u1z1W0D2Ip2L5dgQyrjQCU0v55ltbqE4+
         +M6GaEJhTSDKSWkdYMPFzwcUOc3bFWW1oRJJRwi82UPdp3PxkK4mxQInN0ak0IhMZMnM
         DHNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tGKVuSFSyIN+VYM66MS5xfSSck4EN9wYEzt34f5JQKw=;
        b=K/4FC+l9Qasb/5UmUOZ/y27U6/TiUyAYAojCe4TLUKwTyiG4PnkJlihzzJ5laBrDXD
         iRzPJFIX2Knr8usfnqXj81cYxsSNrfcPNHvqhaEiO2Ygd9ZfgLqvUYcFt3UqwSlhET6P
         b0RsKUGIRoOeQO2ObyLCwl5KO1zWJXPB2YM8t162pGpQV3CFR5qbvJ6jlcmgbZN8//yO
         qz+3cXoBdcj0GMsf5VAj3Y5bBgBWXm/jY+lU3c1nctzfeRLYqE0jleZTGO0BXzawp0CF
         WStUtqxRKhHdcwnR5c0F2jrCXzXEMuZqgC48YE2Zpwa28OlswKuV0/Ro86Q1USpwuAMo
         /CeA==
X-Gm-Message-State: AO0yUKUHKCGWj2l0c9J+1+AP50HExTSvlhkH1X2dOg7/ob7cS8hI/eM1
	OH71I1NzeeZysHtGcKAG08A=
X-Google-Smtp-Source: AK7set9016shcJwzv1sEkMvRXsfcVre9z4DYTDp5dJ5uyQivdg69nbvGWEM+K9Vb5w7ajvlRu5CpmA==
X-Received: by 2002:a05:600c:3b9e:b0:3ea:f6c4:5f26 with SMTP id n30-20020a05600c3b9e00b003eaf6c45f26mr2038589wms.17.1677237543966;
        Fri, 24 Feb 2023 03:19:03 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id l1-20020a1c7901000000b003e2058a7109sm2451956wme.14.2023.02.24.03.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 03:19:03 -0800 (PST)
Date: Fri, 24 Feb 2023 11:19:01 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Message-ID: <Y/idJSMkcMrmTg0I@debian>
References: <20230223141545.280864003@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>

Hi Greg,

On Thu, Feb 23, 2023 at 03:16:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2932
[2]. https://openqa.qa.codethink.co.uk/tests/2934
[3]. https://openqa.qa.codethink.co.uk/tests/2935

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
