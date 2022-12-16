Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33D31378
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 10:02:46 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id w23so1785072ply.12
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 02:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FP9LJMDYntXNXXevgIOUHTB1ze5iCC1u3bRVMjKPtEQ=;
        b=DPapAx5OjERByaIzFy2dxneEocIRIp22ontAn+A2LLl/l0fJXWsXoNKum6ClbjoKjE
         +ymAIryOTyF3fA3opSBgYMDqCk8AiaLWz8W7uB+Z6xP6NtQIku9faYGyr7FHDzaLGSX6
         eTF4XmsP76VM2imwrkcTp6LRBP57cclridIv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FP9LJMDYntXNXXevgIOUHTB1ze5iCC1u3bRVMjKPtEQ=;
        b=o/A2sKDaGfZvyHOYI9xp8OcaYOZrBvWMEgGBbk6zFjazwps/CrE6sVHZ7ZoFVyo2b8
         AqMFnA0vdf0XWsDO8BsSMUKTYsOFbMzxmAS1FaXioS4/DgHngCJfIArOoQ9dhUEgvkXh
         ykFaUVI0OdyJiZYchROVORjZPctqt+MT4ogFvo0V+9I8Yr3hQq2iR8GzCct4aAKuOMHf
         j17YwcsYa1Mhe681FVwX+fLCm3WgwWbsrDtAXFSVDoZcXdFDI0hU6bQ47i7Dzw8n4gty
         ADwqyX4BmHhJ0wRTLh+AzjDiwfrp2ZeUIu3yS5s8ZVepF3BloZAc4n4wvREtJOPr8NKE
         6ZAg==
X-Gm-Message-State: ANoB5pme4F1GePDNNJtp94CxGhgem/B0Y5O0D/f0MmEbopnvNBSAC2K7
	OMr23XFjXaop9MwCe8QMWPo/NQ==
X-Google-Smtp-Source: AA0mqf70/ynGFAS3PgdTEeblJ6xC8/DMQr+bqmM5hCQ42dFjxw2wMIT8EpmcBEwD6rUDrFevMp8rzg==
X-Received: by 2002:a17:902:c141:b0:189:6e2b:b742 with SMTP id 1-20020a170902c14100b001896e2bb742mr32615957plj.43.1671184965790;
        Fri, 16 Dec 2022 02:02:45 -0800 (PST)
Received: from 5c08d17891b1 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id i12-20020a170902cf0c00b001895d87225csm1190232plg.182.2022.12.16.02.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 02:02:44 -0800 (PST)
Date: Fri, 16 Dec 2022 10:02:36 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/15] 5.10.160-rc1 review
Message-ID: <20221216100236.GA971897@5c08d17891b1>
References: <20221215172906.638553794@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>

On Thu, Dec 15, 2022 at 07:10:27PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.160 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.160-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
