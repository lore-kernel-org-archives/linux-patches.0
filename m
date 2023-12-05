Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A7A63DFF
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 16:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QMdrPxC5"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-7c4602ad8baso1352376241.3
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 08:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701793275; x=1702398075; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OmAkQb/1MroERVIyIw0Fp7+C3+mpW6FbekfkXqQHOdM=;
        b=QMdrPxC5GuLK7qxn3rNHk/vB15husDjr7TfFZvrP3eu5k0mHVzXJ45L9YMcVzQADzn
         jaP8aOwR1EVbpuGqBRljcBVoRnjjuAyflHjyNmKDL5F0E2pXTEZftgDRPH7RxB+OJmVs
         zuPfdq3ldMywyNWozBpOJKW1ofpuwlaVBWBD5bRYarKDYOhFVxkNtovnVDvlQmrGTctw
         c5TwZfFvXmINyBw7CTTYb+mlo3e4en7aGMZxNZs9+WWdzlhysDUlzHO10uj2+8lCn1+m
         mjQ+k5mAIkrWjOxh5B6Itu3QpfjPgB44w4MBLH/IjoN7xS9TLSi0n/U8XvH6BCR0DO2C
         80lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701793275; x=1702398075;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OmAkQb/1MroERVIyIw0Fp7+C3+mpW6FbekfkXqQHOdM=;
        b=f1gHiTgFrPcDSson2H5en733Kw0Kgfh2jl3NKHVp2FBIQlMny0aK/zxHeSfuXfkbVg
         4FVaSDVtLz1C4XxUR+CWATxnaXgaoLcwcozmWXYB3sbvdaVO9vw+2W+MT4N9PVHQ5AEN
         LKV3fM/xzA13ZsLa/j+p6H+ozfDtuqh+DeZ/82YWu8xOf9T04pJ/R+AULs0UsmR7/LI8
         jdOEdm3VR/pHLGBtCcq8ZQ8kZmIWB1ze17F/n1dJC6rCZ0TVfOZaPsiBgy67LoK2biR/
         5GtOs1RB8gscEsUmdMg/igseCV7TKFRZKbtQvgXIQ1uvj3emsHO6pc1P3eCRvDEHnKh4
         8iAA==
X-Gm-Message-State: AOJu0YzJ/5I9b+ktF40qUT6lhxf8R+OU6TX9Ibt3+ceNbLLSVB9fLKSv
	h12fVKBu+r8JsUhUEzxNgyy3VoN75bz+B2onPdHY2Q==
X-Google-Smtp-Source: AGHT+IFKdDeq0ZdVTclJaBsMXkTDIpAHb7IkgfNh+LabXJK2B4KIqFMn7aJn4bBqzsCyBRaPx1Kd+vEDBP9x2g3onY0=
X-Received: by 2002:a05:6122:90e:b0:4ac:2316:5afa with SMTP id
 j14-20020a056122090e00b004ac23165afamr4338177vka.12.1701793275028; Tue, 05
 Dec 2023 08:21:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205031531.426872356@linuxfoundation.org>
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 5 Dec 2023 21:51:03 +0530
Message-ID: <CA+G9fYt4DSUQA-zcuZUxVnoSx+DUo0ZB1sX=d2SSwBaD0s_a+w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/107] 6.1.66-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 5 Dec 2023 at 08:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.66 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.66-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Powerpc, s390 and riscv allmodconfig failed on stable-rc linux-6.1.y

 - s390: gcc-13-allmodconfig: FAILED
 - Powerpc: gcc-13-allmodconfig: FAILED
 - riscv: gcc-13-allmodconfig: FAILED

S390 build error:
arch/s390/mm/page-states.c:198:23: error: 'invalid_pg_dir' undeclared
(first use in this function); did you mean 'is_valid_bugaddr'?
  page = virt_to_page(&invalid_pg_dir);
                       ^~~~~~~~~~~~~~

s390/cmma: fix handling of swapper_pg_dir and invalid_pg_dir
 [ Upstream commit 84bb41d5df48868055d159d9247b80927f1f70f9 ]


Powerpc build error:
arch/powerpc/platforms/pseries/iommu.c:926:28: error: 'struct dma_win'
has no member named 'direct'
    *direct_mapping = window->direct;
                            ^~

powerpc/pseries/iommu: enable_ddw incorrectly returns direct mapping
for SR-IOV device
 [ Upstream commit 3bf983e4e93ce8e6d69e9d63f52a66ec0856672e ]


riscv: gcc-13-allmodconfig: FAILED

drivers/perf/riscv_pmu_sbi.c: In function 'pmu_sbi_ovf_handler':
drivers/perf/riscv_pmu_sbi.c:582:40: error: 'riscv_pmu_irq_num'
undeclared (first use in this function); did you mean 'riscv_pmu_irq'?
  582 |                 csr_clear(CSR_SIP, BIT(riscv_pmu_irq_num));
      |                                        ^~~~~~~~~~~~~~~~~

drivers: perf: Check find_first_bit() return value
 [ Upstream commit c6e316ac05532febb0c966fa9b55f5258ed037be ]


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Links:
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2Z6hXBQ5SQY07zKJyG6c3B1W9M0/
 - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/builds/2Z6hXGJFTdSPKZSutAt0vOOcDd1
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.65-108-gc1e513337d8b/testrun/21509082/suite/build/test/gcc-13-allmodconfig/details/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.65-108-gc1e513337d8b/testrun/21509040/suite/build/test/gcc-13-allmodconfig/details/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.65-108-gc1e513337d8b/testrun/21509172/suite/build/test/gcc-13-allmodconfig/history/

--
Linaro LKFT
https://lkft.linaro.org
