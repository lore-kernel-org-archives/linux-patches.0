Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92EB17FE0
	for <patches@lists.linux.dev>; Tue,  9 May 2023 17:05:24 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-24de3a8bfcfso5847206a91.1
        for <patches@lists.linux.dev>; Tue, 09 May 2023 10:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683651924; x=1686243924;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=amE40pGjkHaZY1kl3ojQhTIMDPt7Dk1yxIzG7+bYcrA=;
        b=EuMMChqFf167ZSiRxfbyUgRbSW0Gl+e/+JR5pN9GyR4V/SvQyfc2RLcY+BZZr+QsBT
         vBBiuZlht9tErwMdHx3rDCunUGjzROiVdktnHT4SuW9mg5lPYUtRIiJif3jr48W0QYwZ
         0avQyg4ZXORF/3ZM0uusErsSbeacKSZlZERdDEQ3bu2yp1xX/HGCULAtqHXuzMZYkkQ0
         QKIua2N6lN+XCyS77rxc/zk1R1t/Rx5n97a+o0cT1BU7wsnMZt0P1Hue8WnR6qyddDGX
         77Mwu8LYATkwTyeGgyQDeEQAEeHim4NLlM+FLZAiHERahs7K3xlh0eFLyoucJjF/xFvX
         xBvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683651924; x=1686243924;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=amE40pGjkHaZY1kl3ojQhTIMDPt7Dk1yxIzG7+bYcrA=;
        b=LldFJTRJKHkF4y7d2ylNwPBFvHieTKG4pY/Kj7d0FlUCT7fftcsrx8gIj0LUKerDTP
         QQBoDCWqZTwClu8m09aPusZyKOXyDyi/LDV90UotTg0Y43Q0/gEJ71c+5YYxjSis9xSf
         A6dqcS7+Tca//91+cio2XRMTOhQ/nEZMC89mrjWEuGd0aR/ibBunKtiNG6PRo+cWwRhp
         2icVtl+bwa2Vbyzyf6+gyDyMvRg1mskOGKHeBygeCmCoev1ipb14S1WPuFmmDDDyG0k+
         lebYEoWiAnGEBTTK04OvF9P0txUNFwtbc/yyOobveqCqhR04hxEQzlxuTn0g9LeiYwhr
         O7UQ==
X-Gm-Message-State: AC+VfDwtQeAXrWpHXGBiKgDuv3fcPwBcjet1249zPvzWYqoNXqYQrMzo
	gV5o3qyEEvsM27hhBzS85tqCRVYP4v/q5sMnddg=
X-Google-Smtp-Source: ACHHUZ4D1jFjztMuQrAVOVCq1/uk1yxKVf2VKX74E0qpqL8JRbtWGioMuJnzKNgemeDUWc/uD2CgcYpRPpXXHh8Q9QI=
X-Received: by 2002:a17:90a:a784:b0:250:27ad:e1a6 with SMTP id
 f4-20020a17090aa78400b0025027ade1a6mr15002406pjq.31.1683651924346; Tue, 09
 May 2023 10:05:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230509030701.507375024@linuxfoundation.org>
In-Reply-To: <20230509030701.507375024@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 9 May 2023 10:05:13 -0700
Message-ID: <CAJq+SaBywHUnZUjJHqw0MgAGvTTc7rWUfh-7f4GXZxiZ9VEJ4A@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/662] 6.2.15-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.2.15 release.
> There are 662 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.15-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
