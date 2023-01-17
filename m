Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D7723A8
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 12:27:15 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id bg13-20020a05600c3c8d00b003d9712b29d2so25686145wmb.2
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 04:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FU6WkRe9hFxrq6Tsp3Ga9E9BKQlPB/TCyToG9zfxCJ0=;
        b=b4kpqDx2WsKMvlHqzDeSu6ChAc0tfgEWDAp437Bh67E7HOkGw0ynbhjkuEs0vxKYrD
         yGKWmmQVeC+n/6ueSyCe/Fkt+SLkQn1kAVC4iYbp4RnEquilY9dVJQTyaBwYE+q88esN
         +DrRK0FZmodXetCtOeJCkWOJYyIa/imjIbrl8TY+l8B5ALvDxd+/MaJwfvgDYrkCUokU
         fSGZW1I/98mwRiPCVycsDA7PRn0ILxdzFjx+N0sUr1xX5eh90Dfj7D/cmZ9dVT1HMEZY
         3aFSvp72Xk/8YWBarU6soeVESKC15lSCq9zjaPVcQ5riVxcrsCusc7hewPwlw8vj9U8Q
         uriQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FU6WkRe9hFxrq6Tsp3Ga9E9BKQlPB/TCyToG9zfxCJ0=;
        b=B/JSVS0GPN/g75vuMu6/0nIy5TmJTBB6+VQ1Jf8cfnxQJnOBlIk+aQX3Cp9YQARCrE
         1hzFANLm2mBHr3i8jVfV9fqXp8jvm5RdfYjmVGiHjM45x1DAGPUjtiC4W7Tc5dxVUtau
         zFRnRYul1PsRawv/SL3xjvASufmww50a9TkS1ECIQt6ss49MfmQ+kcIr3l1tG9Q/oCT4
         Q25HDrJnAH5Ekbn4LjziYJguxmYAnqB0duXAzPtQN6imSU7JbFIYEcdsrT9sJDEgGWz2
         FBHy+4LjOacsAx7X/ywW/wrHmshkSOZjzGMXvNHr3YVPQD4YoiwYhzYw+urnfnXrrfmR
         FqtA==
X-Gm-Message-State: AFqh2ko9b5i5gLEhjTqtgtsWpS9j71k/u7ozfTQEz6nQ14PKfIave7kw
	URZ0Pn6nY3PdxoR6nbkfgkM=
X-Google-Smtp-Source: AMrXdXujlnw4ci9b9SeAJHZulwAMVjpFlu82KQ4ygtwCl3APlFIiWWhyC32b+ajc0TPIt9ptRZzFaw==
X-Received: by 2002:a7b:cb88:0:b0:3d9:f801:73bf with SMTP id m8-20020a7bcb88000000b003d9f80173bfmr3001591wmi.12.1673958433866;
        Tue, 17 Jan 2023 04:27:13 -0800 (PST)
Received: from debian ([67.208.52.125])
        by smtp.gmail.com with ESMTPSA id k30-20020a05600c1c9e00b003d9b89a39b2sm40832747wms.10.2023.01.17.04.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 04:27:13 -0800 (PST)
Date: Tue, 17 Jan 2023 12:27:06 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/521] 4.19.270-rc1 review
Message-ID: <Y8aUGsZWCLGSp4iN@debian>
References: <20230116154847.246743274@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>

Hi Greg,

On Mon, Jan 16, 2023 at 04:44:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.270 release.
> There are 521 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> fails
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
riscv build fails with the error:
arch/riscv/kernel/stacktrace.c: In function 'walk_stackframe':
arch/riscv/kernel/stacktrace.c:66:36: error: 'struct pt_regs' has no member named 'epc'; did you mean 'sepc'?
   66 |                 if (regs && (regs->epc == pc) && (frame->fp & 0x7)) {
      |                                    ^~~


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2659


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
