Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B82D20F3
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 08:59:46 +0000 (UTC)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-3f730c1253fso10622625e9.1
        for <patches@lists.linux.dev>; Fri, 09 Jun 2023 01:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686301184; x=1688893184;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dk7boxF/9/KN8GwWEET84WLw8dgEVug8WBc4y7YXzoE=;
        b=pdcrcA9ymjmWCw4gJJoG99qknB3gxUsHnyct2z7MHeGGbClJ4HuEAWuEg1nxRSSkLi
         UMne/SfFUfqr+mtvdB0ZQsioOz6Q17grcfDRBtSTgzAWkthlCDbgFGFcRCf3IndlmTn1
         4wRTIqgbIcN6LUSuZscWQ28ZiZxL54o2XVe5CHyaD/WyjC6O/0stkbw49C8aYKxGuGqq
         HyqzI2+Sa6b4EfDy7TYPwnLfi+/tMR+HrZK5e1WRely0Jk+tbL1e9HBwn8H6CZ3hVniP
         kjATyftvyZXtoVZKaFFsb+b2aZQoBORaOFcTAwH7Y9Q25y9uf1Iw7KHVpw38cgmAI7UE
         7B7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686301184; x=1688893184;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dk7boxF/9/KN8GwWEET84WLw8dgEVug8WBc4y7YXzoE=;
        b=VHllp58iVu+Ap/kqh14B93HO5ZYvZH2IYZnK73eJLTNzTXaqvstk4X0zqgugUeUXlO
         1cOUNN5k3brIwyhIcwBVZ9/8SVLc1g98mrAkeRlbv/bFEdmRLQu4bEJRPsPoVdOnKrVx
         vN659WOCqoaJf3DyLVhvVqcQEmh9JK+FxpMk4EBC1RISpFv1bGJoXbHyVEqzAlLnqPvD
         MCk/zKnhj5kgTwYsvmFUnv2Ke1UomXV/eMzKeWz24ZolRGya6bUe5KVmkkwmv9GpTLXn
         2awl0zZOwUPWssj8iDqQhPJQdUL4+PikybwdEOL9JEx+eqUDg8wDzBcLa0xdjsrFtC7G
         18JQ==
X-Gm-Message-State: AC+VfDyn4rkXVyoe8iq1x93If9tqn9iBaVCFiK/ImGGpiV7ekx9b3vc4
	YYIKKLztYsVUVj5pk0KBYMA=
X-Google-Smtp-Source: ACHHUZ7DijPleZHqtZpsYl1X78/S7FIkEn5S34I55CA9LriEVpVhX0bCOcbv5Dl08GHXgFR0URLDiA==
X-Received: by 2002:a7b:cb98:0:b0:3f7:948f:5f17 with SMTP id m24-20020a7bcb98000000b003f7948f5f17mr420174wmi.7.1686301184473;
        Fri, 09 Jun 2023 01:59:44 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id n6-20020a7bc5c6000000b003f7f87ba116sm2003715wmk.19.2023.06.09.01.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 01:59:44 -0700 (PDT)
Date: Fri, 9 Jun 2023 09:59:42 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/285] 6.3.7-rc2 review
Message-ID: <ZILp/l2B2AJ+/1Yi@debian>
References: <20230608175722.489602717@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608175722.489602717@linuxfoundation.org>

Hi Greg,

On Thu, Jun 08, 2023 at 08:00:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.7 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 12.2.1 20230511):
mips: 52 configs -> no failure
arm: 71 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/3814
[2]. https://openqa.qa.codethink.co.uk/tests/3815
[3]. https://openqa.qa.codethink.co.uk/tests/3829

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
