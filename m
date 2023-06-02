Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E238E8801
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 22:35:14 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-650a9ba426fso2446786b3a.1
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 15:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685745314; x=1688337314;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BLJK6B/t+AAazpXMbTyXCw5/1FSBnILSO8TGv60LISA=;
        b=X2Y9WRhRev8Mer+bWy4/ZXO+UBVfEXhpIgg4tDk1mymCLoW/95KNZg3BmwPNEfuEnB
         XaDgyiRQqwDmtimavdXYrY10RqtThR3V5lORoFcOp/p9pwlh/W0GZNjLZfMaXKh0KrfL
         YWg3MQtalqplVXoc0GooswVQkQxbjNblNyk/GiNjuGdDCN3Dm+94kB/Z9J8+DrRqU7YC
         8Zy0AQdoBaEKjzzvugXLKO8ytogmyRJ1SG8XDBxn1u1VEgwsx9WvyFcY7sg/Yft7CggO
         DvDzDS6Bzmm+dZTXYjxDrQOnXpQPBIRLoxRQZSlH1El0cVG4EeKOqVIwk+Zud5FGJ4A6
         FVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685745314; x=1688337314;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BLJK6B/t+AAazpXMbTyXCw5/1FSBnILSO8TGv60LISA=;
        b=Qw6Y4eBckUFqMu9tZVfVEzvRiQCZO5uYbc0DXBqfo6lijeGuuHPjV4sakZ76bfw1zz
         LlUKQkHo5XqNuCCmXKI0/paYEb41pJyyQtgI/AaE9ovnbDGUdSfNlHrPhgMrW6B+nCF9
         5TYZGX/5p57/7EgdbOkZB6xA2WpJvEHv2uKGZzCPOsSRq/X4ow6YF2EomT80SuZ6e5vy
         GV91Hy1SxvzZnPXjrWrXz2a4WoZzHQEtDpjQgRaGOa3FuHiCBSaVmkJ8wecirViklplZ
         +Q3pttuI4woXbGuQoI5fFOXiXzuNkDS/3odH69Fcuw6PjOUWBWgI1ZGytSOxhPRXIrUZ
         t8dg==
X-Gm-Message-State: AC+VfDwwJcPzBgqR3DXpbxSwbTUrdQJFSzrHwVmGn8qU/Nf4nDRnFCq+
	ICeJU/DzCbqdLYs9GG20qCI=
X-Google-Smtp-Source: ACHHUZ69DuAaHeEdVPpsfXXv7jhZr6QdUIa8tsksClAfXzsW/LwuseadU7HpvVOWHIDoOiZiBd/i+w==
X-Received: by 2002:a05:6a20:4293:b0:d5:73ad:87c2 with SMTP id o19-20020a056a20429300b000d573ad87c2mr14415696pzj.56.1685745314173;
        Fri, 02 Jun 2023 15:35:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y5-20020a63ce05000000b005346b9a7fe5sm1723201pgf.22.2023.06.02.15.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 15:35:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 2 Jun 2023 15:35:12 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.115-rc2 review
Message-ID: <fb6afe92-efe8-4bd9-86b7-879e2b5cc80c@roeck-us.net>
References: <20230601143331.405588582@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601143331.405588582@linuxfoundation.org>

On Thu, Jun 01, 2023 at 03:36:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.115 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 14:33:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 158 fail: 2
Failed builds:
	s390:defconfig
	s390:allmodconfig
Qemu test results:
	total: 499 pass: 494 fail: 5
Failed tests:
	s390:defconfig:nolocktests:smp2:net,default:initrd
	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs

Failures as already reported by others.

Guenter
