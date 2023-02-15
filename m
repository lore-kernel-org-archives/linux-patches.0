Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674BBC5D8
	for <patches@lists.linux.dev>; Wed, 15 Feb 2023 19:03:58 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id j184so8479381pfg.10
        for <patches@lists.linux.dev>; Wed, 15 Feb 2023 11:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6JQaHVGzKqqN/rCfFJ1z8PwWnyDbd3wsfGz9fkN1qoc=;
        b=GCO968mmt3mnc3Z/hiDLjNxUcwosT+FFnenFoUEKMoMQqJVeaDBsV7lAX7MH2lUYzc
         iFpu+qHshJAWp9ZhMyuG1P8zDKAxT7FLnI6aXShOxIReFTIgaBqhmTjBByFcDs7x/Roo
         El3xBLAvEMP02c90zlKc4FYaR59ja8Z3gBR/Aq17/ET+HEGstVCoxBFLcJjwrMHpYUze
         1D7rzENumYM7erA4gh3P5Cqh3+jiqUja3CRmhLFYyTa8Ihk45/berp/8ralnz+vAfzOy
         tH851wnCcbsW3Eo4Nf1FYzjOmTlYwupAvoyl8O6m1T9hKbobZOwjWCckSzfa1psH+ful
         HyPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6JQaHVGzKqqN/rCfFJ1z8PwWnyDbd3wsfGz9fkN1qoc=;
        b=XKxs+Sg2lPwSZrwVYV5xHha4V4L35OsInihaV2bp88aOAKjATEgBYPCvp91txgz2BI
         qkTLnl+Mma5A3ECZZLG+O+gOn4Ym+tyQr8Rxa5zEWbHTnGmd4Aj6RORX2SZ2syuFd0XD
         dfQmmVN/7GgjeVJmN2OsTquOtdFgoMxHX96lMRcPqwsYs4EbW5sz6amH6ErTktqqaRN3
         4YeF7Wrr4YT/TKdTVTs6nj1+622DcUhKIxvcdBrvkD2aUzXRwBpE12IOZX+KB95XgKtK
         WUGVP+NNHFvTEpSEFZsAvruA2aFtaxgI83gL22kDk/JEndlkDdnpmRvgdKk7DdQ5DKvW
         whcw==
X-Gm-Message-State: AO0yUKUOFiYI1D4MDcHPg9qZSjq5eUfdwmVyHTLAmGeiQhggGO4urPdt
	gun0AAbTctOUgIV8NZzSPhD9GrBcMPlw5FszYb8=
X-Google-Smtp-Source: AK7set+EOaHXrqqUKR4rzgfzoqZlIV0XPvx+6ZUhukUamfJDXPHbqKwUAfa7PuuS8Rzu4DqyZip61l+ZEWDD+QAg/o4=
X-Received: by 2002:a62:1dd2:0:b0:599:234e:7e82 with SMTP id
 d201-20020a621dd2000000b00599234e7e82mr554552pfd.53.1676487837796; Wed, 15
 Feb 2023 11:03:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230214172549.450713187@linuxfoundation.org>
In-Reply-To: <20230214172549.450713187@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 15 Feb 2023 11:03:46 -0800
Message-ID: <CAJq+SaC52Y8ZgQQwoZ0Wzj-JHUtC1rJNQkQNKt=-8kFRkOXELw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/134] 5.10.168-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.10.168 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 Feb 2023 17:25:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.168-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
