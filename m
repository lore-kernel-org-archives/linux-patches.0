Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD592D780
	for <patches@lists.linux.dev>; Wed, 13 Dec 2023 14:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="b0wEgu04"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d336760e72so18044905ad.3
        for <patches@lists.linux.dev>; Wed, 13 Dec 2023 06:56:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702479410; x=1703084210;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=02iXJsr8I1Hx9DZ+EoYreRi3wtC3FVG+hruJRxTtQ7A=;
        b=b+hX86TCSoj8Smk4Vm/X3QPfg9I3HQnkZqzkpoNgyK9iFwBiwlh6Cu+sxXWLDgo9cm
         HUmChCTrcm5VoPumRUfejqubxdHSAU7KJReEBCQuDRpiXwiwKc1ToFAADaxFTOGGPfrr
         cbn3np4p7ISnKuWnW2XGX7LYCU9l8jj1rK9iP3aOPrMnOB09AOjtXf4FnOOTNE5naSA0
         xcLXV7RhEUG3LgVdazhHlSLLYSGxoSNVfRniSWHGKTuiwkgvKwxJ/4WVcT0CGHTmp4f5
         2a4aZjaV3UsnThGW593gCwZtjnzYfXg9niNzWSXU97or7cS8vBr2lQFo+207sJPBODGY
         5WMg==
X-Gm-Message-State: AOJu0Yw3jPKffe0hDMHiYe8b2ydfONordEFReMxEU6X+ri4EWhiYAJmC
	XA+g/KQB8JVo8T/hkM3I/dU=
X-Google-Smtp-Source: AGHT+IEUekH9GLpWwt0/WDKEjJs8j4o6eNZpMgpQCDoKoClcvbEREqLdQ6LnT8C4MXV9lTmXxI08yQ==
X-Received: by 2002:a17:902:d481:b0:1cf:f3a0:3c8e with SMTP id c1-20020a170902d48100b001cff3a03c8emr9251575plg.28.1702479410447;
        Wed, 13 Dec 2023 06:56:50 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902ab8700b001cfc19c2d01sm3288445plr.296.2023.12.13.06.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 06:56:49 -0800 (PST)
Date: Wed, 13 Dec 2023 11:56:48 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1702479408;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=02iXJsr8I1Hx9DZ+EoYreRi3wtC3FVG+hruJRxTtQ7A=;
	b=b0wEgu04ocg3IOIKXrOQ3dQnCw7yQIdZVesOv/Y8h9L8xhaMS11m4gTAxV9R5XQyF4zEWi
	H9YIT5JiSDo2r7YTljqS/VyihJGYFNCd0S1StYDmR3ICAiKLOeA0mSra8G0ecx6fH8DGjn
	LVk6/LICEyRx84geKZWBAK/xS8X3/z3agSCl7L7hmGUF+cH8eZ8QZ+l9dBgzLgk/RhW7AG
	izGup9AkxwxOHZg2gcHhwGVgH20PIVivHnq1SKbu1Rx3Ss4WeDtRt2MAgPz//csgxgFJVf
	zJKd6UyVEtNSRQWkFSCCD1daGG42mmc24gOcOxrYtp8QzNF1gEdI0n0+GCa4FA==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/244] 6.6.7-rc1 review
Message-ID: <zzonspyiqrsxgs7ygfpuwo5pbqeuhj5arizokbungiwwms7tj6@zkwnv2fwk2hf>
References: <20231211182045.784881756@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>

On 23/12/11 07:18PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.7 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No regressions on my system:
[    0.000000] Linux version 6.6.7-rc1+ (rbmarliere@debian) (Debian clang version 16.0.6 (19), GNU ld (GNU Binutils for Debian) 2.41.50.20231206) #12 SMP PREEMPT_DYNAMIC Wed Dec 13 11:37:51 -03 2023

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>

Thanks!
-	Ricardo
