Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E38B10973
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 17:25:30 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-39a3f2668d5so644728b6e.1
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 10:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1686245130; x=1688837130;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wKBFg60cWuUD0LVXfKP1NLor9h+suWJBlukHsIpPRjk=;
        b=iN4601uPzHQNLlzHwONjgwmNfEIBvmsDmgCm/86VWnFj8eqqG5HfcIJ/UGRBQRWvx4
         XFXWZawEJTYwWvbjnrscXdqQKlMR0XbL6Uo5I3vARcoICcNg+nToGmS0AIRbeFa9xIAA
         vLuLsWl46WOIo7q48TpF7VYlxLPixAtY8C3CU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686245130; x=1688837130;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wKBFg60cWuUD0LVXfKP1NLor9h+suWJBlukHsIpPRjk=;
        b=l4X1ZuWMn2EijcDyHiXZT2HCEM2ToZa+aOdxf0sP/j2UoePGoTDCfjWk/MJ85PcKzF
         8jyadsCA9x2jShWvP+OH5fotIzlH8xsBw4kil3BHoaKoIvuo3XU6eBmTL0AEaQ1Npb8e
         eweTPl+1BHB98u+koAhjNlOiXT0LAZMEmecX++BMCatqFsaqXmcJ96f7VCexUuJQL5iX
         86WPmeEsKa4izffW64eY8TxWmSA345v66WOJ5QKDu4T9oerm3B9dByCQCmI/wvp0KEtH
         tVUSTuUQQzyOB1Ctd+Tg3HbLiAjXTZHkvwCESbujtzW0i21zn7s0pckeZUBGa2LG9Gtp
         43fA==
X-Gm-Message-State: AC+VfDwr33RRltM2GcRcaoLKyGc2+jZSy6nZOwNwSEqM6ytokiutaxhd
	GvEO9MQMh+RbPomrBbqG4qgEqA==
X-Google-Smtp-Source: ACHHUZ6oHplnoBJLkNML8qJBJBs2hZ6s/0SNRjXynHk9itwTvZD42Auwlu154ksXHwS5kgYjwfAPqQ==
X-Received: by 2002:a05:6808:98b:b0:398:2b78:5a53 with SMTP id a11-20020a056808098b00b003982b785a53mr5626118oic.40.1686245128739;
        Thu, 08 Jun 2023 10:25:28 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id j132-20020aca3c8a000000b0038c0a359e74sm626111oia.31.2023.06.08.10.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 10:25:28 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 8 Jun 2023 12:25:26 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/286] 6.3.7-rc1 review
Message-ID: <ZIIPBuKQzllrV7pC@fedora64.linuxtx.org>
References: <20230607200922.978677727@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>

On Wed, Jun 07, 2023 at 10:11:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.7 release.
> There are 286 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
