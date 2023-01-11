Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578E020FF
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 10:58:39 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d15so16393213pls.6
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 02:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fxhv4QkDrldLenO5lrQ3LjOcD7YvqwRwzw2LufBgbsE=;
        b=RFoVrcQyO6qxmEoyl0HWaOre3WfSMCrNVzTBJPzBB6DI1p1k6u+sR/2AL27WRawEx0
         EdJV0SKf2VyU8eM1skvgHv+hCDcfRrOM8rPLhh/vynS0urPNSAi4TJ6UpMzDBXQZTUaw
         lVE11GxyyFNvbaFIVI3/ko83+Qw3iVG8t8Mtk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fxhv4QkDrldLenO5lrQ3LjOcD7YvqwRwzw2LufBgbsE=;
        b=iBlPz/3aAuubGq7zOK+IZAg/PdZLYSDLUquNIUVASm3WW0IGTuJS82dCF1qyD8hnd3
         q7t8MrNQRcyLcmg2fcsHHHXyjKEeWAvBckNIDpTm0Dq9UrHJvcQx7xwQ9NHCmDKwHR1i
         1K6KVw5kunODVVJ21ijmCn2Cf/D4mtC4vN0dfOlwT8JYRzbl1n3761fI6muDUYvIfhIW
         mGSSHwYCVqRgtJtT9ZaZmLxX8ZwIDwxL0xMgF1PvJQ3rm3qQGO10CoH2NsKcYDlijiuZ
         0MdSXsaB63ABISiYBznPECkNoDCGxa3AERTmfdRTOKl7Ri5aqzfpQ+eF6dkKsGgeokg4
         g1AA==
X-Gm-Message-State: AFqh2kpRgLB1sWEBMQSMKfNYNvS2WeLRwJEAk0gFr4kPbphVSlni+nmw
	TPC4g3UqbAoC8TGagOedn/paxOA8B3Gt7pnYdKlHkg==
X-Google-Smtp-Source: AMrXdXtKarQD1JhMpONsWVMgA6XJI0xr4rJxbaVh14tjNsEoR4+23h6jtCyBZrNpr28mzhOMvT8dCA==
X-Received: by 2002:a05:6a20:e189:b0:ac:5671:adfa with SMTP id ks9-20020a056a20e18900b000ac5671adfamr2073123pzb.18.1673434718187;
        Wed, 11 Jan 2023 02:58:38 -0800 (PST)
Received: from 8da649e65097 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id o33-20020a17090a0a2400b00226463cd239sm10469946pjo.15.2023.01.11.02.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 02:58:37 -0800 (PST)
Date: Wed, 11 Jan 2023 10:58:29 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Message-ID: <20230111105829.GA7@8da649e65097>
References: <20230110180018.288460217@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>

On Tue, Jan 10, 2023 at 07:02:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.5-rc1 tested.

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
