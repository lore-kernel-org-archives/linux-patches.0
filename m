Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDDB7E
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 02:39:34 +0000 (UTC)
Received: by mail-oi1-f172.google.com with SMTP id t62so304662oib.12
        for <patches@lists.linux.dev>; Wed, 23 Nov 2022 18:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=INRI4j7u0ywb8VN6ROU8d4+uuUvfHheBW0Fak5UKexc=;
        b=Ifoa+gBezHayJ8L1oRtUoB3+5WzF0EvHQk5wN+6ezTKexHiJjELDyGAxvkP1YiaTyY
         2uyzbMuzBurx/5i0cStZsgKHs6rkRjI9deZfC8Dxi882MYHO3mpVMs0BqNwELNQUYDx6
         JcaycZsTst0S0J8AOIgeAdBcPciigpl9OHpd1E4rVYbslgbD3oEzfgGFBtATWIWMu9eW
         lbCtZ3Z1wwlIrgXJkpzKU40mPsAa0lUoe4l/VVi8D3kNceW0AggZHdx52N8THv8gAnwl
         DpLfSAmH3sRFnCOezu8J6LtPOEX6+WyUM/D4UxJJk6KQqr8lWsUTexz9LsNfYnvGYjNK
         oP1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=INRI4j7u0ywb8VN6ROU8d4+uuUvfHheBW0Fak5UKexc=;
        b=xNZC9S+Q/7qB/BmYlxv4+qezBgnS2DAB7fEEylt73mCfLSBQgFPTts7xktNVpG6LHs
         mXeMRJa/21bxorOnCPWhDR1X8L3rnkxVhgogLxTLzNKLag1wmkya3R4huxy6HRb3umVN
         VWXTO1VPUhQMRGNhUcEmlPfzjUipNoPhlJS54URjR9iC/mEi/hjZnQYgjzpCVYrRt3BB
         iKicLXQEddVIapg5EZtTadvOxMTzA172r/m/Gggdo7ST1RDL73C8mM/yMlInbb8MeIOq
         UNOff6BpD1rYGQEie5fOumTgKvmUr8mx2a2n5I1wTqJAfd5VS1/XT+hVfUpNkToo5rah
         9/WQ==
X-Gm-Message-State: ANoB5plYvdKi+LQgw546hAHI/4xLbjRhM9CF46550+VM07USf4VVa11g
	YmbYGJ/PQkVG7MyhngCc0yw=
X-Google-Smtp-Source: AA0mqf5rxKdUPlF/w5S0LSfmz4QOv3bm1rR4PokvvsrEZx8F00GhpZatCGnnb26bI519OMyP0iqkCQ==
X-Received: by 2002:aca:3dd4:0:b0:354:7326:8b07 with SMTP id k203-20020aca3dd4000000b0035473268b07mr5824182oia.43.1669257573489;
        Wed, 23 Nov 2022 18:39:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k5-20020a4a8505000000b0049ee88e86f9sm11789ooh.10.2022.11.23.18.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 18:39:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 23 Nov 2022 18:39:32 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Message-ID: <20221124023932.GG2576375@roeck-us.net>
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

Build results:
	total: 152 pass: 147 fail: 5
Failed builds:
	arm:allmodconfig
	mips:allmodconfig
	powerpc:allmodconfig
	powerpc:ppc32_allmodconfig
	sparc64:allmodconfig
Qemu test results:
	total: 500 pass: 500 fail: 0

Error log:
drivers/rtc/rtc-cmos.c:1347:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
 1347 | static void rtc_wake_setup(struct device *dev)

Guenter
