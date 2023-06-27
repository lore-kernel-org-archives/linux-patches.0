Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E446FDF
	for <patches@lists.linux.dev>; Tue, 27 Jun 2023 21:34:18 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-66c729f5618so3521072b3a.1
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 14:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687901658; x=1690493658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5KvC6gSHm3Mnr+8G5W9klezbIpsKfd6ztL0rbeRtQI0=;
        b=QPENOK5BbSgG8l9bmuhRH+rRSXkVXZE9b+o5uwlbBR3yXJ09bzX6WDbaj1CCC1ChLP
         c6OKfXtEmBYAca1VZX18/F7teg1cUXhVcpy5M5omOUSy9DPPXe6if4h8n9pcDmL43GJj
         lHJ7lzGUWRd0U4NGHmxvbKU2AgldNhTo7ltWDT1fUO6uAeyDMy+/dDKV3nIN4vwz1rJM
         yUI8oNTeJ+XDDGpaO71dwDjuqGWhenWc/8gU1E//MouLq5kBf+Fg0o29yzYLAOwWc8Ww
         j6RChgjrRn1x2yKAIBAwl+S+ALj8quy6SNI5BVzmQuqeb/kJksBTMA9sqyMvvS1aXitX
         yx/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687901658; x=1690493658;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5KvC6gSHm3Mnr+8G5W9klezbIpsKfd6ztL0rbeRtQI0=;
        b=FsvJu8nWbdRKFL8LpPRmPFKZRxWpDWWGFWSCtDsyn/Zx4WtuvWVhmYIE782eE4GAGh
         ZK9f6fzxYOI96Azm0RBdIrAnGOkRgkcJwtfdFCmifas4OK4dxOgmhM7jsOxkNFtJVQqU
         2sWNst/DGjfhP1I5of1xDyQljj1200IFTxfQYj98Aqi3yEwCPyvQyAarsXDKrTKuB0kR
         P8Q6YbvrjgJs1I04IDj3D2J906LBAH7DSNGGkmIzQYRAFbo7pZCkiiZuZQG0b92AsHAs
         kqzEP7x0ZjIa5Yw8m8bANySgFDkiME8ZhWLi3zh6/jWRkkJHchOB4LR7IBfASB9nyIUR
         bkzw==
X-Gm-Message-State: AC+VfDzBmslWFdkesB3mYAUFmmTufLScZx2wUtWUzbm/PmgExTjM/SS2
	ERZfOweBjZMOmabANQ2mRDg=
X-Google-Smtp-Source: ACHHUZ7kpqShW/z488sGKO53Orw6gnSjl2YVClGn6LZJIHDUsOoWyzYi3JGhkv3V1AbWx50+Y54CfA==
X-Received: by 2002:a17:903:1208:b0:1b5:54cc:fcb8 with SMTP id l8-20020a170903120800b001b554ccfcb8mr14429663plh.19.1687901657929;
        Tue, 27 Jun 2023 14:34:17 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h12-20020a170902f7cc00b001b8229942a0sm1588253plw.34.2023.06.27.14.34.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 14:34:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 27 Jun 2023 14:34:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 00/96] 5.15.119-rc1 review
Message-ID: <82f3c033-4f69-4fbc-a497-942c99fe9406@roeck-us.net>
References: <20230626180746.943455203@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>

On Mon, Jun 26, 2023 at 08:11:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.119 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
