Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88992B761
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 16:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JGWcqszK"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5859a7d6556so3695953a12.0
        for <patches@lists.linux.dev>; Tue, 24 Oct 2023 09:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698166736; x=1698771536; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XApgLgJkwGLPznBBV7b3yGWrUWswEGv1qYPFUqVGFAg=;
        b=JGWcqszKLg6JMyYFjy9oF6BAlSwHFuIFM1n1R9iI3Ummbtetc4sSxgorlHOYz1QCvD
         V7CKVsaI05tXUThUmv1ZdRYUnabTGfWBh0Ds9f2s4ykEs95gFVz7883EOM+lKu0BAO7a
         10qPiGQdcs763Hk9v1QCvtbvmFhyjGg9WOmvUgtfFDtdNXHRtr+++y4+8lmu/fzu1SCv
         +xtNbArgetOVjiSyi7AYsemdgityRs0VXLzMMWAt3pE4KfEs5bBR816fWync7jejWQea
         3ZB1vBOm69qFfPON+P7C1L0Jcrldlq+8lEkUfmwzYQoZ7PSKv4+e6LVXquQEhlT2s5KQ
         VWKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698166736; x=1698771536;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XApgLgJkwGLPznBBV7b3yGWrUWswEGv1qYPFUqVGFAg=;
        b=wfihH1RsNYaXCl/nCc3XtqzSnMV9/DmxhhvxWR9rtBe4aJTvZQlkpndxe3TH/wHmPn
         YdD+dYf3z45CalCmJjXhqJGwO8pAODNJ2Kz1sLMCDiUEYYtsuTkOMT7l9Y4KgpHjQxOv
         B6Mv0Eel7ul7VmMK4Kzp6fB/DpISrSbxCpqqNxEGMSQPbUfCSfiaDQ8yTOmry9jnJNSS
         zjUB5LBb3b60x0YZ07IMlTxJOf9320L+Vxrd+UcmbtbgNsrh/uCsVMSKw5oRfXhm1yGl
         kpDeLIHVZ2ais2zc/wOTvlYiwVxjErjGSI5S68iQEFJjwUHA0HOfxuhTu49NXcifwzAg
         qgmQ==
X-Gm-Message-State: AOJu0YwdAYsjFGy58M05wnHAWz4CG1KhOej7wH8b27HsZYCSazXPEFnY
	hcYAczdq9YxA3m6YC+HM66zWmOqkEzLFAvT7H94=
X-Google-Smtp-Source: AGHT+IGsqbSps0S/wo9bl6IMVr8qLMKUtaWRXnIEe8XcmwJnkZE4f4agHLIfKvZM/QQ9XcCZUPz1Go+o6cSBsnTGz8U=
X-Received: by 2002:a17:90a:17c4:b0:27d:3c75:db02 with SMTP id
 q62-20020a17090a17c400b0027d3c75db02mr12601390pja.32.1698166735988; Tue, 24
 Oct 2023 09:58:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231024083327.980887231@linuxfoundation.org>
In-Reply-To: <20231024083327.980887231@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 24 Oct 2023 09:58:44 -0700
Message-ID: <CAJq+SaAYiA31Yue0oet10rBVgxbJxHyD1KuYZw8-w4segj8iGw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/135] 5.15.137-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.137 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Oct 2023 08:32:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.137-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
