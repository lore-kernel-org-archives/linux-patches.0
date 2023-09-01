Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8BE5662
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 09:20:20 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-401ceda85cdso17989255e9.1
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 02:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693560019; x=1694164819; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eoDPIMR93fFo73tpDzClv3W9lTUI4siMLDCC0A/zMFY=;
        b=j7X5L8s0iwk0jjdy3D5FBy6AegaW8D71HmE8jaVM5h6BjYOZJWvIgspPsUdXRMKSzj
         LvbTfSFu2Wl6MjkhVeFjGjnSPiaVfYLwW7iPsfMHgGixgXAWIaneQ/fe6e7BjWyG4OkH
         ACDL3EVjAjWeWGhZUoTTTSXkhvV5GSrGTsQmCSJGvIgHljavRKyvPFrBa88Jzo332mc5
         9s3Wi6LCp+v6XXqb5TDL5pNwY0rh0awqQigPb5i/sdAKMgegwMJLsEvs5tfB2jzVuYwb
         pWxt0a3gKBY/hrII2JMpiwghz/4BxpUIzwq6tRsXAICSn+eiJBlqBr6W5yFPsCqTm0UA
         rKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693560019; x=1694164819;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eoDPIMR93fFo73tpDzClv3W9lTUI4siMLDCC0A/zMFY=;
        b=ZVvEOOskiVYoTtAeTIxvsMzV9NcW5HZgnRbG59Kh4rgZrC+pnUH5SYSwvJ0SsgGfn9
         83Nxhz3PrqEcec2FJ+Tmp235Xw2FHTqJOnD5eNIzmEr6EsyYrvTw6IC8enUs9DiuNN8H
         yuGuUmJjBM9Flq6DpyiYzwUoeN4ZS3/Pl3oDgZPYDJaBA5SbZIoNDQ06a9b4UeP45P55
         wOaq4bIHkWwpD/klRmvarQChl0+ojjNCbKKtFTmBse7liWCKgrIfEmRHehnHq1xgcT4p
         PC0hUa0OH475Ceyt5Oq/SGAfhasOSyU36GUE16YGe6m0KLyClKv9TWi0cZfbxQpdqzMO
         /psg==
X-Gm-Message-State: AOJu0YweCJnXZNeHeM6Cci+aJmX2I2bxz0+LkTk3xhrt2YOLZ1AbqAmR
	HUlcO/MPCh6R6lj3hdgYweE=
X-Google-Smtp-Source: AGHT+IG3EJppxHOF4LgW3ZbOskCfv+9wLDrY/GDjW65q0eRIvQfPRQOFxNnW7DdUGuzZ7P79x1ynXA==
X-Received: by 2002:a05:600c:2283:b0:401:b705:ebe6 with SMTP id 3-20020a05600c228300b00401b705ebe6mr1326376wmf.32.1693560018868;
        Fri, 01 Sep 2023 02:20:18 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id p3-20020a05600c1d8300b00401e32b25adsm4404674wms.4.2023.09.01.02.20.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 02:20:18 -0700 (PDT)
Date: Fri, 1 Sep 2023 10:20:16 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 0/3] 5.4.256-rc1 review
Message-ID: <ZPGs0EX6i0+xc3DZ@debian>
References: <20230831110828.874071888@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831110828.874071888@linuxfoundation.org>

Hi Greg,

On Thu, Aug 31, 2023 at 01:09:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.256 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.4.1 20230829):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/4880


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
