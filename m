Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0675739F
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 20:41:58 +0000 (UTC)
Received: by mail-pj1-f45.google.com with SMTP id j8so11337374pjy.4
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 13:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681332118; x=1683924118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hl9sCiGfDSiyFdzk6F9ozEO0BgQb3bdfVK/ZFLs3Rec=;
        b=KW53y1eMdYXi1Ugvb5GSc4XHAUbz4MBJzeFgMXx9gYfbmlHeBzDTx7/DmAIUysi+jZ
         cn6P7kvdSHGdN/24w93MMe2Ces9uKlRNPdx3gXg0t0ZeakMXy3x0AsGc25+0Lb1BX4mu
         8+Q0y3smH/qF1gzT8Zw4gIvlVJnIFfFq6paFOSSzwReofXsx2D0XN+LwW9oPN5lSbVop
         ydrs4p0hDjYANLNT5JxPCM/vEqxl267PRoDrK6wxnfOVfz8Cls5IltWDi7T2QZxBNh3T
         2lfqzsML0i7zl+5IRbW7+qLeCcGANYmA2FjRoBTbrqJWU0VPrvW8hXHC6YmJpJUOqmp8
         ueLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681332118; x=1683924118;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hl9sCiGfDSiyFdzk6F9ozEO0BgQb3bdfVK/ZFLs3Rec=;
        b=Wa2lvNcH9923srQT9wfe4lQkM0vOmVkLwABFoOZlhVbIM4Y3BMKHRbdiAlgtbesUSN
         5igaGVpbE2mszv8NwsEqHOvTUk2EExadQnR6LXoQPsum/zsSWDbcpQL7gKLvHFEXdZHp
         +ZX8ie6ObSbAmzcxHpd1LZA85jLmaeHathimUQtcBK1UN6WP5QEzsa3JVpLDReOC7+0v
         yqmdPl6HrBI5fetTifJ+fv1G5DGVTn09Lxm4zpw3+0AxIEYOGnq33cLRbuHe4E3uZfxp
         a0ECmLN22NJNnIb/cq/nmdrPMqXcQ0IWXOE4pcioydZXA2LUIrXHUv+v2kiWdwumUTBL
         MSfA==
X-Gm-Message-State: AAQBX9chJfgA7LrNJK51LBw4HYuiA7kIrgO5bdo9lIbLoAQwmd+l7Yye
	L8ZNGOE1r1jeVzC//pvugeo=
X-Google-Smtp-Source: AKy350bVi5vXq6CC2Egmi3HVYVAB891DpVnGz5volM1VUtSzz82SvlVYzTk/uX4Ln5NaFx9WETF7sA==
X-Received: by 2002:a17:90b:3b8c:b0:233:e1e6:33d4 with SMTP id pc12-20020a17090b3b8c00b00233e1e633d4mr25449629pjb.47.1681332118255;
        Wed, 12 Apr 2023 13:41:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bh2-20020a17090b048200b0023acdac248dsm1507561pjb.15.2023.04.12.13.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 13:41:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 12 Apr 2023 13:41:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/93] 5.15.107-rc1 review
Message-ID: <b94560ed-90d7-4d64-b15e-03478e1e75c8@roeck-us.net>
References: <20230412082823.045155996@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>

On Wed, Apr 12, 2023 at 10:33:01AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.107 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
