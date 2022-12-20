Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9F37E
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 11:20:04 +0000 (UTC)
Received: by mail-wm1-f42.google.com with SMTP id c65-20020a1c3544000000b003cfffd00fc0so10869138wma.1
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 03:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2lkzhxocRun/354TaurNhyByO/xU5VYZuEn4lnI7Les=;
        b=LG2XND57AYCLmmziUE9xBeCYCWIBljQwA1eSzf4iNVyblavE5P+LlRaHRHY7f099VW
         su5EG5OIK3/oCwVFzqN/LJxbl07L4aLCMDdnq6IpJIQwYjg4NjgqlUPhs8xpSjJ+kLIW
         CnuAbMdekFTVZ8aD1Kt3LCy39UdYGKow4PIxXcre+oe/s7bR/dNItcUbLZLDplGd7iRG
         qmYFf3K9beZgpI7P7xEqUI1VdECTr7QtBfy0632vFbbvCperkdq85qcTNVW1QbKGpPh6
         SzcyplIxRUuLFfDkiATBxjMzUi4uUxgHbluKprQ3oif8AVhWQaFkrQ5q39wcLBYthq9o
         FeHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2lkzhxocRun/354TaurNhyByO/xU5VYZuEn4lnI7Les=;
        b=10+DK4pBXKO1wmqJhy/01+rF8NY7WVochOkxY9XdWT+MUJy6W8mi0AOkQ9KTZ6QPZp
         rJbChS1zk2a1Q+hKVMDnaL79zfpZL27RvmTq758JOqTPLWWLfew8hvfAska+Eespt4kv
         NQw1uqYciDOPBZau4z3hWUp6QCmpWqgQ8wHjcPsNiDehBqD29lLQjolEvSDMDqNMlU/c
         SVSsi9NlYq9prXja+JRzAztPdo//hH0npikpdMHbMLyK6HaCtveSKuca8k5ZAfE+lqpa
         /6KtzWfIzFHaBuDv1al/TQ9OZaZK1btGW9DwgPity5nGbQjp/y+4rdCPQUTmzayiv+8F
         Z89w==
X-Gm-Message-State: ANoB5pl9/ok8marZxEaXSeIJpN43o21bXMCTZTg3hHGj3D3+8O9dWmFL
	mvJ0RLDthffC9DvTzTxdDU0=
X-Google-Smtp-Source: AA0mqf6lLW7WJ7KzxajZSlVFlhw1yOdpWQtaC+WCBLV+bGwGK7ancWAEq8J4wbmzHcLmc+r0p3SUrg==
X-Received: by 2002:a7b:c30e:0:b0:3cf:6910:51d4 with SMTP id k14-20020a7bc30e000000b003cf691051d4mr33540745wmj.29.1671535202599;
        Tue, 20 Dec 2022 03:20:02 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id p189-20020a1c29c6000000b003c701c12a17sm22204179wmp.12.2022.12.20.03.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 03:20:02 -0800 (PST)
Date: Tue, 20 Dec 2022 11:20:00 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
Message-ID: <Y6GaYM7gg3ManVGc@debian>
References: <20221219182940.739981110@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>

Hi Greg,

On Mon, Dec 19, 2022 at 08:24:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.85 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2422
[2]. https://openqa.qa.codethink.co.uk/tests/2425
[3]. https://openqa.qa.codethink.co.uk/tests/2428

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
