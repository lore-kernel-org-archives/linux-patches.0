Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904A712286
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 19:43:11 +0000 (UTC)
Received: by mail-wr1-f41.google.com with SMTP id bp11so7876963wrb.9
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 12:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=80FlYR4ra67WxSs9hG7X4/v7MPicXs8P7V1IbHZmi6U=;
        b=AFmoHX+zTSVWJ/FPNTT7aiVVklllmTVbnNvip/xTAVAd190pw8syBPclWFQiDITFdw
         TJe+h+zO+eoxmhwihRk5RkKLlc6TuUVht9dRQQD205/7jtKrqx1/pVDveXOkq/l9JQm6
         bEbrmj8UMIJDXJWkKLe46uTM+WQTw0SWbw1DoX4qMVLwDZJMIt4xinLZOgvmi5Vm02zP
         mN6oeW7UwRc3UCvJS0w0xSl9gpsvjQLkLpbxoaWRphEwTqWmenOEBgom7a+od7MnGnbV
         Nz17JAyI23+WOg9EYH6FHP9jHovk2Qzw7MRRA+TANLoGD+i0HiLRJsn5W7KlNQcy6W2E
         O+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80FlYR4ra67WxSs9hG7X4/v7MPicXs8P7V1IbHZmi6U=;
        b=ZyuyjootM/XNrn5px9nt1meiZuYTSByAK15B+X8FN9tUKnXwbqRPPwUEOBFcsx6knu
         sW7N6d0hOQ3/mIdT1kiNC6Actc8IghXK4NZwy8EcmiyvZQp75uRNoCCFMGyddWuaNliY
         /NcZt4t1A/oWyLwcV2wR6seKcOkri9CK1JeS0dLtjY3/kR9zyk7I8JiblvO63snHW7he
         0IDeHbBnz+q32aHFnPzxrchTbeUiApdz1QFcTnqSJiE+DSnCHuMNOmMOf0GbU0xUFWMS
         mIPI07cmkzsJsONwZlr3H4c8GtLN/DBUL+eCVMNnz5hd1hvLU0P6IgiTkJ57Mje7KaZ1
         LIfg==
X-Gm-Message-State: ACrzQf0kZgSyCYfD0GolBDMbLhUDvHduhPorCU5oA6yNKU4Ur3+Hme1U
	EhYq+I0oKljadD9F/WPr1Ak=
X-Google-Smtp-Source: AMsMyM7M7lqjoiGpYhS7NRkp4swbbzyv8eD1Jxf0VfzmLRHUirEHIM0KthXXrmNmjjZYXpkcNgqsLQ==
X-Received: by 2002:a5d:6488:0:b0:22b:3b0b:5e72 with SMTP id o8-20020a5d6488000000b0022b3b0b5e72mr567153wri.138.1666986189672;
        Fri, 28 Oct 2022 12:43:09 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id j21-20020a05600c42d500b003b492753826sm4779470wme.43.2022.10.28.12.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 12:43:09 -0700 (PDT)
Date: Fri, 28 Oct 2022 20:43:07 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 00/78] 5.15.76-rc2 review
Message-ID: <Y1wwyzl/2ZX7G4VD@debian>
References: <20221028120302.594918388@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028120302.594918388@linuxfoundation.org>

Hi Greg,

On Fri, Oct 28, 2022 at 02:04:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.76 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Oct 2022 12:02:44 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2058
[2]. https://openqa.qa.codethink.co.uk/tests/2061

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
