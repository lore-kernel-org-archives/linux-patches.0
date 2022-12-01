Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050E41116
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 11:21:58 +0000 (UTC)
Received: by mail-pg1-f171.google.com with SMTP id 136so1416409pga.1
        for <patches@lists.linux.dev>; Thu, 01 Dec 2022 03:21:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KcV2E+DLshJUcTnYfXOz34aTP2E58VdR57j+4Rky+uQ=;
        b=TZRZkF65FQ5q55inrSNPxIuLR7N/l0tL+GXiIolKXwtk8Llkai+VTu918FsGjgCVib
         bkVrtPYfM0rAl/aE/L2eAMDICmu7vR1aujpdtHNEseO+2vEuB6AXCVgq5H1puWe3S+xT
         t4m90KKwkwe2p1SC683IoQhPxAz4SvGh3deag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KcV2E+DLshJUcTnYfXOz34aTP2E58VdR57j+4Rky+uQ=;
        b=G+5E0M32WB3LK1qP4NGqZzug5WhgOYhRJ3xcVTWx9oPiEFyXFtVt6HDCjSRl8Z0PTm
         buDvWictIpSzX5xbIVG43CbY3vaZTjSWRr4CwRnntq+QfcaptA6RNIrvYYz/QBJSZMzU
         xPQ90pGdWxc+F5lghtX6mGPDELpIF92//zfW0zkf7TVx7Rfr7dnFl6+huVlI+VFwP5ZZ
         121CMs13uhmL5TS02NWPWtcHZO4/PXSjC8q5sYSzEIEd/LGwXJ0ecEl+JSn6L8meeiia
         we+nw4+UEBId8AW+mjH1HkoJAV341LncwbLDrT6kJGwzbPwEuL0MP9Do4jel/WAuT+Ys
         IL4g==
X-Gm-Message-State: ANoB5pkNuvWGALS9Wt9cQPL3VZNHtF3BnYG+POpkSHF+R2kKsIJCigyB
	IFBvQ0hoMe7KXENxrxH8ml4VwQ==
X-Google-Smtp-Source: AA0mqf5CwbXqaZTfVyhq2dfjg5jWlL0RCXWBvgRz/usGHIpDiDHZjcRlR8eeEJoMxzZrI/v8Bif1sw==
X-Received: by 2002:a62:be01:0:b0:575:caf6:5cd8 with SMTP id l1-20020a62be01000000b00575caf65cd8mr8989382pff.22.1669893718200;
        Thu, 01 Dec 2022 03:21:58 -0800 (PST)
Received: from 7bbcfc1ba566 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id k1-20020a170902c40100b00188fc33e96dsm3375966plk.198.2022.12.01.03.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 03:21:57 -0800 (PST)
Date: Thu, 1 Dec 2022 11:21:49 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/162] 5.10.157-rc1 review
Message-ID: <20221201112149.GA1304551@7bbcfc1ba566>
References: <20221130180528.466039523@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>

On Wed, Nov 30, 2022 at 07:21:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.157 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

5.10.157-rc1 tested.

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
