Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3BF2F5B
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 08:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="itegzj+p"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-32d8c2c6dfdso2700957f8f.1
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 01:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698137341; x=1698742141; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mo7Xx0J6SUzUUTIhfv7Y9XKD/ghnjNlWvwQxCcFYVUc=;
        b=itegzj+p+MNdrzy/qupquVpEJJ2cAlzLsDOXrt80m/grPPCoUp6yKBPac7AjqF1XUU
         tniVIgBG9sPOwRQGna2Twe/Wz7dAiCfYyue4CgQUIIWe9sGBU9svBcQM5yBjx8jwLtI1
         Slbzw1J1kWWKFR/ynzJMcBnCuvbgE3KRV2WZ6eLS8VK0Vs/dhsDR4ZiFGiUAZjhkIeU6
         BUc8h3Nu/KemOaMCNmK04Ncs7Nzj4AvLPLMLYKO2vkmFnTt8dOXRfiQd9eG35ow1BU2A
         fch/m+S3Dr5LWMsf63InhSssdaIGWw/hrpwCngePmvtCACm3w6wiXdcZlLn+fQVlz5iL
         1ncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698137341; x=1698742141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mo7Xx0J6SUzUUTIhfv7Y9XKD/ghnjNlWvwQxCcFYVUc=;
        b=T588gvVHVupZa0zFamdKGfLKwmxQLNw0HmeGn1yCDMM3zxf+Am1WkwPwXafvgh4Foo
         XxcAkm5ABzFnUs3q9xEScHr6fEYF5sFOqfXMIEtdN1vz4RoHO+eC6HUpy+2nwiBxyMwG
         1GPh3yu13dNA5JBQivoNVyeT9ip++rAw9lUf0GsOE6uKGx7tR8EuCDw3/JBiekHnxuyR
         PYuczDMXygry4LLXzVqxHgO4Su//7mBgxOtSq3SwslRMDo0gGbFLaBM3WEvcyGrwTlzP
         RcBavSnwg/y79TP9Qd5flBQwOTS7t953pAkelo83JcFmMWgnn6vZg2UImqd+MoVt25qN
         lAHA==
X-Gm-Message-State: AOJu0YxnMQBWwgWdwINso5rUSjIB3FqwKyYymCPGGAkI2jvqD1uwSCRR
	VIiUYOXSYRnx8aDpHSaFJG97CDFEjC4=
X-Google-Smtp-Source: AGHT+IFYnntQKKmgFF57gLWNDHCriOfCR2w7Uuy18Hr38cyfpNHRgWxpL0oHJ/uZOKpa1PxvtEpIrw==
X-Received: by 2002:a5d:5291:0:b0:32d:a717:717a with SMTP id c17-20020a5d5291000000b0032da717717amr10157922wrv.40.1698137341339;
        Tue, 24 Oct 2023 01:49:01 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id y10-20020a5d470a000000b0032d9efeccd8sm9465323wrq.51.2023.10.24.01.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 01:49:01 -0700 (PDT)
Date: Tue, 24 Oct 2023 09:48:59 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/241] 6.5.9-rc1 review
Message-ID: <ZTeE-_JQy4M2TfO6@debian>
References: <20231023104833.832874523@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>

Hi Greg,

On Mon, Oct 23, 2023 at 12:53:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.9 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.

Build test (gcc version 13.2.1 20230827):
mips: 52 configs -> no failure
arm: 70 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/5364
[2]. https://openqa.qa.codethink.co.uk/tests/5365
[3]. https://openqa.qa.codethink.co.uk/tests/5371

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
