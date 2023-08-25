Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCB1C2D5
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 09:09:13 +0000 (UTC)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3fef56f7223so5994185e9.3
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 02:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692954552; x=1693559352;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BlCKPb+gS/u8b2HNdafG02mmprfB5qP1z6F3xKmLKkc=;
        b=lyxwtosEE9udg9BUrGOeVC9n09rQIpZ8DTt9AoyUcY0b5Y92IIfHnNqAQWvxCwHxUk
         yVrNgSxXiRXv8tV43Qc9zyreubVDqRmDxm3E8xJzP85ZcDsSEAV/X3qd87sp4IhUfb2X
         JGlJ6IVHSnujSpAqjcacuvrwewTPdYrbjkl5vGLIjGKax3BZwfoNZXhHR5V1GK9PhT0c
         UZ09uZS7xA465aBMkiTjuFLBXKjlqUrZq77MfVntfSZ1+YRT6sI3G+U4tDoHGP+T+bR+
         5a2455/WmeoV9X6ZsZ9SRNgAMOeQB1ARBkld5qdl+2qbg066TzG7FLYOT7YoqYJC+O1Y
         LePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692954552; x=1693559352;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BlCKPb+gS/u8b2HNdafG02mmprfB5qP1z6F3xKmLKkc=;
        b=f3Hb0PXTUnuSO94ccZITr88U4/jff1wWhr+NNc5qG4mxs2pZkjF9Pbw2IIfhHIi8CK
         zZsBN5lJC/YMW8GvtMWI1TnLLS+FsZXEejwZIRkTRxIkFzZ4QMll8Z62M0bMKbVnqmoD
         aJIhDSpyenU7EVj4z/yiq7xPvRYqxJ2RN+QG+/+CI+hAugAY3K16GIa32h4UCBqGSmBB
         rb7318+GymwQkcUSe8WXLu55/uJvfwUL8gn3AbeKStjzwqY/FD6NkzqH6q2+v7rwRz6L
         eI7CPdtSxSm84V0S3cnqfnstT5pGUsOmBPmwu3JbIBgG/pgc59JJ2pfpu6UT9keDlaSo
         yPtw==
X-Gm-Message-State: AOJu0YxPThXXswAvQo8zHD5F8+DdzBVTMWEgKJ7FKAhkTNw58ret2Ht/
	kGSa5FwO8GTl+Yov+Fv3Yrk=
X-Google-Smtp-Source: AGHT+IEEvUTNIeIpX92kaNzNg6zFx0Ysh39VmTXqvkAAIcYoZFcL0Lm/wke4qo/TJ3e3dEM4nes60A==
X-Received: by 2002:a05:600c:2248:b0:3fe:2bb1:11ba with SMTP id a8-20020a05600c224800b003fe2bb111bamr14300392wmm.27.1692954551583;
        Fri, 25 Aug 2023 02:09:11 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id p18-20020a5d4e12000000b00317731a6e07sm1612026wrt.62.2023.08.25.02.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 02:09:11 -0700 (PDT)
Date: Fri, 25 Aug 2023 10:09:09 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/139] 5.15.128-rc1 review
Message-ID: <ZOhvtS9fxHHLpZW3@debian>
References: <20230824145023.559380953@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>

Hi Greg,

On Thu, Aug 24, 2023 at 04:48:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.128 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 26 Aug 2023 14:49:55 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.3.1 20230625):
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

[1]. https://openqa.qa.codethink.co.uk/tests/4793
[2]. https://openqa.qa.codethink.co.uk/tests/4794
[3]. https://openqa.qa.codethink.co.uk/tests/4784

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
