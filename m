Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9EB5381
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 11:32:50 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id l7-20020a05600c4f0700b003e79fa98ce1so1300755wmq.2
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 03:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677756768;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8SpiicYH8xSOqfzRZM/wdYAOIOdFlsIP7PTh93wHnR4=;
        b=h0TW0Xj2nPM39iYp1nu4PQfc8pClsCkrJDs2KqygKgNYNiCynrSB6OU0EktdvHfSrc
         3UnCZJ7nri7huoImTiH2wGh0LX9zeEA+Ua0wZrRlnko+qbUf5q+5jTK5V5i/+sNq173U
         LytwomAS/8aVLBloFtC/o1zKL4uFM9BZwdPsxuYnfR4jDQEcnRq0C01cCYSmXj8GZGRd
         vOnQ7BN0Rs4+zQR8sCpSt13axyYgP96p9+SV1iWixgv7WDtReIKjxXbpoROgJTUqLsEF
         u1FGQYhuRruAGvf1ofYdSKdz69wdjpAa4oSNDaF4oC3xQfC1cbQrVLiuynkVShSJdBfB
         /XYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756768;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8SpiicYH8xSOqfzRZM/wdYAOIOdFlsIP7PTh93wHnR4=;
        b=6VH8BW0dLKGHUvHOnFq7HbYY+eC3Q/haA0RDExo0ZpWK1hpTeVI/BT2GN/i6eVWaRs
         BbEYtZYiTsLmTwzzFc0XHKs5bpRn2a8zGe8qh3taC0VsQLj6Lk76RToLO7Hll9DrRLNl
         auYPnKcM4T63+ActQd9O7E3ONUNKUASpqqBGbfHwPGE76LozW87fTKQK7F4zT7HUicrn
         D455pVYMr8ZUg32FrsdYIH4xvT5uelWQNgIv1SQ5ZsnMh7P9zABs1RO5yUwKpKm3DkVD
         sc5lfGf3IRwKmQ4vbKtTi+7ZMQW0BoK1Vz4rctDntChzIDIMxRTwuLFENdDO+HmGbr1p
         fHqw==
X-Gm-Message-State: AO0yUKVjnBE6bU0vx2Zpj30c0GMuqZYdBJk/O3QqESdX47zQY7sNi8ev
	l8D8DFLrNXA76dAr+gXqZAc=
X-Google-Smtp-Source: AK7set+iZxK62GWEK4sOjgh6v27Pb9NPjD2OLs7/eVH1I6BtxiWgid3i/EUtu4mQTl7MqI+2z9by6g==
X-Received: by 2002:a05:600c:3549:b0:3eb:25ff:3446 with SMTP id i9-20020a05600c354900b003eb25ff3446mr7262629wmq.4.1677756768570;
        Thu, 02 Mar 2023 03:32:48 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id he11-20020a05600c540b00b003daf7721bb3sm2778576wmb.12.2023.03.02.03.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:32:48 -0800 (PST)
Date: Thu, 2 Mar 2023 11:32:46 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/13] 5.4.234-rc1 review
Message-ID: <ZACJXtFWBPjQQXRj@debian>
References: <20230301180651.177668495@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180651.177668495@linuxfoundation.org>

Hi Greg,

On Wed, Mar 01, 2023 at 07:07:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.234 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2972


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
