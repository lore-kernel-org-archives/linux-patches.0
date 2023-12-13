Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C13C1D681
	for <patches@lists.linux.dev>; Wed, 13 Dec 2023 14:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eH6k2AhK"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6d0985c70ffso1994969b3a.2
        for <patches@lists.linux.dev>; Wed, 13 Dec 2023 06:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702477839; x=1703082639; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLer1SF7EpDgV5wwruLn7G1R9ug5hXuliPpWU0a6AFE=;
        b=eH6k2AhKrHHWoHzTyJI8thcnVLfTtOhMb2VJEbtMwjkHgi0zlCvdR79quZ3ww2Kvgt
         ZIhLdrMhn6G6nyVMO4DYr5LwrSiyA2rrJurp/d2ngdox9fpfdMDmxUCcUBpNs4JW9gi3
         LEAUbqgvoryHb2eccdI2ZzE2H5WGHSisdqEF7x1AiRCX+VPAJeb9w7WJVeEBxgaTU1bW
         cDnreLGs6ng8t6TC6DMqp6IqhJozHAcde8YKzEbKPZuGrQw0xrghaJyFsC4dRGOF6DXA
         s95Fc1Q6ueyyQlfUWqvbli5QF3D36F0fRnzYJjRl5/l1SOzJAN2weFtGN7hyAImCcejr
         Nt4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702477839; x=1703082639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QLer1SF7EpDgV5wwruLn7G1R9ug5hXuliPpWU0a6AFE=;
        b=IF8VsKxV9mF73bpdzLyc9HylPfZ4v0FN8iV5gajD8LyJLaX5NCvlIIzFw9gTuSZe56
         bEB2ujaAue1Vge/QhNDYxei4AFJV/qhrECuJnyoYUYcypLyqkbyc7ZkLr6zvFFRDp7ta
         dywFaxWDGJ05iTVHAGYXaVhjMDpDmZosQplsuJB7gxUfBDBlHORA3EfvLRyXIsVcshMR
         PIpp4F7yNoo6XxhltfNp8sscl/McMN7m364t54pGhJRK6bEHIpaxaHUSvVEBDbEZFxSG
         i3wb3PMB5y0aOekcn0BAMaXigpYBlB3yEmf1XyvZ0BzIY9cmvxxb5SqrM3ZfRE3Z3Gx1
         +mug==
X-Gm-Message-State: AOJu0Yx8RdLKUHOyFv7Uy5ZLH1WnYgQyq70rNBmYTcY7oO8OoxZEg8Ut
	aB5f2GmCmdzrJP/2UqPH0E8=
X-Google-Smtp-Source: AGHT+IFLSrUkVbTFTgvCJSNuu8ML3O5t98F48xqf1rkoyPc0reME2OknOSdN7K8VoNkJsq5+v0a6ow==
X-Received: by 2002:a05:6a00:3305:b0:6ce:6007:9bb with SMTP id cq5-20020a056a00330500b006ce600709bbmr4451522pfb.60.1702477838995;
        Wed, 13 Dec 2023 06:30:38 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z17-20020aa785d1000000b006ce5bb61a5fsm10102920pfn.3.2023.12.13.06.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 06:30:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 13 Dec 2023 06:30:37 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 4.19 00/53] 4.19.302-rc2 review
Message-ID: <9137cfe5-83b1-4307-9943-77e8367ecc64@roeck-us.net>
References: <20231212120154.063773918@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212120154.063773918@linuxfoundation.org>

On Tue, Dec 12, 2023 at 01:05:09PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.302 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Dec 2023 12:01:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 147 pass: 147 fail: 0
Qemu test results:
	total: 441 pass: 441 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
