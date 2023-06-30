Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C593FD4
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 06:16:42 +0000 (UTC)
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-4fb94b1423eso2254141e87.1
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 23:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1688105800; x=1690697800;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Uhmn3RW3fCZZK1xj84ra9lbrAgT4ezYFSHn/zPTSsl0=;
        b=X5ZywbJZoGy8KJYcyA5gRYsmEEWHVlTYNYdy/QQHPb9oZ4GIHIXB0Ex5coZiJnJyVB
         gH/P26N1m8YaaVpLpbzPY986HZ3R2SDzICxhRvqFo3p0sfBxKtbzrt8XD8DOZ8zC4da8
         GOHpeTf4JM9qhLojqURbeY9D0I22cTD6s924Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688105800; x=1690697800;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uhmn3RW3fCZZK1xj84ra9lbrAgT4ezYFSHn/zPTSsl0=;
        b=ggDzqa1XRNzsfnqdw98NE5K/KvQGf2hdcte5QOW6KsoEDXYTOS2nhbbPJXysR5uty+
         ntSovX4WCFWCjKXnjqXs4uAvAcVVAvi6dudbOaUIOCfQ/F+O2W2E3jit8yLiBzE0/P7S
         yjqd2eGb6MUL4s3NMr5mBvmYSAOB5XUzMFUjNf/GD1L6ZHsMVObj48PNxqmfI7Ael4or
         jHOqkOPYRilK4/5uXYeIcG6ys6/soob7IQpn10pexrSpN4dcHEHgcIZI6EgRXtedkyWl
         o8zSj81ro7RqXzes50lvlzyqIpQac1eQgIJ/Siytlp33NSZTgalDUoDe6c8SZY/Fcf7l
         THIQ==
X-Gm-Message-State: ABy/qLblyg0dfUOIC7DdMO3NZj6KZyUXOXCdFoC2vwsPiGk2zvaryHBm
	1bOChbejkUsgar7SzwBgDYW0zSUTYLCgJhyPIgTkoV1v
X-Google-Smtp-Source: APBJJlFBdOzowM79XYTMBtAv/TBB2qqeOhOKmY/SQPz01OhpCGyrMgKtfrX6XTqEz9Mxz8pibMdG4g==
X-Received: by 2002:a05:6512:39c3:b0:4fb:7592:7e03 with SMTP id k3-20020a05651239c300b004fb75927e03mr1600223lfu.20.1688105800496;
        Thu, 29 Jun 2023 23:16:40 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id m11-20020a056512014b00b004fb326d4ff0sm2187866lfo.77.2023.06.29.23.16.39
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jun 2023 23:16:39 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2b6a0d91e80so24279631fa.3
        for <patches@lists.linux.dev>; Thu, 29 Jun 2023 23:16:39 -0700 (PDT)
X-Received: by 2002:a2e:870f:0:b0:2b6:99a3:c254 with SMTP id
 m15-20020a2e870f000000b002b699a3c254mr1390190lji.26.1688105798765; Thu, 29
 Jun 2023 23:16:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230629184151.888604958@linuxfoundation.org> <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
In-Reply-To: <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 29 Jun 2023 23:16:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com>
Message-ID: <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com>
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	linux-parisc <linux-parisc@vger.kernel.org>, sparclinux@vger.kernel.org, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Helge Deller <deller@gmx.de>, Jason Wang <wangborong@cdjrlc.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 29 Jun 2023 at 22:31, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> arch/parisc/mm/fault.c: In function 'do_page_fault':
> arch/parisc/mm/fault.c:292:22: error: 'prev' undeclared (first use in this function)
>   292 |                 if (!prev || !(prev->vm_flags & VM_GROWSUP))

Bah. "prev" should be "prev_vma" here.

I've pushed out the fix. Greg, apologies. It's

   ea3f8272876f parisc: fix expand_stack() conversion

and Naresh already pointed to the similarly silly sparc32 fix.

             Linus
