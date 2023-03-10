Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1E47E6
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 02:26:40 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so8378933pjh.0
        for <patches@lists.linux.dev>; Thu, 09 Mar 2023 18:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1678415200;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8n96jBDj6U8/0HiuamqOgxHV9NLL2L/E5rBePzKD8o4=;
        b=I7rd0ImirBXyHnnNTVPfhY3MVC3hc8ULMj8UGlsEltLBKEIm/J9l8sES9VP1BtXeXx
         luwSD+PZbmfcvvTA37U25F89+C0R3XDiA2vLCsltzdkLn1MPAUDnsbsqdbdmLWw0xdJl
         p9D14hbgQk3NkDdT/3m5WIxJpGK149doGAdvM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678415200;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8n96jBDj6U8/0HiuamqOgxHV9NLL2L/E5rBePzKD8o4=;
        b=pKD/mGoUIC9bec0ZjUYXNskLs6/kKH+yvuzTvuYBw6nA4tWIOCdwiKOlg829eCxBmM
         dbCiK+Ye4D40dRfYlXu2NL4JdX6igpc9ol5vKI1ZikGIVqZ4STYC3idBBybC4p7PmzP1
         y7TovMUhjiFhXaacKon3kk4roIebzF47XcsT3iu8vvaT0iHXQBK/75tget6wpNuNdjf6
         FLYBHK0aBBzTeKcfLMecjukJzC2/qw19ZcUfP2wNvb49XAbYZeSEyDbzMS2FFYKX8eDp
         mqbmAoeB/aK4rqQBquMLY2arGcqzWifaU9UJVglPX8z195R10aUmA2A8mqXsiVrq/qi5
         +RYg==
X-Gm-Message-State: AO0yUKXMY2bS6BPwER5RbOUpXm2qvVzjyOBBrnVoXFA5q1z5z5D9Gopm
	7TbP6Px2QrCLKpRqCx7bS5udwA==
X-Google-Smtp-Source: AK7set9pzQ9I8F/ZqVL/8w6lsggmI04JDkdDcXTVEUnMqBWkkBjGhrn9uYkx4mr//ebYveJ0sKKiIA==
X-Received: by 2002:a05:6a20:430f:b0:cd:1367:3b69 with SMTP id h15-20020a056a20430f00b000cd13673b69mr24116204pzk.17.1678415199651;
        Thu, 09 Mar 2023 18:26:39 -0800 (PST)
Received: from b836f21f488f (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id n18-20020a62e512000000b005a79596c795sm248402pff.29.2023.03.09.18.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 18:26:38 -0800 (PST)
Date: Fri, 10 Mar 2023 02:26:31 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/887] 6.1.16-rc2 review
Message-ID: <20230310022631.GA457080@b836f21f488f>
References: <20230308091853.132772149@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308091853.132772149@linuxfoundation.org>

On Wed, Mar 08, 2023 at 10:29:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.16-rc2 tested.

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
