Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F67C17CA1
	for <patches@lists.linux.dev>; Wed,  9 Nov 2022 11:43:10 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id 78so15972656pgb.13
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 03:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ODY7XT88Lb/pdMVorgr1Omr1Qh/cJGNYn8iuRKgv224=;
        b=TQeFk8oIslS+EyBWdOSfSVTuEjBkH5kojK+B8JLwLu63A4au+NOj11SlJAA1xSSnts
         ct2+ElU3SbvA/KJtVFIUK+NS9TJaDzKoTMM186g5a2tpJlFqPf8vWsHBndzu7+FNhhH+
         YbV46mjcs5aSmOCbqznnKJ0GjKpmsFzpHIO1c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODY7XT88Lb/pdMVorgr1Omr1Qh/cJGNYn8iuRKgv224=;
        b=Ts54yUn+6RjT7JmAehU4EjC6xkR6nCDKi/Ca0LEuV+jSC0yMgyGQO3TjZ8Auny+hbL
         v9iPmFAeqfsf1tmPflS27D8+Hd4V6I/x3HhHqnuvY4NEvJXnLm3qrn5gTfQwHCM0QqCZ
         mhDwxHptvUT4Dk9qzlRF/JPoxJPTOAactel2AJElyo/bwM1gzcQkvkWOttQ4opDn5PHF
         Q5yb5n8MQR/d5z/SAs+qSkBL9fgS42m04T8O7W5CUX++CMTMpbTZXImQ7skVu9SkMn7S
         O9VrIZ8Z1jK8Pu9UFWJ7t0kpz5tMUPKzTPGpFSj7m6EhKMmYcWDWSO6P3dw55h84Ii23
         Ux9w==
X-Gm-Message-State: ACrzQf2JHKT0OjSmvaku7753TcKFsZsuRsT4lnzTFSwitEIcOZahx2fI
	TesPRmMvWTs6J9l1UHxKK8h8Tg==
X-Google-Smtp-Source: AMsMyM73mE2Qn0THhWKZ+B2kaOit8E5j+WJWTTZAQ4xn7qeVjcQkQ3W283GCgJZSHbaaudluG9eAQA==
X-Received: by 2002:a63:1748:0:b0:46f:18be:4880 with SMTP id 8-20020a631748000000b0046f18be4880mr51454952pgx.128.1667994189740;
        Wed, 09 Nov 2022 03:43:09 -0800 (PST)
Received: from b0ad8707f47a ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id mi3-20020a17090b4b4300b0020d3662cc77sm1010624pjb.48.2022.11.09.03.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 03:43:08 -0800 (PST)
Date: Wed, 9 Nov 2022 11:43:00 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/197] 6.0.8-rc1 review
Message-ID: <20221109114300.GA3493079@b0ad8707f47a>
References: <20221108133354.787209461@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>

On Tue, Nov 08, 2022 at 02:37:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.8 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.0.8-rc1 tested.

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
- Samsung Exynos5422

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
