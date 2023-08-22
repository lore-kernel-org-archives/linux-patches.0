Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9F57F
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 14:29:35 +0000 (UTC)
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3a741f46fadso3440953b6e.0
        for <patches@lists.linux.dev>; Tue, 22 Aug 2023 07:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1692714575; x=1693319375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RtMM8v6IiohW/f8NheBJDCq6aKcUIgznS7UeM1fX+Ks=;
        b=TP4D3Gg/s3Nu/iV0bul6JqS5eOId5CCRuj9en/E6QOFSWBbdGEnjXqbJ1+4Kwk3Q/8
         svU3daBbGqraMawAPMZVR3/CGtBeUsmQFR3ZG35n8TeGDJ5RPDTNIwCHfjL2cg2DHkAp
         rgGS6S1OFjEz32NHfM9mEFLshsG4KNrxWu6vY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692714575; x=1693319375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RtMM8v6IiohW/f8NheBJDCq6aKcUIgznS7UeM1fX+Ks=;
        b=bbqwp/VBOgWKuAZjt45x3byj4/FpnuWSbNGdTmDLPczWUI4IYxkeCWqJhkZ1Nw79PG
         W9Sk9NZMLkDbaqOpHKqsaj1J0irBQ4+HXA5vxTOze67IDMXzd6PPE+5+Yf4KNa9lQWOf
         Dqf/B38Pvy3dgly+fwouiNJ+Lij9QC6Jd57Oo4P0JAhRNdxKWlSlK5gv5P2nxPjDH+V6
         2jMRoLqXYGX3KTbNjr6xO6GnIDyQX8btOFGSJhqqKMvfIWAn+cTvENSJfnXcAZRcdTSM
         PwD2OnIHkqho5pP1gUVZS48czNE8PrBtxJzhhMlspiRdyNPz2jZSUzOKOoVV+Je1al1O
         LX1g==
X-Gm-Message-State: AOJu0YzRS10EQkX6cbazH1KUlIe8Ky3PNeP4zpkt+deavC7KCzel7MJD
	QNSqB/M2KNeTb6xMbwbYkCt0GQ==
X-Google-Smtp-Source: AGHT+IHWqqF3x5jjHnTZkfTQ6SWx9wWvhUOtZbXGP18FUv0qrYrp/FYm+MMAcFCMlICmGXXRP8sAkA==
X-Received: by 2002:a54:4490:0:b0:3a4:a87:bea1 with SMTP id v16-20020a544490000000b003a40a87bea1mr11526966oiv.21.1692714574893;
        Tue, 22 Aug 2023 07:29:34 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id bk15-20020a0568081a0f00b003a48ed3564bsm4807348oib.50.2023.08.22.07.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 07:29:34 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date: Tue, 22 Aug 2023 09:29:32 -0500
From: Justin Forbes <jforbes@fedoraproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.4 000/234] 6.4.12-rc1 review
Message-ID: <ZOTGTCrdlCklrtyS@fedora64.linuxtx.org>
References: <20230821194128.754601642@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>

On Mon, Aug 21, 2023 at 09:39:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.12 release.
> There are 234 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, ppc64le, s390x,
x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
