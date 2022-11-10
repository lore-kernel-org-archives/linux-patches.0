Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9658185E
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 10:49:31 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id a14so1661404wru.5
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 02:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ROpwLsXYHkdh2CbpdpjA4gqQDALR6BVreGb29JmqqV4=;
        b=ewmo6yr2wRsqlz/gf2IIBFKaZ/YFq2HKcXp+z6/aA51pJR0btmdUT81p3ycA9u/yXW
         cpMa1SpFNbhtMwjGSJ8DJuvmfrUpX9w/1+wNTzjYtKYIfEwtC+Qx+OUZYuA+7ND2EGNY
         +/zo3VbC2V/TDDZ+fL+Iy9SrbUakTGFIMgHvQqPq3ceAKlmp4gvS8kwyjikBLLOHkp7+
         J5HAtSXFrm1kqN0c8TrC5uBwZjGr4Jsiqgv2f9QS8dHvjCJMFEm4rmb+Zp7moqwkQTdr
         M8TS4pkId6Xtqiqw7QUCma2ipXSzPqK9pe6X3sXJudcu/Pss+5gmuQmBZw4tdPEuy8mO
         Wq0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ROpwLsXYHkdh2CbpdpjA4gqQDALR6BVreGb29JmqqV4=;
        b=S9Q0r+qKoA95B5P6ajJgw2teetf51J/p/iBZKKY4RGGqtr+IzhpmDctkLwJOZdROis
         Vf7E6hgrkX9kGlbW4nSiy+/hYqUO3mksQQ/6BJF+7rk9Kul+aDBOUUgOrkWEfm6/SjT/
         7Xb3xfHZCkeM2uoW/NBKcCwUxCPJ+VEvktPIzDx4aU5t4EhrG9yrgdMX2zirXuqQIJQs
         jV+ZcySfmtoQjlMK1pxmUooe3MIQPxsaRZ6z8fMOJbMpFlEILTodAhoHrhhaiy/57O2+
         aB/SqlzeeVjDdfcNzIFJoZ00BpokjKfDIZzeQyhBah/tv+XtUrUNLKUr1KCvjl4ZHMEk
         vTjQ==
X-Gm-Message-State: ACrzQf0SsywmzO8P5b/lDqPVgVKGd8dgPVwdKCOVgW3olH0jMrClQSW6
	JrxGwItkmF5IQTQob5coc78=
X-Google-Smtp-Source: AMsMyM7g+PeXgffRh/MYCK4llbFoXF19BLntOaOCzFtKL1RLY7yHSGjid2lEcs+Obxf7V3wEicD+8g==
X-Received: by 2002:a05:6000:a11:b0:236:7685:e7 with SMTP id co17-20020a0560000a1100b00236768500e7mr42754468wrb.359.1668077369945;
        Thu, 10 Nov 2022 02:49:29 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id i5-20020adffc05000000b0023660f6cecfsm15607950wrr.80.2022.11.10.02.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 02:49:29 -0800 (PST)
Date: Thu, 10 Nov 2022 10:49:27 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/74] 5.4.224-rc1 review
Message-ID: <Y2zXNzYcoAnMKd6l@debian>
References: <20221108133333.659601604@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>

Hi Greg,

On Tue, Nov 08, 2022 at 02:38:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.224 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2132


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
