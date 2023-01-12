Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A39F361
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 00:40:33 +0000 (UTC)
Received: by mail-oi1-f181.google.com with SMTP id d188so2996818oia.3
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 16:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gmm3Kka8nPO6cOZbO1FBl6SeSZ30du4k0AiQMDwpj2I=;
        b=mL8zKn2DSYyQ/FIcpmI/WpJPMFqMXQ+g32HMxe+smn4iuXjDrcKWmVVfVZw5f4Q7vK
         5pNahLYCwjg2VkR+QTq4UV+mv/DxYO8Bp3ksfY7rg+erqDNc4G4xLbNdscI+zbo+eniY
         emW/ZLjvdGH/eSDwQsDVxzp0TZW4sm/J0Ox36maB8nQ6NtWGActmVxXyZLXXTxucKUVo
         QsHMOOqPAqHoHNeETr7oxx5dVpsYpnpiciUzFuAQuW2qEpuM0dT+rmcQNyG1/VeBTk8x
         bEIt5oV+M0AO57ZcD2lUD3RTKy1+Djl48CkClClQILCa07zzmViKFiItE53hwebknTsU
         ZN/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gmm3Kka8nPO6cOZbO1FBl6SeSZ30du4k0AiQMDwpj2I=;
        b=z/G2/5y4XCD1LA5AhD/q6Ve9BovL5W4D71TA+I2xE9oYhDHSbnbGZdWxZ8IEtf8ffb
         bMXaaOPBkjfDoEomuAsUwIftxpbaO4xKb1NuRdvyuM2QRSpq3dqJsgQ9Se0Yts02LNQD
         2sAyd2xYzCvz+3HQSYPPIaXQUsn10sIzOmgI/ZfhpIxgXtQqwl1XP/wwHdOmFWU9plG2
         GhW6Q+rV8XvxG3JKqsmQPG8U/NO9kysmZMqfnL+arAnCoYJdWpD1WsT4/FmB8lETfyCP
         yI/WyQkGcp06TXAwMnzpkN+ImHSSoa8KP2SgUFMv07HOHLfLFY7qoBgddjD6MWTGddi8
         rg8Q==
X-Gm-Message-State: AFqh2kpIQCmivloxoJFXPXXSXxaSw0K4c3mKoud+QOSESCLbviKijsTG
	nE8rEH6MdKXU7l54lDw8CdY=
X-Google-Smtp-Source: AMrXdXuMKt/Fz5Rsn3/w68ycL7qBeSDUdCor8hBlrKV49vdgAPCvjbfvkAaK/KAwC+T5i79Mut6k7g==
X-Received: by 2002:a05:6808:bd0:b0:364:5d10:71fa with SMTP id o16-20020a0568080bd000b003645d1071famr4440565oik.1.1673484032514;
        Wed, 11 Jan 2023 16:40:32 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 15-20020aca090f000000b003509cc4ad4esm7280627oij.39.2023.01.11.16.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 16:40:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 11 Jan 2023 16:40:30 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Message-ID: <20230112004030.GC1991532@roeck-us.net>
References: <20230110180018.288460217@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>

On Tue, Jan 10, 2023 at 07:02:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 500 pass: 500 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
