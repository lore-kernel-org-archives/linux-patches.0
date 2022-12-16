Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50A320E3
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 13:14:01 +0000 (UTC)
Received: by mail-wm1-f51.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso4064280wme.5
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 05:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m8td16btPgGE0p4CoNaWK079dTkpm7qVZ4qxtSECPDY=;
        b=K6PXalvePnYIFBv7rGrqI0KXfx4XfXgtBJ2gbom4ZxZ7ZjyhsTvhdLe/Wu8gy81yAt
         NRZS9bkM64cKmV4UganS1pwltS0Na+tAsnj9g65aFxg7kPDu9R8QQgGOwz9JRuSJwi2F
         eEnx42t0kytGp/PPQA4qG8GNkTl5ogKt3kYwP3tYze6FAR6RfUR3UHI2eaOTEE6D/lb5
         Sg4nmHpfnfD+jbJVnGIzWL5GsTwLKW6qS1SH8pbiGkcDt/bdwa0SC9oyHYnGkxeCFT6p
         EaPplEl4YMHROLVAAgBMDbTkk1oW7Rb1eoqqqIWEk8rjsQr6QxPHbNP5D15AVaZw/Bqa
         TRYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m8td16btPgGE0p4CoNaWK079dTkpm7qVZ4qxtSECPDY=;
        b=GOGvs2jtjgQch6B6nQ4oRxTzRUvKaIQZF/SUvEBUy/DmeacNg7QqpvmsgukTskN8OY
         wrlmzeambXBkBgG/Lpm1+oaDDmzfPnjdY64Zxiv+C35abwcsGyEYkq83/N8PEMh+YcLE
         elUlgo00igT9tIKrb2C4qWZLIJlbqaSu3f+RbhKD/hB6XzuutDSPQdN6WJ9USuXWMvjh
         RF9Zg1y5IHvYbolWgKgF7t5kY168vJSkQqYMQKjBZH2RKlfqAjW5rnPEzv8w4ziLOlWI
         daCf5L2bI5nU1eeh0HEL47WgtzcpMnAIb/wi5/d3stYYU92/FAmiPYJ5pubRRp9sY0gS
         cqmA==
X-Gm-Message-State: ANoB5pkm3u0UXAVj+82kisX4H7vpRFGoBbiS9mvVdwDeH16xFbIeahnV
	MykJ8hkFofewEc5HkIOKkjY=
X-Google-Smtp-Source: AA0mqf7ttMl4WZ+BxbG1kuGPLsFd0seu2xr5S/A6FCrPk/BguowJtqlYyuOP90IYBxxwaCQg9TLd5g==
X-Received: by 2002:a05:600c:3544:b0:3d1:e04f:9bfa with SMTP id i4-20020a05600c354400b003d1e04f9bfamr25285912wmq.28.1671196439882;
        Fri, 16 Dec 2022 05:13:59 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id z22-20020a05600c0a1600b003cfd0bd8c0asm2507934wmp.30.2022.12.16.05.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 05:13:59 -0800 (PST)
Date: Fri, 16 Dec 2022 13:13:57 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/14] 5.15.84-rc1 review
Message-ID: <Y5xvFdS9BWXmVg+3@debian>
References: <20221215172906.338769943@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>

Hi Greg,

On Thu, Dec 15, 2022 at 07:10:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.84 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2363
[2]. https://openqa.qa.codethink.co.uk/tests/2369
[3]. https://openqa.qa.codethink.co.uk/tests/2365

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
