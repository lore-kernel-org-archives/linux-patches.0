Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F7F1E1D2
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 16:01:26 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1bc6bfc4b58so8414275ad.1
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 09:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691683286; x=1692288086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VCfWx3vFJ83mA2KZ0trVS84UlW4Ht+rf9HMJonRkhK8=;
        b=Pw0qghx/IUvl8RjVtfj1jkxgtwFx1jIJSJWi0ylXipW1SrhFqZoHbSlgUfVZZZ3lBp
         zUeo319gawOMYitBuu3FvynPaBD4df68XAhTBL5d6A4c8eTu11A/sXYQ1laEy6Nsv948
         Bp+231u8iPsDZL8SgOmV7V5Rlu3EGIh/9INP61M5VyoX056rJvP57F7P0y3O3Fmke+5p
         9gnfKmnHsT9dqwRRaKgqe3lJyH6jEI+gsts2VrOr6Q0+/RO+cr3x1v50bvv3J0as06YP
         8P5LIQnMp2FEz+4Lnigkmt3/6kxvSblHVmsOg0DCeL72hStLqSNYFjN2UFKgwx1X2zM8
         HVGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691683286; x=1692288086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VCfWx3vFJ83mA2KZ0trVS84UlW4Ht+rf9HMJonRkhK8=;
        b=mFnyaDwngqgm54xh/kF5huKMO6KxkiTsz/XU6YDZkwoR7GszoOtgLWxqDMAyN85yBz
         l+pBNEyDuO3wQuVXSYEO3cQ+A9eS4tAEDbJkB6OgkjUVjTT2yHhif5enyyCu+0ScVfDG
         AC8mOMEdhGcoeOOhVMSWI75AkyP/glqL8UrEmSqAe8v+pAcC1unAd+Q/LeaiCADm/nek
         9iGumMo2M2Qi2kQp1/2JuwkFB1TjUltCRXN40do7kUrupfG93B5oputrwmpPqWvUVu0T
         Atqn3Jwmij+ENbZXQpK+HfQ4ScE/oEQM6K4q9zt0XMjqAqoGwi+yGMA9vvMOTyUQBH1W
         IdZg==
X-Gm-Message-State: AOJu0YxBe18YybTZNYWOaa0/oVoN1ta7t/ycU5Dsm4xfoMowGkcfn3vs
	n8usYvOqgQx1CtZeJhghL7A=
X-Google-Smtp-Source: AGHT+IFzPJh6ZXg/SGfsGGVshu/4ERE5mmrJboBsvd1OozFBY7TNudilX6BZfO6Pty1CgVu/A1zpMQ==
X-Received: by 2002:a17:902:aa05:b0:1bb:c5b5:8353 with SMTP id be5-20020a170902aa0500b001bbc5b58353mr2302926plb.4.1691683286127;
        Thu, 10 Aug 2023 09:01:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902724b00b001b246dcffb7sm1943744pll.300.2023.08.10.09.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 09:01:25 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 10 Aug 2023 09:01:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.4 000/154] 5.4.253-rc1 review
Message-ID: <56aba1eb-ea51-4c9c-adf2-a4b8aa8f8814@roeck-us.net>
References: <20230809103636.887175326@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>

On Wed, Aug 09, 2023 at 12:40:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.253 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
