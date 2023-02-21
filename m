Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF784C64
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 15:02:43 +0000 (UTC)
Received: by mail-wm1-f52.google.com with SMTP id o4-20020a05600c4fc400b003e1f5f2a29cso3853611wmq.4
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 07:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TkM/rKx6BKDw2NTG9Wlpe47dRHkurVcHEfekPcsHiw4=;
        b=l8Sn/OkgI92MpvVZ3KVSau/sh6Iz/1fvpLLlnAdODElEg0vMVJsHgkeUODsJ/ctZWU
         WDop2A9bmYp5yMNjvcpwWPq/woACJIoq6IJ8kfCGS1fyJ2mJsyJR/IFoEaEqENJppBq1
         Q+GR7qyFuYp+vqJlMXQIPJ5QzdlWcJJiQmZf+XI8vJVdrW+Qf9arUc+sLEuu2o8Do4I+
         AiQF+23xYyl5CCU9eRmqhSttNQh8MhZ0fryiqgTfmvQhe9kxjh71M+NbATihsdwNhojE
         p+WotO1n/SJV5up1optpMwkN9hSjO6mAE8Fon+H2avssKwcthwO7z2ri3aYFRyOvaysT
         g3UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TkM/rKx6BKDw2NTG9Wlpe47dRHkurVcHEfekPcsHiw4=;
        b=VsspopQrbRV8yMEbRROBLrCBlSjDMrfccVaNsBBy69lQywCoiU2u7OslOOLE7GZmdF
         +ZrIWqa9j5RudoZzMFH8j+K51Ql20hAY24rInSkvQtIx0mJNX1yqLImEPSoCVk6I8HcE
         3F9yku1XnVyvDALLHGa3/nZ2uoj940r37HHL7y36+nIAUtWs/g0VlxuuDjVaG4Td/1VD
         00xJ1qHVlhaaZYqx693gRrghql0Rp1R0XSbpnnI8R/3JVksIx84LazxEjDG6uy0eM0w+
         RM5anMJjh2+ChzBZ2TyRv09Ug0crQ5X1jUEPyycEIsSeSLYeWx7GFxNOFe2hRkzxgiQn
         1c1A==
X-Gm-Message-State: AO0yUKXjaPl4PnOHyfF4v8i4fdjbB+yhHaVKMLxVw3KDk82TSNyonraB
	SYnwJKsxIIxEDedL1JTho7s=
X-Google-Smtp-Source: AK7set9qPnhdz0+Gn2CiKXm3CyLfmuYvYrCIm+cUKdvRO6er+3NZoxYTMxy5onPu6ykkCPzc6nn2AQ==
X-Received: by 2002:a05:600c:4b1b:b0:3df:fbc7:5b10 with SMTP id i27-20020a05600c4b1b00b003dffbc75b10mr9576946wmp.0.1676991762078;
        Tue, 21 Feb 2023 07:02:42 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id h6-20020a05600c350600b003e0238d9101sm5508047wmq.31.2023.02.21.07.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 07:02:41 -0800 (PST)
Date: Tue, 21 Feb 2023 15:02:39 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/89] 4.19.273-rc1 review
Message-ID: <Y/TdD1BOQm/2CcjW@debian>
References: <20230220133553.066768704@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>

Hi Greg,

On Mon, Feb 20, 2023 at 02:34:59PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.273 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2904


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
