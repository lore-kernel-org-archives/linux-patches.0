Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FD47E
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 02:38:39 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-12c8312131fso597317fac.4
        for <patches@lists.linux.dev>; Wed, 23 Nov 2022 18:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ienSnmYCrgek258e+ZJSHsCrXp4Z8ixedL6+majQKqI=;
        b=MIUDvjjrffXPR3iuKDOxkwYikhKDg5EMVkSd2LyOmIlECRF9COb90JCropA6I/Nbml
         KTJDcIoEBSVrP7SuG8vBZ6o1mngq5osfQ3SEsItaSyZEWdL6IgBGzKN5XkcswxPErtrn
         OLM7UtV2RNxx9fz/hNx4hhQ9SIj+D2DnLheTzfUGF5feesh3OxuhPuPNd7Q/UWNyMDsq
         VowyokzDz2oSzHQHfnrHznc3EueKREO8knnCawWhoTvSo8k6KtGMATZx2lelI+grxGQq
         12WLTjAcdRzVw+MebaabT3B6HdueOfxptAYUwkCAkWI0yQvC9/XiLQ24BFgcbCSZoPyw
         5qxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ienSnmYCrgek258e+ZJSHsCrXp4Z8ixedL6+majQKqI=;
        b=voWN6Zyf8Yj6RvXf6sJdrfDUKx4UJ5Yj1bMaF5JH88AC/erTF0rhgMfMi5wZbGaFw9
         doVehVK4yLvz5mUfQCnFXoXO5s4CUOClNTNUrRwvyxMPfiYVgQFLWJcNbExbUsNibsqQ
         p5r12gTubciG+kCKXSzxgcUalsJ9TfaFQAqaKdxa673eC/2pqlCNr20pN3yME8Q4AiGq
         zrDTRzg49G50EdPflanKi3qPoCUo7qvlCULDDt2GC25SR05bXloyJZl9AlIYw9ncPw3T
         drnMKPwLtna+at+aqFKHjKMCmqFSnKxqMmlnu91kcUEf8nArZmgzyR5Qy/TThYtZjgAW
         I80A==
X-Gm-Message-State: ANoB5pnL7hWUmmwEXpApB/Rxrc+atY4hksu6yYOZ2Lg/PmmfPJR5Avu2
	WZfCb4LRK+U/lzfzC8TC/XE=
X-Google-Smtp-Source: AA0mqf4jHmc41MB6MLKAyTTdfgojFkTOmYlEpcWfCkFgC7e0drwgP/fbTbE6yoyXYj7IymIDS2bcyw==
X-Received: by 2002:a05:6870:788a:b0:13c:f9d:e75 with SMTP id hc10-20020a056870788a00b0013c0f9d0e75mr7879938oab.27.1669257518460;
        Wed, 23 Nov 2022 18:38:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u2-20020a4ac982000000b004807de5c302sm4888ooq.17.2022.11.23.18.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:38:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 23 Nov 2022 18:38:37 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/181] 5.15.80-rc1 review
Message-ID: <20221124023837.GF2576375@roeck-us.net>
References: <20221123084602.707860461@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>

On Wed, Nov 23, 2022 at 09:49:23AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.80 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 154 fail: 5
Failed builds:
	arm:allmodconfig
	mips:allmodconfig
	powerpc:allmodconfig
	powerpc:ppc32_allmodconfig
	sparc64:allmodconfig
Qemu test results:
	total: 489 pass: 489 fail: 0

As already reported, the error is:

Error log:
drivers/rtc/rtc-cmos.c:1299:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
 1299 | static void rtc_wake_setup(struct device *dev)

Guenter
