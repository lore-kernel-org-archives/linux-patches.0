Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD625383
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 16:44:36 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-792726d3aeeso194615139f.0
        for <patches@lists.linux.dev>; Wed, 30 Aug 2023 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693413876; x=1694018676; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VB9BcG9DBx3YBgNtAp765xJQP9YYe+QOzLCI45b7TjA=;
        b=EUg/NxT1YFKLOKkRzeYE5gwhL26sqbrBk6K0Gm/w29FpUUbtmc5GO8gvc8a+RLCr6w
         Rs9ycH6FNtlV7kp7SQ/uDnDYY/VdpitefVsLzHdMXBCDyZqw5ubWD2GCB3cyQVSkoKqJ
         j/cWTnOEpgA9mKvjEEXxwl/9qMlrWzM6L7zowvfrHMe7/OotH4msO7zdpnN3Y6qjET27
         nRHtEELFtuVKyESfi2ovWXzUhIekgf3+pvklrT0ecKevahB5S9YqnVIFCzc7INSeC7F+
         BQRJIvbsQeF29oUje6ytfePsXErSjY6b8znFSh9x2rJYvEHaKiHM5qzgIr4xlzY4ybVy
         rZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693413876; x=1694018676;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VB9BcG9DBx3YBgNtAp765xJQP9YYe+QOzLCI45b7TjA=;
        b=Fn23WkvdYWnEiTi2SIiLpkwhEH6g6bA4Axd12OUVARk/01O31lLZ2ikazUdjrawKek
         RSaelpUBSY6iv8w43q4csys9Ix/xN4auZk6UT95h+3e5zAEPSGhnvd3Gx1Iim2GH0nHe
         64j1WOu9j37iX0ACKE57GM0hQFAnxemKjT5UNcIobTHoaqq9Q6qGyFsAQ0SFME/O/WLz
         24BS2vCQLJ1hZnBBnK6M9nkaKx/N1cHyGUW/dCWAaEDw/iepF3Fnww7QCuIgo/4mS9Bf
         61TUpWXCrWG3yEHga6VeHMGl6uyEUcPd/kN1NjRXxK8eK8BmCcR525YscGG9M8fyuqJC
         JeGg==
X-Gm-Message-State: AOJu0Yz4pONI6WY2resLcRuDG3V/DwnZLWh7hDCnNaZ1b6s+EwMo2IAM
	4/NUmIlqtkTRhBIWw0iZrg4=
X-Google-Smtp-Source: AGHT+IGUv20sbwduwPaQIjZ7MnGXmaLgkBIZ4HLZXUWF8gBJHgLANXduERX1A/QiIRbKuOhDZRDqkg==
X-Received: by 2002:a6b:7006:0:b0:795:c6f:59ff with SMTP id l6-20020a6b7006000000b007950c6f59ffmr3192682ioc.17.1693413875851;
        Wed, 30 Aug 2023 09:44:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g7-20020a6b6b07000000b00786f5990435sm4001523ioc.7.2023.08.30.09.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Aug 2023 09:44:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 30 Aug 2023 09:44:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 000/135] 5.10.192-rc1 review
Message-ID: <27d08b24-3581-4451-b8db-5df144784d6a@roeck-us.net>
References: <20230824170617.074557800@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>

Hi,

On Thu, Aug 24, 2023 at 07:07:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.192 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 26 Aug 2023 17:05:50 +0000.
> Anything received after that time might be too late.
> 
[ ... ]

> Lang Yu <Lang.Yu@amd.com>
>     drm/amdgpu: install stub fence into potential unused fence pointers
> 

This patch is causing continuous log spam in chromeos-5.10, so we are
going to revert it.

WARNING: CPU: 1 PID: 13383 at include/linux/dma-fence.h:478 amdgpu_sync_keep_later+0x95/0xbd

This is just a note to let others know that this may be the cause
if they see the same problem.

Thanks,
Guenter
