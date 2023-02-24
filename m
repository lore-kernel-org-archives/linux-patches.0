Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C483B17C7
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 04:28:45 +0000 (UTC)
Received: by mail-il1-f177.google.com with SMTP id l2so1708640ilg.7
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 20:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6J+e0VKbbp3H0TYyNveZYjDHxPFvQQ5cybpNvNw40/8=;
        b=flUuocuFapCrkmQsf3INc/+2ipzpBKBe4QCEdBB04vajQtORxlP0C77/OhTdLBuWEE
         Ww1scnjvjtP9iqJ+uQ0xez16LpwzDuDCc6NpPRiYP0WBHn4/b64ZuvZP3ooAQXW9Ak6K
         MkYW6rdADqTUNak74C9RqKAL9k0HF+xB7tfdROxZc2452Olb4RLq+0vo80hT/kmn+DqG
         EUluk6tfTHuzWuFCRHBfATK2/8kgLcJaPgDUBuXVFvHT5eiDeTNHv+yjCcrTBcVsSarl
         S/zVcYw1LKEktX/+ldSSCGlCQejF+3FMtgiMIfQXCIyVTjf/Jhi6NDD9n3QyI4cY0KHO
         blNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6J+e0VKbbp3H0TYyNveZYjDHxPFvQQ5cybpNvNw40/8=;
        b=RYlr9bgJlIJrEN2bY73e95kmr1CNUyOHRpWtRCLO+LQzGcVITd3HcdmRo5amjZ59X9
         6sSB7r8l2QTjIfuGD8ZReLUafjhpD+8+gehp3uxb0mHmaZ4xYdCSTs4UlULEZAKEYXA9
         rPzw6/P4cOl74miT4y4gU6fw2ld0gR2B66D+ImDa7uIgKm8vaJCyw0URk2g8NeQ0aKot
         fzBM0KM4n/mWwZbsq6PbkTEUmotBnW57PRVQNVSd+lJnLSwHOIpHZtlrVoA5KsSmrDpR
         HfaadL6Gwmy+gCW9ZpFk/zMnBChAxmgemVI7Tu7DD0QzaFfREb0FGwITtlBcRAwrhfqo
         jwgw==
X-Gm-Message-State: AO0yUKVUnoneg49TY7tsNf5OhvhC6asZyIyDFCz7GXBWZNeeNWwbvDO7
	+tox050g+gsL7vot9nb9Tis=
X-Google-Smtp-Source: AK7set9bVsbJUcbP7MtVR+cbHEi3s6nLwciWQCP5pLfrhdJqa8lHmec2OApkZ6t2wZ85oxGKIP/I6g==
X-Received: by 2002:a05:6e02:1d99:b0:315:7004:3e69 with SMTP id h25-20020a056e021d9900b0031570043e69mr12271620ila.13.1677212924903;
        Thu, 23 Feb 2023 20:28:44 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v25-20020a02b919000000b003b0692eb199sm2935112jan.20.2023.02.23.20.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 20:28:44 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 23 Feb 2023 20:28:43 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/26] 5.10.170-rc2 review
Message-ID: <20230224042843.GC1354431@roeck-us.net>
References: <20230223141540.701637224@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141540.701637224@linuxfoundation.org>

On Thu, Feb 23, 2023 at 03:16:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.170 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 478 pass: 478 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
