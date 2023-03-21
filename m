Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D864C952
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 15:22:03 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id o2so8972877plg.4
        for <patches@lists.linux.dev>; Tue, 21 Mar 2023 08:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1679412123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6gWfY3tQUtshjFSkcAdDgcrIWsk+2YKijGy43yiViKk=;
        b=EaR2/n2qw+RyvpiZ1yCsIKAcdWm37lT15zD0Eq+LIDerzkbF29Qpc8oGElyy34NZPr
         l4Lx4DuvMJaS34Sfd//GyLDGUbt8pzJbBd7BfQqMSiFz8uKPAWKWu+xXZJotGnqfFatR
         lz2shj9+DWX2Gb3sbL/SHkaPBtR/Wxz3SLytg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679412123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6gWfY3tQUtshjFSkcAdDgcrIWsk+2YKijGy43yiViKk=;
        b=sNR8g36P3LGKVK3h7pVW+wNAs2hBAWnnsIdfIuIFACOhWnME8SJgmZPf+UsTe8+YYe
         Yyjqr4NerGILAy7IbdeXxwmPYxNEtsTYftLzUic93Ulq835qS65MeutMuAO8rVvCAItx
         9WwZnWrNhVUYq47JQrx1qTCc1kWty5j0y/U5ShZXDFcaYjdk0qWb1E0FcA5t/BwwbuAc
         2nNxAibCMRxF3oct+ryp84aFNR7HvJpqQ0Sa1P66jVT3+34ykcUK+PD0h8EsQUXMOYdn
         Ru1vJExTeTIjZ+6DnAXYywRLKkLELf+yMBvHyJUzyC5wU89r1LOqIGoENsRuTZWZrg8J
         BBoQ==
X-Gm-Message-State: AO0yUKXaGeUHkgsYXzZ5fzfvu/1QDljYIfdKDMLqsln/9Ay2/J8/oCgR
	9mJTzKZpswYJ9r8LZIZbOuNBoA==
X-Google-Smtp-Source: AK7set+kulQ7RY0SJLZceDsuQd7Xg4twQsw+0TsI21QGPHuCcuIHG7WMoLXcFTf0NePX91aMu6DBLA==
X-Received: by 2002:a17:90b:3a8d:b0:237:ae7c:1594 with SMTP id om13-20020a17090b3a8d00b00237ae7c1594mr247406pjb.8.1679412122531;
        Tue, 21 Mar 2023 08:22:02 -0700 (PDT)
Received: from b1f8169a9f5c (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id s61-20020a17090a69c300b00230cbb4b6e8sm8129524pjj.24.2023.03.21.08.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 08:22:01 -0700 (PDT)
Date: Tue, 21 Mar 2023 15:21:53 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc2 review
Message-ID: <20230321152153.GA8@b1f8169a9f5c>
References: <20230321080705.245176209@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321080705.245176209@linuxfoundation.org>

On Tue, Mar 21, 2023 at 09:39:14AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 08:06:28 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.21-rc2 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
