Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99157B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 12:29:25 +0000 (UTC)
Received: by mail-wr1-f43.google.com with SMTP id f11so7386775wrv.8
        for <patches@lists.linux.dev>; Sat, 11 Mar 2023 04:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678537764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EGHz0fJPRD+mfnBHrFBegYlbXI3MqDWp40pyWHsBvyI=;
        b=JH7LJfYFhu+kfjWdlaQw3jlJ0NdbosD4h8yGasaNuOdCOwiVmX1bGHAiwI9NFNa+zB
         9hv0JTYJ0ab+MRp/9QG6QTMupQOKxlCzYIEy3HKDYHMV4eqA4WPwHyJ2spgM0WUv7ETb
         mcc4mhvZuq6eafbU/rbRSY7pUnGmfM9mU/8wAZ0D9zDi1EQoG2tVtq84bMnwpuuLP12f
         P/j5PhQ+yR3lRmgh9zLn9gR8F407KWjZ1zamf96yEemUsLCD+0C34RZtAIMmbpcFObxT
         Xq2vkyskYDL94o1YAGPqXzeULOUHKopOIiV+K1DYrHRxY/BX5465gvyyzml1LAwVYChF
         PuoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678537764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EGHz0fJPRD+mfnBHrFBegYlbXI3MqDWp40pyWHsBvyI=;
        b=uH5eIBbcCSfHktwPmLM7o3BgKENwRUVUSvnQk8+I4lpG045CvcMTAtHNDtE/q1udfu
         IFp0FqDQcJOB2IohU0uahnmaQ52j+PgPgcUBf6dxsntX1jR7yILw7KT52RivF1jjqsif
         tIMsbFc/CvBFCeF1GwqaxFyhLJm04DbSrWvhcH7PHkj8ZAEdJsUovSHR2cx8NWR+JiSc
         5oWOLqTKIzqHS7A5r6GlvNZ+u1nrYDvbfxfJEn8rzkdQ31wXWbKTtlqWvJu74lAkFKdW
         OQqHjsC1okYUYDsu+KIES/HCLXU2E2n76FeAi3CV3wy0fSEzITiTGOkHlubtNf/wVJVM
         rV7w==
X-Gm-Message-State: AO0yUKVIriMJ6HCU8dWqNUhPfjNUCAI1bHbEVofz0MgvaUCXFomc7qE/
	cd+DE5YjniD5ob0DPxrqq/k=
X-Google-Smtp-Source: AK7set/o3qJv+B4hk928bHCUA80aFE28ZVQmxmKijrzikeVPeKa1eZxlsCw693E3pL9SxV2iLUd1qA==
X-Received: by 2002:a5d:46c8:0:b0:2c7:df1:a09d with SMTP id g8-20020a5d46c8000000b002c70df1a09dmr18447655wrs.4.1678537763884;
        Sat, 11 Mar 2023 04:29:23 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id q6-20020a5d5746000000b002ca864b807csm2503494wrw.0.2023.03.11.04.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 04:29:23 -0800 (PST)
Date: Sat, 11 Mar 2023 12:29:22 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/200] 6.1.17-rc1 review
Message-ID: <ZAx0Ig8kLHwnndcA@debian>
References: <20230310133717.050159289@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>

Hi Greg,

On Fri, Mar 10, 2023 at 02:36:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.17 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/3076

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
