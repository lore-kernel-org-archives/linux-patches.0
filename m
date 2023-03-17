Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F69620F8
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 10:12:47 +0000 (UTC)
Received: by mail-wm1-f42.google.com with SMTP id bh21-20020a05600c3d1500b003ed1ff06fb0so2934369wmb.3
        for <patches@lists.linux.dev>; Fri, 17 Mar 2023 03:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679047966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DwS/vv31f4BuEfVrvdbvseaIFS29tE8KLLx+JthWfKo=;
        b=kqYUbUCx7rarPzu1sjKivk4CQ1upiEdKzDr5T0rYLb87bdZ8TDWTTirWGwI6M/WVZE
         T/ueZTlr/XJN+MhEGtYdA8+ZOSrZxkjlUAYtnX7h1edorVAFIkqNqY8A2VfbGHoJub84
         VXmOTpw5y59SU7iWFMvd4ycCtOa93f8WF10alm5TJeroKb3upInUcfFqeZXAEJ034/R1
         wu/hlSFEDBEz/haiMhZ3siTsqQ5G/Vkko4/iPNOQJs5miGzhzpiFdg3xaI1H+T9ujxWI
         e0rNUf2PGJmbK6C02KGOkdjLUj1Rakm9KHxGZrcgHKkbC3Cymmv9pKAOamPRYXVh7F5H
         hsCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679047966;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DwS/vv31f4BuEfVrvdbvseaIFS29tE8KLLx+JthWfKo=;
        b=M8svf0lJWLIKDd9KKArZGD9tlltRIEe6c0r1X99RMOxBnQmzKGQFE+yu23GWk/b7fa
         Q/LfbKuP9IG4Ak4/Wb21PL3uSXYv5WOEbx/lnj/ZIVlYBhWpMQAl46peaH3SuJKfZg4u
         n/ZjYau2Ler10Imxt5oM8BFpzjbzLEs6WPshuPoAeuoaQGlB5PZGQYQNUWOIWnowHc9e
         8VQ4BXRroOLblhzRgz2uKvaqX8UOkIQ8BeSBvoSa++7/16Ny1B38UOXKJa/3eDFnzPjs
         qF5kMluqZBoaLRr4xZEr1qjm0ikuDCgJOxCs8xQnzaOCvJrwny5OwfScbt8NqRyNU7wl
         Aqjw==
X-Gm-Message-State: AO0yUKVPpoeCFHHb3wSey1lEZhTl0+/PZU7esSALP29nW60dtiUwLZxH
	gXZbkN6alQ3xJis747Zw9Gs=
X-Google-Smtp-Source: AK7set9t0nI25zcAALJYDS8Ya6hHA1lT5YjlB5SYqg/ZM0iK/wFqLj2Hwa4T8WrJ5MfdoTj9qk7Kiw==
X-Received: by 2002:a05:600c:21c6:b0:3ed:775e:5257 with SMTP id x6-20020a05600c21c600b003ed775e5257mr1910770wmj.35.1679047965728;
        Fri, 17 Mar 2023 03:12:45 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id h20-20020a1ccc14000000b003dc522dd25esm1535687wmb.30.2023.03.17.03.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 03:12:45 -0700 (PDT)
Date: Fri, 17 Mar 2023 10:12:43 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/140] 6.1.20-rc2 review
Message-ID: <ZBQ9Gzk4dGfeYUv6@debian>
References: <20230316083444.336870717@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083444.336870717@linuxfoundation.org>

Hi Greg,

On Thu, Mar 16, 2023 at 09:50:22AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230311):
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
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/3134
[2]. https://openqa.qa.codethink.co.uk/tests/3146

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
