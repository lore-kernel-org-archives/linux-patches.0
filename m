Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596487B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 03:27:14 +0000 (UTC)
Received: by mail-oo1-f47.google.com with SMTP id bd3-20020a4aee03000000b00517affa07c0so1084956oob.7
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 19:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678505233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IRQjTFtZ94OO6AEc5izEppuaCdMJD6xuPyl+zIKdfW0=;
        b=qZ3+51ZkMcXkaOHg75zJzQUFCG2CdbVufZt+1EzJOKfWIsabcrq10X+BVt3yOmD+rL
         bZLwRSBwwHca7UYHRve/fBHPpMKi8wpsnmZd4RfEa0Up9Mx5tWO9IIAHs0zbRlc5UCPf
         Cyt30eYc559eRwiOgPBrpA6I8gfZTqNwbdmbdtiJMX8TV2Y+WxhEne1z0wjwjV9iJhqA
         EIwDHuyfJSpRCWkBDUqyXPI+2BZu8j6UmaTEzPXQr+CI4jEoBi7HWIrJqLVglg3WDLyS
         H02B0e9VK0N1bRLCdTrw++7klmC7M61fEXcvek3EixfB04ut+3iOdkEVOzLWWSE7ZtQq
         4lAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678505233;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IRQjTFtZ94OO6AEc5izEppuaCdMJD6xuPyl+zIKdfW0=;
        b=ppvUNjyXi5KyiiKVDXu8u1X5Ay0DwMYz3FzwhaFbqntX4ev7VaFGmd62HbnsLv428c
         ED1kZJuAIWhvEgLvZCwuKOfvnvht7g6XBADk0A7Krz/uzZOuFfaBJvgQN/Yc15Agdk4X
         qnDqOK+UIZLqdzFFi4xa2OznovprnOzLtGj1+0HqXyTR7j8egrNPALRxFD4tAqhWu/3N
         6WlqjIP0bAWZPfK6WZixh8aS9dx0YvvDd7fG/Yu9+u1+096zleMgbGuGd+QRAlTwhdCq
         2u4vjUnXIAPkpIyBGaNL1xpKbG4/ihP27ZpsUYdZLiP90UiyZQ3VwMFidX5exW6MvGiD
         iK/Q==
X-Gm-Message-State: AO0yUKW/DWD3xl048Qkq+l2SZoIRPoAX6q+McE78jVLyY+1KKgcvf+Ny
	7zoiN88vsD3hCbibLLZBVA0=
X-Google-Smtp-Source: AK7set/b/h7yPTGgW+JptrAuYIikQROxM33Mewn9h4AMhQ77jAlxlj5swvFy36v1sw4RTl5ZJUDivQ==
X-Received: by 2002:a05:6820:123:b0:525:2e75:a615 with SMTP id i3-20020a056820012300b005252e75a615mr11455263ood.8.1678505233488;
        Fri, 10 Mar 2023 19:27:13 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c26-20020a4ad8da000000b004c60069d1fbsm663982oov.11.2023.03.10.19.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:27:13 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 10 Mar 2023 19:27:12 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/357] 5.4.235-rc1 review
Message-ID: <69d8df8c-4da3-481d-8731-09320882a75a@roeck-us.net>
References: <20230310133733.973883071@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>

On Fri, Mar 10, 2023 at 02:34:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.235 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 157 fail: 2
Failed builds:
	s390:defconfig
	s390:allmodconfig
Qemu test results:
	total: 455 pass: 450 fail: 5
Failed tests:
	s390:defconfig:nolocktests:smp2:net,default:initrd
	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs

Failures as already reported.

Guenter
