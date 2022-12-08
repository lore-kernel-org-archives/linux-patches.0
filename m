Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F80F7F3
	for <patches@lists.linux.dev>; Thu,  8 Dec 2022 09:36:30 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id co23so925418wrb.4
        for <patches@lists.linux.dev>; Thu, 08 Dec 2022 01:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vzvhVqrPG1tKRsCvh4LCgxjPjyy657R8RcpZzQGS+tA=;
        b=MfLWVAWkrg7h52VP6avmx+dbSJ7FOnKbDMnbrZv1hBqoS/PBeZrYnMGqIjvtu0E1o4
         paMQmnrTbJSSiP/I2KS3u0ICDMzfORmzpR9JjyHzBQ5Tm+TP0fdgGx/IF4yXLmAioS/l
         mYuExigRjT5hHVtnJUIbqY2caTNt59842NceEunJDFuy5vwouDt1t8hUdiLnwV96+rP3
         9pwCRdEBiAMeCkCaH53x2e6N7HyidPVqtmS8j+NzFvdZxhaXY8ejXzyRNdY2e7Yrn2LY
         JNpzfGMJTkRzlabkmjJmd2RiR5R1IPe64e7Twmm18fZpQI7TLizf+8qga8BXyCW3k9wz
         ouCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vzvhVqrPG1tKRsCvh4LCgxjPjyy657R8RcpZzQGS+tA=;
        b=07vpvOelKKYZajiYddezyuDoU6Jj3C3HFPULdueRMqcMAGzNqOJtiRnLIQsWiXAUVN
         llYlB/g293JxWIKDw5BiM/ri6v2iZxbClxSyrgETyRtZgGiDjFaYFe4COKoE/d2s69lL
         JlHMu7mDjbZeIpCWtl9UQ2GczW7eGzU3Et6PZgATecmhrqJduRa2vTON7URCnpWU1q8m
         3n5DIlSrXmVVD/jw1FmiyKNuUfUT00v3Qyu4S07hwE3VH2MTRS9LzluKRvI0C8GjAmdl
         X5igXYMUYuuTA+e+jSITXCl92XuDgUArZCnOF95nk6LCOgTFocG16m5q43I56BJYzTwk
         bTiA==
X-Gm-Message-State: ANoB5pljj87u6MCbue4JmEvVQFBO0RyWft0Et+Rz9iloSfg4XwqKj4h7
	6BC56/LqezFhg68CcbeDBGF67FfH6yM=
X-Google-Smtp-Source: AA0mqf4e/mWcPd5avTxy30ryYO/u4DA51g6lNAEGDeUkrn7fyQ3cEAyZCp8lT5Da7dCNrZ4NeByIFg==
X-Received: by 2002:a05:6000:1d84:b0:236:6fb9:9ce2 with SMTP id bk4-20020a0560001d8400b002366fb99ce2mr1101797wrb.67.1670492188100;
        Thu, 08 Dec 2022 01:36:28 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id j13-20020a056000124d00b002421db5f279sm21422615wrx.78.2022.12.08.01.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 01:36:27 -0800 (PST)
Date: Thu, 8 Dec 2022 09:36:26 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/125] 6.0.12-rc3 review
Message-ID: <Y5GwGrJmtTJWCCT/@debian>
References: <20221206163445.868107856@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206163445.868107856@linuxfoundation.org>

Hi Greg,

On Tue, Dec 06, 2022 at 05:39:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:27 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2315
[2]. https://openqa.qa.codethink.co.uk/tests/2299
[3]. https://openqa.qa.codethink.co.uk/tests/2325

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
