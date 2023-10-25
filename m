Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0080915491
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 10:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aRi5WwHX"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-32caaa1c493so3821996f8f.3
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 03:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698231198; x=1698835998; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E5LFOX0gmykKgdLOW/m7PRk1qIDkKpMeejYtgVYKiAg=;
        b=aRi5WwHXF9G7rYj/7xmR+1DwO9uP17n/5LvZrE1gkZJ5Tf0Q8zBM8RC72TDhRI5P7C
         v8o02TeB3FN8jY5peAVznA7GWuHtNnbAmz0ePuk06WD54BI5Eo7ULu3FzJSAp1HUE8fw
         1jdTjn+LiE7yDl6GJpBm58qVplpCL8I3qy9zADNdyM+J3tjfE5vRT84EntfYhTfP6nEv
         h4J6jKGbz716996RGxWrllgg9pjPZQ9wd2qcFq1xzWpMDPCX8YrjODX3zY/cJqtNHvpv
         9mAMrAn6S4+fdTMbN1PGIm3PMYfTWl+PnZjhe63eHEcJSR/Md7uf+8B9lGhHPsMGFoPd
         Swng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698231198; x=1698835998;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E5LFOX0gmykKgdLOW/m7PRk1qIDkKpMeejYtgVYKiAg=;
        b=Cvn2pAqw3CUYevlWkidCw5ZHP864SvYdQvRVvcBSzRBz1urWKQi4FR5AV5Qjy7i1//
         INySE0XqGC0D+z2jd+8/ErT4EvLi8Ahpi9dgKO86LhIaVWfFd/Nr7YEBA4dQ4MWcDR3t
         tuFKeQ1hVhIjqoxHWlir2nFH4RlhpY+NWIcKivpZlpgG4qEpNIlMDlARP8KH6byWcSMD
         dp3R3x87OqN984P21d3zR02MdmJRLE70S9CyUDygL8oxPoP6AKdjHuSiUv+96N8RzEBH
         k8wtfXswOS2seCysq+CVtOhLdwAfPwGeMQx3/zmjnf6uc8Y1ytSqWsqxrOxweyX5r8Ts
         6c9Q==
X-Gm-Message-State: AOJu0YynS5CDnZbgaLcuVnjJQpWmbOxSzfTaWVDb6GM1ElmbdtylPBaA
	9QnXpZHa0Hrloc4KklWBZtg=
X-Google-Smtp-Source: AGHT+IHm4rhFsIfSunj99etgP4L3hKz3Kf6mT85Ndo9cH1jm/mZT7VsHlOrM9UgiVd/BbfdlfX7xMw==
X-Received: by 2002:a5d:660e:0:b0:32d:8872:aacb with SMTP id n14-20020a5d660e000000b0032d8872aacbmr10935716wru.53.1698231197566;
        Wed, 25 Oct 2023 03:53:17 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id f1-20020adff8c1000000b0032da75af3easm11793086wrq.80.2023.10.25.03.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 03:53:17 -0700 (PDT)
Date: Wed, 25 Oct 2023 11:53:15 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/135] 5.15.137-rc2 review
Message-ID: <ZTjzmw_pVK4eSOED@debian>
References: <20231024083327.980887231@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024083327.980887231@linuxfoundation.org>

Hi Greg,

On Tue, Oct 24, 2023 at 10:36:50AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.137 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Oct 2023 08:32:55 +0000.
> Anything received after that time might be too late.

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

[1]. https://openqa.qa.codethink.co.uk/tests/5379
[2]. https://openqa.qa.codethink.co.uk/tests/5381
[3]. https://openqa.qa.codethink.co.uk/tests/5380

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
