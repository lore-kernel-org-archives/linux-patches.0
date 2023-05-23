Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33DE01E50F
	for <patches@lists.linux.dev>; Tue, 23 May 2023 14:19:58 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-64d1a0d640cso4530405b3a.1
        for <patches@lists.linux.dev>; Tue, 23 May 2023 07:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1684851597; x=1687443597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qSaB8S6iMPltKJC6OceZ8AkCVMkwLB7jQ5nONfJjJWs=;
        b=lfNilZeefBWNt84JHJ0el8W+89Vs/JZYfiyTiA6G/aqGvgGwou0+z1E3Os/uHNNnkJ
         xo6SrNpz6weAKD2G5KaT+YIkQW5aDjDwhC+7sVswOhT8tZh2oybbAwy8QAPlzwOgKNjv
         6MYnhHXoXKFz3+l+vgrHZXoTfkYyiQpQYeXgk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684851597; x=1687443597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qSaB8S6iMPltKJC6OceZ8AkCVMkwLB7jQ5nONfJjJWs=;
        b=KsAOBrahkPcGk79Uefk5FH5jFnReRtsw92+LKihanCPzw12prv9QWeyYE6xxWc2eGO
         NDW8z8xEw9nVebmjfThk0Fgmu5csc1ZJ949MDYLeR4xsMeF6ujmNl+QqtRHBpiyb4zoh
         gAaamSdFmtUs6SsfetgeNh1aWAMgiuZNOUr/bhzwFsHmo55YdTA4QVxQFhTAta697Sqr
         KVMyZ6rulEkfv+D0k25xrRx6xLz7KUEGGywVdXS9HqhR3oFtaz9FOpGozvz40pRKwRr4
         4Zw5kp3+OOshn6CqNVj0mBDgmrvB+A3YwRpo8KNGPRnSywrO25yLa60fcKSMqcEsJJ3N
         Yy6A==
X-Gm-Message-State: AC+VfDweEROvXZ27l7pyF7qB8mJRHmD06ag9iF24ki7H9CVFAj1HbTpa
	sUqPni7DMevE1O38qDyDPt7s6w==
X-Google-Smtp-Source: ACHHUZ4KadxoD0Jt037h9tJ9dq8BsTt5jC/AWMCvzI/nuoobmcRmENwU0+79sZ6MvkqPkFPZFv7JbQ==
X-Received: by 2002:a05:6a20:3953:b0:10c:5745:3f4e with SMTP id r19-20020a056a20395300b0010c57453f4emr3506961pzg.56.1684851597339;
        Tue, 23 May 2023 07:19:57 -0700 (PDT)
Received: from d2762026c99c ([122.199.31.3])
        by smtp.gmail.com with ESMTPSA id b12-20020a17090ae38c00b0025063e893c9sm7577936pjz.55.2023.05.23.07.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 07:19:56 -0700 (PDT)
Date: Tue, 23 May 2023 14:19:49 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/364] 6.3.4-rc1 review
Message-ID: <20230523141949.GA175285@d2762026c99c>
References: <20230522190412.801391872@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>

On Mon, May 22, 2023 at 08:05:05PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.4 release.
> There are 364 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 May 2023 19:03:25 +0000.
> Anything received after that time might be too late.

Hi Greg,

I had the same build errors as Chris and Sudip.

6.3.4-rc1 tested with the following patch reverted
 "xhci: Avoid PCI MSI/MSIX interrupt reinitialization at resume"
  78887e3e5f00fca305670d8f3ba3c0f42b343047

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
