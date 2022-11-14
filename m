Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D92C8470
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 19:26:54 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso14789656pjc.0
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 11:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pskk/Obnk4hchuiZ9l4NfZNZ9E7NVr1eYK8NSHmFWQk=;
        b=d8PVcr/GvfrNAIls2vAc8FUWBi+HEpiklySPvn70ds6gJ6sY2XqCOrJKkNodR7fcJ0
         cDGGLrenL3zSwZ90hQ29M7nY3pBMySCVjd7+EH+lTnJ6vAieUWwnQJjMJQRGS8tkHL0U
         NlGLWJtXGsv/NBetfXBGosJt8SDvqayzaDjak2rzEMJPxNZBW0eI8Xr21X4F8DW+zXk1
         yjHMHlMSL9EHRY+v3ykWxTOeaT9kYz2RuDVyBcaEYiUkxCzPWx+L72tXswep+hu/jgfx
         ToxuX0kuSQXJcb71NkPz5g9KiJxDZUUfcM29Tr12LyojVyQDIBN2o6tkn/604pxNQwdr
         Ji8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pskk/Obnk4hchuiZ9l4NfZNZ9E7NVr1eYK8NSHmFWQk=;
        b=cSr8x1cIjCJy4GH9OftlhIvbY/OaBuLdhx4Vqtbsj+xeXiFfK40ytcwpsEix3jcfBM
         bqEw0nQGg5AMfzVWm8EBx9bmgs3hjTISeeOgoDtCE1b/A1fQnlkQsI00ofLNqkn36veY
         VqK8PzBgIDFnWSeHmOEAV669stMZpeFDjM2ZOrNSwqzCpIaNb5uj2PcJWXVtPRlwBpRQ
         /lDtM+xMBFVGIRKKhEochxkZg5fzhgR2j5hr2+rGa21Fk3WA96STte/i+eDYWl/g0a68
         WfKNhs+E6GD1rhs5T+ElN+RCBz+GgFC2/KlBJA0eRjgOMrFpYoDxnPGqUA5dYDcz2UiQ
         JZBA==
X-Gm-Message-State: ANoB5plRrOxswL+L1XLpuwTrnUD9Decqe1tL7kGe7Y6MI67vo04MHoIs
	uxdqgRWSNK6XpizQnfk3w5w=
X-Google-Smtp-Source: AA0mqf5CiQqHVUxQRfTsN9vhXKcqjaNuA+cc8se49nNhwlbycT89Uk0/9bMeC084pbra0AEfA7YNYw==
X-Received: by 2002:a17:902:6acc:b0:186:a687:e077 with SMTP id i12-20020a1709026acc00b00186a687e077mr759460plt.26.1668454013673;
        Mon, 14 Nov 2022 11:26:53 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b12-20020a170903228c00b00186b0ac12c5sm7929338plh.172.2022.11.14.11.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 11:26:52 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 14 Nov 2022 11:26:50 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
Message-ID: <20221114192650.GA1452278@roeck-us.net>
References: <20221114124448.729235104@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>

On Mon, Nov 14, 2022 at 01:44:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 

Build reference: v5.15.78-132-gb6ea7e152210
Compiler version: arm-linux-gnueabi-gcc (GCC) 11.3.0
Assembler version: GNU assembler (GNU Binutils) 2.39

Building arm:allmodconfig ... failed
--------------
Error log:
drivers/net/ethernet/mediatek/mtk_star_emac.c: In function 'mtk_star_enable':
drivers/net/ethernet/mediatek/mtk_star_emac.c:980:29: error: 'struct mtk_star_priv' has no member named 'rx_napi'; did you mean 'napi'?
  980 |         napi_disable(&priv->rx_napi);
      |                             ^~~~~~~
      |                             napi
drivers/net/ethernet/mediatek/mtk_star_emac.c:981:29: error: 'struct mtk_star_priv' has no member named 'tx_napi'; did you mean 'napi'?
  981 |         napi_disable(&priv->tx_napi);
      |                             ^~~~~~~
      |                             napi

Guenter
