Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6796D24
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 16:21:40 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id m8so1876577ilh.5
        for <patches@lists.linux.dev>; Tue, 21 Feb 2023 08:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nGfhTI+tFR4TsTGx5t43C5hwI9q8bNkRRPtQzmExCro=;
        b=lCd4S1J7YBv3me8sqi0gL1LRHFAtn+6jKH2Es6PCN9D/zE6rdl2v7ORyUUhJkD2myI
         2Afp7wwBzOI6P3OK/ztozGZBoN7In1UBeEWhpMkmMIHHiCqtpOWNbed017VHGlYPlRsm
         DSb51wZVYEmkReLuMQWjKpLavziyXS7fKLyGd2hs2xrHhFd3WF1SRAS/S+j+vg+sgvhq
         huhcLN0Q7qRMvfrMR2lIeJgbmDYTtSAYTh6HlZIAqpA+o/0Ii8pLxoP9//ShjcTRa5ta
         xlWJ7bODh3TEXM+GM/R6WE2Tequj7fmHj0epmqkBaZCp/QUnOW+gle6Jfa/+DhsLM0Wx
         nTjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nGfhTI+tFR4TsTGx5t43C5hwI9q8bNkRRPtQzmExCro=;
        b=BTURlQ5Ae3/lESgCrNxSyqx5UvHPw1oG/6pj6A7vgpUDH92vVG60gpMzwO2febMZZ3
         mDmNI6ze76J+w2pjKEmQsIhwaZ9YGpkvy0CFJwC0bKGsmzBo6XOGYfnifmRJzroMNjEr
         BjNSNjiL5kw/KiwXxMB/wCSyDd5LMaMrTd+JVJko+AF3y5FqvZJz3nDU75bk7frpiE06
         sT9y8EZJ4k/GYCHJb9bm6nB/9bojkTcMmya/xhMpPx73gNhHMvBEqAAQ+y2TwkFbeR60
         GJqGR4S0vzxQskIolMAEbcPoT87UTL9c0GBXuJVCKO7qDlmx/wrKgElzUNHafN0u/cuk
         naWQ==
X-Gm-Message-State: AO0yUKVm18xQnC5wiJZdCkYRylQugfCGCL1WDXjtoxchEvf8ZTRnJ3oq
	3O0ArQR+GSDndMsMO/E0CbA=
X-Google-Smtp-Source: AK7set8cYzP2KSyPOiPexjRBTfqKs8wnu8uRIJaBHpzYQ8F7MDO610Lq+xMoZQqmrrbVAd9U/bSorg==
X-Received: by 2002:a05:6e02:1ca2:b0:315:9bc8:ac51 with SMTP id x2-20020a056e021ca200b003159bc8ac51mr3151237ill.28.1676996499567;
        Tue, 21 Feb 2023 08:21:39 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g8-20020a02cd08000000b003a47dd62351sm4171409jaq.144.2023.02.21.08.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 08:21:39 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 21 Feb 2023 08:21:38 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/83] 5.15.95-rc1 review
Message-ID: <20230221162138.GE1588041@roeck-us.net>
References: <20230220133553.669025851@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>

On Mon, Feb 20, 2023 at 02:35:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.95 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 492 pass: 492 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
