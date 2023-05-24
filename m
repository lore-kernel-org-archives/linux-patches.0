Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D110860868
	for <patches@lists.linux.dev>; Wed, 24 May 2023 13:30:21 +0000 (UTC)
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-534696e4e0aso237046a12.0
        for <patches@lists.linux.dev>; Wed, 24 May 2023 06:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684935021; x=1687527021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GxdSCsmwEYvEk63TFK+FV5f8HceCpvSs4IoYiBfYQio=;
        b=l6YcUGKhmdo66vUmRH5M6UodbMyTVGt+YTKbm6A+BJZw5rfQ0U/73/SR2QQgZmpiCk
         X5vxkyHKsDP0qj4lzVg6jvq4C6B4dUzs0waZYjb5IqtvfJHjNDW+6oVgzxB1tn1n5lKZ
         tkIqK4mWb1fjSkSVCmTF38xEo0ME76bOD1dGYG3+vHlBfgapSb3ntnoLXiHhC4vrh0TO
         e4TQk8uTadNpaq0pZKjIHT7LGN+tklG/U2BUyUPpG5qsAHMPr0vuexAC2+KseGsMNfZC
         73HnQKhXLf+3UrJv1k+LATC795xrR08ZTkZPbZ3EcvwCkvoWS45JARmnuK5/jjcjyrjS
         IVfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684935021; x=1687527021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GxdSCsmwEYvEk63TFK+FV5f8HceCpvSs4IoYiBfYQio=;
        b=icYFYzkvwWBMCXC/FzDuLQuZuK8jM8qpxnpAHL2kItWQ5cjRnHxRehqUX7PxK9uFf3
         ZHACKm3HEP8ZzDVjklQobVGIg9NibKgBPCJYwCdOtlP1p8c5ZJefBh1F3YJGfgw1mdM0
         b/VFtkRTpiGLww7sGUGjzjELSYwCLx8roTHjyh+qGX+v7t9yPUw0aWq7qvqCRTv3Bc80
         ODcU1OO5EYzTEFLCGEsHzqmVunN6W4uWoxHpEDQUcCX/CQNQFu4Vzzy1vq0dh81+K/kc
         8PLS1LSdtKKymEQvsJPxYUNgEIuzjhAgsRpk8oCUQwKotbsDDsXvothrGWBV6orSMxJj
         cKLA==
X-Gm-Message-State: AC+VfDwGVtPsLXi1DiQQouyjHXlwYPw+/38V/KywqlAHEskCrVZIzCT/
	EmZ957ULNUcOqLSMIswKRf8=
X-Google-Smtp-Source: ACHHUZ4qt+542VeOln/VB23JLFlOHOdjQEeOb42tzBAMXi+JMeapJekYTWSm5hljINawnVfl7liZow==
X-Received: by 2002:a17:902:d312:b0:1ad:8c8f:afb1 with SMTP id b18-20020a170902d31200b001ad8c8fafb1mr16531018plc.39.1684935020841;
        Wed, 24 May 2023 06:30:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u12-20020a170902bf4c00b001ac7ab3e7ecsm8676734pls.210.2023.05.24.06.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 06:30:20 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 24 May 2023 06:30:19 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/363] 6.3.4-rc2 review
Message-ID: <f664e283-a724-487a-83ea-16a1f72d2de0@roeck-us.net>
References: <20230523164950.435226211@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523164950.435226211@linuxfoundation.org>

On Tue, May 23, 2023 at 06:01:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.4 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 May 2023 16:48:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 153 pass: 153 fail: 0
Qemu test results:
	total: 520 pass: 520 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
