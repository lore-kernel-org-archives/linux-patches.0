Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346F5C13D
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 18:33:45 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-77ac14ff51bso180862639f.3
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 11:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692038024; x=1692642824;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hA1c32nPoqRtqKf1PeXAkYTakp7BkAfWNw6eIzfC7MU=;
        b=SoApQCrCfC7Mt89LgZDoWi1W1VWVv/sBUPllr/NAiHmv7RJREjec9tUvnmqf2ONb8f
         FTuhY+ZCQCL8UYzmbahUniwGqy9YqArSKiJl8bhPxu20rR5ny+2QKQ5SoRW3QM0ZWblX
         Jgxkc7ANJnqnsJBhyhBZJxtdDsXjTKcAgST/bKI1YIV4/o5gwyC6qEL6Y5eTcVvr27ma
         bgu1Yv2E8bVcwsGCvhWYVmx32odVL8jGMF+lYn0OyyJnr4K62jV4/JXnO+0AKuJFWmoQ
         y4JPrFchLR/ie2g+dJKkBXb1lZBuQhW1Wb8oR4zBD9tIjVumkKegnj620ntCo7XeKWwN
         rCaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692038024; x=1692642824;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hA1c32nPoqRtqKf1PeXAkYTakp7BkAfWNw6eIzfC7MU=;
        b=DuAoz5aBdJcy9S9hhrOheqalMFeq2u/Rf5WmwZNK/DI99S+CCenQdmOWtDa/k0VRVG
         +fWXPhbgTyKld6H61RVxi5fp07Utt2AlWecJjehCR8x6AeuK148rX8zmYtqohw7VBcwK
         z+WhLTSt5GivRhC/ekco5yjSWMRv6N2U1Kmk8K9VTlr22J2Y1gilnBX86MAjjZl22pqg
         ksNz4/y4MD4e2lX7WFvFVkqwJGIofwErhl7aaL9vyvqqrAz+9wgSn9YS3ipgB2Wq132v
         MD746NaHJ7x8a1iDx4XEArf/yE+kJK2pyoNZRC4RsuspvykAOajBadc9uRHsyel+QGQ9
         mszw==
X-Gm-Message-State: AOJu0Yyp3gHAuUaR7r+jVR87up7h/s5QGkZgl/5SV1qWmrR006qXEjnD
	KUEaskYgthmBL8H9CNbFsIA=
X-Google-Smtp-Source: AGHT+IGInvIBfbQ8LylVFc5S+ya7eq8omF2ey3IsarSvH5b8Avvbz5J1tuP4Xh+uIsPEnn4nNDa1mg==
X-Received: by 2002:a6b:4a17:0:b0:790:aedd:3e81 with SMTP id w23-20020a6b4a17000000b00790aedd3e81mr12348202iob.8.1692038024176;
        Mon, 14 Aug 2023 11:33:44 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u2-20020a02c042000000b004310d570d6dsm3193100jam.94.2023.08.14.11.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 11:33:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 14 Aug 2023 11:33:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/149] 6.1.46-rc1 review
Message-ID: <ba8db9d2-2bf3-4b23-97c1-1db07f93644c@roeck-us.net>
References: <20230813211718.757428827@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>

On Sun, Aug 13, 2023 at 11:17:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.46 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 521 pass: 519 fail: 2
Failed tests:
	arm:fuji-bmc:aspeed_g5_defconfig:notests:mem1G:mtd128,0,8,1:net,nic:aspeed-bmc-facebook-fuji:rootfs
	arm:bletchley-bmc,fmc-model=mt25qu02g,spi-model=mt25qu02g:aspeed_g5_defconfig:notests:mem1G:mtd256:net,nic:aspeed-bmc-facebook-bletchley:rootfs

As already reported, the failing tests are crashing in f2fs code.
This bears the questions 1) should I stop testing f2fs and 2),
would it make sense to mark f2fs as broken in v6.1.y ?

It doesn't seem to make sense to keep testing code which is known
to be broken.

Thanks,
Guenter
