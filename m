Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C077A17757
	for <patches@lists.linux.dev>; Tue, 23 May 2023 23:54:13 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1a516fb6523so2469875ad.3
        for <patches@lists.linux.dev>; Tue, 23 May 2023 16:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684886053; x=1687478053;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6fGiwkDKraznRyKW1dHr3SPz8az5q9g0yfOqKKZGiTM=;
        b=BY4J4pvnlDk61hWplzCxd0wsPIi3br/wLSkhqcJL1E/z2/biCsoKdTRHLa2zT241j8
         kkX26uAw0cpgy0hFeZvrNDPax3Dkh7GjCZWRD7b9qU7NBtzsVt/rHq8w6Dfhp2D6iZO7
         wRCid1gIgIezxcG0m+gs58MsNDxqUBhmwSkjK+LWHBr8hg/9FdOQ+RpxquqwdH/odGBE
         vvjDN1GmEtHWzIr/Vk5JSdTlnF7IfdbUoq8fFsUM4MqERDsyf7uJzbr7P5wtC/KRQAoM
         tk46BnMenh6WjSakT7sgsmYmgBhlC8w++de9uwYp0vSVWMs7xp0q7vQ42v1YsbCQASlm
         a1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684886053; x=1687478053;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6fGiwkDKraznRyKW1dHr3SPz8az5q9g0yfOqKKZGiTM=;
        b=J8iQ7YxLg5O+7XSpRv9kW7p3wQdOGKSAciv90zv6aDjjA+/abNIdpP64D7k/vne0s8
         i5T9pSiOlQKP/39oTmqdM/gczQW3J4B8cnougKnh8YzSZMY5LbMa0X2gIrtl9qUGeFFI
         4HV1SWz+GQXBOcfykiK2WOwnryFIFdzshxZmAgCIB/Gn5l7xOelccqg/YjTbo8Gxsr7L
         siv8om31EpJ4OtieM+mj3/+scL/ap7QU5A3gWuKVsiodSYxyqVrRNtGefsJp4BfLhFuE
         l1pGJdOMsAK6A/CUqiFyThZ8TPcZ/bmWMcu6mAk1kqkjZiB3uR44AtHFJmB80vVP8933
         ryEA==
X-Gm-Message-State: AC+VfDxhqWpHUwBAxuzcYCod3biiTN6C/2wq01igH2sBO732etqnkVsb
	sMi7nOELiozShQux0kUw3c0=
X-Google-Smtp-Source: ACHHUZ4k1k9AaQovyVOjaGE0BCq7wngWO0MDKRy61Xln9RYJpGVHK22N51JxTCeaBzGS/jge7DbL0A==
X-Received: by 2002:a17:902:f2cc:b0:1ac:72ff:9853 with SMTP id h12-20020a170902f2cc00b001ac72ff9853mr12610289plc.30.1684886053134;
        Tue, 23 May 2023 16:54:13 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u8-20020a170902714800b001acacff3a70sm7399525plm.125.2023.05.23.16.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 16:54:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 23 May 2023 16:54:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/292] 6.1.30-rc1 review
Message-ID: <2ca3a858-b165-4236-8a8f-32741d365779@roeck-us.net>
References: <20230522190405.880733338@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>

On Mon, May 22, 2023 at 08:05:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.30 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 May 2023 19:03:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
