Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F65A49
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 03:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxtx.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxtx.org header.i=@linuxtx.org header.b="HHLn6xBH"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3b2ea7cc821so3334477b6e.1
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 19:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1699326436; x=1699931236; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dtUmnXI5t0ND/jp+Ght3tKSphvzb3bRY83Nh8JP9hmc=;
        b=HHLn6xBH6Fs73Rni4+94TJznmol/qmv4B/Ohg23aB8idClWePipaF1OiwM2Jadujvt
         6utN2v7KYoB7KDMGycTf6ihESD2/gGaoMvbDVUsx9hi4qsfKjxsYUrEwMgSSjRw2ueDF
         jw0DuytujawMWiuYu1mIZ2SE+jtfDSKicGpSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699326436; x=1699931236;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dtUmnXI5t0ND/jp+Ght3tKSphvzb3bRY83Nh8JP9hmc=;
        b=PlP/b8CUzmVrhChaDm2Zng3fpw6Tq+RehkGJ6PmeEAh3P5N7WGrUe6vmx+XmGaUJrZ
         aguYNa6ABmK7IGdZB0saI/VaGa4mej2SFPEXor7V6CREuakz2QAKIND3++9xMNg1Oe3/
         s2cORVMTk5EjYtzYezyB48ELGwndhUity7qsGW01fNuIweQyDG9bLLWglCDqspDx7a9T
         GuJZoNexC4bfxA78UUm4rcAKyJVYMInSNHaSzGri6155GPe3jWOuVTXBtvRHuBm4BQ29
         Y6/cvICJr7wWdWyS196sfLOPL4sj4W9ldsiCdvX9dC5chJ2kv4GsomTXipl5sKsjQqfi
         bvxQ==
X-Gm-Message-State: AOJu0YyvUrnLLv1YDsfdrU0rlGBI5/sh+DjZSqCc0AsV4mt2Ja5PSYqk
	IK+/5IrdwC9cu/O2ImgDdVlQjg==
X-Google-Smtp-Source: AGHT+IFT6lsP6Br3V1pqr43R6QRdoI3ixaDhJj7yN91h+HiV6lyzbxqu2GrReJ7VMjKl2tZy07S4DQ==
X-Received: by 2002:a05:6808:313:b0:3ad:ff3e:d25c with SMTP id i19-20020a056808031300b003adff3ed25cmr32211896oie.53.1699326436673;
        Mon, 06 Nov 2023 19:07:16 -0800 (PST)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id bg42-20020a05680817aa00b003afc33bf048sm1472993oib.2.2023.11.06.19.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 19:07:15 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Mon, 6 Nov 2023 21:07:14 -0600
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.5 00/88] 6.5.11-rc1 review
Message-ID: <ZUmp4oPrMU5qSHSo@fedora64.linuxtx.org>
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

On Mon, Nov 06, 2023 at 02:02:54PM +0100, Greg Kroah-Hartman wrote:
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

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
