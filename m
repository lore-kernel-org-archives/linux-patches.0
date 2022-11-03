Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D4D6FAE
	for <patches@lists.linux.dev>; Thu,  3 Nov 2022 12:21:19 +0000 (UTC)
Received: by mail-wr1-f45.google.com with SMTP id j15so2522671wrq.3
        for <patches@lists.linux.dev>; Thu, 03 Nov 2022 05:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6UKiNJebKkHGcQAXA3/jGztnsJvVESsNIXBeqOYqZec=;
        b=JUhF8WZ92kc8FoTHdswOHrOfJJDqAmsPj51nbzYhDweatNVqfCOsO/A28XPgpdECpH
         Fbu493NCbpyF5JBxX3m7jOuVJOnowSi2blpDSajvhDg52GxVbZqBazpoHMMxZ0eC9tRa
         MABpXxCZBySbZD1Cmh/Fd59GV+FXa2Y7vsKx7tucwkTaFJOP9uavUtt51B89wz2sCv9t
         WqGMTOnqXw8snX8caGFEdh5cy6Z60eW81ASp9BFcUq6MYFUlctPGp/maLA69XjQghBQT
         5HiBdd88awfJfpwblvvDUDhvUs/a4450wqqNiz2O+vDxkRrX8L2H1YkQ7iY8K5Wju4mu
         DC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6UKiNJebKkHGcQAXA3/jGztnsJvVESsNIXBeqOYqZec=;
        b=nxBlN4Gc0wYFODRIKZy9gPfkzHd9WWh+JsAL0nRRSVXXC6xWuwWqJI7OqRqWHVhI+c
         itQdLHMCqXC1TZAUxJHIlXH4jBApwz97gZqbD4rmT1NWBDcj8kkFVVxAaizq4GzKyABy
         ZCGsuSF7QtZ12JepXJf82jm6FmPFL1Egy8To5jqMJ3qnimrPubMqDfGnJ+bgjkkXgwGE
         /H+xj7mrPYg6jrE8zRueIvNd7SNJcjWf5h93NPP3mUbeAKHYXTLbfcjlR0LJUfiSehCC
         Ufe6Ek/nmMbqjYIU1NeuIlVHVZOgYaBR5H72rgKAdC/YpGpPm2lSpwfx8O4pVIRReNRR
         UWCg==
X-Gm-Message-State: ACrzQf3+KvzpZxS7JbgZSd9Jyr2PSKaNiJJy1bI+537cjyb5Oe00LsqB
	awseWMWpwl073jkUqTM9v+M=
X-Google-Smtp-Source: AMsMyM4aiWjdlsSbUGxWYYjv5V5KM4TxKiLa3JNQ1169ssA1M5jjI1hTWLqvkO5six6ipFDZonPCBA==
X-Received: by 2002:adf:f94b:0:b0:236:c825:e2d with SMTP id q11-20020adff94b000000b00236c8250e2dmr14162662wrr.307.1667478077732;
        Thu, 03 Nov 2022 05:21:17 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id bj9-20020a0560001e0900b002365cd93d05sm774179wrb.102.2022.11.03.05.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 05:21:17 -0700 (PDT)
Date: Thu, 3 Nov 2022 12:21:15 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/64] 5.4.223-rc1 review
Message-ID: <Y2OyO9DDIf+8iZRE@debian>
References: <20221102022051.821538553@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>

Hi Greg,

On Wed, Nov 02, 2022 at 03:33:26AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.223 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2087


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
