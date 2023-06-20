Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554C6101FA
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 11:49:04 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3112d202363so2979041f8f.3
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 04:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687261742; x=1689853742;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KcYpNVQaGyRkwsi0hWgjQRd/rnueYbvh3KZf7v3ooec=;
        b=PSs+fr8/kRZ9Rp/e1xBLEc9BrCw/XN3RVLm9JTgXJoK1c2LeNv/Ee+HciskEgp5C8G
         /0a57Z5WfpEUM98+fIrDLzgnvzFGx1kIej+0xmdEroWMZdbEq0skYJXWrxnHs8vRmaQC
         AOkzfZo489qflGRqkG/anzvKXQsnRXv+ePHOLvm8cKwG8wmG07PHTFZi9tCmi9Z78h5L
         lv0qA/kgCQvOsNKbj+oVP4hXaWYgF31hKGozdBus0FPO9TqGS01U0l8+NlqJ+BKkIxRB
         yt6kK9S5/fvUwtGWYmDprdWCJJN28qiWd9GcuBdzeuL3CxFdT8TpBC5cULW95eeIdX+e
         +PXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687261742; x=1689853742;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KcYpNVQaGyRkwsi0hWgjQRd/rnueYbvh3KZf7v3ooec=;
        b=c8cuVCxIPLgDaMM/W7UCsmTBTeGv4U8QEB5Is0R1zs6tEfBjCKAEaezyEkLWwTigIS
         jnYYQikPHdB2NfeStOO8pV/jqifJBDG1oJbVhASNDYPfr59G/xI4tDpHilRTQAohFFxM
         h72tjPXewM1p+E/bDo1s0ib08un49yFzHNAkeRwSQsvWe11ehj7pbi824ytMoXX33E8I
         Hijm8JazLt4dryWMr4+pnqkBvLEvN5UgSlP/2iu/897Tl5AKF5TQiUHyOkbqBmBYMQIa
         GB+/dxaceSsZyKdXbSYZtE0fh/BheYingYEugJOPgLpO1A7B2pW6iAQJZIpXcWqY8o3n
         /aHA==
X-Gm-Message-State: AC+VfDzREjNkWdcAS2ZUrIPjOWsrPhqXCawj+GBBJMVsin7mKd7AVIvF
	9z6BVfXt7aWxGeScX2BkinM=
X-Google-Smtp-Source: ACHHUZ7sjaqbnzfBCWe+7Igx4XocK4yNn7Slik/papkIcItK+cnTPMWY+pyjVfzRTeoFBIHvFSVW/w==
X-Received: by 2002:a5d:510a:0:b0:306:2a1a:d265 with SMTP id s10-20020a5d510a000000b003062a1ad265mr5953213wrt.58.1687261742074;
        Tue, 20 Jun 2023 04:49:02 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id s10-20020a5d69ca000000b003047ea78b42sm1820542wrw.43.2023.06.20.04.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 04:49:01 -0700 (PDT)
Date: Tue, 20 Jun 2023 12:49:00 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/166] 6.1.35-rc1 review
Message-ID: <ZJGSLMfERKxfjNmD@debian>
References: <20230619102154.568541872@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>

Hi Greg,

On Mon, Jun 19, 2023 at 12:27:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.35 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 12.2.1 20230511):
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
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/4075
[2]. https://openqa.qa.codethink.co.uk/tests/4076
[3]. https://openqa.qa.codethink.co.uk/tests/4077

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
