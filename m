Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380C3EBF
	for <patches@lists.linux.dev>; Sat, 18 Nov 2023 00:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=heitbaum.com header.i=@heitbaum.com header.b="VaTf0fP9"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-28396793876so1462177a91.3
        for <patches@lists.linux.dev>; Fri, 17 Nov 2023 16:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1700268778; x=1700873578; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KbIt0RC8fwx+JBBK19uY6YIBtCeUq3tJXkgbuxVQjvo=;
        b=VaTf0fP9IOWhz5lC/5KHA4IQ2Jg91hh3bHMHT/j0mFpG0EOyW+Fy0zeaVoG3JXME/N
         iUBOpZKUO7YBy/RpJmLIYTRcKH8U3yt44cHUwJMnzaD/q0uUWsPTnb3hw+VQSUetb0uY
         XyOgRIFC+qrk58XyYUfP9BkCRlgMjbl2oaTBQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700268778; x=1700873578;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KbIt0RC8fwx+JBBK19uY6YIBtCeUq3tJXkgbuxVQjvo=;
        b=pmj+K8CT8X4jtKs27ePJei4S3PeDzjAe5oaT1Qcw7m9s+6f/KYExaDt4RthSuQr9Jn
         qJ4OhB25EjHm8Ss+ITOjKIlUBExxDO7/GywbS/itdDu0/IkC1x2Cns8WHm5KTCI8GnO2
         9A+FTVVoCr/NuNW1hVNGhsi//YVZHbHPqtiSfGax8YK31w9qZqDDADD05gDd2Zw0STgH
         6u+nSEDmHfP0MZtvB0F6rXjSbcWEqMdx76DX45IPpE1S3fxWAUqBaUOseYaWunP+mGFy
         buJdhBEwYVgmwjkhVg4LRRJWIu4ovIdF2eJ3hnXZV4jLVyb0fwBI7UsQ7BphiXJAd4n4
         Ga3w==
X-Gm-Message-State: AOJu0YyhzF6RN3U46ucjPnN3b8e5J7BIrNYKBL+1NmwJ51UEt2i3V3NO
	qFWwsU+f/li9hwNwgUOE3aoQyg==
X-Google-Smtp-Source: AGHT+IGIkXYGN2lacDFlwicQRn/oQ5YpY77jSOvHRUnSKCFJXI6necgBdoFPjPospalwTJlRyp2uXA==
X-Received: by 2002:a17:90b:3851:b0:283:21d3:11eb with SMTP id nl17-20020a17090b385100b0028321d311ebmr1191273pjb.3.1700268778202;
        Fri, 17 Nov 2023 16:52:58 -0800 (PST)
Received: from a20e1fa70cf1 ([122.199.31.3])
        by smtp.gmail.com with ESMTPSA id b1-20020a17090a9bc100b0027d219d3ac6sm3734494pjw.47.2023.11.17.16.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 16:52:57 -0800 (PST)
Date: Sat, 18 Nov 2023 00:52:50 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.6 000/603] 6.6.2-rc1 review
Message-ID: <ZVgK4g+uTiVQsbF5@a20e1fa70cf1>
References: <20231115191613.097702445@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>

On Wed, Nov 15, 2023 at 02:09:05PM -0500, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.2 release.
> There are 603 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.6.2-rc1 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
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
