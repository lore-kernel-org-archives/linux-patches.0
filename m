Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B657B
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 11:04:30 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id 140so4593543pfz.6
        for <patches@lists.linux.dev>; Fri, 02 Dec 2022 03:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D1KXzSfZtuAisNZ05G51clQ324jnx8aq/gsDbzWWu5w=;
        b=RF10Mb34k2R5dAeYwD2YhiPWcI2Lcs/g4SWXS3huGVHmzpcWS3aJCJjenoi5+J5qNL
         N3PGDtE7158fXkTpnGTBESokd8cDI4BVGr2BjHh9zxuiC0jIT0ixgMWzN5Cqrgd5aeqd
         1zCBIzqITcDuwDjvZ4zN50m/xb9TGNBnSluxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1KXzSfZtuAisNZ05G51clQ324jnx8aq/gsDbzWWu5w=;
        b=qNRymF5ScHkiys2m8PgOvxlEVS34e+WEtjuDFV9Be+6fa9jhLdpUsaxxlIIKOSlW6R
         L7klQVSEj4X4FN/YwDlGS7zL+TmZbc7dOzfeU+WJrpWSZqrtV+Oy/lHh8mTVj3KPFuDq
         NLlTg8DbcGLE/uW/mB2AKiRDy8FkdQG8M6VSR5UJG07LeefZr4loNY53M0+50nAMvdoF
         0gNDcga99b1FBzZO8DBdhbTynKFN2cDpZSNjbaeqxedG/nu7XPuP80ptB4sJVZ4ppsUX
         U7i4oNmTuEU0gE1LaVZQXxFCIC9glyXCPD7XahD7mDXrm9QPjMxbOAdXVXQ7bpuYdQTh
         b4Ww==
X-Gm-Message-State: ANoB5pl/KLbTvQHqUuD8m2CVehI3KL37Iw8Xq7T9rU0mbu0G5c4MVpqt
	MsuirpZ9wu81VNT1OwKC+JDaHQ==
X-Google-Smtp-Source: AA0mqf7wTZc+5wt4aeoquiU5DMuMCNEz7aE23amfAwhpaX6SQfiBJKju3DcbsUGJ+ZaHl0jVjFfUGA==
X-Received: by 2002:aa7:85c8:0:b0:574:5789:b8a4 with SMTP id z8-20020aa785c8000000b005745789b8a4mr44798364pfn.47.1669979068145;
        Fri, 02 Dec 2022 03:04:28 -0800 (PST)
Received: from d86934a8d1b3 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id mm10-20020a17090b358a00b00218f9bd50c7sm4519127pjb.50.2022.12.02.03.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 03:04:27 -0800 (PST)
Date: Fri, 2 Dec 2022 11:04:20 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/280] 6.0.11-rc2 review
Message-ID: <20221202110420.GA20583@d86934a8d1b3>
References: <20221201131113.897261583@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201131113.897261583@linuxfoundation.org>

On Thu, Dec 01, 2022 at 02:11:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

6.0.11-rc2 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)
- SolidRun Cubox-i Dual/Quad - NXP iMX6 (Cubox-i4Pro)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
