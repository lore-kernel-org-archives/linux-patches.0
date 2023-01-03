Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1967E
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 10:35:06 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id l26so20740166wme.5
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 02:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AfGReWJsEpgaC6MfseBZWuw9WJkIOAaz/xT/DXX/SQU=;
        b=h1QSt+MknGre39BJ3Yo48XOqq76l0gckHT2kutJymoheskHYcPM2hx+Jz9hrZiyMid
         LaJlwr6uoJWjPizaE2L5HJI+IU0peEYrP29PMYyTspZf9UKb0rJItRuMEjlly3c/Gf9O
         tAOSy49U9WKvfNkFxIzlkq+uVbwebchmNkOIiPEbTRP7TQ9Co9OZxLh+uZJFS6VqrSzJ
         fWOS6jOBkwECFgTZfZlxFt7JTX/tMN8mBOPgDK9j36ohhCXmLWxMX8+0zsASn7TEISlZ
         GLRMSlz84JakMsenRmYGy6GXENNR/ZUV3xz+h1IzGxlC1BNLDZyFRrKkdbTdkYTKc6J+
         RzNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AfGReWJsEpgaC6MfseBZWuw9WJkIOAaz/xT/DXX/SQU=;
        b=JxS30VED8kjtQhHs1JdbZy/yHe9NCuJKlZfJLLjlN4kHptwGYt+tDpQBNi4SNwQlYi
         DC+wHqLEfxMS3ggEcs+vjk1lFDjQRTHKjskgKQgREJeLXkhi8ud6d9YDq0kDHEhdCY1g
         dPj9TtJE9DA1VAe/9T6XYtUbMB7f8d/vQ7Xkx8Z9Ekx9vsMHmOP+X5JF6CP9kZklhzVW
         9qWfsaMJbQA3f7vozmDJpIRZOZYn+6Cs8806cycUFZGg5IEsU7E/7YZZHKQHJjnshbgg
         6A6GVxRUN/jdQk2QvfWpTBbZO6NBIMQLBhySiX2vtdb9JsgUP4bl1ltHIwsGSiX9wfNM
         dTjQ==
X-Gm-Message-State: AFqh2kpvmWCfIP2hHYWOQDqI/bI8PX5SZ1Gu19cMjziKbLmGznpFuyeV
	QcRoEkA3RE3C07GTT6wUjGM=
X-Google-Smtp-Source: AMrXdXvAgmJxGp0ZymYz1kaRaPpZhGWjGO9FbeOEeYVlz28b4UTTrLiCHaVQnyc/IPneBTDZD2rq5A==
X-Received: by 2002:a05:600c:a4f:b0:3d2:196c:270c with SMTP id c15-20020a05600c0a4f00b003d2196c270cmr33126523wmq.31.1672742105262;
        Tue, 03 Jan 2023 02:35:05 -0800 (PST)
Received: from debian ([2a10:d582:3bb:0:63f8:f640:f53e:dd47])
        by smtp.gmail.com with ESMTPSA id fc7-20020a05600c524700b003a3442f1229sm52161164wmb.29.2023.01.03.02.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 02:35:04 -0800 (PST)
Date: Tue, 3 Jan 2023 10:34:58 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
Message-ID: <Y7QE0sSGtrM54Ch1@debian>
References: <20230102110551.509937186@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>

Hi Greg,

On Mon, Jan 02, 2023 at 12:21:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2542
[2]. https://openqa.qa.codethink.co.uk/tests/2543
[3]. https://openqa.qa.codethink.co.uk/tests/2544

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
