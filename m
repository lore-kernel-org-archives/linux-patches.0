Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBE6D53B
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 23:25:57 +0000 (UTC)
Received: by mail-pj1-f53.google.com with SMTP id kb15so773668pjb.1
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 15:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1677799557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EJebJkjcbH6lD9dZKQHxPTGnyvjfRr/WRlDMZGcswFY=;
        b=WGeot1XIgZ2Pt2nVRmzXPAFnvh9xNUBiRlbjTx51Cyiy1dSh80xz389Doc7zl4qK+6
         hOOeXnEuFF8M5eR9RToy9zoEq+iEUkmauHAFOO17XX6oQa5u3ZNfeJHkm8i3nZBRx2HN
         vZHKbLoBZhUuA7jisrnjGqVjj53Jugynnm7EE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677799557;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJebJkjcbH6lD9dZKQHxPTGnyvjfRr/WRlDMZGcswFY=;
        b=RPTByh+Pv5X6Ufwl/szIlq3f7AO7M8zTamqOTiwvwqPzj1Z1j2dK/bf0NvIY52n7Jk
         ftfkUIpva9c237qCQAHbJK0AmD+P1Ll+2e51kNrzFeGrPZeRCPYTIBNvIdv83ygeZrYH
         QHMok28ujU/ENtKVNPsnklQNHV2SzFxeHUS+KnspPA60y7B+xOQmg+J2wCOebGKohUhB
         /1pmLI64lUU/EiG5Tt/rQ43jVpWb7eQ878zXS1uDJTigr3wJ9Rji75PcK/vtZY6D5LIJ
         wzbE5nDmi+ej6WhFUbZr/GoasoP9vUSrZ98YnbFC2XTLm8gOFtsW3IBakVzIMqVtsF4B
         GF+g==
X-Gm-Message-State: AO0yUKVMAwm1soyK6Vz/PkN4d3VfVgl9Lyz45YJVmKs9b08zz8mHlnMl
	4o1pyiZ9oIZhlSfHfLPak/dDzQ==
X-Google-Smtp-Source: AK7set9Yx25dOoCsYZOTUD2EIBEROIjWHDqCnvpz/1WDl/+CEOOyfaXgH3GSCQrEXWN3y/EdcG0B9w==
X-Received: by 2002:a17:90b:1b4f:b0:237:c565:7bc6 with SMTP id nv15-20020a17090b1b4f00b00237c5657bc6mr12995431pjb.10.1677799556931;
        Thu, 02 Mar 2023 15:25:56 -0800 (PST)
Received: from f899b28bb789 (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id om9-20020a17090b3a8900b002339195a47bsm2081257pjb.53.2023.03.02.15.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 15:25:56 -0800 (PST)
Date: Thu, 2 Mar 2023 23:25:45 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/42] 6.1.15-rc1 review
Message-ID: <20230302232545.GA1559@f899b28bb789>
References: <20230301180657.003689969@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>

On Wed, Mar 01, 2023 at 07:08:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.15 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.15-rc1 tested.

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
