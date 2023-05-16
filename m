Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260B3156F2
	for <patches@lists.linux.dev>; Tue, 16 May 2023 09:20:35 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-3f509ec3196so17627165e9.1
        for <patches@lists.linux.dev>; Tue, 16 May 2023 02:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684228833; x=1686820833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bf8niA9dFNqb8/6zqk0cfY1upregS7xh6PWdNGORQhM=;
        b=mUot4xoBX4iGmqkstjP8aDJ3zBNwYhA2G4z426kWrguLoC0BitUwFzUzMQnxxEIgHA
         FtbopgdIm35fJX5ntP5FINCK308Gd6qTfq/m+efAJUTNYfLeflcddgt016YnNIE4VnOM
         YI5ocNCinhb7Sf9b2UDZFacTlcZsSt48XAz48AtqZnvfgrGRpJbYtTR1gKvxMLpCBAcu
         oQ0ZVyQQWStLf8S430aUj42YpUpaFWHaMQGWuYJUSw22k0qpkfAuT5LPwvUYSIhix61o
         lfoHB3/7Gobohxx4bSogCvdsogiyVX1VbtH4RHigNT3CsH3gPHHfXbJJZaXv/zUw/K5r
         dfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684228833; x=1686820833;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bf8niA9dFNqb8/6zqk0cfY1upregS7xh6PWdNGORQhM=;
        b=iZO9XivFWDart69cGPlSVmXDziRQek6o0z13pXXqrb61wPn+AIvEH1+zJ7PQpjener
         pKAOI9P0x2cKnERFg6lBgm9gG/wZ809oAUlWXaPtLp9LHYzFEqA6LeO0op2o+KtnZQr8
         PcxxEnGA1BglB6K0m6Cz1Y6A8ieAeyOZ5954X4T67vvoukuGSJMYh+yrXP0Ah2WSqyKI
         WCbQdZW1o6q+ei7wr6ot/CV1IwEH4BFy4CirN7KSwehl//ANOVcu3QdYrYafOa2hBMR2
         PXR69y5BFDUqG7GaMxtiMbNt6xNc2CzDXuD547mKoxaQrmE00lQ1LcIISOrH07WuSyQv
         ojEw==
X-Gm-Message-State: AC+VfDwi/j2RgCSkOailCLKWy40dYQuiyAkHpZIZipkhRd2cGSzFX23u
	gQ709whLiBzLlqnTMzZdUzg=
X-Google-Smtp-Source: ACHHUZ5eDj7Yehs023857OsvA5mGGLmTFEZC+rtL63WQL5IwzfcHatKOCLG6ZMbny3CyAgPXBC80PA==
X-Received: by 2002:adf:f2ca:0:b0:307:8b6f:dcf1 with SMTP id d10-20020adff2ca000000b003078b6fdcf1mr24326445wrp.25.1684228833127;
        Tue, 16 May 2023 02:20:33 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id r14-20020a5d494e000000b003063a92bbf5sm1904018wrs.70.2023.05.16.02.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 02:20:32 -0700 (PDT)
Date: Tue, 16 May 2023 10:20:30 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/246] 6.3.3-rc1 review
Message-ID: <ZGNK3vxOsQXf3d9K@debian>
References: <20230515161722.610123835@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>

Hi Greg,

On Mon, May 15, 2023 at 06:23:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.3 release.
> There are 246 patches in this series, all will be posted as a response
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

[1]. https://openqa.qa.codethink.co.uk/tests/3539
[2]. https://openqa.qa.codethink.co.uk/tests/3540

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
