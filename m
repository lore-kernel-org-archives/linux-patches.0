Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A612574E
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 13:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heitbaum.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=heitbaum.com header.i=@heitbaum.com header.b="OgPUB4h6"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1cfae5ca719so4430395ad.0
        for <patches@lists.linux.dev>; Fri, 01 Dec 2023 05:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1701436506; x=1702041306; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gvg9SzsVyrg1+cSkW8ZTDbtaOZGy4u7v+r+pXKw+7Dc=;
        b=OgPUB4h6mBc+p6hPTem/8I3Um+lcIK+WiamhuKbhf/ls8MtF9gcDAAKsn1/AlAyOwN
         lQ619Nd58KcqXRMRi3XNm1eZ4smhRX7MY5NDDQGNIccpf42yDE4s8MZvgBraqw8oue+F
         VuIOW2ocZmh0/J9s6HDEwLyv5Vsk+P8y8TPTQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701436506; x=1702041306;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gvg9SzsVyrg1+cSkW8ZTDbtaOZGy4u7v+r+pXKw+7Dc=;
        b=vCaAawsVtlyjz0pfoFcxafFz5ZuehTdl1oJPO5IDTvmGG3okX3UnlDCat+OAOu/XoE
         1NdU4+CVbuDz6r4sc26qBIf2C5ZrVPq8W0wlwyrPeUk7tWo7mYrZEFqqSU1pu8FC6R4V
         wnc4gCit2LyCYTqXG0fQ4nbliyjKosH/VyxAbAI4/2+5IQAas5WU6MNLVWfzM9WtT43n
         C1L61IsPzsW/VNMdaaRPdHFW129g5F2pAowPcwh3jA05O/OBo5+u1XFN/kFCn5c9HGU/
         HXJuP+H24Xd2vtt1CYnjPiiSl3S4qziZqIYO7Wi2WuzWH7/lToLiMHsoN2BkJ1l7zdx4
         tt0w==
X-Gm-Message-State: AOJu0YztChqDwsl9QfQrYrGRvhOwnJCJyVPsPK9XI9Ivb9RzvGLIlokN
	h7N+fx7z0vhZjIcHvk5tajeA6Q==
X-Google-Smtp-Source: AGHT+IGkj80lTOlpVv7cLv0ty3QcpEA/UEzBSdkHRwLlyy2C0DVPD4e+YQqHJcf5zZY1pKqlA911HQ==
X-Received: by 2002:a17:902:aa02:b0:1cf:fe32:634a with SMTP id be2-20020a170902aa0200b001cffe32634amr11199468plb.43.1701436506057;
        Fri, 01 Dec 2023 05:15:06 -0800 (PST)
Received: from 8bdb44144243 ([122.199.31.3])
        by smtp.gmail.com with ESMTPSA id iw1-20020a170903044100b001cf59ad964asm1575312plb.140.2023.12.01.05.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Dec 2023 05:15:05 -0800 (PST)
Date: Fri, 1 Dec 2023 13:14:55 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/112] 6.6.4-rc1 review
Message-ID: <ZWncT50EfYHdJS0x@8bdb44144243>
References: <20231130162140.298098091@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>

On Thu, Nov 30, 2023 at 04:20:47PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.4 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.6.4-rc1 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
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
