Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC33EC2
	for <patches@lists.linux.dev>; Fri,  9 Jun 2023 08:37:19 +0000 (UTC)
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-4f63006b4e3so1899879e87.1
        for <patches@lists.linux.dev>; Fri, 09 Jun 2023 01:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686299837; x=1688891837;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rtdp6P63HQbGmGq+4yqAlM4nOqO4aijCBboBziskvS8=;
        b=HL6QwiHpTNwuWwthU7HzeB+3aWrkIojrxz0xUZTUkoKw6sId+cfeDXU9xYqxCg+0Fv
         a0qeMGb6kLLgMNqj58xhqzDB0610cLZM0OaYMBXuMUQK3AC3PfVjLpg+lgvnH4e18xCU
         H7mzznYQRKq4kmTiyTqvqUjtt7hhax0Iv/3wYVd+/z0tHK6wmyW9FCaoqAawYQaYkukV
         21bhvfBU8CfRDttBaDzk5ID34fNGNKiB892V2hqFg1ClL/15/pS19AlB0y5pqsedOgVc
         mcosK5oFTG9csyosM+f4c1q5k+dg6SsA1Fa1VFQmxdCob9Zf120NJMdAq40K80OAYgY9
         ENZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686299837; x=1688891837;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rtdp6P63HQbGmGq+4yqAlM4nOqO4aijCBboBziskvS8=;
        b=ImDY1wwnMHV10nETQn+qSSm2WRMJ3P/sB0UkdQYk7di1NThZoEsbUyrevis9E4/l6D
         7YI0AQxjPmgojIIfcWLZZp4AnojGpX+9UPzsA8NxYmtaKI1hEOdhlEwgbT+35mbSkT7z
         UG9FrE1FCOuFEMlB2Tnaun9n64XlHWcOFa0khh2wNzBePwRJRcZqT6RaEgvi4XijdRXG
         ZN0eiLNIXkuT48zry2nrBaJWb5fEtdsyxBh6fpdeoQGy//RjI5zBaxNaKO80DhVRQRCv
         g4A3SUOTPtwUVwHQAwpnQMeH+lcrpO+PFb0lEtGlYXK22tqtDjcFFMvRkxpr83K6UFKY
         SYIA==
X-Gm-Message-State: AC+VfDzqmQHOKjwG4ZhM2SmKx0noaXVzq+I8ROmhCoWK1wZEyENt6XSX
	Hz6MQWmUXndZI3HJHnvniao=
X-Google-Smtp-Source: ACHHUZ5TJ84oMw6e8ieLIW9shCXDG5MXAQT+AFOVmbALeDD2X6VsftfkTQCeS4s4SCTHdnArY9sVMw==
X-Received: by 2002:a19:7b05:0:b0:4f1:3eea:eaf9 with SMTP id w5-20020a197b05000000b004f13eeaeaf9mr431036lfc.24.1686299836724;
        Fri, 09 Jun 2023 01:37:16 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c235100b003f7f475c3c7sm1960076wmq.8.2023.06.09.01.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 01:37:16 -0700 (PDT)
Date: Fri, 9 Jun 2023 09:37:14 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/159] 5.15.116-rc1 review
Message-ID: <ZILkuoWrVfwRmc/f@debian>
References: <20230607200903.652580797@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>

Hi Greg,

On Wed, Jun 07, 2023 at 10:15:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.116 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Build test (gcc version 12.2.1 20230511):
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

[1]. https://openqa.qa.codethink.co.uk/tests/3807
[2]. https://openqa.qa.codethink.co.uk/tests/3823
[3]. https://openqa.qa.codethink.co.uk/tests/3824

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
