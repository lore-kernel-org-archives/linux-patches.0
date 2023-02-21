Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8134C64
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 14:57:38 +0000 (UTC)
Received: by mail-wm1-f50.google.com with SMTP id l6so3423794wms.3
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 06:57:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4H9Mx/yKZ3Hus53qi2wHVToOwmIjYjSCkNX7dVFqCwo=;
        b=F2QVHq2MCLZT2G5xJA114eev7sGqCMrd7Io0D+KtpUjacTeZhDiQ9UixCwB1qbmptO
         dWnBgzBbqEDLMGlhxBVmRgj7IcKcxRD39kHShMHrEzeXoYAo6wN4RKpKig9W6tqtNUTt
         2UbDIjuwX5Tir3Q305RwQWwA5koLQAa4CMCpx3jKvGwFwHrPU6USlvVujdgJqP0DD4cK
         VGB9Wk3iQV0WEmmPfqzCXdRAturixbDMT+U6x/0iH5nMDlSt0utdeASuG3ox7jX1RS+Q
         WDqrHMWdipE2fhrI/Ku9CuzS8nE1ggzLRNisrzLwkqYWgoYo1w9KF8LfgwEjWY9O6+4x
         DP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4H9Mx/yKZ3Hus53qi2wHVToOwmIjYjSCkNX7dVFqCwo=;
        b=DK9VkJLA54cnM4Ur5Y1aAHjMw0+B1mkNfKwghlebDQEE+LDH6lTvWBfgvAzEqYxcC/
         aouoWBjlVSsf4jWoPpjaJCtWHMbcRWcmGjw6HKt6iwbPzMAQ73xRu2hf6qceus7yI0Il
         bQBZQ5CUwdkQYCk6ltUXvGUouT49rAiRSQYy6dlR+ce5M4JMlSFltdS284DIiggITDNN
         AyrfxEIIWYlvvxOaDb/kd9OUvJ0a2H7ApYXwtveYP0vvXwXftBSwfx+UKmnzohYJXy2A
         OpnGbkua807QsQtlZDTyfbgMPT/YEawlXsopFfrBV9nVlnLmxnSI0i31MQMnFXTj+/S4
         eTxQ==
X-Gm-Message-State: AO0yUKXc+DKwr2fK7oV6rMdolDPw2gJ+aDgNYmNLk9muGDtEvAgXzXWZ
	DweFuc7Pjs04Qf/xnv2wnf8=
X-Google-Smtp-Source: AK7set/tts7I2v794GNeEU0xjDE4f5TUNTMY6f68NtdjKBIJ0UWaYFSZ0sj6Q7mjoYHCqSjqfrEI4g==
X-Received: by 2002:a05:600c:3b11:b0:3e2:669:757 with SMTP id m17-20020a05600c3b1100b003e206690757mr3471234wms.10.1676991457308;
        Tue, 21 Feb 2023 06:57:37 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id r18-20020a05600c459200b003dc433355aasm4595702wmo.18.2023.02.21.06.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 06:57:37 -0800 (PST)
Date: Tue, 21 Feb 2023 14:57:35 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/83] 5.15.95-rc1 review
Message-ID: <Y/Tb36aAXPJzbCAG@debian>
References: <20230220133553.669025851@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>

Hi Greg,

On Mon, Feb 20, 2023 at 02:35:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.95 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2907
[2]. https://openqa.qa.codethink.co.uk/tests/2910
[3]. https://openqa.qa.codethink.co.uk/tests/2912

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
