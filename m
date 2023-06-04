Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858B017ED
	for <patches@lists.linux.dev>; Sun,  4 Jun 2023 08:37:33 +0000 (UTC)
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-3f6e68cc738so31904915e9.1
        for <patches@lists.linux.dev>; Sun, 04 Jun 2023 01:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685867851; x=1688459851;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/RW4TbjF3qcw7YmxPDw6GL8ZaIlrSZn8h5/QVYrrPp8=;
        b=EbrdZUBU0Mji0L16MSXokIObTH9SYRfFZ9gA94biGdVBS0x4jvyCuw88nbgVmLXeA/
         dBIZXIkJM4USV1s1QzfjXqPlQ/mkCcSFfHkMxq+V4UbBCW0jCU86+n2p7b7lwz/SHUbB
         6oBwcfFk8E7dJ74MnTPLfF8tL0+RwRLT2hwbIogBWWwm/iQeXR4mqAdOEqG2qEjzJ4gK
         mp74hHZR1+daJ1JAGQX947XUR6kYqFMaA6Kmp6GKKYgdiTNglrCsD/P3W9m/uQ0kXYBo
         Bb7sXpIjaqG3xkkf/ZXKvxX7PwFOj+mznLXJ5s44FskVQxyhUz6ViuYAfzoqxKjsZRTZ
         UK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685867851; x=1688459851;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/RW4TbjF3qcw7YmxPDw6GL8ZaIlrSZn8h5/QVYrrPp8=;
        b=X6u0oejEMmecC0blmFg8xtIk0gNdT35HdVZENhIR+aQtOD9wdzA6/YJSdds2WGE6y+
         MNYNRfCR4FmHzDtTdlw/IhcO9aTwePoVc89rrrKqlxsCtxTl9rnjvH+3xEHoKXgcvDCb
         3Oga+oySvtCqTppVRdsxZUhUA+4DB++X0npG9tCCqQfr2jFWlSNW9haDnR5Mbi9tY5Pe
         pmbOr4PaI/6SSNOZpWgGI0kjDBD/lAmYsW7mS9KJbS/UsyjEM5qBOCkJ+9rMtZCCFsmh
         HdJjxHIeBpG3Kzf39cmGxPdZ9kq0EsZLfucpF2aiVB0tHeYWAFKqDeDZfBleY4Aq6lpV
         OpwQ==
X-Gm-Message-State: AC+VfDytCcX+ir4lE9t/MAhUk1DRg692WD3PnJKR1EAauigH8Tu2i7hO
	z0YAtFA6Pcsiv519iUnTZyc=
X-Google-Smtp-Source: ACHHUZ6L4JF0jW2JC0FX5JeRF+CeIhBoPYgf9/5C1p+83UpPGn6iPCqD+sXs46KxF7D+/zjqgYrtuw==
X-Received: by 2002:a5d:58e3:0:b0:309:31ac:6663 with SMTP id f3-20020a5d58e3000000b0030931ac6663mr2692479wrd.16.1685867851220;
        Sun, 04 Jun 2023 01:37:31 -0700 (PDT)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id j6-20020a5d6186000000b002ffbf2213d4sm6466544wru.75.2023.06.04.01.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 01:37:30 -0700 (PDT)
Date: Sun, 4 Jun 2023 09:37:29 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/35] 5.15.115-rc3 review
Message-ID: <ZHxNSQkgrZsyV6OT@debian>
References: <20230603143543.855276091@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230603143543.855276091@linuxfoundation.org>

Hi Greg,

On Sat, Jun 03, 2023 at 04:37:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.115 release.
> There are 35 patches in this series, all will be posted as a response
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

[1]. https://openqa.qa.codethink.co.uk/tests/3687
[2]. https://openqa.qa.codethink.co.uk/tests/3688

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
