Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C178824
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 13:12:30 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id bx10so2507487wrb.0
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 05:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X8YsgKnIJOFyhQ7t2VLMQ+l0kptJ6IwPkdNPAIwj52U=;
        b=e+24v0hMJak1xczraQjZAwxkBmUk7qX8GcEIOjpXyxlZedje68ToeO99k6VVts1dx8
         jo6dfxxfJPzYE310mS+T5urjm1b6hdOfYH7rGUCOz82BaZG8FmZtRjtZc1Y0Hyjnf95J
         6+skiaJWQ4wCpCfstbz1ieEV/X21grU2JjDP6p8Cyke9f/kFAEBifKTij7VaxIjJAoCS
         3p7bQRz5fJM8cZtUtFiCm8HB7XWWsCL93yPJi3K2x+CfPsLaLXYtfuSXUgKVV7jH1kwt
         p6NDtHmedcTmOZT5JjWJa8qF0eSHlMYH1/PY7wKS2dpS9o8kNbq6WccwD3oHS7Z8GKqb
         T3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X8YsgKnIJOFyhQ7t2VLMQ+l0kptJ6IwPkdNPAIwj52U=;
        b=j9yJk9l+tHLjHgZjiT59xUQ6HZZRZcbxQbLeY6BTbqqTpDTmgkSz4tWlV5ZgrrY+Ee
         RVwhBUZqS5D1SS4xvRyViS69+1Hh4k8b4riqnFqA0IgIRMhPwxFCu3upw5WtCspW6qRZ
         pH+CA5rTzx6KzDhVfTP5cMZKbyMYpSCqgjpFWW9K1ywaTfqy6uPN6PEl0C+/3nRGXKoX
         MXmTNadNFX9lr0BOTzIhr2QvfKS7fJkco4J1r12xB220yvOwuI0e2DhHKIue1g0aQPpR
         X2lqKXyZa38IcGhKGE+n0U5quozFBUs6KXwXlGGNSJxLJUPM2HR3UN/ZucCrAHSPq1Uw
         zMzw==
X-Gm-Message-State: ANoB5pnMkK9c+4NWttCGPgDSenC/Dzq2F4Nh4wirSisoXkkXN0i19qbe
	6E14X9rjevNZpmG09ojPanQ=
X-Google-Smtp-Source: AA0mqf45Q5dIuAPy6YO4qn22IivwKdjbN8vmLve0xUekmrOuGQraf/FhRjglL2gPUJkd0W4UjeqMSQ==
X-Received: by 2002:a5d:69c5:0:b0:242:1926:ea3d with SMTP id s5-20020a5d69c5000000b002421926ea3dmr20922040wrw.35.1671196349188;
        Fri, 16 Dec 2022 05:12:29 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id w1-20020adfec41000000b002422b462975sm2253950wrn.34.2022.12.16.05.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 05:12:28 -0800 (PST)
Date: Fri, 16 Dec 2022 13:12:27 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/15] 5.10.160-rc1 review
Message-ID: <Y5xuu/JMKzzL3glu@debian>
References: <20221215172906.638553794@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>

Hi Greg,

On Thu, Dec 15, 2022 at 07:10:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.160 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2362
[2]. https://openqa.qa.codethink.co.uk/tests/2366


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
