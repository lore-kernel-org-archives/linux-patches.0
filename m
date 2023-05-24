Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1D1C15F
	for <patches@lists.linux.dev>; Wed, 24 May 2023 09:10:11 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2533d8f4a1eso2988a91.1
        for <patches@lists.linux.dev>; Wed, 24 May 2023 02:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google; t=1684919411; x=1687511411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jCr/OarpwieZOdmOIu/V9/SmcLUVBsGlmM/9L/c4/Sg=;
        b=UWrzm3fkA2t41R/7rcZtG59r4OaD3kflJfw8z5OXpXJYWUkbvvu0V+t4VOPaF4oSBG
         oFegg8MxngWUsRrdDdGMAW1QK4uME4dH/E51jFAr9E8pzujqP+bJLymvONVtzK8udaeG
         AJW18VFG18kaIQ5ouv7PQVQTlPPceajrBMW0M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684919411; x=1687511411;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCr/OarpwieZOdmOIu/V9/SmcLUVBsGlmM/9L/c4/Sg=;
        b=dfv5TWxkBzFSAMfSZMxIK8md0y8LIRUHIC09ph1g+IvUKCt+bpI3xAnuaaisBYM+Al
         M7XS0GxyWm+g4+IXMFIwFG/4TLNf1vcSWEBD17BNT8qzITR6h2RZkMmrpm1uuDm4N5E7
         keypg80T5AvBBN4i3C4kU1955gcBP0BkvceciGpCCqNY0FS+040uAi15fNw56VSV5kE2
         orOEsF8OneTTCxhxRIh08dfD73HvemUZAEa+gUzi8jcJTKqyJ20/b5xTKUgof+9xgxi1
         oHD6df0Fq9uBUAc1ulqDr08nL5OEO3Fy5+G4/yfW1HiZnsEpSDnPvxTv8uPdENIMXg97
         SbAg==
X-Gm-Message-State: AC+VfDwdCG3E8qRn7cfKu4HHSloRERQZTg6oXo6A3iUBrGmbCwQrS4TN
	gRyTMNHPEHdvnV8DkGBbydE37Q==
X-Google-Smtp-Source: ACHHUZ5C0WPRnTM0+P/MCsTe53CbWPUvCmfYCSa/0oJkwLPOsN+SR7MwcINaovSF6b5GlxJdy+iB2Q==
X-Received: by 2002:a17:90a:51c7:b0:255:4f3b:f3b6 with SMTP id u65-20020a17090a51c700b002554f3bf3b6mr10346649pjh.37.1684919410656;
        Wed, 24 May 2023 02:10:10 -0700 (PDT)
Received: from 330e1fe543a3 ([122.199.31.3])
        by smtp.gmail.com with ESMTPSA id nb1-20020a17090b35c100b0024decfb1ec2sm890928pjb.30.2023.05.24.02.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 02:10:10 -0700 (PDT)
Date: Wed, 24 May 2023 09:10:03 +0000
From: Rudi Heitbaum <rudi@heitbaum.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.3 000/363] 6.3.4-rc2 review
Message-ID: <20230524091003.GA517720@330e1fe543a3>
References: <20230523164950.435226211@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523164950.435226211@linuxfoundation.org>

On Tue, May 23, 2023 at 06:01:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.4 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 May 2023 16:48:37 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.3.4-rc2 tested.

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
