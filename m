Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18033801
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 11:25:14 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id b29so16095676pfp.13
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 04:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tyecaq/gN+qBEfIyj0l1+MIZmCqNuoZxcsqFQnGuP3E=;
        b=AwEB63N3WrXRyhF2CPiGYeaTfqhycU8Ov/kFpAUKHKJ6nlf8jfcmtxqTps0tTQKhrx
         wPBd548bkip0o0OeQgXPt40CfzF2ta/RJxncB29ivp5bd4RXsZQW6QQhFEEYW74mFAkz
         NNS9QCJLoUCEPikTa8bEBRAMtOszT8oFuHMKE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tyecaq/gN+qBEfIyj0l1+MIZmCqNuoZxcsqFQnGuP3E=;
        b=57qT2qWL7IWnU0Q8cNaYVcr0XvB5nPo/rC0Pl8oIMFqnj9S6vHT/U78ZR1dixsCjgH
         jRl2iOjCsaPJ0D89FL6FxpQnBYiwmZF4VahkzP37A3OROORAN9TGWQcUU5H5KlxCTjdh
         bGl9l66rV+Lhq/WcA1PEKEo84SxeZb8sRe9D6+m9iZh6MQmkFnMa5vFh95yrpNkE0cz1
         W1tiyzbci7BW8xi9AvJIyOj4aE5Xb9ac0aaX2G1A2DGDC5VMjkkiQiaPfAEAeTSX10VT
         pAUc82PP9q4WmC0zlYE7/GlQyxy18XP8ek385UqC/GiFvtWms1IMHJBGfTuYhDnvpaQe
         GI/A==
X-Gm-Message-State: ACrzQf04udk8N7IFL8uYPkt2mWhr6+GVFgqHM0recIq9Go38x460Vnj8
	fBX1dcPRWoPRw+jM2m5tvYzfkw==
X-Google-Smtp-Source: AMsMyM7j3EzDQ8PvsNYxU5vH9j9hXlsXsRx4PEH6xdQBdsM/nwMQbNzO3gaLU5ujJxJNI9w9RwacPQ==
X-Received: by 2002:a63:ce54:0:b0:46a:e2a9:c7f6 with SMTP id r20-20020a63ce54000000b0046ae2a9c7f6mr21073216pgi.264.1667388314312;
        Wed, 02 Nov 2022 04:25:14 -0700 (PDT)
Received: from 77b1786dd767 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id u4-20020a17090341c400b00187033cac81sm5067558ple.145.2022.11.02.04.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 04:25:13 -0700 (PDT)
Date: Wed, 2 Nov 2022 11:25:05 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/91] 5.10.153-rc1 review
Message-ID: <20221102112505.GA934867@77b1786dd767>
References: <20221102022055.039689234@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>

On Wed, Nov 02, 2022 at 03:32:43AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.153 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.153-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
