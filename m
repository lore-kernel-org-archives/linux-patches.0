Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328A5154B4
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 11:50:54 +0000 (UTC)
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-401bbfc05fcso36277395e9.3
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 04:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693309853; x=1693914653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IxizkUy5yBDTtEGaVTKg6jAoVfIxrNZ5Slb9begCALE=;
        b=QBdSWhTmUvyAjBTnt1XTxEeFQjDi5tkGmhrkexSO8l/M3aSSCFEZr4Alm8M8hA9Hj+
         ASIdCcYrI1RtlKAM0n6DbzsSnI66JpRt8gLK6AtHrx3Y9Vf6exP+VZXSd5bY9dTHXKbj
         pXkJjJ7kueoamOnNozOSLaDd5a308VvaMc3UTPuT9qGWkv6oc+Qj8qzNOonEIC1oRyqk
         neYbeimaZxAfUr/ifs5L5R63gqWeKJSh9+guWKXmg6GKEFuOzv9b94uFNJQ4rTm1PfbX
         nSTaLgdKu7kLLnCL4/ahOq2H2N6j9Lvw3szpesaZyCfiChBLO+dbWpbawq6DI7j1dY/f
         /rBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693309853; x=1693914653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IxizkUy5yBDTtEGaVTKg6jAoVfIxrNZ5Slb9begCALE=;
        b=CLICaHGg/B4IGXARXOw95eRNx6H40rTHK/e0iMx4WxTaaW9AxsEdQkdNO1jvTzXFGP
         /gYzAhlgist4oi4IhYLh7lXfmkZlAqzEEJEjJ0ugnkzJOOHoRFY4CPlRDHE3B8qVg4vw
         WMiRV3CAXSHyNzji1khGwI58BsOsf86jLqWSRmm4chAHAQRBV7Zlq1QKg1KY/6bbXQap
         Qpwq8p+3w8vQtQIQZA2QQw4XOl4Vhlxe2LLUnOT6FsKa8iQpOJuV62EV7roeGel/6aYi
         YhC6oBU1EAVnnU34hYAmUUh9YP1Za8hrztg2iwS+g5kjU4CXjINyxmGA8+Bpgz+F1G8k
         vgDg==
X-Gm-Message-State: AOJu0YxYpys5iUuCDfjetW/GirPUeO7tMH9wLCop7b3ciJJ7ZOKtAAvv
	0C6pxbzSiiGw7W/b8tCBBnA=
X-Google-Smtp-Source: AGHT+IEesIndmqEJay6wwnFGesWsz1/5jdiPC4i14UignA7futhgSXTkmtwkhHT2HeVamd+ca9SdWw==
X-Received: by 2002:a05:600c:ad6:b0:3fe:fc0f:52e2 with SMTP id c22-20020a05600c0ad600b003fefc0f52e2mr15403503wmr.37.1693309852966;
        Tue, 29 Aug 2023 04:50:52 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id 10-20020a05600c234a00b003feeb082a9fsm13812623wmq.3.2023.08.29.04.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 04:50:52 -0700 (PDT)
Date: Tue, 29 Aug 2023 12:50:50 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 00/89] 5.15.129-rc1 review
Message-ID: <ZO3bmkc2J0UpzSGR@debian>
References: <20230828101150.163430842@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>

Hi Greg,

On Mon, Aug 28, 2023 at 12:13:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.129 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.3.1 20230629):
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

[1]. https://openqa.qa.codethink.co.uk/tests/4839
[2]. https://openqa.qa.codethink.co.uk/tests/4860
[3]. https://openqa.qa.codethink.co.uk/tests/4859

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
