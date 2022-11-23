Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEE64699
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 17:03:24 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id v81so19654777oie.5
        for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xvt9NMUMshKq6vZrNophFamB+BPLohd5Icmfx4xFrM8=;
        b=bm9/oOvAW0+K3TJJ7Gj5sl3POoljrlM5fVEpGzyPYDn4OCbo2EeE67VBrIOriN/jqg
         ht41OZVqCMlusFwyludo9TG2r5836OGVFluTeXayWnJN3BwV1XlA3NC5EVlIkCH5gHPJ
         HN27HGz0DIoa4TEqjlB9O3zEO5gvarItsEocQ3K+jerWc0/bh90xxvNYnOYfAv/nSFQw
         gMQOc6drXwiicuWIoc7v0eKNzPfOY3raHDwtA6vTKMmZbIBh/28u++jjNJblBh8RKK07
         Io7YWkQaVhSTvIaweIs8MKe40rxEWQFmw7loCuk+6YlBZZUerx9FXPWKZgeSKXnez3Nu
         U+mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xvt9NMUMshKq6vZrNophFamB+BPLohd5Icmfx4xFrM8=;
        b=xayj0NE0Dk9FwjmPWdTvUfpR4E1xtbaQ/enqWw0kYnqyKGE7vGnQ2iIh+OGaHhPaPb
         lu/NRGEXqpkm7fDxduIFJh/I48uhR3bXCHhgy+YOiuqWo/A6FF+1BnLCMomLxL8Ktb83
         bszfbvbjlZf+14LakSKE06hXsVGQbknTTgd8gOz6LomIoCgBIkmKEY/94gNMzhSOV4N6
         8TIPmnOz1I8siZcZtQXCiQmLvlKe5+YpsHawSYsBHTYvixx/VgY5CAoGoVBOpL8qP00N
         H3azWTknHzgken7PNW7WTHFhwJqbCElAEHRaxfU3KKgVH9JhEfZ1L7t0wtdbuldbPn55
         T6eA==
X-Gm-Message-State: ANoB5pkKl7B3cqC0QFBRSA0qWVslvDWQcU+TdiyKCPXWZ4YCpO+f3l+X
	yCU/RCjYK3Oq2y240mg3dWA=
X-Google-Smtp-Source: AA0mqf5wBlGvPRLvp/pTWhAa3z7dqWlSRK2KNfpsujr/Ynf5V+BHlGBDdSDKcoDbs2wesz+bqx1Fbw==
X-Received: by 2002:a05:6808:1115:b0:359:cb71:328b with SMTP id e21-20020a056808111500b00359cb71328bmr14023971oih.282.1669223003837;
        Wed, 23 Nov 2022 09:03:23 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s8-20020a056870248800b001431bf4e5a0sm2090707oaq.38.2022.11.23.09.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 09:03:23 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 23 Nov 2022 09:03:22 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Message-ID: <20221123170322.GB3745358@roeck-us.net>
References: <20221123084625.457073469@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>

On Wed, Nov 23, 2022 at 09:47:25AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build reference: v6.0.9-315-gdcf677c
Compiler version: arm-linux-gnueabi-gcc (GCC) 11.3.0
Assembler version: GNU assembler (GNU Binutils) 2.39

Building arm:allmodconfig ... failed
--------------
Error log:
drivers/rtc/rtc-cmos.c:1347:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
 1347 | static void rtc_wake_setup(struct device *dev)

Guenter
