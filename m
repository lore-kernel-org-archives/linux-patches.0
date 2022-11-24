Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D6923D4
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 10:46:59 +0000 (UTC)
Received: by mail-wr1-f53.google.com with SMTP id cl5so1864835wrb.9
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 02:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OBGmEKa1taT9s2f+pNmogNOTs2QhvuGYkyttP/ZEg0A=;
        b=KKtTGM+Wqckv6yNTN+FgPmssH6e7pdpSBKoiOULlqzOxZBpTZBCo4H2RgwsARjGXhF
         pkjtIEdbSQpTqeYO9z28dL2X1A5lZ6j2P/uBTS60gjVtKoEbwlI6uozq+Zdj4t+LpBk7
         b4lgDw9wCtGeJ8IpNZBXWoErkXKWRatXAauILRhdTmWxzRLnhvJxfpuRsluSPnF7Bx/1
         Ymg8+VOpEz27ldGZUgIpL/EQK477UCLbO733OVwrVCkzIAdPIGGted9+T55HSiamS448
         tjkhHYBrwfKQ/OMFAXNnGZQ6kVCDvA2tTwB/JyJFirF/9D1bYe4wOrp3vY1OUbrpnzHm
         SpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OBGmEKa1taT9s2f+pNmogNOTs2QhvuGYkyttP/ZEg0A=;
        b=A4RCzzU7hv4roSXYBu7W8xmIMM1f1uC2zwkEXc8O0r+Av3+OM9/YyNpRIqGCZUkn4H
         HG9/k8ZNnhgeQbr0WO50soxVBVgGgThtP7Xr8Q8IWVzuPolOEuh2m5gFuoz5m76HRrke
         MDxgaRJW6RhKK1NsLjyWVNdu3Ot2yCqQ75cdlQ4eS+30aKX42+xjtZV7ibyU7gTYMDji
         sm8rj3VQR8oqm7D80fLphw1sRy963Q6kFtKRMRkW5fjC2PhlNikOpaaBp+qjNq0J9aRz
         WjRg17eJWTD7Ube5mQywTymglyS/XHeN3v0WuzFBFOgeBa4OaykzW7D2eGW4+B4ofNOf
         JqFw==
X-Gm-Message-State: ANoB5pm2QVpisUu8ZBYZwLSu1Wi8O6ZSBlz6CeO77W47tciFbHxrt2tn
	xW2yhbQmPrFeFueDtgbTDew=
X-Google-Smtp-Source: AA0mqf5AI018JjORniXqYKxttL5b+uUMhffATkG37fVLAjeMp4v0yTlOp1Jqv7OBhtJLBOOzUaPd0w==
X-Received: by 2002:adf:f782:0:b0:236:73fa:c56e with SMTP id q2-20020adff782000000b0023673fac56emr13767852wrp.432.1669286817360;
        Thu, 24 Nov 2022 02:46:57 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id k1-20020a7bc401000000b003cfbe1da539sm1298992wmi.36.2022.11.24.02.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 02:46:56 -0800 (PST)
Date: Thu, 24 Nov 2022 10:46:55 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
Message-ID: <Y39Ln9u9gwH2aO3c@debian>
References: <20221123084557.945845710@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>

Hi Greg,

On Wed, Nov 23, 2022 at 09:49:43AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.156 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2208
[2]. https://openqa.qa.codethink.co.uk/tests/2212


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
