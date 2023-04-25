Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D9D7B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 01:06:01 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-63b50a02bffso4388772b3a.2
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 18:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384761; x=1684976761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wrCAPeEXhKwKO/yYGy9jgCOEwKGr1fHsPVPzH+QsoQs=;
        b=GyA/wx0uI0tiaynf3OhQ9Bfcrhi555ap0/1eadvAg6PAxN7rSB/5FsbhFRxESCfEWZ
         xgsnpumQIXUuSgY/pFscRfLho9rnV8EDGKhuNt025uImLKJ4jeGo7qlhzjLXOr5xrm3S
         Iu6L3nBi3VTTL3PTgq3JDAttiq8N3tpFI5bT4Da71MpZoR9kRuC/JmmuKk8YD6p2ZhYB
         5jspUrTRCIv4RHvSKys0pZzQnlm2SmyMZZrd9Hs5FIpzBMIUWyN2SykGTu1srBvKUGFP
         n5tpATi0P83IFi/V41mh/MhFQ9Cz07I1L9jKqvMpC5729VXXB5irQA+RasEiJjpy8OQq
         xi7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384761; x=1684976761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wrCAPeEXhKwKO/yYGy9jgCOEwKGr1fHsPVPzH+QsoQs=;
        b=GjSTt/HeLmGPUhdl0zvjj6olrlWSAXxS6N2plFl8Pv+JF7YFkQSei+SGkwcz0UjQ38
         WZfbAQqNdlfnpopWxq745TBYswH11ihKlKIhDN/nqsVN3QF2WDq7GmCPjmwkt6sLMJ04
         0P3ceI8JVCjitEq4jr/+um5cBCfGcFfv3V0BlCN2sziBnDGNU9UJz/nLB29JpK+ijqF5
         mmPYH64yolJhnPc5jJFYBNK2D9fU53J+Nuwghw3MxY14Sx4+IzlMrF5i0dWWE7n9IQBX
         BN/pw5u+x6lkQ0u8epeGyf+Z566byFyEmzCDJkCRU068Z10nhpAWyKRWaoceGfAma8FY
         /I0w==
X-Gm-Message-State: AAQBX9cytynbFd5egcNrDnZZlpQUqAbP9Nr7oLEqtFGg/eEdNwohnpfP
	Lzt+ofemOO20cnRQjxkcGtw=
X-Google-Smtp-Source: AKy350ZKKEzwv82QiHFoPFRuqCyiUrmaGrxijZ7bf1D8FVpCDIvl8ezphoghTsA9cC+A9h6vNpqutw==
X-Received: by 2002:a05:6a00:a06:b0:63b:5c82:e209 with SMTP id p6-20020a056a000a0600b0063b5c82e209mr25149281pfh.10.1682384760840;
        Mon, 24 Apr 2023 18:06:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w66-20020a628245000000b0063f16daf7dbsm6423564pfd.55.2023.04.24.18.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:06:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 24 Apr 2023 18:05:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/98] 6.1.26-rc1 review
Message-ID: <6756ff45-c2f9-4689-8d31-87fa8337eb47@roeck-us.net>
References: <20230424131133.829259077@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>

On Mon, Apr 24, 2023 at 03:16:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.26 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
