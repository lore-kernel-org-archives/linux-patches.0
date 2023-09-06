Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDA0EDB
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 17:24:27 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-68a4bcf8a97so81081b3a.1
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 10:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694021067; x=1694625867; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qccLOFn0NebA/jrIta/G+mGqQIcHSVpro0Pr6B+XGoU=;
        b=XYXmsJjD8k4rtOliBJGMQ2L1CZ7/Mf0H5Q5srCtolmmNkXOeRrnhed+lvs6N2ypuAq
         HNNNkWda+texArE5BFdGfIB5E6oNkcpAn+xjvtJnqb5jlTMOMHQ2sr/C6dfRzqyKkbEC
         Og+kJEDXMUzeXdGGa6VSPWHiAmi282UwQ6om3djFI3Lo/3jMDqIRt143J08h+oRMQZsT
         AKx/d+F9KdBRvJe8Zn6K+O35WwbSJsOZTSmtE6tTolhz4ZLo6Mc5ckzEy6PHIh1gsQ9R
         VrWG4O5osELbgBU+gT2efQPRccshzVLRM7U73bSWvOuKGaVLGDB8Le56JIboWEwGDLCf
         Slag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694021067; x=1694625867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qccLOFn0NebA/jrIta/G+mGqQIcHSVpro0Pr6B+XGoU=;
        b=jbB9v0ItZAdF19hLOnP+B/96lHAvixJje8kPymfU287OgDccWifzAoTDLedTr7L8th
         9/lCnpYO9i7T0ghd4NVvpzyzfeoXDkHvicmjRTIyKunZJwCESDIiQZ6HYMrlEABlMhN+
         dlo/2SlgUPr55FQvVPypFTck+WHRO91cOnusz7g4InvLBkSrrNLnOjo0cnwuV7kMXH+N
         WhE7ex7BMILofTdlSonDYcIlqBdXIr8PsvxpXVQrQgZ0JUGboq78fshb4FuYnl78bHSg
         NYHR1CJy/DOcUv+zdrmccHRPSpKHX9QQl8qd6HlXWpy9IB7R+PIU2o5dsn65UunLjD/u
         YQvg==
X-Gm-Message-State: AOJu0YzNwqmvkYRF3/3tM+tkhHQXXfOTNq0g2qFoklFCfccg2L7JP+KU
	vOFobKjd1mkgN921y6C+Jo0=
X-Google-Smtp-Source: AGHT+IHLPR0x8+QIk/pp2xjdgCSZFCLEoKwDAzs9xmdnRDM4BBGqiSDZNbnV8oeToyc0zaCR0qsepw==
X-Received: by 2002:a05:6a00:1a93:b0:68a:69ba:6789 with SMTP id e19-20020a056a001a9300b0068a69ba6789mr16298253pfv.16.1694021066935;
        Wed, 06 Sep 2023 10:24:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c11-20020aa78c0b000000b0068a538cc7adsm11077577pfd.52.2023.09.06.10.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 10:24:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 6 Sep 2023 10:24:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 00/28] 5.15.131-rc1 review
Message-ID: <4e5bda1a-67e7-48dd-a7b0-2b4a6ff02431@roeck-us.net>
References: <20230904182945.178705038@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904182945.178705038@linuxfoundation.org>

On Mon, Sep 04, 2023 at 07:30:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.131 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
