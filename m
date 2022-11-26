Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E53117CB
	for <patches@lists.linux.dev>; Sat, 26 Nov 2022 05:07:43 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id v3-20020a17090ac90300b00218441ac0f6so8853452pjt.0
        for <patches@lists.linux.dev>; Fri, 25 Nov 2022 21:07:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XIOp2nu9uvK0guG9IHkctrJxTkczWL48KQcVVRMB+sI=;
        b=KbHbebB1AOC6FNyUoIrqEKRRU8gN4H1n3aW0W4XOxqYjk01uU6tC/ivQA1/TsaQ/vC
         vxd66ZN8e0RHI4d2NQB79eYHp0/mqsTBmND3xMnsyxixf4RMewsfnGRqFZn6fBWjCoUM
         vHSI3OSrHZbt7x+fJ4p6aHpujG/7mjR07c1G8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XIOp2nu9uvK0guG9IHkctrJxTkczWL48KQcVVRMB+sI=;
        b=VCcwTZzXfAxYlmfzvlu0vyf8FYixAcS5bsNibuJdjqSevJJOdil3oGq77vghUSYf/n
         kMVFAG8WRqg47XWonQeU/MyI250RPqDRy2nFdxGnuZAH+tkXl0zHMkb3wSwnQv1/UVv8
         TEoDYGFFzSWF7DoI6ydUijhR/KYbgFWOa9wpujKOnNDNNYoyxIUnkhLfTc3TsBAFwE+w
         ABw79Q5QvigfS+DmPI3IXGol0NWLphzUwojV0wiEVvc5ObeU0EjWXisX/f2uAdFUH6dP
         RxIPxaa6r1dR5wKiSdUxsi/6N7yaSUVUD2zaOftK+/CwCSyyViD0gAlN0M22n5gNK+5x
         wuyw==
X-Gm-Message-State: ANoB5pm4RzYmLwlHk+02YgrKQAhUpq35o6OezMMk8pnDYAInBzvqN2iw
	kSlJsPhIP6vEHU9OPcESacW4hw==
X-Google-Smtp-Source: AA0mqf7SgF9lw7W0QqWM9WGGCr1ko400p0Hj8rA6IDF/EO+wK3u6KaOCsCX7175wYeZ+1CYXYmSpzQ==
X-Received: by 2002:a17:90a:5298:b0:217:e054:9ac8 with SMTP id w24-20020a17090a529800b00217e0549ac8mr50572914pjh.246.1669439262808;
        Fri, 25 Nov 2022 21:07:42 -0800 (PST)
Received: from a6c5907d6328 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id im16-20020a170902bb1000b00183c6784704sm3094862plb.291.2022.11.25.21.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Nov 2022 21:07:41 -0800 (PST)
Date: Sat, 26 Nov 2022 05:07:32 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/313] 6.0.10-rc2 review
Message-ID: <20221126050732.GA2942465@a6c5907d6328>
References: <20221125075804.064161337@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125075804.064161337@linuxfoundation.org>

On Fri, Nov 25, 2022 at 08:58:38AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Nov 2022 07:57:07 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.0.10-rc2 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)
- SolidRun Cubox-i Dual/Quad - NXP iMX6 (Cubox-i4Pro)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
