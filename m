Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69567F
	for <patches@lists.linux.dev>; Fri, 25 Nov 2022 00:29:11 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id db10-20020a0568306b0a00b0066d43e80118so1789073otb.1
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 16:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rTkWTJr+jVo44z0ToVSWhOX33FwS2vLhzhC45GxZgmU=;
        b=Qdjl+pr+iIz3S+2tn1Q0JU7ziR4GJ03sr352O+F4nFNUm1ZTG52sYXAn95iZZhHWA2
         vfyvvqmSy/GXOB8bIDWNZaol5ovJUTOs+XSMPsjBBdwVwt5nfJGp+M/DyGLj3qCbT6nF
         MIuRFfqjJ3qVcCymi6VGzNg03Rj4i/w1QMoF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rTkWTJr+jVo44z0ToVSWhOX33FwS2vLhzhC45GxZgmU=;
        b=TbNTh0FzAHwy48eqTl/A7A9wUmsdmf/z3/cA+Qdkh8l1j6+I5nkVFnKbQtxWO6ZJGx
         8Gm4jyNbuDW1wuI2NevHE02zR8q3KNsLLqUT0hXrlCFRLRhWjVR6NtPoRFJfOMMq2T0n
         /f9rybHopzW9wnxopJOSBhJ4tVQ+rptrHYCs8hBTCmESevv+2XH8vMXBTg/QJOp/wFag
         SfabeY696+yHdNmJc9AOb/yT3bZAtlsuxbHJh34ZbdVm/ntoLZgx3XD4vHalF7kM7zeV
         Zi//LYeJjCgF4zq2MPjlgsgcul3TAkCkQKqBj4F5oCbvBQRsCUZUXwVvhwTIIRx83lZ8
         +M5Q==
X-Gm-Message-State: ANoB5pmBbf49et9j1gIDzeXE0tYCyY9i9AQNUh362exlfC6U8OxZgNE0
	CvRB7eGPHHTtC0WZVhvnRfPBQA==
X-Google-Smtp-Source: AA0mqf5Up/gRWD0unDI43s9o/afyX5Cgl0YlLTTlVxTCX38dEV155pu9MJQMQWx1c5O2bS1YQcANXA==
X-Received: by 2002:a05:6830:1604:b0:661:ef0:230a with SMTP id g4-20020a056830160400b006610ef0230amr9369057otr.235.1669336150530;
        Thu, 24 Nov 2022 16:29:10 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id d16-20020a9d4f10000000b0066c8bf7f196sm972120otl.51.2022.11.24.16.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 16:29:10 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Thu, 24 Nov 2022 18:29:08 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Message-ID: <Y4AMVB9zUGgPQbLk@fedora64.linuxtx.org>
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
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
