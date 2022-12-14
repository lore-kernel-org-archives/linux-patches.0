Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAF46121
	for <patches@lists.linux.dev>; Wed, 14 Dec 2022 11:29:42 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso10323746wme.5
        for <patches@lists.linux.dev>; Wed, 14 Dec 2022 03:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mcLQq4wc+ePTHz3KFhqZubKSfpBbFf5K0CB+YZPtKSM=;
        b=Zam1SMBfYxcb3eWkKkAgO1GAYvO4X0jSeqgPj4q3NqwLkNqK96FNV+lv0IIxIXkG6s
         105qRPJi5Z4MPvXWUz7JGsoq5Vlh6kqL8z0XBwMSVf4FGLrrJQg2X7tBtD0AwLZMRqLi
         dGTcwwvpO20on6IqRdqTK68AohPuVg7kTTZuAvIjT8vSnvkul/czMpqr3ssfDbxrb4i6
         VsqyfxnMoPsrM6sROKcuO+ZaftJoD5zmMksj3zGlpsV/MeNOLXiHVhEI+a0VFqk6F4Oj
         /T0Bw3/K44w5DKkFlno6xrCTymBYo2xa0Ypp1Xn7kEUEz+oIBtwAI1dOc9JsYcr8nUU+
         MvNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mcLQq4wc+ePTHz3KFhqZubKSfpBbFf5K0CB+YZPtKSM=;
        b=KTdvCmjY7vceU8tRuidGvQF8scy35m6uUrhxbE1SghSmZh46Np+oBoiBKen68zOVMg
         PfMchsf7iHKi3uK+JZ/1hpq2vDWCAbpspyTftNRT4YfOCEB635nEq223HbYa1Jr6y7fz
         5IHafETY9jdJkZI7148Ym06ZUu2/9ibrDxtCEXnhz0B89zKDaAa6RNfS23+z1PEiyxGj
         NtG3ycaGqw+rjWO0PGXa/3TZjvr7FNOx8ptiEh8KzpeItSLxtzFyYaJrFL84ANsFoufU
         wblnhA0sudjtFTWwHN0wBIlKlgemopu/jfeHa/Tbv+v630sF/kz62FjtZynmWZizxTXA
         sFow==
X-Gm-Message-State: ANoB5plR72lFQqrakEfWahMI98Kr7Je7n2x11/iAcukJWCqxQWjadrcg
	WRGj1ivx0RuxLPHpI3tAuUk=
X-Google-Smtp-Source: AA0mqf7lDYYUkK7sP38Nz0FEvE9H0oB0J6UD9QcQDsyawLTj2Drdb/ngTXV5z4/F6MWDtrYnupBGtQ==
X-Received: by 2002:a7b:c00a:0:b0:3cf:cfcd:1f5 with SMTP id c10-20020a7bc00a000000b003cfcfcd01f5mr18075728wmb.38.1671017380706;
        Wed, 14 Dec 2022 03:29:40 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id t1-20020a5d6a41000000b00241dd5de644sm2518985wrw.97.2022.12.14.03.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 03:29:39 -0800 (PST)
Date: Wed, 14 Dec 2022 11:29:37 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.159-rc2 review
Message-ID: <Y5mzofTHKUW0tRME@debian>
References: <20221213150409.357752716@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213150409.357752716@linuxfoundation.org>

Hi Greg,

On Tue, Dec 13, 2022 at 04:05:08PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Dec 2022 15:03:44 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2350
[2]. https://openqa.qa.codethink.co.uk/tests/2352


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
