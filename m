Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E735F7B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 01:14:40 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-63b73203e0aso31996719b3a.1
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 18:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682385280; x=1684977280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n2bQyMry/9kSseFNQy1cBpWwH7AVeOJi3gZtdTMmTCg=;
        b=nCNcHQo5PbPYzh7MjyO2ZOQb3SP77sL8VfN+AoaNosvUCSJJmXhKydJfvdR1hjmKcp
         z+2S2WYpNgkOMyhOgxcpBR8jTi3gghJ+CRhQx1lpg+BGKR73PI4RGdCGCZ6muFcif0ZC
         juSlzE6U9LRzVkTGYdT3R0JimTiPQaYJoGIRu/fw8Y6c1z89JjoTARmbyYWblc39qeLf
         FMxUGRbC+zv3F2hLueEXhTas6OGI/PX/kbe206ubDGaJKea4sGgaQsfqssxevQeXURWF
         wmWHMHUBkzBwy/c3M2KOO4evUrjPtqYpm1w0FSPbESnbe2hHBami//Wqgb5prec8rvf/
         JIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682385280; x=1684977280;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n2bQyMry/9kSseFNQy1cBpWwH7AVeOJi3gZtdTMmTCg=;
        b=C1ESiOFUD/8P5G2SpocR7or0/ujSS0UOK2brWDz23h/WAcqu4+RgTfn3HGo/fYmwUS
         kgbOmyz9eohqx5UuDrzgYwxOxwYuAqVzjFqp6CbpCnKYdrUWiPvGMHzetv+FUxfKOf3h
         koPfs9rI/rbE0Ko7qq3ayAt5V0J4Mrayl/9WdiVmGrWvfz23iBcvakRQaPjywnFs5fgs
         PKBB89w6LdGv22BgEBDh9eNmmyttR5RXmOm/nswxljpPDjcdknxKKTM7ahN9FutBOU96
         kLFuRsniZKl5jTIurrWIzjgDdPiRLwVd6Iv2ZgAegLhiAisk6UPSlI6o2iMrB0+OrKDh
         E+UA==
X-Gm-Message-State: AAQBX9dfgbT2pT38tNNwCJDyCR2RKT6Q/Qd7TV51PlxR9vZ81VtxZ28H
	b/+DgCLF733/jSlixUr7zjA=
X-Google-Smtp-Source: AKy350ZasDNSaksLDrr3nAEgu2HhY1yXh3Dlz2qR4UYh0a0ya6SiQ47yY9iOtvM7KfHiM4bGmrMJBA==
X-Received: by 2002:a17:902:da82:b0:1a0:76e8:a4d with SMTP id j2-20020a170902da8200b001a076e80a4dmr23434574plx.14.1682385280267;
        Mon, 24 Apr 2023 18:14:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x22-20020a170902821600b001a24e2eec75sm7062491pln.193.2023.04.24.18.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:14:39 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 24 Apr 2023 18:14:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/73] 5.15.109-rc1 review
Message-ID: <0f1a684a-0d4d-4dc0-b99d-339f6559b87f@roeck-us.net>
References: <20230424131129.040707961@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>

On Mon, Apr 24, 2023 at 03:16:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.109 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
