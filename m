Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D40524F
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 11:17:10 +0000 (UTC)
Received: by mail-wr1-f47.google.com with SMTP id c12so13546625wrw.1
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 03:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=npDbChGxVT4upG8iaPwlFeucpDW9PWHzn2e04HvErHg=;
        b=SXYrhGcd4tqmWcOnaTmKqN+sRnT/WFxWYU4Azd9/iijyM0RUUC9M4K5jXT00g5aZ2v
         OUKYkUwRUBZykOKKB4jAQW0UMlvo84Krd6+CUp5qCOqq43nfd28dXj5wHNKOx2rhVnMz
         VjNN9puvOdzvmaZpbyPe7sJJZub+P9WtcWFmom3Ai9c/YOKsXrntLjfRT2rmRkJbikWj
         SzKK5bqyp1+uzzAHl2Og/PMMrSudaKlKyfmT+XGm2/956Ubttmj5fOoOR0Mb9xdpRO4x
         xk8nLOsB/rlW6yxwX8jWFhi4t1iYFCZpyqeLDCBCOw2qeMRJCosqfL2PpQO+oeEQvhAa
         3NQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=npDbChGxVT4upG8iaPwlFeucpDW9PWHzn2e04HvErHg=;
        b=xupw0COZdFQPrkG+oA6/1pAxJltKSytS2ta0QNKq8/qPQYt/7ja+4SU8J+7Z5hJGty
         a6UZWtq7sS5w3P9VBn4C5y3sHhnXpmUNJ1sbgdE5avKpeljzHTN93rAGvVNCDv661iXX
         oVCwdyuNdS3poXPRo6DMKjQv0ALz3wC3B/b29p/bNKjVWKu6GoFu7gg2n0lmo+hVTxhm
         ncP3eHmtjfAO51iXQoCumg4qzsSxtPph4aZC9ssHqEQT8odSi7csf45YrUGhY6CZMeN7
         Vl71u/L4pNBdLMrvY5wsLhy/DAAINLvIDNrknxNh1ctE6+DkzvdKELzMtTyr+v64oO6q
         SEVw==
X-Gm-Message-State: AO0yUKWVQ2Jy4iqyBgP4StIufxlgC23F5JZrpIDPAShr4yj42zE78/MR
	1DDC234wnzDK92H4ouS1kds=
X-Google-Smtp-Source: AK7set+UJzenSO3Gz/GaTaipnBhKn5GSfxZ5z86bym5kTMn8n+9cf8ur0PJk98JfC7yVX7pPnN9Ayg==
X-Received: by 2002:adf:d0c8:0:b0:2c7:1b3d:1fb9 with SMTP id z8-20020adfd0c8000000b002c71b3d1fb9mr1944209wrh.50.1677237428674;
        Fri, 24 Feb 2023 03:17:08 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id u13-20020a5d434d000000b002c55ec7f661sm11676426wrr.5.2023.02.24.03.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 03:17:08 -0800 (PST)
Date: Fri, 24 Feb 2023 11:17:06 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/26] 5.10.170-rc2 review
Message-ID: <Y/icsrUPXoxqPCLj@debian>
References: <20230223141540.701637224@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141540.701637224@linuxfoundation.org>

Hi Greg,

On Thu, Feb 23, 2023 at 03:16:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.170 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2930
[2]. https://openqa.qa.codethink.co.uk/tests/2933


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
