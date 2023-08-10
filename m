Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB3B1E1D2
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 16:06:03 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-563e860df0fso857892a12.2
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 09:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691683563; x=1692288363;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7QTlvRoNFyRkX134ok9OXAI5i34/aitXtvtzRW1b4zY=;
        b=c1uli04YlC1QuVJyrnAyDUG1dktQfEbYV5+ruAVTnx8APe45u26qzq22tpvrFSa7Ji
         9LsFSCkQ1YVNAocfwIqISiw1/XWQr7acau6ys3HEjIocGbqaIITvriakFIMhIcVGckpG
         h71GJ98iZmp+FAax/QUIEO/+njb+FoztpoY4NyekEhVw3Mof6jyHVUubWo1gCzsTLO6l
         4viT+RsV53XY5HjoESUYXKAtOON1uyys0xgiTz01IINMw1UrnctBgJDFH3dVmO4qCB10
         Dd8sL0asyPXPy91dVOCcYQk4R2FZ6bQbo/LbtEV8kHrTQIKopbaeR/RV2uQTZJ0zGTUv
         LPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691683563; x=1692288363;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7QTlvRoNFyRkX134ok9OXAI5i34/aitXtvtzRW1b4zY=;
        b=SYY3XKutfMTWX118N5gHCGshW/xY+nY4HXjnlsgEHA0gGhQA6vNcgHN01jWkpB1kmh
         atWw/EMOdvItj6SdF4FMKgjQYTHSCDdAGiLvc32mq/dqeSncBG7sttsgWH3tG7N4cCob
         VYcYpsJI32YsLx87ZigDEzcwg7JGVzmYnYWrgXHv3qV4YTi8UzgfqDaZC4zVPCiF45Ee
         4/+cVN3HrhNfr9xAD5eVb6qOQpLXCzci0fDt7ptDH0ZK+/NZNeH5NsBgE3pzfOAIKKrU
         LWw1P++WDhgINQvbcdljF579u/t+ldaH6p7IXxojZZKTzy983MCQL/3liTDOkEJPqJF8
         ggAg==
X-Gm-Message-State: AOJu0YykYDjZhwES3uot2im/5Rvnrp7qSIBT9J1O8dAnJUj3vj64dTlI
	e+POC1iyswObpHGrBfkgSBQ=
X-Google-Smtp-Source: AGHT+IFYuzGXk0YLQzgsucbh6baCPkIJDrQ80m5KaFMbG7JdAt8Ixv2BouUHDvkq9z5yklEglcqWKw==
X-Received: by 2002:a17:90b:4d8b:b0:261:1141:b716 with SMTP id oj11-20020a17090b4d8b00b002611141b716mr2564311pjb.33.1691683562805;
        Thu, 10 Aug 2023 09:06:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n20-20020a17090ade9400b002682523653asm1685322pjv.49.2023.08.10.09.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Aug 2023 09:06:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 10 Aug 2023 09:06:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 00/92] 5.15.126-rc1 review
Message-ID: <681f8e2c-df72-4a54-bef8-803ac0bc69f6@roeck-us.net>
References: <20230809103633.485906560@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>

On Wed, Aug 09, 2023 at 12:40:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.126 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 157 fail: 3
Failed builds:
	arm:allmodconfig
	arm64:defconfig
	arm64:allmodconfig
Qemu test results:
	total: 501 pass: 423 fail: 78
Failed tests:
	<most arm>
	<all arm64/arm64be>

As already reported, plus:

Error log:
drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_plane.c:176:20: error: 'drm_plane_helper_destroy' undeclared here

for arm:multi_v7_defconfig

Side note: I am surprised about successful arm64 tests/builds
since arm64:defconfig fails to build with obvious code errors.

drivers/firmware/arm_scmi/smc.c:39:13: error: duplicate member 'irq'

drivers/firmware/arm_scmi/smc.c: In function 'smc_chan_setup':
drivers/firmware/arm_scmi/smc.c:118:34: error: 'irq' undeclared

Guenter
