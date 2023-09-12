Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3932281A
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 18:35:58 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-68fbb10dec7so2414564b3a.3
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 11:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694543757; x=1695148557; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AZag0nbTh/60KISxMvfYW3oBhoTMiURqNU/JyM0of4M=;
        b=bH5CM3eHz8shyw526xBd9iCNpujrTT1Vy4Ix2l4lYvf3X9Kqvk5i/K77Fa6TW/FrhW
         v5/Z8zAFUoW5sZ3igP9XwNJ2s3J4fWXpp5t0yBojV/BzsCU2tonKoHeidf2W3hN0rxQI
         Wkd9sGMYTTN2TPYhfovn45+0SwF9I6zQC1yAqt3uYtFauUIfRg/IoZFHWivj2uilgWUm
         ejHess6i2+Wjn5Xkdvq8apemt7ybgp6ELxMGHVbgiWebPwaadBcwc3jh66TwyIfeXZES
         9YtSKNq0IEsAnSg6ceYoJjEFGWZdjTfGyJe+UoUWgiYHZCu5V14IoL1B2R75C37IzjDX
         bPiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694543757; x=1695148557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AZag0nbTh/60KISxMvfYW3oBhoTMiURqNU/JyM0of4M=;
        b=h1RAIG+2/c4tnaSqqHHfsOdCNLl98DIh9D6x5nyA6hTbRgJsUdqgcYS+8fzvQtOejJ
         tlpS9bJmOoCTuD6Lv3SY8CuaX0RBrepiGwSDog+hwOsESC6Tz53UdkGW7VFqnFO2YdDB
         eX9KQrK2dk0TEdb6U//wc11+T1xbx9MsdKCgekAYkEl3JedsUiqYpWx3FeaFCRAV1ate
         O4rZANE+QyvQPIP8A4X3ff5kQwB3roIYCXtppU7nzOUZHEXOOwmn85LmErvXIAuZWr8e
         /aixgAKljf+wBjLo7Xn2e/c/F3100ZqeIjw+JfZmJirGlbVJYNZkUNlFj/1L2GkiU+pS
         O2ZA==
X-Gm-Message-State: AOJu0YymgpAFhsq8Znr2+Kpf7NQ9sn3QvZeJMcNQDWwPjNu7GCUJBDBF
	bX0XvESnxIT1R/o/CmZmakE=
X-Google-Smtp-Source: AGHT+IGjMQdzBZbg0ku2W19NjtZdbxC5I0VEjNvoGDDK53ZMRCRAjY2kmZiAPW9b8kd6sZnR9yNykw==
X-Received: by 2002:a05:6a20:9191:b0:13f:67b6:b65f with SMTP id v17-20020a056a20919100b0013f67b6b65fmr248450pzd.54.1694543757424;
        Tue, 12 Sep 2023 11:35:57 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u12-20020aa7848c000000b0068ffb8da107sm276179pfn.212.2023.09.12.11.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 11:35:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 12 Sep 2023 11:35:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/739] 6.5.3-rc1 review
Message-ID: <82783c0a-fc60-46ea-8b93-0d3037ebe2b8@roeck-us.net>
References: <20230911134650.921299741@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>

On Mon, Sep 11, 2023 at 03:36:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.3 release.
> There are 739 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 530 pass: 530 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
