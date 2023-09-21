Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2BE20E7
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 15:53:51 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-77ac14ff51bso43944339f.3
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 08:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695311631; x=1695916431; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QjTezTynTvqJlvf69zSKAa6dTWaidBbob/xaqQEVHUE=;
        b=X78GOP/Ir1bmgf5C6tIDKQDyzi7sA6paSFgtvSXO95lfyee9URwiVprbvMaKbjGKdu
         jFfmHi1ITmwxwoZ2+Yz9W+oJmJqNxDVgk6vds/0rIV52FYh3WHokZ9MS5Z92A9p9iyt7
         e0k+lWZ+5+G5VcqNJGyA13bjPX2sY0it3evDaKdRdIW/oFnGVcF7YLlj3dMtiOfKw2W6
         JkGLym5i4jkqOB4iUM21i9bOz4m3amV38jBxZ9g8xZ/DfYScncTTieMrdBBHE9YKq7Co
         uMkutkm0Ws0IqCtjElET9Wib7Lq6iHvxhJUBqxiofq9QYbQaND60PXlsebulswNFNDrH
         UY6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695311631; x=1695916431;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QjTezTynTvqJlvf69zSKAa6dTWaidBbob/xaqQEVHUE=;
        b=GudrkggZp4aQqAq3eyCV2kzTzfGinKsOw+sd/k6RgnoxYtNUhvw8kDDKJMmjFRDjDd
         NpYvtV8uvtuqJnm0MVjvQijP3UTXBn5ue3iAF32AeClOK2qvr7Xx/qLKBpJeiix5dPfN
         iqKwoMEh0QccYu7h4yqFnzy9LJzHvz2sYkP9eg5iyad76NG76At1/xCyG6uEzuDpZfKz
         V8tX76l90SuJ1asK0XAagBRx1VsWCujG9yxKhEAc0TEkXeo7WAX1jovSdQsfvh1ZqI9U
         1DlQ+QEeWwnjc5nBR6Xh+1apvGwO+go+Fp7GByechpzVPJ3bk3ptbnmt67Kg9Ypp7aEa
         eyew==
X-Gm-Message-State: AOJu0YxAhgdok0QU3+o8/nhmCJXBvXNWOt2D3UfXLBDlduvT2SjpvJR2
	I0kGTWLoI8T/ecGDPX/O+V4=
X-Google-Smtp-Source: AGHT+IEpYwsuhBNIwJEQqvsb//9rTopvYqrIvT5z0atK2g87iYx/Y8K7JfQni2Qb84qM7j9BUqJf6g==
X-Received: by 2002:a05:6e02:16c8:b0:34f:525d:198 with SMTP id 8-20020a056e0216c800b0034f525d0198mr7618097ilx.13.1695311631254;
        Thu, 21 Sep 2023 08:53:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c9-20020a02a609000000b0042b279bb086sm450069jam.66.2023.09.21.08.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 08:53:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Thu, 21 Sep 2023 08:53:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 000/273] 4.19.295-rc1 review
Message-ID: <c090d70e-ed2a-46e4-ac92-217fddbe07fc@roeck-us.net>
References: <20230920112846.440597133@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>

On Wed, Sep 20, 2023 at 01:27:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.295 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 149 pass: 147 fail: 2
Failed builds:
	arm:allmodconfig
	arm:imx_v6_v7_defconfig
Qemu test results:
	total: 441 pass: 434 fail: 7
Failed tests:
	arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:mem256:net=nic:net=nic:imx6ul-14x14-evk:initrd
	arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:sd:mem256:net=nic:net=nic:imx6ul-14x14-evk:ext2
	arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:usb0:mem256:net=nic:net=nic:imx6ul-14x14-evk:ext2
	arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:usb1:mem256:net=nic:net=nic:imx6ul-14x14-evk:ext2
	arm:mcimx7d-sabre:imx_v6_v7_defconfig:nodrm:mem256:net=nic:imx7d-sdb:initrd
	arm:mcimx7d-sabre:imx_v6_v7_defconfig:nodrm:usb1:mem256:net=nic:imx7d-sdb:ext2
	arm:mcimx7d-sabre:imx_v6_v7_defconfig:nodrm:sd:mem256:net=nic:imx7d-sdb:ext2

drivers/pci/controller/dwc/pci-imx6.c:645:10: error: 'const struct dw_pcie_host_ops' has no member named 'host_deinit'
drivers/pci/controller/dwc/pci-imx6.c:645:24: error: 'imx6_pcie_host_exit' undeclared here

Guenter
