Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498161365
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 01:50:04 +0000 (UTC)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-169ba826189so8819986fac.2
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 17:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7NHm0AKOe5KR/2Xw1j7bTsvQ+lWtNdjtBx/zsfht8d0=;
        b=llKgGzRo6b4CLPCRhHtJb6unkhcStdzjo5481HR7CWxGKhYwXMgpd+WE89X62QpcOn
         PywPXCqRpdRWZROYxC7Z7Hbdo7Va62+DPHsZ9LnPPjv2QmAoAaBvuNcPAZSiDFnpaU9p
         gFDaBnSNbv/A0BGIFft1splMK3e58GeBim+6BGLDorRoXcuhVbkQAHvDP4kwfiw0wfbJ
         iyfFEeBpvLHpbWQcytk6ov5iY8HCmp41V4p8q8gBthJBpEpZYf0t39oaYuoFnIBcHJGz
         IVHoD/89TtnOsIY/hNv4x429khDMOFcZwfAX55Xd5jUGWO8b0q9tFPRxZvw6D2VLNFkJ
         yo4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7NHm0AKOe5KR/2Xw1j7bTsvQ+lWtNdjtBx/zsfht8d0=;
        b=WsCiqsVsz/vc9EIX/2TZ9QMvwWSG/UbjdXpt3Y6csVDO35BqBBdKJ+zcE0Hf31T1z1
         NJvq/4D51+i8f8VKhpLf3dSWv+Yi5wsN93CKL4GcKgEjH/SNdZ4HXIAO9iu+/k2NWG1R
         +etmQxvWB+ykUrF+0aSX0h/XBFQSs1YeeXWQMjA+8tnwkuudAkHpvzcQu8pBYFTPwrPp
         wO9SPMcQgeY8L6TvOgSCsWR5V+lqLDongaicJLSN9d41WrKgGnCcn5JvqskwP+vDdc4B
         DNoc98jP1CtBzYcXNIaxbyL+QnMyv3B0vhIu7ho9UWIoiIlUWWi93hl+5CgfIbzgc6BR
         gA/g==
X-Gm-Message-State: AO0yUKVre6TVoFRSSx53VhLZBOzJaUCuE4+wSFvZqpk4JD8T1GorGRYn
	74G76v4ztCHNYXeO1Ov3kxc=
X-Google-Smtp-Source: AK7set+vMfE9u10gbIODpQu7mZ1QupWySs8gsOgacAPk/2p74yzuRpdyq8Zyl0NVIQwR5RSRY9hUVQ==
X-Received: by 2002:a05:6870:3326:b0:16a:1615:3fbd with SMTP id x38-20020a056870332600b0016a16153fbdmr866884oae.32.1675475403441;
        Fri, 03 Feb 2023 17:50:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h41-20020a056870172900b0014c8b5d54b2sm1432242oae.20.2023.02.03.17.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 17:50:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 3 Feb 2023 17:50:01 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc1 review
Message-ID: <20230204015001.GC3089769@roeck-us.net>
References: <20230203101023.832083974@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>

On Fri, Feb 03, 2023 at 11:11:45AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 158 fail: 1
Failed builds:
	ia64:defconfig
Qemu test results:
	total: 450 pass: 450 fail: 0

ia64 build error as already reported.

Guenter
