Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFC9101DD
	for <patches@lists.linux.dev>; Fri, 13 Oct 2023 02:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KnOCCYdi"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-49ad8b76003so613401e0c.3
        for <patches@lists.linux.dev>; Thu, 12 Oct 2023 19:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697164392; x=1697769192; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L2qr7zuO96ufZPS1iOqXbjMEn0xmlzZcOIPVy4ltN2k=;
        b=KnOCCYdiD4I0Y9c6gLIOcr5lvB4szeKB7jAa4dj68V2SBhWSAhq3Juqdb+BROujhbl
         TAT0vQlvRJfyzhHL1bV7bDxR20/28JR+W1KUdF9STsuiWwodlXS880sTPJR6DpTX+UV5
         sfW/T98YdsVIT6YHfkmnumChIy+kWsy/6vr/xMHJzutDpaLgP60M96XO+Qp5XC1pidq7
         1P1ruJhLGt+d8hZlO231UigRRqEJSfRgT7dzGMZsAXKIW8TenKQb4DSgw9k9F7xHaxrH
         WS9C4ULGZAqJ//iiWoCbEe/g8xuARd4gD9TWsebwrFq27iQo9kRhS4SF3xCRm2He0BsG
         nU7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697164392; x=1697769192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L2qr7zuO96ufZPS1iOqXbjMEn0xmlzZcOIPVy4ltN2k=;
        b=kdKGl0qN7PLGGYWknvAzUrtnS+lnqzV8uTIz9lyYMLAdSrvN+jDpbU43issi0C75o3
         lnfPK0uqu7NgB4oWmVhq3WvD+m0zV9o7ZkL34pCDqcedIzd5XeynM6KZDjtoiqKksHjE
         CgoiQ0Z56aSNNnGrpHLDZShZd2gzfqzD4qPV5b8Ino3cyOUY1SW8TdOsNc6B2eE6gu0P
         07ZjHuFX/5gN87qJAl7r0/7c7+ySnSbnHjCaQCiLQF+c7a9DOv/ldmbHKqmY3njda3Ma
         hKtFCkpwFxgww1tMi0Dc+smpWh9Or4W+AzTqSaqVmwg79c79eY7ZoR0IhSnJYnvLO/sm
         C2bg==
X-Gm-Message-State: AOJu0YwFOhcZqyeuGX10p99cvCG/vLJ9yW+ZHpA2/l+T+jcxC473F7UQ
	rJtl9W7n7g3Og6A9TtbE1to=
X-Google-Smtp-Source: AGHT+IHymc3LaF5qB1ZpGLtIIFMfjchPFLcMnp13ploIYnVn8zZlv1a1d40OypvMwY1xb0cOsRh97A==
X-Received: by 2002:a1f:c342:0:b0:49c:79f3:27a4 with SMTP id t63-20020a1fc342000000b0049c79f327a4mr23532551vkf.3.1697164391755;
        Thu, 12 Oct 2023 19:33:11 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i14-20020ac5cd8e000000b0049aa0209f49sm3170815vka.52.2023.10.12.19.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Oct 2023 19:33:10 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 12 Oct 2023 19:33:08 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 0/6] 6.1.58-rc1 review
Message-ID: <0d61d6c4-5e73-44c3-abbb-4a90b0a27acb@roeck-us.net>
References: <20231012180030.112560642@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231012180030.112560642@linuxfoundation.org>

On Thu, Oct 12, 2023 at 08:00:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.58 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Oct 2023 18:00:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 529 pass: 529 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
