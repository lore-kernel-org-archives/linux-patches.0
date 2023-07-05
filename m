Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FEF84C8F
	for <patches@lists.linux.dev>; Wed,  5 Jul 2023 10:16:14 +0000 (UTC)
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-55e1ae72dceso4408526eaf.3
        for <patches@lists.linux.dev>; Wed, 05 Jul 2023 03:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1688552173; x=1691144173;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AzhvK8EnyXoNyk7icoiRJkisO9UvyAqZpT57/R0erjo=;
        b=K6OJeNqfhO6IRs9I3aXem2n2bgVrKW+SWowkSVr/eEtXZv1Pat+tjoIl5fWv/7b163
         0iDdwfeh0D2nVCpemy3kx5z+2yFApRsAa6Tyz2x3eRXS5PT3KQF/9NF9F2GgHhI1VOsP
         SzVy7aVttT+XtKNFS07U/Ry0ow3ZhjmAAVBFI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688552173; x=1691144173;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AzhvK8EnyXoNyk7icoiRJkisO9UvyAqZpT57/R0erjo=;
        b=GN1y9QVoRflD8SJAuX9C5OS0HpZ7lK2l0aCsMz9+IuJFrnzzrZuk42CuCSj/ImhpVR
         a254+3lLBBsz+Vt7WCNJ0aGSbxsdJsVzoO65OrsBk4+QXzzDb8K9Y9L7ZbTxBYl0MXUd
         0V5XPM1b4EDaz0NNhmImyna1GFTfj1pscjJ3/7CYHVBUzgZDAjYPip+2uJa5aXhD74KB
         CA7B+csoz+K2qTyAykKaMUl9LVt7rPq8utYyW7VYRoxNq+L0xmfiSfdh351MLU9Vbkxb
         V+oj+WFqAha0nAukCjTcWp+8fcjBFE5A5lIFVRUz+KiB7uQgeSiIdaO1Ovl1Psrhr80d
         92+A==
X-Gm-Message-State: AC+VfDwuilV/b5imKbX1irgomlU2TvAHfV/JQDSu4foqwri70zoufV6u
	CkXYtgbKqpPDChkCRJABJPad0Q==
X-Google-Smtp-Source: ACHHUZ6fT5xRwDL5gF8pDtJcEsLSySgE1A8aMrIHeqhzNAHOr6m2+0zLz2H0+Ssc8xYUk3QeE0j8vA==
X-Received: by 2002:a54:4713:0:b0:3a3:6743:a9c with SMTP id k19-20020a544713000000b003a367430a9cmr15390485oik.6.1688552173480;
        Wed, 05 Jul 2023 03:16:13 -0700 (PDT)
Received: from 5f8976b95e14 ([122.199.31.3])
        by smtp.gmail.com with ESMTPSA id 204-20020a6300d5000000b0053051d50a48sm17500765pga.79.2023.07.05.03.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 03:16:12 -0700 (PDT)
Date: Wed, 5 Jul 2023 10:16:04 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.4 00/15] 6.4.2-rc2 review
Message-ID: <ZKVC5OwGFbCoqDdm@5f8976b95e14>
References: <20230704084611.900603362@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230704084611.900603362@linuxfoundation.org>

On Tue, Jul 04, 2023 at 09:48:24AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.2 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jul 2023 08:46:01 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.4.2-rc2 tested.

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
