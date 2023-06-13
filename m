Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E17B1361
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 23:10:15 +0000 (UTC)
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6b2d9ea4901so3123495a34.1
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 16:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686697814; x=1689289814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ThnGwJYxeqSNiOkoq76JlK5vhrFTF2bvs99eMiOK5Io=;
        b=B9tiGOL+/EfAowWlHC+ACMZd+O9ywfA4a1GLTVboS+3h2KicdVCCUibWxsnM/Yrh+5
         nbCVJqWEEikC6lZgKM8nzGYeQ2FoF3YrRaoFJCjaAT0Ra6CsdUHXh/jsvreEf89jJ1Nj
         MRh7077roodC9MvP6lL+QktRQi9o80ZcVoF46zfoFT+0uC9akbJsVlrEvjJe4RfcTqYu
         ONyOjlQ7/FE8CEp45Waz4h8/unBzxkJqQX6HnX8zdU6nSUtGS4LOZ2byKp7FQ0SFTU+2
         y1cPH7pGXWNaXT42WpWZh3aVvAaR25rCHQ0QOEtH2dWmRiJN/LoSt5i7misMWfpgrYrv
         Y7hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686697814; x=1689289814;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ThnGwJYxeqSNiOkoq76JlK5vhrFTF2bvs99eMiOK5Io=;
        b=KxfJn0E/5SJapEwqXktFOx8oZVHx67wxKQezVNKHqF5L7ve0ToMVKzZzx8KV919Uer
         K2RIhgKaX5E2V+TApDcoXz17NxHQKXFr5Y3BeH6aO2yX+ti/GbGIW56pVdxjMTZfHP8R
         SHoPoo16LEJ41hlxkVTv0hVfJPt7g8ZZwAee8jxBmVHSn9uXi6HCrADmMWdZifj5SwCb
         LnFQOyIEq7SEy05YEuYDa6njvRqi79LL/ZxbQLwvKae3e+9YYfv6mGTs+9EpNqz6uGnR
         v61Lhklxt6VAIJ/OCUTSmTXJpf0aXBGtbLNizbFJ892ID27RkAq93r5JfnZuf4AWvvI9
         OiFw==
X-Gm-Message-State: AC+VfDwjzCnoh6/CAM2mMrWjT4a6LSrBXBJtNxAol/NOR9oNhcr0Vn1o
	48wWEHougT6DDI6+3KXIN0o=
X-Google-Smtp-Source: ACHHUZ7yIK/lLhQ7hs5c+Ty0225YPV+i0YckVvHxyToPhsUOcH/k/CR66uX9UTZXQR+HXaDYSlld0w==
X-Received: by 2002:a05:6359:59d:b0:129:d242:f782 with SMTP id ee29-20020a056359059d00b00129d242f782mr7547135rwb.0.1686697814375;
        Tue, 13 Jun 2023 16:10:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k67-20020a632446000000b005439aaf0301sm9815843pgk.64.2023.06.13.16.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 16:10:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 13 Jun 2023 16:10:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/91] 5.15.117-rc1 review
Message-ID: <3519fdde-069c-4473-b5ae-bd3a58d323dc@roeck-us.net>
References: <20230612101702.085813286@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>

On Mon, Jun 12, 2023 at 12:25:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.117 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 499 pass: 499 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
