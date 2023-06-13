Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F723C25
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 12:13:46 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3f735259fa0so55683405e9.1
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 05:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686658424; x=1689250424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rGUiRPk+gVEHbD7ZvJ2F/Ye5LU63063fiqe0GTm1AZI=;
        b=EVaGpthskgsEhBQzet0q4sysCdrLW6JpLIwOR/ykspc8Qlo4oS14H+POulooWLSXEg
         Qazr4Lezoe+6bTtFeDi80tDrP6IVpQczSxfvcPNnAeHGnFfIPAnbrjkc/knqIbiB2T9L
         /6f8LSY4aIJ0ftMicOsxo8HUKkvBnDo0Swd/OAW6YBsFxzCtx9QYaIZM7qCiMDqz8bFP
         5UNBRiZ9Gv+YZTzVhfC9cXtld7r8kbSYEDEbgn7A5d7QuFMQdWKsvKMe0MIOv9V6RPh2
         krWlY5N2Zi4LJWqp9oB0/HobpHdUHIfRvWPwUzOx6mDTU9v9XWOdYqrALaBQrO3Gv2vK
         CTzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686658424; x=1689250424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGUiRPk+gVEHbD7ZvJ2F/Ye5LU63063fiqe0GTm1AZI=;
        b=kd/elWp7oBMT4J0SAZRXMlSiPvczh2/+t8aTzCiItNY4qk4moCqg6gar0zpD544UV/
         7oYBDJIKxZzsR4+3yZ9BK7jJfpkCgCyA8g1RKlksRf9AahfiMfqo/rokAQ/xOAeJyKls
         9KDPkIgCHB7Eg7v4mil42ScSM3XgcELOg4OumWKG+tZH5XsnQ72C8ojmdONeKEzX6Whe
         Lz0VbAwyq9uuzciHyaZfBCZ0DOW7WKBuKtc2V7hAyB7v2CZk4VNjH6FoigTvDNcZIu5I
         gW6Je7r+6QWmNxkS2gOznwqXhjco4lAgKiAduuLo+etDNn5ezNwoUCGC713QwfnWyLGj
         ESiQ==
X-Gm-Message-State: AC+VfDwBJrG4SONWQuhXalXrpDXjPoqNZDOM1aduY8xsrYee+qKB6x0l
	JLiCCXbSmDJqBz0e631bQBC6hOZM7gc=
X-Google-Smtp-Source: ACHHUZ7tuBZ2AMJ+KiLoQMQy1dESv+R03sMRcwSb0QvHb/EWax8eQTCRA6ajmludPK6QmTXavw+8LA==
X-Received: by 2002:adf:ef52:0:b0:306:2e04:5925 with SMTP id c18-20020adfef52000000b003062e045925mr7962050wrp.17.1686658424415;
        Tue, 13 Jun 2023 05:13:44 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id v18-20020adfebd2000000b0030789698eebsm15220338wrn.89.2023.06.13.05.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 05:13:44 -0700 (PDT)
Date: Tue, 13 Jun 2023 13:13:41 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/68] 5.10.184-rc1 review
Message-ID: <ZIhddcdk001hcJgU@debian>
References: <20230612101658.437327280@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>

Hi Greg,

On Mon, Jun 12, 2023 at 12:25:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.184 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 11.3.1 20230511):
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

[1]. https://openqa.qa.codethink.co.uk/tests/3913
[2]. https://openqa.qa.codethink.co.uk/tests/3914


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
