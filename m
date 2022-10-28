Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3E723A0
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 10:18:11 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id c24so4459040pls.9
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 03:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DSKJv1f/uVlp0hff+snMR0wsnevB65aMFxEQQizFBpA=;
        b=Qv3qfdxLvWItvoVyHt2AVoKll3nKREI/ZG2asPBKUQPv2SRMcjQtGtUTs3+WFQo0O8
         9HcNkQymRFA1X5r6hdlNRK725D4tZ8a3Wge4W3747Ck/ZlUPgtCd7PmnkzjXqZexAEFv
         Hn4aajmyzXT0xc5THfW/EVLed5s3VzMW2xz80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DSKJv1f/uVlp0hff+snMR0wsnevB65aMFxEQQizFBpA=;
        b=QsiyIWGgAxuRB8uW7lMoTiNUbodf5fcINz/YTR7s49e9ByQ7+qPMd5f25EvreKIAzP
         y2sX+L8QrpkRJN7drNIEpotCkelSOPn/SUMEPPPjK/BwYfd1DmA4r6024sGGm6r9ysuZ
         DnfXozDUeUohygAaN25p6+ARM5m2BYOR7D0iRb6FbOpIuPFe8GhGEPT/uiGJsf0ereBe
         oaOHiqzXQJ2KTlmVEh2msbaGl00+don1OVTIuE/1gwl6DTkOnspu8Nt3DHtp4ALkI3oS
         n+TZDH7VBO5ERABF5iy/Hn4hbePSdx1Y2j1qMikm4rDFrt6tMKg69RvJJAiIhiLgv7CM
         BfRQ==
X-Gm-Message-State: ACrzQf1gnOR4TRW+xTD7j31WyXv+r3LUT5zcI6lmI88HkJ58rYNiKM2t
	UmKbGmWbLwzIwWH0g1hf/kYHJA==
X-Google-Smtp-Source: AMsMyM42VLGabApraSGNSPouVxxKriSgE7M0ZYJbOsPjhq0ZT8JFO8iTPEyhcjI2rjlhMo2Ky+1lGg==
X-Received: by 2002:a17:902:8685:b0:186:cb66:d77b with SMTP id g5-20020a170902868500b00186cb66d77bmr17207873plo.39.1666952290879;
        Fri, 28 Oct 2022 03:18:10 -0700 (PDT)
Received: from 377995ad3d24 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id bt20-20020a17090af01400b001fb1de10a4dsm251163pjb.33.2022.10.28.03.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 03:18:10 -0700 (PDT)
Date: Fri, 28 Oct 2022 10:18:02 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
Message-ID: <20221028101802.GA2440677@377995ad3d24>
References: <20221027165057.208202132@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>

On Thu, Oct 27, 2022 at 06:54:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Oct 2022 16:50:35 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.0.6-rc1 tested.

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
