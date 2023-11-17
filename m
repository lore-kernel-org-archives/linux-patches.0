Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B94C8CC
	for <patches@lists.linux.dev>; Fri, 17 Nov 2023 04:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IKo5bvjL"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1cc7077d34aso13100595ad.2
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 20:14:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700194446; x=1700799246; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f1IviFP1UmvZ/gHfcbxMG+ukFwTbGKkI3NY0964zDgY=;
        b=IKo5bvjLUa5/KdDi2toBLE4dcw745XsPpp3IYrjs9xUM52Uh/SrSO2YC9X0hizR6vQ
         KCZ2IGV2oRln+morLNjfRBxVqTBeOCMYOR4zpYSROoMlMTIQsKMNDaIneo9q1Bz7nxYY
         imFYNUHSiNu1MrVto5KBtsinVW1UaOuVPn2GlYhZyu+G3qQwinlpHMfVC8ZnlrxpC5ZY
         Kd1nQwI/idJa73K/o8LVUjiWWoG6pecOnuzQHnBclnCx7ZsVkLrsZgyrQv02NnFC+m9p
         sHtb7QtrymqQClX+hiicqRcbl2M9h5hN0tPoDVmgm0ScFz+dq99UXSjqIA8NPP3F3hlQ
         y4pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700194446; x=1700799246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f1IviFP1UmvZ/gHfcbxMG+ukFwTbGKkI3NY0964zDgY=;
        b=cdUU5xiMjAR8+0dR3SSiJXkb2WyTFx87pF0V8rWha6u9ko0SFY0z3oUhXQbbDMnZHY
         ZXGP2pktMLS8iXjetpRZ6uHexGh/w+yD2Ca7c+51em++X2IjfrbsyMntqr73caBnC3MJ
         ODMGoZs2i4/9cLlwAez+/sVy84XDMX0LmGzGhiNNxH817wBeBl7SIIskizWOPH4lvGPV
         KAoTRavJ8DkUBRneWzYA9lyyVXmXFg6Xt63cl6O2fM2/7FxzrGpiFxHChxh8e4CrRgaj
         +EezU/YQlUjaNNdGiz6ShD3non+AnFW+IBUwofNjxvBaQEJOphmE6CRM6iVLjERvHLJ0
         q7ZA==
X-Gm-Message-State: AOJu0YxNzko0dGth4e3iXfNSzImEaE5ZSrUXYAtnJ+FMEgI5A4Jd2t4x
	66XEYoAzFJGXcKLu1isk0hKbbgteVb4=
X-Google-Smtp-Source: AGHT+IGRWr0hFpsOm93SdG7YYSwLthuSdyhc6evr7+nyvmVBQW6izTePlhRxOsUC2b/kc67Sayo2Ig==
X-Received: by 2002:a17:902:ced1:b0:1cc:1e16:e998 with SMTP id d17-20020a170902ced100b001cc1e16e998mr12362911plg.51.1700194446427;
        Thu, 16 Nov 2023 20:14:06 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y8-20020a17090264c800b001c9c5a1b477sm458829pli.169.2023.11.16.20.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Nov 2023 20:14:06 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 16 Nov 2023 20:14:04 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/550] 6.5.12-rc1 review
Message-ID: <6c9f2a56-367a-455e-9d62-ebb507e225f0@roeck-us.net>
References: <20231115191600.708733204@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>

On Wed, Nov 15, 2023 at 02:09:44PM -0500, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.12 release.
> There are 550 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 155 fail: 2
Failed builds:
	i386:allyesconfig
	x86_64:allyesconfig
Qemu test results:
	total: 530 pass: 100 fail: 430
Failed tests:
	lots ...

I didn't check all failed tests, but it looks like the already reported
kunit build failures are responsible for at least a large majority of
the failures.

Guenter
