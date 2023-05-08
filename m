Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8205711CBD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 21:49:12 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-38e7ce73ca0so2496263b6e.2
        for <patches@lists.linux.dev>; Mon, 08 May 2023 14:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1683582551; x=1686174551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fehA/P0nQb9AOIPJIL+h5u2kmPqGkpBLIR0S5RMmSKI=;
        b=JFgseqpeK7kU17cYODycdW5zMKCclYUit04E0+ylKKwaMoR9PROe3bQ7HM7L38PXns
         a902OkAH0fPnD4P/9Z4t7BvqN8A/Q04woEy3McO/b/NIMTL1Q1CAaGyCMFv4HlXMi8xj
         QjvlLsOUcG4q9nT6ebGMv99tTCzTXFvHbvfkU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683582551; x=1686174551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fehA/P0nQb9AOIPJIL+h5u2kmPqGkpBLIR0S5RMmSKI=;
        b=cieOp48/Hf11/DdJPu6kcy6XlWDjZlHtwDfj+rygmjb2xftjS7vl4HtreKVkDZMUi8
         hqzQqbo5Zyl2HeD4g/GBjwdcreZYE+9wYOvTlmZcfUK62L6cj6of0stDUR06/gR+h71N
         YI20kusgWsDuGYR3yT6gYNuqFRtLhXCGjrZ0bYVz6Izqt9Mk2XCKoNjeKYMHxEtQWsWM
         fXhAAy9hpDjm/YZFQa5QGtbrdYqkyoFEoemyKenknTXhp79Mr7gLuceD4UCY+b28i9hh
         D8rLlBbV3Mb4RH4ErtVpdMJSky3xLyVdSZi9+8teEDuvD6z39J75tseeJ3sy2Zb1OJRy
         qXGA==
X-Gm-Message-State: AC+VfDx8v0X9tr0a42FQV45zpG2WAEFyJw3Uwg3d+TVpYmhyYENhvDqP
	kqahbx/ONBXnuN1wlD/iCqA9Zg==
X-Google-Smtp-Source: ACHHUZ6GXb//BsLxdDYdHqYWGIQYHQX09BeAL9X247lAM3+D6OTn9XN2RfPNoqJoB1J7oHi7q/8WLw==
X-Received: by 2002:a54:4499:0:b0:387:4984:ea81 with SMTP id v25-20020a544499000000b003874984ea81mr278633oiv.17.1683582551378;
        Mon, 08 May 2023 14:49:11 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id s11-20020acac20b000000b003895430852dsm466559oif.54.2023.05.08.14.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 14:49:10 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 8 May 2023 16:49:09 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/663] 6.2.15-rc1 review
Message-ID: <ZFluVYBfjfyS8eLd@fedora64.linuxtx.org>
References: <20230508094428.384831245@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>

On Mon, May 08, 2023 at 11:37:06AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.15 release.
> There are 663 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 May 2023 09:42:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.15-rc1.gz
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
