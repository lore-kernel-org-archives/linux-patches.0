Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF0C364
	for <patches@lists.linux.dev>; Wed, 10 May 2023 08:47:29 +0000 (UTC)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-3f4449fa085so5875545e9.0
        for <patches@lists.linux.dev>; Wed, 10 May 2023 01:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683708447; x=1686300447;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LhnW+JP05p5xI3BHymPhzEKMUYpUnBRttHR9ooutHcA=;
        b=sQji7RQpC1tFjw8pY/rXACVFK44Wpz6QpwTSd5NEk2ENdzXVBrzKDiTYt0kVPnwrWb
         bcViRDJcJ4qH7fS1W2LVoojw6+ro/2ragXR43AQV+KAjy+jXoLBtF+9df1TFP9+upcTa
         QDHtFTLJZu/dv4bA4epHAJC7xUyqdvqyiBs+cY+fuYOJ6TDDQ9hJAjROUExK1XUpo5J2
         pe9883TDGNNdRcuJRgGdcSD0SlDUcb8LI/UIOz4dYIFbmog9eqHAh5cWaB1wXdbZ3kue
         MuCBmwNeJ0kn3ArqCQtq325239DDnfnKjjahkL1Z+Un2jtobd9oPPClUOZd1bxxRc/3s
         xNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683708447; x=1686300447;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LhnW+JP05p5xI3BHymPhzEKMUYpUnBRttHR9ooutHcA=;
        b=VRs1DT37i0t797zlDXIgG0Rh4PHoH8A4awcWIKiAXQwdAPg1L2AlaIYfBKevdtOIhL
         X94L4ZM/rVMpLr0iBfzQjAPGgjQk1tqewJ05F+OvqmsQKj5fCRYwwfq17htzREEQGTFV
         98B3WvdFif37QW2R6Hbx6cJ3zNMGN+L+QrS1fcWfSc3OBDDhLyuFcQ10ZdsUdH3tY9hb
         +MktA0slkukI9rLuo0oFCzkCUotY6IAhLSumtfrI+4eMK0VfJEDTgQcjH6BzjdkVfmy2
         eEz4KkC/B+HOAQcKekeyF98qQImquuPa4YyngTFcgmWigfGNJKzTcSD3bSNY9Lox72KY
         FmIw==
X-Gm-Message-State: AC+VfDzLbStX/OjvOuPh/A6KwwQZu44cmMd9nDgJHJv+VqSNi+uD3rGJ
	kmqdIm3/+MuUDLRVhGHCKt8=
X-Google-Smtp-Source: ACHHUZ4FEGxEnQqg2x4qqKQD9yQXQATLp3B/BWp+Z3oK5uLblyLkRX248AOauwQqT+WxGDEplj8xyQ==
X-Received: by 2002:a7b:c8c6:0:b0:3f4:2220:28d5 with SMTP id f6-20020a7bc8c6000000b003f4222028d5mr7786003wml.29.1683708447218;
        Wed, 10 May 2023 01:47:27 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id n2-20020a05600c294200b003f17eded97bsm22087861wmd.19.2023.05.10.01.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 01:47:26 -0700 (PDT)
Date: Wed, 10 May 2023 09:47:25 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/610] 6.1.28-rc2 review
Message-ID: <ZFtaHYsRjdVrVMhc@debian>
References: <20230509030653.039732630@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509030653.039732630@linuxfoundation.org>

Hi Greg,

On Tue, May 09, 2023 at 05:26:31AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.28 release.
> There are 610 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230501):
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

[1]. https://openqa.qa.codethink.co.uk/tests/3490
[2]. https://openqa.qa.codethink.co.uk/tests/3491

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
