Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795E07E
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 10:52:24 +0000 (UTC)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-68a4bcf8a97so2100168b3a.1
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 03:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1693997544; x=1694602344; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=25AzewrCxhn5VAJTnf4NrbRvqDvucF8KzATEUTz04rk=;
        b=YJYL0GGmmcZ4stCCDpEtcBtpCrLS3hMYqwtLujKkkbxsWwA7HHRMrIS11P2QVBGhTn
         hlBQkptOn3fZuvgyIjg433xt5dGtPcMfQIMdpml5lS0Ebwy3P85q3hRn+GgFQ9jgf0GS
         McnPg1sJOWPU6TtxSvFTjnNbFSnctQui4xGoM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693997544; x=1694602344;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=25AzewrCxhn5VAJTnf4NrbRvqDvucF8KzATEUTz04rk=;
        b=GYNjU1MqyC3KZIgrAHPjAC4vXFTShZbBgmmHncjyCx77Fc0FjtiBpNFWLtEMoQto5l
         dwmA3jSK3oIFJO8SiXWabxC/jUqQc580vhIRUZAAGau5l8vsw4SwqGWHVKI7VqUuDRuW
         wz6sC8hLXPszMY5tQGSU2YM9ZvGDNl1MnAzXkpTyDk/FE0jH8utNAvnBUBBJ+AWL2wn9
         vuJhuQ4uDyE605qLydfCc7RAtUy4kjfDcxh8Dn5KRxREIC2ab1/tFMcmI3B6EHrvwI/a
         WBZn/qyzijCGl+LE1Cz73x+z+lF2NRI5+OEYQotPEYlm7jWY91bXfou3BdIoapabFmy/
         9y4Q==
X-Gm-Message-State: AOJu0YxGyD93gG4gSHP8od4hgBWkfHsX70MdD/MFfoAEdm2W6Ni4J0TZ
	WPJ6bGHct4zuisakU165XOY3jA==
X-Google-Smtp-Source: AGHT+IE/L4KsJkWscRV8gObXAFvrgi3HthktxCW0Ao5WvP3mNZLeiR941VTd+lXO2Lk2HtEScIqD3A==
X-Received: by 2002:a05:6a20:a108:b0:14c:6404:7c5e with SMTP id q8-20020a056a20a10800b0014c64047c5emr16905385pzk.24.1693997543604;
        Wed, 06 Sep 2023 03:52:23 -0700 (PDT)
Received: from 9e79d0ab4c28 ([122.199.31.3])
        by smtp.gmail.com with ESMTPSA id fm19-20020a056a002f9300b0068c1ac1784csm10587729pfb.59.2023.09.06.03.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 03:52:22 -0700 (PDT)
Date: Wed, 6 Sep 2023 10:52:15 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.5 00/34] 6.5.2-rc1 review
Message-ID: <ZPhZ31KW+q9AuEl+@9e79d0ab4c28>
References: <20230904182948.594404081@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>

On Mon, Sep 04, 2023 at 07:29:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.5.2-rc1 tested.

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
