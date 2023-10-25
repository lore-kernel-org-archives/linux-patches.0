Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD8715491
	for <patches@lists.linux.dev>; Wed, 25 Oct 2023 10:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O5VADc9s"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-32dff202b4bso2012919f8f.1
        for <patches@lists.linux.dev>; Wed, 25 Oct 2023 03:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698231050; x=1698835850; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bPKkz+vjJvjQly7UyaRBk2YCrClRb/oFfsG2xUXP3aA=;
        b=O5VADc9syrLtUUK4nHMKWy1csym+G2mG6OSUBfmIMoOoAReZh6GYVwgNg/al3MAYmF
         ewcfRo6vFsROCo4y5mISlH59yBpRHbdcxjxy83FeAru4/lGAz0WaWgLnfMkAUryVlOTw
         NjGoRe7zyw/pj3M//eF9qqLVvHqGLWM9jFJN9GObiHhv4NUa4h6uMJEvfav71cx+6vYo
         7Wp94dXR1qJIPfxkpocfGRxWsIFvO861eOfTG/Oo8wJVGjpmW0aS9G3MLlyUe2fzYTuR
         00lVi9k6cAMuVrF/JClwrasdlGRdfQJG1wFy5w+1MC7Zs+uHvzLCusMaWoJ+CMo9u9CS
         gang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698231050; x=1698835850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bPKkz+vjJvjQly7UyaRBk2YCrClRb/oFfsG2xUXP3aA=;
        b=dqlO9kzmHD7U88AltasIXQRunAlLCHZligmh92UbfDEOGBN404wCoOgEGJXxdibGYy
         HIi+65Uuoos/3PvU9Zk8laVadIpDsJnrBc2JlATBZmROMfaGtpGvznmQ2xIjb9E2/xX3
         e6x/AJhesbS8rOdIGJ+v7O3JEusDGXwp+E8nmyfjZoAzmvkZhfXHqmTvNpTAu6QUD6C8
         qDEgcHtHet3RnudNMXQzchBvvpqqGf+qIFlrizNxUKLLC8TS/oWHONyJfwULxSvQ3hyn
         3Y3bwakiONyHD7U7w0eYURkY1Iz3vL9XG8d/W/B1eOieotSNaeS+5H4rmj4gkbW/+/hr
         u2Mw==
X-Gm-Message-State: AOJu0Yz+dR7RRdYwOP/MR+uvZieoNx0W96oEF73QIgO+13H4rV8rgu+u
	kb2zwbMe40XA/L20i05bDHw=
X-Google-Smtp-Source: AGHT+IGwaxVLt/dmiX8321rXIm1YMr2aoLrRxFqelYqLmTQRbYNR1Sx7N26TqW+Tzt+p9q+rJ0Gyuw==
X-Received: by 2002:a05:6000:1e8b:b0:32d:a2c0:fc28 with SMTP id dd11-20020a0560001e8b00b0032da2c0fc28mr10207956wrb.28.1698231050234;
        Wed, 25 Oct 2023 03:50:50 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id n11-20020adffe0b000000b0032dbf26e7aesm11755629wrr.65.2023.10.25.03.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 03:50:49 -0700 (PDT)
Date: Wed, 25 Oct 2023 11:50:48 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 000/120] 5.4.259-rc2 review
Message-ID: <ZTjzCMtJY4DsnoXv@debian>
References: <20231024083306.700855687@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024083306.700855687@linuxfoundation.org>

Hi Greg,

On Tue, Oct 24, 2023 at 10:36:44AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.259 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Oct 2023 08:32:40 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230511):
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

[1]. https://openqa.qa.codethink.co.uk/tests/5374


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
