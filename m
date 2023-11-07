Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7C230FA1
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 17:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=marliere.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marliere.net header.i=@marliere.net header.b="FClUayP9"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-5a7b3d33663so72235457b3.3
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 09:15:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699377327; x=1699982127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:dkim-signature:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2g8jDPpSWd4rfNQp4XblzxoeaX9SXaeroV6LJ5acpaw=;
        b=bKD2mDMYmwmUuzSMszegULiULVfxefRzVK/AbhFlyTMlPbzcQTPWm7joEV8ivA4N3n
         xCQxm2DXDg0V32KLtJVVunXlPQq+jY2qdzPhPcMcUrVdZ/Auq588xa5JtLsE/g9ntgPc
         20glIB9ylzbdALU8YYRhrANbRwUJlNLtMAFTgcC1nTtiy9MAVbm8Jh68kyp62x+l4WMX
         xHFpoNX3c2ZZQkRNPEF6AjEGWWN2jOmAGRPNP4mQt1pavh9lsoJyV5WuSVF7uXbTOt8E
         wFCwvHLW5AokH/vdkqOF3cg10NWr2yoewcS/Mpt/3Y6kuYFCnwId1+ZAneCVI+tUUPXT
         IDrg==
X-Gm-Message-State: AOJu0YxkDkOUb+raNJFifcozd8OP9dbkG3fVijkC2iUK6XidWqqHtKt8
	Z6ASJivE0J10MwVhApOd5TQ=
X-Google-Smtp-Source: AGHT+IF8FH2D09mlKrobTjV9en1jfV6JBlPNLYCJarJIEd4EX45IgVWo9/2skiohK66dVdl6t426AQ==
X-Received: by 2002:a0d:e2d0:0:b0:5a8:1d0e:ca6 with SMTP id l199-20020a0de2d0000000b005a81d0e0ca6mr13910596ywe.32.1699377326769;
        Tue, 07 Nov 2023 09:15:26 -0800 (PST)
Received: from mail.marliere.net ([24.199.118.162])
        by smtp.gmail.com with ESMTPSA id u36-20020a81b624000000b005a7ba08b2acsm5806277ywh.0.2023.11.07.09.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 09:15:26 -0800 (PST)
Date: Tue, 7 Nov 2023 14:15:27 -0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=2023; t=1699377325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2g8jDPpSWd4rfNQp4XblzxoeaX9SXaeroV6LJ5acpaw=;
	b=FClUayP9yArLPiqzXLPPJUFkq6e2VjsEem+wp1NqnkzDvy76VDEPh11+IUKSV6uNdsC0i3
	5bLycnT2leBd7EqC77mwA9FsHsLDm2OmB4N6oEzMTXxLiPSL9jHi1Y7QesI2An+Ww4Koop
	rLIJO1seKgi/ivNBqH6FXSLXlyOuLPL28Z/b6mkb63qbStwwpmAaI9eIH60ej6PNPY5h+r
	1SQv3yOBOI0uAHCYxbio5Qt1un1AeMg1SbiFRVHpjaZXDMBe+xk/J/TArljStla+364MJR
	KKUytLi56v8CrjFXa2/OFM5TCHs5isODOWhqtZ+GopU+8dKL2cG15BvaCJePig==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=ricardo@marliere.net smtp.mailfrom=ricardo@marliere.net
From: "Ricardo B. Marliere" <ricardo@marliere.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 00/88] 6.5.11-rc1 review
Message-ID: <4cfshixe7klz632hrculpkkz4opdz7bpkvxtvt5v6w4ul6wja2@66l5mo5shjgt>
References: <20231106130305.772449722@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>

On 23/11/06 02:02PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.11 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

No regressions on my system.

Tested-by: Ricardo B. Marliere <ricardo@marliere.net>

Thank you.

