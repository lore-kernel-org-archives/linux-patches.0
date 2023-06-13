Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702D73C25
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 12:19:39 +0000 (UTC)
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-4f62b552751so6601195e87.3
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 05:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686658777; x=1689250777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mzJgGG/CDYOhD2YNQTv2CpS/TSd4Qcu56zqodO6IyB4=;
        b=Qbe/SL0po5bwWWWFREV7MhlgjuwUoGjUD82KbJ/MQ2qc0C8XQmnPG3w2pzBDWaBxjq
         pHbZWbhF0e9FOhM1kxt3TbkRYjMuGDGI7W2r0DPVbQxlZgu+EgBeKAr/FARcUpP+88ds
         uS3SMi98EB6c502dbpLPxEkzoFpKcsxGPDkhXY3xCcvXZxCC+RJH7l3zfMmTUD/G7rbI
         NSz3t9a7S6sE6U0tHECE02oadhCvLOxmR5J+jF/ZLEMj+WczhTB6Jin8yS46gIvx2Q/D
         2sYvlkQd2kYY2lvTMLf6cXTS0xuS9fnWaWKZoVFwDQiSglQ2pgErQ9jZqmEvXtrno1OC
         dNxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686658777; x=1689250777;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mzJgGG/CDYOhD2YNQTv2CpS/TSd4Qcu56zqodO6IyB4=;
        b=OuedkISEIdO2fn33r5BMdVJSfERfnZyXZufYmzTd0bqRNo2FVv8poaR4al7QY4EXf3
         GVsSMyf61KFHvbSz1ksRW93XMQ3Sl+I5W9bM3IyStcwnk9N4mNgVWWbNs5u5SMbu2Kh9
         Dh+99MGRQ7BwTMMyarDipjrrZVdOJkYMLE1qw3yv9isvhEtctVnL4+kXYlrvpm0TAAXj
         2+1YSJOSPKZeVKLgLZiyguuwIWyR6uFDGoVWwcQw/hzrmf8y7URqTBfGMv4ob7WHyh/Z
         ueFvBt9XkJQyhAuNd3OG5801ez34mXw2gnnIYqYPFstJUxBlCP1B2sZZlLZUBZeDcW9P
         56CA==
X-Gm-Message-State: AC+VfDw+QiOSzJfZFwI/RQJ4M9QVwxOfyAXMUoxUcof1xqorJOlNT7vZ
	KMWVc6jOmyZUzL7WoNvNPcQ=
X-Google-Smtp-Source: ACHHUZ73NS69UjggKVhkFEj2G1DBNP2JULH1k7n4O+6a0aEVHacXcSMiSNDEOlOremukbrwfskSwHw==
X-Received: by 2002:a19:5f0d:0:b0:4f6:26de:502e with SMTP id t13-20020a195f0d000000b004f626de502emr5281226lfb.43.1686658777047;
        Tue, 13 Jun 2023 05:19:37 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id x19-20020a1c7c13000000b003f7aad8c160sm14252269wmc.11.2023.06.13.05.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 05:19:36 -0700 (PDT)
Date: Tue, 13 Jun 2023 13:19:34 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/91] 5.15.117-rc1 review
Message-ID: <ZIhe1sDoz1bNjjcS@debian>
References: <20230612101702.085813286@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>

Hi Greg,

On Mon, Jun 12, 2023 at 12:25:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.117 release.
> There are 91 patches in this series, all will be posted as a response
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

[1]. https://openqa.qa.codethink.co.uk/tests/3932
[2]. https://openqa.qa.codethink.co.uk/tests/3919
[3]. https://openqa.qa.codethink.co.uk/tests/3918

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
