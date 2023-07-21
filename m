Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41BFDDC2
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 23:14:53 +0000 (UTC)
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-1b012c3ce43so1886815fac.3
        for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1689981293; x=1690586093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8pl4+KEkTr4riPSItxRj6r6i2XVOObONgI+gpH8d55o=;
        b=QqAx9akK+6wVnxjRUgGX3AKizMFHDaWo1bP8k+aXYARshZGKcMt4etFHdi4ISpR85A
         yM93agVqtl8ELOR26QiyV38CKkedrrnrsjVv2/Hea7YVRUp18NXqmrsQu4DtzXV5izqQ
         nSmoNTVql0ajmSxPWht67scocCyUuUYScAEBE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689981293; x=1690586093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8pl4+KEkTr4riPSItxRj6r6i2XVOObONgI+gpH8d55o=;
        b=EgFoLcA2fodDWUKOzNqdc1sK3fJiQRg+i1v5sVhfzcbM2AWZMVXi/VDBpO2638nXqp
         xqIqeFQeiXVeSmX9Bs8ZqyhhJZWvYJKIjyptixtO55L/TwxE2KthB04IY1+Pzm8Q/aqq
         K+CpdWVunbpkV5z1kO6DhnsY/OhzY0Rq1oy3UiNgeELxR2iwP6PgTcuDNA6MhNGRo3qw
         v6R/qHaWZ4RgGJlNbSbmIzgcPMDGiuTcYVUWq1ryxbJDthSbEXXwUAuJMBEl6EQ8Nw+e
         kg4Puodr8gT7I8Ph4B4qCJVH0lu9S9B+4XHQ4+NPooGUUdkFSXqJ2lcsvwdAoaBTu0E6
         SSpA==
X-Gm-Message-State: ABy/qLZOjsehEXr1BOUspvr8eBHdSuRbNtskWpXtsvaTVXR9Tad9cXCj
	mIjJ11G2ZDmTGIILTlQ5Zk2Z7A==
X-Google-Smtp-Source: APBJJlFi7ua3WeSNgOWmcXMexHBw/DElyBpUADYByVQ1nOPHIcHrf2suS+VE/wRVlFb0YPikGmRjfA==
X-Received: by 2002:a05:6870:8091:b0:1ba:7f7e:2b20 with SMTP id q17-20020a056870809100b001ba7f7e2b20mr3907660oab.20.1689981292798;
        Fri, 21 Jul 2023 16:14:52 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id h40-20020a056870172800b001807f020a39sm2003909oae.12.2023.07.21.16.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 16:14:52 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Fri, 21 Jul 2023 18:14:50 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.4 000/292] 6.4.5-rc1 review
Message-ID: <ZLsRajeb+IAwynza@fedora64.linuxtx.org>
References: <20230721160528.800311148@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>

On Fri, Jul 21, 2023 at 06:01:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.5 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Jul 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
