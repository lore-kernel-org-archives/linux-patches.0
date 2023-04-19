Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2834E17D4
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 03:35:24 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1a6cf95d559so14115665ad.3
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 20:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681875323; x=1684467323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wa+6Weqi99+2cMzOYJs7dkr4M9BIqG1QIOg6cp94MLA=;
        b=EpZXLJSIM+h04gLWSd2K357yF8tsIJqMwRErdeshY83QqfcVZZLkALfy3nQTAGkoSw
         e6M6FXTmbQlmDtVKNvyVjnswAR86Q9REUicpEQEQrsIa/zlHY3jTONl5KuZovHiCHd1D
         MQZqBL1IAdqJqD68N93NCrROtXqFzY/9wCUeln/NO8a84Kct9AANwXQmMlOxXFwC1bv2
         axitMoCVX7x37O8jg2zIQyrJsrShQ1GRQHjnQuZK/ZtIpKUPHSANhs7fkiQsDt76MrP2
         0sxhMoCEsVrYohUSMLqyWXs0wZRWLI6OS1ew03dvW6hs+vVQBckhmDVjYfwAOHSkwtMp
         Rs3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681875323; x=1684467323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wa+6Weqi99+2cMzOYJs7dkr4M9BIqG1QIOg6cp94MLA=;
        b=SmZHpiarI7Z0ZGmPJiT0WvUH9lVlMJJTv2o4J29bB0jomltH07bF/4YJTCRSpqxrFh
         uNx9FMMUwdJxHH18h5TbyvPi6a4vsmc6mc5dnwo2d9O7asw+shsPUDj3HfhoW3Vcd4Ea
         dlp0B5K3LbPGrN1wdnTEY19Rpcpp0Mz6nyWJhYic01duL4IXYgZFeS48QFF2LlUIy8B1
         W422weOWjLcfahq7jDI2kpr7a0OFR7lX2t3viUtheuuZHql1YsoZ035RIrfObvGAkijM
         9vi1s3TT0kHhI1OG4DJ+NYuGwMi2ZHKkbHkG/ulRFfjf0TAZJnkqbVOL4dcjGbks4J66
         302g==
X-Gm-Message-State: AAQBX9cTe/xNYKxh/fZpy5dZ4Pjjvm9IvuLKJw1f1oF8AQGdEw/5tFv8
	QD1ETKJE95yphpQFXDMI6bA=
X-Google-Smtp-Source: AKy350ZYZxUtiSSyhM+Q8fMkS4W7z7TsrDfZZezs5h9oFZgA6PCnf/wSoL0TpR3o+3hXQrCj7tnN5g==
X-Received: by 2002:a17:903:1205:b0:1a6:c12d:9036 with SMTP id l5-20020a170903120500b001a6c12d9036mr4339072plh.33.1681875323658;
        Tue, 18 Apr 2023 20:35:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902820e00b001a240f053aasm10241989pln.180.2023.04.18.20.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 20:35:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 18 Apr 2023 20:35:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/134] 6.1.25-rc1 review
Message-ID: <bbcd6d92-a7ed-4f3e-a49f-9397c8a05a7d@roeck-us.net>
References: <20230418120313.001025904@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>

On Tue, Apr 18, 2023 at 02:20:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.25 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
