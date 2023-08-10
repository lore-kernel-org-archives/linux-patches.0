Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE211E1D2
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 16:01:00 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-68706b39c4cso788749b3a.2
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 09:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691683260; x=1692288060;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wjTeYbFZbYKPcKF+bargQV6tYusrwZi5lIEU4OMkY/E=;
        b=KPLvINHkZCohYHANmrMub0k7TT3l5/FPsM6iwBKG5HvyGOS6WTV/FVHu/6psIhCePY
         QqpzldZRt7cwhjumPUI24RUeSG5+cfVZGaM2Ysg6+mYlgWNdIeWAInqbbbBcOxwQyx56
         hW0eyNgs8p0V9w0TEvwX1FE3MpCrKwuFghbdRuB4AptyGHynuNSKATWZ06NZi0htCTBQ
         9drUJ4c+IpniniJaOvLm78OPkhT35cidCA8SRLXMSXul/49tP7QlSy27Ag0KjsfjUJ7y
         2N6Zod8MRww1OUE6qS4HzN/Eam/+pEunmP2SvUv8XanNDRcKn+/RkzVM8jZI8zdYfs6q
         weYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691683260; x=1692288060;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wjTeYbFZbYKPcKF+bargQV6tYusrwZi5lIEU4OMkY/E=;
        b=hrIckP18qqwQt3SDrYaBqS/lIV6acTlKMIh29GZh++vxYqd5NPcBtySKsZMb71q60y
         a99kZB0wkUBo5xaV0a6ss2iPsW+Vfw59wAhgzGgTBFdJZrMMSmo7x2mMw07w2HBdIGbI
         UnkaAWUrIiRqJBGAu3GFJ4vTsNY2mIvGBK58Cv8ObwEPulAs2e89Q+y4s6WxAiCjaD9x
         ru0qZoSJ2j0l4Ka3+Hvc5oVTvT5+JKiwgpQYD4EEzUpsq4vdSWyYoZaUXBPbp47sScnu
         bNmQemR2UMwUzh2qltf2jDcBJj4BDj3NyT87oiSFAuJWqAWP2eY4nYlQYS/0xy2Mmhmv
         u6iw==
X-Gm-Message-State: AOJu0YzopwmorsDkIUn3JNLLSEYPd1stx+LF6+w+ZJ5bOgXm9nSxTdER
	1yQoAGPQuLmTS1g3t3r2bCo=
X-Google-Smtp-Source: AGHT+IGeIrtOYyWloO8eecZ9t1WCp/6HVPRvaBU7e4/G1prfV5kAHCCDzYkysAJV2BvAAYI/QzxJKA==
X-Received: by 2002:a17:903:1112:b0:1bb:a367:a70 with SMTP id n18-20020a170903111200b001bba3670a70mr2664565plh.17.1691683259835;
        Thu, 10 Aug 2023 09:00:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c1-20020a170902b68100b001b53be3d942sm1941107pls.232.2023.08.10.09.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 09:00:59 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 10 Aug 2023 09:00:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 000/323] 4.19.291-rc1 review
Message-ID: <4426cb20-3165-4e9a-9309-14b376e9f61f@roeck-us.net>
References: <20230809103658.104386911@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>

On Wed, Aug 09, 2023 at 12:37:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.291 release.
> There are 323 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 149 pass: 147 fail: 2
Failed builds:
	sparc64:allnoconfig
	sparc64:tinyconfig
Qemu test results:
	total: 432 pass: 430 fail: 2
Failed tests:
	sparc64:sun4u:nodebug:nosmp:ata:net,e1000:hd
	sparc64:sun4v:nodebug:nosmp:ata:net,pcnet:hd

Errors as already reported for v4.14.y, here introduced with 4.19.290.

Guenter
