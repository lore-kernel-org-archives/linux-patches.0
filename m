Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EE81078E
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 23:14:12 +0000 (UTC)
Received: by mail-io1-f46.google.com with SMTP id h2so4491321iow.0
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 16:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679440451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MssNP+dR5aGnqdDwyUxjGvQlcjhJTe1cfgpWPQPKmKE=;
        b=oTDyKNsA4gcLP9kaM36zvaR9lCb9PNFw9gWI5no6FllpkFWjGigPHEonxIOFTQmMsO
         wXXO9FJN6mquB9NG6n+KGsdCOULEJCO5Y6YmKEAfFxfUU0yyea5tYz9flDRW906pYGXy
         gGfmG9YsJTTMgYU80rP/JynBV8zZuJlzi0nkJdFBRy5Kg63UIG+sV87mpCWzL5sOLEpR
         m1CqznT64rtjjDN0GuK+1xmzLwGVrDxW0mdxAtAb6UwMVQUyZtGCaOLg5dimGwpb8cUm
         VGqkr7ALTBrIx9ZCOF60GS17cNBlcLayaAhUI0gAWZx4scF2tLLjfAr6gz3AZabHmswv
         UwfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679440451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MssNP+dR5aGnqdDwyUxjGvQlcjhJTe1cfgpWPQPKmKE=;
        b=soXYmTVmfAR8z6/LAh3oIN615vyOdWhvLsqsi/malLO8qawfS33ggxq4hgzL3o6W9S
         IeOGEw3ctepY7TP4T7YGduz8WUbZx57vqiAPyMvFOPMY+zVxSjep0d2OOuR6t0gGNCBH
         hVoMXTmLUBESngEUbews4i93IyYbMfrho3EG5gDOH3NG0JM8a/2807vWh/B64jxIqzeO
         xYOzlZei5sgN4oFavTX6kgfhmaiLMrfeSEDJxROdMoPq636ianIWw0cCmS6FeCXjYCeH
         olM8k03jFE7Cahl5VNhgVSVZsnMIo3bYAnqXvzgm+uRWUw88yGIpUBXYlkScv1jUGJHM
         MwAQ==
X-Gm-Message-State: AO0yUKW6z/8xofrVLJ5kOtEsFbeqSiRa6ZZCp8WoBVymhWYCU3MFOW3a
	05yZsLvFP804v/GBct0E0Kw=
X-Google-Smtp-Source: AK7set9ggclAWMp0o/BqHHDsiwpRuErvu6iFmkFJ+F0Ha7GZpOpmie6EHyy1YVxUDxQWmbyXiCkvwg==
X-Received: by 2002:a05:6602:200e:b0:74c:bb78:25da with SMTP id y14-20020a056602200e00b0074cbb7825damr3364359iod.0.1679440451275;
        Tue, 21 Mar 2023 16:14:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z20-20020a027a54000000b004064cc1c601sm3839204jad.75.2023.03.21.16.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 16:14:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 21 Mar 2023 16:14:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/99] 5.10.176-rc1 review
Message-ID: <7eae087a-f88d-4506-a593-4e37e1ac2d14@roeck-us.net>
References: <20230320145443.333824603@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>

On Mon, Mar 20, 2023 at 03:53:38PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.176 release.
> There are 99 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
