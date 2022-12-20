Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0201876
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 09:18:15 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id w20so5066829ply.12
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 01:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jYtnjCT1VE6xPysrQULKJxODm4kr4P07YtrAqXvYELs=;
        b=EAB6OAdYSQC8gvGWV7mv5rj4USmhY3S5d9HSqFJ8llTT+xc5ZjO6lcMWksu3D5bFqK
         X2brA4qbfsjTGuXA9ZVcBlh3Qb2CtAGgHc9oy3Cuh8Ev8zRwaG9Bl2vdzhHi4yaF4zaZ
         ckA86ITd4WtTnMM20VNuFb6IkH2y5/h37i2kQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jYtnjCT1VE6xPysrQULKJxODm4kr4P07YtrAqXvYELs=;
        b=Dt0oiwH7bu0JP0ZAhK8oJEjZmAsvKI9lX0nAhAgbQpPP6jEjAgV4ge7sjW5boHazCJ
         /KYi2gaCDrxzu7+WzdbzZ2DMN7N5xpBXSHfs4W8E+2dPNWIuQQkYT3j605OJG5ofE8GQ
         HeYLQ72UAyl5xSSVBpVtMrfAEd2cTrZNa5ylwo2vFZDe1UdYJac/CN6mUY6kh8MlOVcd
         JlyW8fQTgoyX9f3NlQSThoSDyck+pHllT7e9FHR5REKOT2eYwiO4BURj67siiQN67E/8
         SfILxqpR/EyCNr0+v90On3beJIqCypJML0AiXd3VtU/pzONrVvZlkA5x+MDHENZMZHCb
         +XOg==
X-Gm-Message-State: ANoB5pnwSnPFqzoHJk7sOOiYy+LlWtQPT696c8QmHmifJ6YMjegqGbUe
	F9S7+4JrEjzPwbJPDmPSmQ+QtQ==
X-Google-Smtp-Source: AA0mqf4YwgL2vvSeSQcktLr7W6vtjAyReWbydmWPih2WA9Cv80rZ1vPZsuMdcwjyiPdaNt0ObAngpQ==
X-Received: by 2002:a17:902:eb8b:b0:189:ced9:a5ff with SMTP id q11-20020a170902eb8b00b00189ced9a5ffmr46168902plg.26.1671527894944;
        Tue, 20 Dec 2022 01:18:14 -0800 (PST)
Received: from ec167f3768ca ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902684f00b00189ed861791sm8789543pln.266.2022.12.20.01.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 01:18:13 -0800 (PST)
Date: Tue, 20 Dec 2022 09:18:01 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
Message-ID: <20221220091801.GA955606@ec167f3768ca>
References: <20221219182940.701087296@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>

On Mon, Dec 19, 2022 at 08:24:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.161 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.161-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
