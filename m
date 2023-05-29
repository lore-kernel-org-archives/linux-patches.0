Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFAF8F71
	for <patches@lists.linux.dev>; Mon, 29 May 2023 16:09:22 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-64d5b4c400fso3926926b3a.1
        for <patches@lists.linux.dev>; Mon, 29 May 2023 09:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685376562; x=1687968562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YiS2FFWs4WwYbdRa94v54Z+BvgoGuQrPEURj3HPmPzE=;
        b=OWdAuHIllii6Lt29LD+o1tATMbArgPIuifwEazV4pxi6IpNH6fXsFgeXvT3ReSCT30
         LjxL+yJ8MgPzesNcPNk/toGFfU9z2p84iT9W9TY4AzSEk4TrMIr4mb7MSzt4yAzyvKY2
         KA8V8S+vXmLv0bjVdVYUk9shxDwsoSfldU5Lltj7Ih18hMbUCI2itLKkpb3a+YWsCGIv
         Ba5kjZXOp5cc8ZL2KquBUb0avALaR7nW2dvhOEcS8nzw/jVIr+bZvcgxZLHp7BVh++GL
         KA9sPCcWe1pP4fIVrXUbO/V7HeWkdG8jym3NUvZTPc6qbXp7jSOZcRLfmrfEX9hHeaQW
         KY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685376562; x=1687968562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YiS2FFWs4WwYbdRa94v54Z+BvgoGuQrPEURj3HPmPzE=;
        b=E9v+fnmVZp1j7zzS9++42cLxo4xaqR9xMG6IknEZMA5aWsMYgUQg+GL0LiFh9gWT5G
         3911Bs/5khMg4bNLaw3SrzxtxaS4MWDCtBa+T1gKHxQTs8WMmjs+kyc8mCot9EP3XWO8
         PbyfVu8aRA4MUpFPYfOHhHtL8hDI8zeceVB/UHquTdb5uNT+IGvIGahIahtz3CW7touj
         BEVrM/omBPg8rWV8iRmDh/57TDaiYodMwtcXSs+yaWopl9WD3O2wme5ZkYcbARqGARAZ
         6gM0YfdkHI2ofHTe3jbBVI6nBcjYl5eb5S4hBVu+XeqYJg5H0mO677IExdTCGGa3gc+L
         Z0pQ==
X-Gm-Message-State: AC+VfDzxO54EufDthvVD153i2Vq1Av9cxzD8ZbWRKowILruSc1bD3+cE
	893KiNIokSAtBpplzsdj9A4=
X-Google-Smtp-Source: ACHHUZ6EoU+LOF1JeVhzD7mo9RrE/6RRuP2ICQAffylOMye8t4xMB2YQrE9RhtnoR/awMGg67z7SBw==
X-Received: by 2002:a05:6a00:881:b0:64a:f8c9:a42c with SMTP id q1-20020a056a00088100b0064af8c9a42cmr151341pfj.18.1685376562264;
        Mon, 29 May 2023 09:09:22 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j13-20020a65430d000000b004fbd91d9716sm6417751pgq.15.2023.05.29.09.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:09:21 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 29 May 2023 09:09:20 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/161] 5.4.244-rc1 review
Message-ID: <48589bd0-755c-4c11-8483-04e115dcedbe@roeck-us.net>
References: <20230528190837.051205996@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>

On Sun, May 28, 2023 at 08:08:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.244 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
