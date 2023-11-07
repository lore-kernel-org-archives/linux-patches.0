Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079E81C06
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 02:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=heitbaum.com header.i=@heitbaum.com header.b="colO2kn4"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6b5cac99cfdso4241921b3a.2
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 18:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1699323134; x=1699927934; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yl+i+/Zm12KSu2JEDO2OvhxPRMv4CU9Hn46hRXkuPys=;
        b=colO2kn418tZa5VkLX9DjDpYTDyGTIxxBctbNkqfrYiP1OIrECpmZJhSPvaa90rHAr
         kqnp3I0U/dMyoR7bmGFysvFeiSmLNvXm4W8poAHVDSse1Jde+HqSAQuZY8Pde37ouzbX
         0dzWrLTduzk5S8xcRDqlgW1C+/psyAJklFvLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699323134; x=1699927934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yl+i+/Zm12KSu2JEDO2OvhxPRMv4CU9Hn46hRXkuPys=;
        b=PDTrGv0Pfi2kPr/IAX2M5z2lN3IkhegEudcwuZyXK+9NZEvSqcAWD/YlKWQQ9fGaPW
         rDa1LqEZQfqorNYhccfcBKmP+xgnLmF91maw3WIfx6OLgwmlqMvPLGyE9uSUVrxgZfch
         9rLgjY/fJJGc3DwiZjSVrgSjNssTlqfsT7zk1Vym2xYcchtz35ffL8Zz8lbnGpLHOHq4
         mQCTlOSO4z6pTKADxxjVvzyIi31b9YHJazUxp29guZVcxGEmItBjVLVWtAFo7ST1XjX8
         6lKBaDiUSYDIJ4SG41UF67C8hCjETVdLi86csIwYMfxZTQdBTacfNLkWFfqC+FTHCaMw
         eYjQ==
X-Gm-Message-State: AOJu0YwoezUgJJHgHpa/oK4yEa3VkeJJliKj3EAUUg1hayCHKnK8T6x2
	zQPL1H99njNWixrFEwW6e1e7Qg==
X-Google-Smtp-Source: AGHT+IEdmPnG/wOAxpAHwbWAT0HofcxKZAgNSheVQUDbL7y4zHPyjkjZVLx/p0kiTC3AAF8uElMg3A==
X-Received: by 2002:a05:6a20:1595:b0:17b:3822:e5ea with SMTP id h21-20020a056a20159500b0017b3822e5eamr31125121pzj.19.1699323134100;
        Mon, 06 Nov 2023 18:12:14 -0800 (PST)
Received: from 8a2541e20aa7 ([122.199.31.3])
        by smtp.gmail.com with ESMTPSA id u22-20020a056a00159600b00687fcb1e609sm6123026pfk.116.2023.11.06.18.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 18:12:13 -0800 (PST)
Date: Tue, 7 Nov 2023 02:12:05 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.6 00/30] 6.6.1-rc1 review
Message-ID: <ZUmc9RaUwJhBXI+y@8a2541e20aa7>
References: <20231106130257.903265688@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>

On Mon, Nov 06, 2023 at 02:03:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.1 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.6.1-rc1 tested.

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
