Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7147E2
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 00:50:27 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-5650ef42f6dso2921675a12.0
        for <patches@lists.linux.dev>; Tue, 22 Aug 2023 17:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692751827; x=1693356627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VM43A4/DK/17xUvga8Gmv1Q0UBVziYLS6+8xmcTLaUI=;
        b=CodYmXiWIj+5nfcp0Fcj7nsBX3UzYQo43LtC7Cyn0wioHPrSAgEXdL1Eizd5bFEmK9
         HRW09Ntbny+l4MiMT2PB/KEq10DP6qYr2OP88OA6STJSrTvii/HQuJsvcCNKB7sYPcBe
         ZoZt06eCosFPqKp+/U+iP1I6vLL1fiifEy2ZzFI0f41t6SeK7VP7sO5noevJc1aGOU8U
         YOGZiL1HLpjpmjWHRGoRo1UzQziBkl+vrdRRbZdnibDj8lcl+a3h894tCHriSxlzNxZX
         da38wSrsqFhdnay3MHrsaDXC+CRz3h0Y+EQHKVFWtwq4vKsaap8Yj/LKpJOy89+Wa+XW
         L7tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692751827; x=1693356627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VM43A4/DK/17xUvga8Gmv1Q0UBVziYLS6+8xmcTLaUI=;
        b=XgmZbbo0oDPnz7kHTK8HzQakdCziE5Hpwex+2yrjkAKU9tyAkrjJYAdaH+XRukjcFK
         4nwMmd+qmG620QX3FCEE4D3kjdirineV5+4Tf/gM1iGgDpTHj3YC8i+35bxMFvNYYqlE
         +VPo3VMAAyHCycCJ0OJA1L3dBIAquAKcnD14FMo9LXSPHDy7RPHAYOc9YRWogpG+PwId
         wRdpuWoFKCFl4eWMfrcajzh/PEytUsHLg14cwkrSw4b7UujClfhSsO0wjRy2pArzTpI1
         NcAwmd2gtFUhM8hCHPnYKee6Guxf0ayjMQ6CioeYEXBkSltBA3aFxx6s3XJsT2brNpx8
         FYlw==
X-Gm-Message-State: AOJu0YynpMdS2of4DIdJilGzL9NmHJ9gKbtV5HJ3NMe9akb+9xPVoJd5
	P3ijVHaRDPLwkN0QY9nzKes=
X-Google-Smtp-Source: AGHT+IH5TO05VVkBG2tZH5Ys414AcYHnwfJRxTfvVCLNNLXlabNNJweDWr7XIxo6v4GYqVcbnx0d9Q==
X-Received: by 2002:a17:90a:ca16:b0:263:fc45:4091 with SMTP id x22-20020a17090aca1600b00263fc454091mr8151185pjt.15.1692751826886;
        Tue, 22 Aug 2023 17:50:26 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id fu4-20020a17090ad18400b002694da8a9cdsm8398306pjb.48.2023.08.22.17.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 17:50:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 22 Aug 2023 17:50:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/234] 6.4.12-rc1 review
Message-ID: <5ffac837-e992-4ed0-b2a3-7324ff1a8489@roeck-us.net>
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

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 522 pass: 522 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
