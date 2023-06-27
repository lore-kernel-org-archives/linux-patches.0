Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8897473
	for <patches@lists.linux.dev>; Tue, 27 Jun 2023 21:35:32 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-263253063f9so690953a91.1
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 14:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687901732; x=1690493732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X2+7EhmDYzz3dsEHy7Rn6SNAYgMmhl2BbDV5wUwjQK8=;
        b=IA2lH70aDaFl2XJlVOTQnIMwx86vTfNIHx/2zlLGnGxoIeJU6iSJr690/J76EnFuLh
         2V1LdJtJMax2yrC2Ejwd224xFInGkiC/vy3Y3hR+yJzX4T4kDY8X4pVvlQmxquMtEnOV
         MpeodNxuEqiSKqERAQxT5oTlnKZSUcJmj7FnqUG4utDG+UaBd6pW6I/32A0PI5XfFUK2
         rrq37uygtSLf6/wPwUcLE20RhV7OZn5XxXGpGGebynm3BiBsV57iv7TBlF0bSf4xqdqC
         eWLttRrvqazCJir5fSR73w6mu4JAZiSXeKHpU+DR3PVUoxth6bNOkrtCfctAU7viC7kD
         gAhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687901732; x=1690493732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X2+7EhmDYzz3dsEHy7Rn6SNAYgMmhl2BbDV5wUwjQK8=;
        b=I0emwuwqgmdJrGMaTWCprwvptNLJNB5Rpv0Z8YjobubJ/ntl35upD3f4RGJG9+T2zd
         SrHMXuoyMq4Auy5gXfyleNw5X+L6jU0y5oiriReufpTv++hilFn5FoVYN+YmjZCt26Za
         D1Wcei0E8OOmBI0gRzaPjFc7uCR01xlAYOuBZzJZcvTflWD9y9POP6F4MoRWQy8sEkx6
         b7XBbgs83pyD+xj3Ib8SXB1WB1FOyWu+kLtewhQHOFWG8sBkYWyE1G6zezub58ft8jek
         d4e2J2+N2dL+Pkzg1ezBBZoqRcN6Eu5t10yhBj9ciVLVA1/2AbGI13KblRfRH+X84y2j
         CMBg==
X-Gm-Message-State: AC+VfDwP5AxWG0vcR4kEqYkHWWHYw+2+rzm6B/awaeYPlZMFKHp23Qcr
	QXhkKa7f/1JrgRH5ayBpGKw=
X-Google-Smtp-Source: ACHHUZ4XdrSuq3CPHSr7GVJLtMGwzV3PBEi7M6MrqV4otgI4lHidph5ey0KmEZL2gATRlHvHBPnGcQ==
X-Received: by 2002:a17:90a:3ee4:b0:253:340d:77d8 with SMTP id k91-20020a17090a3ee400b00253340d77d8mr30883103pjc.33.1687901731785;
        Tue, 27 Jun 2023 14:35:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090abf8a00b0025e7f7b46c3sm8231098pjs.25.2023.06.27.14.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jun 2023 14:35:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 27 Jun 2023 14:35:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 00/81] 5.10.186-rc1 review
Message-ID: <b331ff35-e995-486b-a37e-919405cb61ff@roeck-us.net>
References: <20230626180744.453069285@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230626180744.453069285@linuxfoundation.org>

On Mon, Jun 26, 2023 at 08:11:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.186 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 162 fail: 0
Qemu test results:
	total: 485 pass: 485 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
