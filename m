Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79487460
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 21:47:35 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id bg11so19612oib.5
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 14:47:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1678916855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XNu/ZDxd1c/2898bC2pLvfVOQzHQvYoBI/Zo5PqnfbQ=;
        b=ZYA5aFwKbsbVsNtXAHs6cAkaw0w7EOg1zjhs+M794aOamSW/TRd+V0NONSBmPL9alm
         nNz3VG9ItXgvY87IrtgzL/bWuBi8MxsiHWPHXIXLJrpBHk8dIYudpF14aVtxkS1uEgG5
         64ZhuDD1A2NfeNINR56jDSjnzF55vnfed793g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678916855;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XNu/ZDxd1c/2898bC2pLvfVOQzHQvYoBI/Zo5PqnfbQ=;
        b=EzPxmGe5BjocYCTXoYOoxQjmrg2zLaZd12bIEtewzkkIjH+MfG6OnhtsmcfxYv0NJK
         ym7FVfgNs8NjeX/JIhAhro2CpnH/AluuaTP8yqWnMy7zOIm8qAgPImhX/93WtREgzZkA
         bQOUOSqjqqD6z0XAJvzrTQZ81CDZv0lBt49KKd9cPxZieysTm9Uc2H/cqb3JYSA1Au8o
         Iy+wjIoa743cw/iSLPbPjHClft1JFj6sf2aJXEyA9D6us3VREA9hQxXjRK3LZ/hLp0KK
         6V2G80k1bhvt9rUsFV1OTO7OPMUHn44Wg7fh52rRnr2m55H+ydrJ+Y614Zvei22STggl
         0l3w==
X-Gm-Message-State: AO0yUKXuB6IjHU6ssBdY56yfBfhfu2Mr3yH0jR44yIU408iWwA1YPTVb
	1A/5pyZ4VWDcyXPHmHvp7kLg6w==
X-Google-Smtp-Source: AK7set/1wOi6EX3ewTUrlh0Q+V7z3U5I3m2dJos4Lkw3/kNs4+4AWTV8MxqaKkoV6Egus8jGerD2rQ==
X-Received: by 2002:a05:6808:298a:b0:384:dfc7:7d84 with SMTP id ex10-20020a056808298a00b00384dfc77d84mr1844506oib.58.1678916854725;
        Wed, 15 Mar 2023 14:47:34 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id r140-20020acaa892000000b00383ecd10ea6sm2654963oie.20.2023.03.15.14.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 14:47:34 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Wed, 15 Mar 2023 16:47:32 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/141] 6.2.7-rc1 review
Message-ID: <ZBI89ARxCFkPvm7/@fedora64.linuxtx.org>
References: <20230315115739.932786806@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>

On Wed, Mar 15, 2023 at 01:11:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
