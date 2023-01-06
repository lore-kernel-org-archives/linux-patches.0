Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0D97E0
	for <patches@lists.linux.dev>; Fri,  6 Jan 2023 00:05:05 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id 7so179397pga.1
        for <patches@lists.linux.dev>; Thu, 05 Jan 2023 16:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i2xgnS6P8oE/KrpMlccAZ+Y4dEgvLfcHqD32J1lx09Y=;
        b=dnJOdhDpc89F27/WUX9nX/el+s3gnF3ZFn+gfhDkX1Ru/RHLLlQw/kAE0Deju/pbny
         I85LE0iTbKlSKzqfvP8TWYcLKjVYicKGuQ+rUD/BB/weWJp8lO0X7QGvgPdfFvOgQMQg
         iCo9aRFzfyeqv2Jl9OfOaUxBOV4PWxb5uCbqo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i2xgnS6P8oE/KrpMlccAZ+Y4dEgvLfcHqD32J1lx09Y=;
        b=tBVb8jvgBUtEbE43CU3DnI08kmPYKFHbwF7rwTmYcEsswmRw+hXXGOh5+VoKdQrdRX
         3xk7cH+6QNgW+FbVbirw04wb2E/w+t2aPspyiSgBDQhZZ/NN3zv5oqjG+tA9gLRRHJ1D
         W3MhYrgLcrjo/vUSZiOmbXMc+rgGY84j2kc6QD4g1XkfWONb7en/6WlBOlfQOHrXBUy8
         Q6qYIgTD5bO15KDFmkaC7ekQRA9D0MqSjKNgE0UBcNyIRcBTVQcs81vGwWMuZmy/W0jy
         3risTHNLvIn/NPOOl2a0jdzX69rmyxITDCeJPon/Dp5zNA8e5I0gKRtLCEpYFUWmjv78
         559A==
X-Gm-Message-State: AFqh2ko3GX6WSC6Q5W3WqnCGDAOMsZkmxzA71gxNLW/dzYrprib+TZk3
	Rf4G3Zv6Ue/UQfI/DaQHdBkHtg==
X-Google-Smtp-Source: AMrXdXuxy5OrJQPhjeuVD3E7jCOyZE9sgowf8xRuV/O6+/U+amwrJK46YAwEYVaaF4IJ3A8aKJQU9A==
X-Received: by 2002:a05:6a00:706:b0:580:d409:396c with SMTP id 6-20020a056a00070600b00580d409396cmr47276929pfl.6.1672963504915;
        Thu, 05 Jan 2023 16:05:04 -0800 (PST)
Received: from 5627e7ec9cfd (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id 9-20020a621709000000b00580e07cc338sm22768631pfx.175.2023.01.05.16.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 16:05:03 -0800 (PST)
Date: Fri, 6 Jan 2023 00:04:55 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Message-ID: <20230106000455.GA1929704@5627e7ec9cfd>
References: <20230104160511.905925875@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>

On Wed, Jan 04, 2023 at 05:04:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.4-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)
- SolidRun Cubox-i Dual/Quad - NXP iMX6 (Cubox-i4Pro)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
