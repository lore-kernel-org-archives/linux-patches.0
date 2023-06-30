Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B822E561
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 15:07:37 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1b6824141b4so12208535ad.1
        for <patches@lists.linux.dev>; Fri, 30 Jun 2023 08:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1688137656; x=1690729656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8EnuOO6oK/ZVqVGz3O9HMiKg2lC4Al7i/4UAuVg8htY=;
        b=PDNb3JOlAYukvjfbvtQ8ZLFvnbUoRaeNLFtvnAXu5kbH/6T7dn4pTHw5k8zpwiETGL
         v9PQYHRTz9ctIdIWj9bV9ajKu870gPZlcBRKrZcjLhCY+tLRhybDb33Z+Fd1QgoVy920
         KIdd1JfBuwockiY6424G/jo7krbCswaHzVaKg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688137656; x=1690729656;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8EnuOO6oK/ZVqVGz3O9HMiKg2lC4Al7i/4UAuVg8htY=;
        b=ZLCL8VCx5KLNvi9+JrVIbcm/5jJeq2z/zUuZO+olfGFHcPD8EKcKFdQTizdAM1blp4
         jYlJAUIK8eTlWweY3WIPABZ8aKuqdmy74e6KPpTXxLIoYtyV4MbojtAp87j/SwkRk7r7
         A7s7H5Ekvf2jP98e5aY8uENAjrtt0unLOZU59PKXART1L/vkTEu7nUkxC8jkij7ATToE
         WqAfTyCTUVvydr89kTAZgX/BuMWwirnKTW0QVkOA8hyWliD8bfcNgTI3eYk/IxgRyRfD
         PIbUu6eARLzRQhRA5TGwh2mnKbkik55pbxP+j4TeorrnmV0Z4DpqNc0kic4yY2Mc27HY
         3wsA==
X-Gm-Message-State: AC+VfDyUJFxLrI8MOF/PzH9v4t3jaXPswfmCUJdRzxyuxrkFacxGb+TH
	1hLHZG0DYm39Ugjr9xBUkEvQrA==
X-Google-Smtp-Source: ACHHUZ5iqx/PxCy9A0NgfSEXCrVRwBebxEv2MkEa873Y9HdaqjtDpTpqnWXbi6zOPsH61dYoDU2WJA==
X-Received: by 2002:a17:902:c411:b0:1b6:92f0:b6f5 with SMTP id k17-20020a170902c41100b001b692f0b6f5mr10240571plk.14.1688137656539;
        Fri, 30 Jun 2023 08:07:36 -0700 (PDT)
Received: from 88b90ce288d3 ([122.199.31.3])
        by smtp.gmail.com with ESMTPSA id x12-20020a170902820c00b001b3d7205401sm10867637pln.303.2023.06.30.08.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jun 2023 08:07:35 -0700 (PDT)
Date: Fri, 30 Jun 2023 15:07:27 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.4 00/31] 6.4.1-rc3 review
Message-ID: <ZJ7vr/OtdYiwqLy2@88b90ce288d3>
References: <20230630072101.040486316@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630072101.040486316@linuxfoundation.org>

On Fri, Jun 30, 2023 at 09:33:31AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.1 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 Jul 2023 07:20:45 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.4.1-rc3 tested.

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
