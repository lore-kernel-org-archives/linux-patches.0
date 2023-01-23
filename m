Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD86B7C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 11:18:32 +0000 (UTC)
Received: by mail-wm1-f42.google.com with SMTP id l41-20020a05600c1d2900b003daf986faaeso8272920wms.3
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 03:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DazFximn7GhayZRclUHvazRiYgiu+ilAdGVHp8MR6CA=;
        b=bA0bgyR0lRDzu6nk1tsLirtdVqJOHQtr4QxqFroJVkoTnz1EcZbQ95USRefy7GQ4Cm
         ELoAu0RR/KqA+ztS1PRjL0oOue+H446d2j6YHc5e7U/CjsmS1P+FK1QBiPcXtk7qYJ/o
         hT1GhQpy2rEdNM8+XCVi16NWrnTU+0yvfnPMWjUpm1Gd2XU8EaspygIc5qHdCp7u15Ko
         CqRCSQ5RaJqnwmFqLz6Q1z/tmwzY2rAB7si4xaCv9kF/wFRPDcmqpD/6YNsQiAwkpHkj
         FxKNHNVv49cNoS8UfDN22nC0mMYMR/McL1sh6zYKW5CHHuMQwDHdqTCzrX0PIqdJ+bFj
         htNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DazFximn7GhayZRclUHvazRiYgiu+ilAdGVHp8MR6CA=;
        b=NFR5Yd4xsk1FuiljZ0BAbJ2skLwaT/0ApyIAKKKUdQ02Ru4b8iX6ou9oEN0o4WhfDe
         a1dpsonKz+vArSd5jlYjZM8T/EJ1h1VaDcAEnrMnnoXMzBWP6C3k60i8tfWw4Kei5105
         yjdD4BvIGkGuyZBGnvTReepgwbXmXNiRX1q7jj4LGdklmwAnZQWKLXtsl1lBM4R/0HZ8
         jM6hpDepZx3sztlKEByL5IO+vHDWCD5BL/MzdJmWfFSvnlRnTQa4+YFrJ43g7MOe89NZ
         uJ1CJxC2vnaZFbQhAlsTx06NSiZMmmX4/esIvvWLFiYY6Rgk1tHVFeD8Yaj6qrh2viu8
         lmfg==
X-Gm-Message-State: AFqh2kqwPIdXUdDApwF2e0+ABpCaf1Ojy20YbKgFe5booQsjtP9bW83X
	do5aFgyPXjq13DLitYLMlv0=
X-Google-Smtp-Source: AMrXdXvc/DLUDDsnAF10BfJgZnTtmr9DwugCbLSsoqkVfPKvl4zXiHLOLaLPeldEIP6M5oqX6RJq0w==
X-Received: by 2002:a05:600c:3555:b0:3c6:e63d:fcfc with SMTP id i21-20020a05600c355500b003c6e63dfcfcmr23392889wmq.35.1674472711209;
        Mon, 23 Jan 2023 03:18:31 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id f18-20020a7bcd12000000b003db0659c454sm12223651wmj.32.2023.01.23.03.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 03:18:30 -0800 (PST)
Date: Mon, 23 Jan 2023 11:18:29 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc1 review
Message-ID: <Y85tBSksGZK9QvkI@debian>
References: <20230122150229.351631432@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>

Hi Greg,

On Sun, Jan 22, 2023 at 04:03:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.165 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230113):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2696
[2]. https://openqa.qa.codethink.co.uk/tests/2704


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
