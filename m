Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59979134CD
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 14:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wo6PRUiR"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-1e9ac336589so4420666fac.1
        for <patches@lists.linux.dev>; Wed, 01 Nov 2023 07:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698850655; x=1699455455; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q0SsjUbKqrLXwVrRZWhYjp20BgDkLo5Efc4GdwHjgsE=;
        b=Wo6PRUiRDvfGSkd1sBxsY2hESwZ+F0M3fS9S4fPwiFx/sH6utyO9OMtPtb5hfiIrNL
         uGNZQtL+YfVsTPZnQugEWReyJfgTjU+cXvK9jHMcZfHFFujVsLfBPevBbqjvREufknVH
         b5JStgQwsyhd28XrSrCpQyZYhC4nGE38DpJLwvVHxIUqCBxrUFeX7i40YCAErTE+d6f/
         ruBefp/HEwbnh6edLNNrCMK888ygOQhB+GhbQ7pjzYcoYCGsFxVI8Fb6pOWts4zqWyTo
         PEMvvlWVi1uHuT8wdCUrbyIBJ1vxfBEaUXKezm6OT8KfQ9+4v1oytfSrImwGCasyxgbC
         /Hkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698850655; x=1699455455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q0SsjUbKqrLXwVrRZWhYjp20BgDkLo5Efc4GdwHjgsE=;
        b=OKgqPLgZHJzb5WXUzbTu75oyU812aVPnhuWFZLPw9cB+juS7D1nX2RoKdjl8YayU6w
         gm1ADflkLNxIVr9geQ75eORV3gjgAaecIfaSayvfW7DaiwfDDYzwszH39WLlKmmc0+YJ
         lq6WLQuZWTYLCr6Dv+/2arPYOjKyC3lalvCI/pGt4rRezhemjb6H4C/zmoCm/DQodpYs
         88iSJlA7aZfOY1lWmR48Iyvxx/KWse/Lr+G1bZXtyTx1EPuehOOvwekX6//bOuFLnYME
         f5/+QYjcoeDKY0F6bRZ50P8Zqz0e2xeikV8opU8DJSNiDbuWkChP443Hfm51EfLiIZhJ
         H9/w==
X-Gm-Message-State: AOJu0Yw/Q5ArZmyI6wPPSxhDr7CfU+R73BtwN0YSFeqcftMztpLjLc/R
	DIJ7xcSR1VBob5GT6ARnVNk=
X-Google-Smtp-Source: AGHT+IExZAyNU+7ZyeX8jdCMON9WDnbnuyvAYzflVYrli9zHL9lKASscJ8JjLdkOqzBhBFxbo8vj/w==
X-Received: by 2002:a05:6870:9d98:b0:1e9:c2b7:2c99 with SMTP id pv24-20020a0568709d9800b001e9c2b72c99mr21241281oab.33.1698850655241;
        Wed, 01 Nov 2023 07:57:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id ji21-20020a0568707b5500b001efa91630f6sm262387oab.6.2023.11.01.07.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 07:57:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 1 Nov 2023 07:57:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/86] 6.1.61-rc1 review
Message-ID: <fd7e4e09-bad9-496e-99f5-2bb029e1f304@roeck-us.net>
References: <20231031165918.608547597@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>

On Tue, Oct 31, 2023 at 06:00:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.61 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Nov 2023 16:59:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 529 pass: 529 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
