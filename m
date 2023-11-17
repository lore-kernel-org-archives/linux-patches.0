Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130552A1AA
	for <patches@lists.linux.dev>; Fri, 17 Nov 2023 18:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="LKKQPppi"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1ce3084c2d1so19960765ad.3
        for <patches@lists.linux.dev>; Fri, 17 Nov 2023 10:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1700247440; x=1700852240; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fW6308wA70VS87+E3o3wGRpIiX2Yqcpq2KYslJTEbcg=;
        b=LKKQPppi2/OclU8Yc2mwdlt2lWqQdVPuy6gblj/EYUALpZ1CsIEMFUSGly+Mr8jL8E
         GhhZGvkuHLOqZWEVG362ucNF0O5qwwVMI/uE25fPcP4utWp6IjgTlF22ZbE1Vh9gopCH
         V4Zr/c2UmMu6mef0kbiYqbMtMcvddTGLeYnb0s1prrVeIvMaBJt9teLy1rveu1Mlx2Xd
         VXEnfOaNpKiOzhGwG9dweeYW5M4DblKGxP6gOoiAAqpyKuR5xdUIq++V/v0TR/BuRsST
         AKF8a9uMYT9DXHTfR44PggWFzz98FbjamyWpeRazb8ODmxq7k/F4TYm3/9RVxfGag1OR
         aoVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700247440; x=1700852240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fW6308wA70VS87+E3o3wGRpIiX2Yqcpq2KYslJTEbcg=;
        b=Mn5evLTHJy6BPXclOw0Ia5iX+j3pRqoT9uwu2qju/huf5aMMSpMkynRXX8tArNNv3x
         dokkZBcR0x4WZkt1MljZmcFJAjs+EINi04QOKF2pZFupGPSdAm40+NvdveIn3CoSiZ2o
         s88Duszy+1r50ApurrYTgJU2s4zBsGfMs7QQk4AfTddjzq7szusdGa3dOplTEXOrMqTs
         qO50+vC6Xrucm0TjNQt4j1Fx2zgYwVa5Bdhk5EJR2LZCKPTUykgVmIxTCILYrGWUXLPE
         ALWevepqATNnyUKozXLMnJPxcX3AojpVE/ooEWbR6M95xtw60np9pnayJJOnKFZrKyni
         ZtYw==
X-Gm-Message-State: AOJu0YzAAaqu5kqs6wrGu4moqukrgOpMKseMClDgRYzn5nkWKv4kMYiQ
	oFxMDr+Qjaey7QbTT8wKRfMMLQ==
X-Google-Smtp-Source: AGHT+IFlQXHxTYyap15dGpZg51V8uPaQR4Cvd/FPwpEGVHdEHUzqvcw2KIXNqfb5kgJ+/8bjTQUCVw==
X-Received: by 2002:a17:902:9a84:b0:1cc:4559:f5 with SMTP id w4-20020a1709029a8400b001cc455900f5mr475440plp.14.1700247440159;
        Fri, 17 Nov 2023 10:57:20 -0800 (PST)
Received: from x1 ([2601:1c2:1800:f680:813c:f3fa:3586:5465])
        by smtp.gmail.com with ESMTPSA id e19-20020a170902ed9300b001cc40912649sm1695814plj.304.2023.11.17.10.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 10:57:19 -0800 (PST)
Date: Fri, 17 Nov 2023 10:57:18 -0800
From: Drew Fustini <dfustini@baylibre.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: adrian.hunter@intel.com, ulf.hansson@linaro.org,
	linux-mmc@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] mmc: sdhci-of-dwcmshc: Use logical OR instead of bitwise
 OR in dwcmshc_probe()
Message-ID: <ZVe3jvuERZgkq0BB@x1>
References: <20231116-sdhci-of-dwcmshc-fix-wbitwise-instead-of-logical-v1-1-7e1a7f4ccaab@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231116-sdhci-of-dwcmshc-fix-wbitwise-instead-of-logical-v1-1-7e1a7f4ccaab@kernel.org>

On Thu, Nov 16, 2023 at 06:46:00PM -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>     873 |                 if ((device_property_read_bool(dev, "mmc-ddr-1_8v")) |
>         |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     874 |                     (device_property_read_bool(dev, "mmc-hs200-1_8v")) |
>         |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         |                                                                        ||
>     875 |                     (device_property_read_bool(dev, "mmc-hs400-1_8v")))
>         |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: note: cast one or both operands to int to silence this warning
>   drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>     873 |                 if ((device_property_read_bool(dev, "mmc-ddr-1_8v")) |
>         |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         |                                                                      ||
>     874 |                     (device_property_read_bool(dev, "mmc-hs200-1_8v")) |
>         |                     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>   drivers/mmc/host/sdhci-of-dwcmshc.c:873:7: note: cast one or both operands to int to silence this warning
>   2 errors generated.
> 
> There is little reason for this if statement to use bitwise ORs, as the
> short circuiting of logical OR does not need to be avoided in this
> context; it would be wasteful to call device_property_read_bool() three
> times if the first two calls returned true. Switch to logical OR to fix
> the warning.
> 
> While in the area, the parentheses around the calls to
> device_property_read_bool() are not necessary and make the if statement
> harder to read, so remove them.
> 
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1960
> Fixes: aff35fbc7830 ("mmc: sdhci-of-dwcmshc: Add support for T-Head TH1520")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Tested-by: Drew Fustini <dfustini@baylibre.com>

Thanks for fixing this. I'll add clang to my testing going forward.

Drew
