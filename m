Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BDF7B
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 10:34:14 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so15718579pjb.0
        for <patches@lists.linux.dev>; Wed, 29 Mar 2023 03:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1680086054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+G0x4df8nN5k7A1CedGNXaYeU9br6DP1S70P25KOU3Q=;
        b=leicsZUabtl/b04clZPzdxhIVtE92NjsAby5skkmC4BOrHrwDbqMDxyNy7EYxS/KMO
         pEfo1a6DcBrFeFSzXBkyZigB2nsKXlYpwMHc+X552mssmZFgNZuHXRal13MypE8FXa+q
         0R2JXsv0JPohslv6/ObMVaQDVHWIAAa3gwQ6Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680086054;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+G0x4df8nN5k7A1CedGNXaYeU9br6DP1S70P25KOU3Q=;
        b=4tG0ZCN5fIuQ3OwDJugLd5Gu9iLMn1u2LtbagJUVZruNBwYjVzbq8WG3DadLI1Hn4V
         BrcidIiUyBTzfQzjcPC10xJh+ZeK+WPtMXV7kLRD+a1OSYaa9SYwwGa1jAKH4dYfpa+K
         Y2D1zfk+/TmohEZEFRKXJI45H7THVHnuW5CVeNrPygCfI1oWwUD8cp7dochAWe946st1
         TVIiW2ih7BIUCJTWafTrRE5iWtZmTm5RmxMJqCJy2tNXPgltQiVEI/ZnBShOKYBXLoq0
         79A0QWOsVgCvHo6xeBVgwZ883frATaYFV7Q6SmShVYIQgl7TR5Y/1o1q6mKE/jNjAAmd
         9o6w==
X-Gm-Message-State: AAQBX9dngAmUDp2K4hrhMaiACyPGEve89VgyPNt24ndZaVfDrLHqyEso
	9BbYQT2VQzzAMKkGQSIgdQM/Bw==
X-Google-Smtp-Source: AKy350Z7IkUvnWfi8bjLMEeSSg/1XJxBZz8APPh8P42x16gp4l7TciaEW0XJpMJcStPFJvhfLDdnIQ==
X-Received: by 2002:a17:90a:1de:b0:234:b964:5703 with SMTP id 30-20020a17090a01de00b00234b9645703mr20022640pjd.18.1680086054136;
        Wed, 29 Mar 2023 03:34:14 -0700 (PDT)
Received: from 67ca92301206 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id lt15-20020a17090b354f00b0023b2bc8ebc4sm1160182pjb.9.2023.03.29.03.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 03:34:13 -0700 (PDT)
Date: Wed, 29 Mar 2023 10:34:05 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/224] 6.1.22-rc1 review
Message-ID: <20230329103405.GA8@67ca92301206>
References: <20230328142617.205414124@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>

On Tue, Mar 28, 2023 at 04:39:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.22 release.
> There are 224 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.22-rc1 tested.

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
