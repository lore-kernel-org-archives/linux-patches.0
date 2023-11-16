Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F25321BE
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 23:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lzy1j10n"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6d31f3e8ca8so809033a34.0
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 15:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700178156; x=1700782956; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OmpRtMVImizvD04Tgs0IdV7+Ixa4P5o87c35xN/QN0o=;
        b=Lzy1j10nGYJP8F7GhmOPsHGQWmChsHJLrhFQgSqLyDr9gUueVBY5JQAEVkDoEzlNth
         YQfB5BRE+B0Nn+4M74bF7dL40sNSE3i1AxH2LH3TXAbeUqiy0MpaVSptla5qGT1iYACo
         BGf1E/wNnrvx5Axr2+0D8SVo9zpNyzOYR4ATdnoqjvK4wSPvy7VeEvotn2HF0VOgYsEd
         arNVNA/RfYHasHds9cOvDDz/A6vIyfQH1V8UI+8hqO52/ENFn4xpwMSsWHO7kKtGRb5e
         W6IJPSYIYCi047sB5Xrl8ultzEIZWQo4POfR8TGA+WBFDV3EC1Pt1QCzsq/qEPfmGt/P
         Y4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700178156; x=1700782956;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OmpRtMVImizvD04Tgs0IdV7+Ixa4P5o87c35xN/QN0o=;
        b=vahl9cs05qvGoq3CvVlOLzGIcC1iPpXXufsM5ZJCJr4fLIUQP4D4bcV4uv1pihve4F
         5MgoRlsb3XFQMnPLxkOHj7M3wOHn3tJuOJsh74awFcO3tJQtSSb7QjaaPCnB4KjFWixU
         bpV95kUvVKSCzxNSMpRdj8vKCblzqR4k6NZcpGKOTeHSBVc/bakyaBzK/se4ZgKr84ZS
         Hgoltela/mljuQhP/7aoIQ6540yL4D2Kru3//Iw3aPMzhqBcZhUaZqvYIKbpBs3UgJdM
         lBKGl/0IKbRLGCB+qF7Vp0fjFZWjJpSJe1mvEl8vRczSr6vGdUq3v7le0CQEnz6zFWfy
         u4CQ==
X-Gm-Message-State: AOJu0YyxvCidfNHC1L3rHlb8+6drS67ETVkaPFDc7n+ZPajkjD2p/SKJ
	NSSA9pmDXcUkg338rLdEyXE=
X-Google-Smtp-Source: AGHT+IFVdWr4sT2vfDHDv+EOm4WVZfS8dZxyQHDf75wcRjf2H7ce0ovCNIufPp6tAWNQ3kC0/t7Hfw==
X-Received: by 2002:a05:6870:538f:b0:1e9:c7cc:df9a with SMTP id h15-20020a056870538f00b001e9c7ccdf9amr20528999oan.11.1700178156060;
        Thu, 16 Nov 2023 15:42:36 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 14-20020aa7914e000000b006926e3dc2besm278387pfi.108.2023.11.16.15.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Nov 2023 15:42:35 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 16 Nov 2023 15:42:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 000/119] 5.4.261-rc1 review
Message-ID: <3c4fa3df-d0db-4eb2-b6ec-a397ec1ce399@roeck-us.net>
References: <20231115220132.607437515@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>

On Wed, Nov 15, 2023 at 04:59:50PM -0500, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.261 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 22:01:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 464 pass: 464 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
