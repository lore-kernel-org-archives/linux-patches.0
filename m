Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41893C25
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 12:16:55 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-3f8d17639feso4109715e9.2
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 05:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686658613; x=1689250613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+FzLHkawDTmgf/nMvF5LHf5GXlbo6Jv406YOG07Vfck=;
        b=lvoTvQiicX7z+8+LT9Sf2J9hdSt+8BqjBCOSz/8McyOOtxsXoTuUdKMvUoOs+Cmv0n
         zm/onpH8krxOFB8XWQ3HqaJcdd3BdQ+SuDbZVja91hqObFerhNf4zizVkPIHFVU4X54o
         gsJ8hpoY2tvHlPnPJAhnsT+yLEI7tYLtDStEiMVcLoXDqDxw1ut8HkG6xIbUkoPHzcwN
         7L2VfCp9ABvhCjBLvlS186FRBsAzLZak+Wpuv+/2XEmisba+k29LhouhzyXbdwEjYYFY
         iH1txI19z1qnjySq+0QBWNHceO1MW5d43AsLHEfqorNGViDtujO7QxaYRyte4GYFOOtJ
         eVGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686658613; x=1689250613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+FzLHkawDTmgf/nMvF5LHf5GXlbo6Jv406YOG07Vfck=;
        b=UX6jp3L3StWcaOrYkiwO2xOzErsujZIxa7m84qjh3ya8zWXFgwlUpT4mgw0qBVWyvb
         wlLWXrOybE48w8NBwp0UcuHB9ZS+mnuGWL7B4jZU4arXAxqKCwEHiprjcHfeiHY8ubJ1
         rReJW4ZbGeP1imnTOKDhI7whpdhtwqBmcvMI2erRQIwAr+QzYfhfjzmf+eyMt/2cQn9E
         tFp8cOECkPv6D2TS7hzkPPUcAGHGJ7+jF1t8oTVwRn46hrvc8QanU8ij6C+PoN7jUf8W
         nkpDtgo+PPhmCXz4N6Hg36CIH68M4LqNxX3cV3OpOcnBHeBAfT82BhM0wkF96Fy2jD2x
         EKVQ==
X-Gm-Message-State: AC+VfDyxcQ+eqM0UGuxrKuS0+rUedKrB009YYi1/AzzLSht/f4TyvHCx
	MLvoOE7il+LYz3/k15SToVM=
X-Google-Smtp-Source: ACHHUZ5OapvFYuTyAxuyCS9DWKf/UNbphhKlMU+zel3/Ljc1xgoTVB4XMMxeB/rqp0W01JWUGLvsRA==
X-Received: by 2002:a7b:cd19:0:b0:3f7:f90c:497f with SMTP id f25-20020a7bcd19000000b003f7f90c497fmr10066936wmj.25.1686658613371;
        Tue, 13 Jun 2023 05:16:53 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id x25-20020a05600c21d900b003f60faa4612sm14287529wmj.22.2023.06.13.05.16.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 05:16:53 -0700 (PDT)
Date: Tue, 13 Jun 2023 13:16:51 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/160] 6.3.8-rc1 review
Message-ID: <ZIheMkhpQ+p9b4W3@debian>
References: <20230612101715.129581706@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>

Hi Greg,

On Mon, Jun 12, 2023 at 12:25:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.8 release.
> There are 160 patches in this series, all will be posted as a response
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

[1]. https://openqa.qa.codethink.co.uk/tests/3923
[2]. https://openqa.qa.codethink.co.uk/tests/3925
[3]. https://openqa.qa.codethink.co.uk/tests/3924

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
