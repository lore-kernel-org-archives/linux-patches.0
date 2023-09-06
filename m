Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0BC1095C
	for <patches@lists.linux.dev>; Wed,  6 Sep 2023 17:30:43 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1c0d5b16aacso451235ad.1
        for <patches@lists.linux.dev>; Wed, 06 Sep 2023 10:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694021442; x=1694626242; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GdFFIRXVw4asO0rRRfkbifUfRAANRxtyam8HgnhO5TU=;
        b=Oasa94R5NyrCKepVfkJg4Hm2bY16SC4ScNKe5VBkgIynIfmDca++3/IeYAUYTk28PQ
         gFyaQgxkF8+mrh8qqQSn7a2evK/58wVV+++PGFIhtsjPnYiEKGo8OhXPe+ekj1iUex4o
         eSeu0ymSHukPfGZ/fpcVn9T3whlIJWlvAdMOFnEbGOFLkTfhokSO88QFGeg+pDmcUFbA
         wSC/k/wk5k48bptsxiqtfJ28gqn3n0MI1Nf02kGJEPu5Zgt8f6ABT1bsCKbdAtwfW4Cz
         kOwzlgHgDc3zTzw44AE5zfQTliGXf5t/toFTGe7HVIJdmtrR/gLSQgl/mSJhnXfkBfoA
         d8pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694021442; x=1694626242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GdFFIRXVw4asO0rRRfkbifUfRAANRxtyam8HgnhO5TU=;
        b=WJ7WrRt1p9oXYZP0M3FWCQjJ3/Y6vujsr8kXH6/XFTVU4gfdsW+y20uVWWdfV7IykH
         HrQ2JbGwyufXZ+NixIVqYt+iYABaDzjIRoFkTP0NCfRQ68q9ung4VbQJkazlGmO6QWEn
         2SJSzBCkRK/nSogseMvgTPgIqYh+/DzO9XNKAQ7OaEtK3CvXdApjN3mqm3Iotzl07iHz
         DDG/zqkPaPHkvZM4Z4jr9Uak173so74TT2Q7ZKYMoV2RRJSmVE7RGeS/JWfZQxMsPvWa
         FlhfMnhWw6ToPanABCucmzjveL+24JMVohgPprFpv3anIqfDsqTYlIm6Q6u+SvscKpmb
         k8dw==
X-Gm-Message-State: AOJu0Yy1p2oW9l6dMgf+7mwjHAX7eu/iq6bFHlg2ErMO/1+v+8OHSluI
	DQ6R4qHeXweLtYenwuH6I6M=
X-Google-Smtp-Source: AGHT+IE2VjplLtclOfxZAuJPA3ldL1BglB9zV3kfKp4UCm8i5PdJ340U5moc50cE7BX5EnMVGdHqYA==
X-Received: by 2002:a17:90a:7a8f:b0:26c:f871:e6b1 with SMTP id q15-20020a17090a7a8f00b0026cf871e6b1mr12085090pjf.22.1694021442398;
        Wed, 06 Sep 2023 10:30:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t10-20020a17090ad50a00b002682523653asm40955pju.49.2023.09.06.10.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 10:30:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 6 Sep 2023 10:30:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 00/32] 6.4.15-rc1 review
Message-ID: <0bf59003-ec01-47e6-ad61-b0ccb356bf45@roeck-us.net>
References: <20230904182947.899158313@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230904182947.899158313@linuxfoundation.org>

On Mon, Sep 04, 2023 at 07:29:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.15 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 524 pass: 524 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
