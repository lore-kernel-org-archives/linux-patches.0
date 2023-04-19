Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A8717D4
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 03:39:46 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1a50cb65c92so30712165ad.0
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 20:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681875586; x=1684467586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lCMyUIkSESOlhZx4cSCMuxrtlv3+z5on7gThiRJtPRk=;
        b=JCeUKqdLjpiwkKPZHnaog2PoakuyxE03eb31a/EyI7ltPNpggCaUJslmG1VoQQmadD
         aDuFMSGNBMFVYUIfzr29rYKh9Vcae8Wi6pCDV5pOadaHEJLLIEoxZpA3ewHtKSx1s9Aq
         CFMYrXhCsVM93MTO5fHIvFqlgkgyr+jowjRrasEUxF5pMCFMiYm+KwdvABd5++8BVn23
         X91NvwjjOPwDbW/WJB+O/3ygWeDLq5TOu+42FzkURfgQS3/zpBQ6MAknjZmPk0+l62yM
         5ZzZWElw86n97nGME4AtuCifO8iMO5F0JQBTZFyIH4poVRRdFRx9C5MindNOnXrUbL4v
         BzvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681875586; x=1684467586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lCMyUIkSESOlhZx4cSCMuxrtlv3+z5on7gThiRJtPRk=;
        b=bOeb8knEp9MOgbO7v+QcFCAobBRfn/7a8yNcicRRMW/wbAui+ygsaWD/9ztwCj/ZJb
         CxAvv1M5qgq3tgTLymqYWhB8a8akMlqt6B5a738SYLPi19NIH3l/sdT8Bxh/JxyS2fZ7
         uh1Cn+ICPfYEBtIB9JNfqsG29ne7FGotkzRkGfyvu+Q0QUcMRb/a9uBpc7oLm3S0FB33
         IetxIQMWQxYyfidQdD38sPGS4sPPRxlZWFW4PdS2Op97zN0cAfHQyFmCjw0ncarFAaVk
         SI6Ln61wizH1GlEHWdQlO0VPhmdYIYrpfva1rLihbEAb3Hl2gv4yAKXVZkBSDbC7wR3q
         956A==
X-Gm-Message-State: AAQBX9dQfMddV98R4NQ9KC7szELvFo/pAdCcc3G49d1ukYKOTCK1KvVf
	QjNrsKA9c3BvR5Qya4biM4k=
X-Google-Smtp-Source: AKy350alzAQ1tk3cE3nGnmYS3QnMmTPe+MoJYsB8Rc6bkccmvKe7LoWQWcsuM1cBEJmsKqNTYXzeDQ==
X-Received: by 2002:a17:902:cad5:b0:1a6:9794:a4 with SMTP id y21-20020a170902cad500b001a6979400a4mr3112233pld.63.1681875585754;
        Tue, 18 Apr 2023 20:39:45 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id jw19-20020a170903279300b0019f3cc463absm10384893plb.0.2023.04.18.20.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 20:39:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 18 Apr 2023 20:39:44 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/124] 5.10.178-rc1 review
Message-ID: <ad99f18a-6cb3-4187-99ed-40128bb8e98a@roeck-us.net>
References: <20230418120309.539243408@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>

On Tue, Apr 18, 2023 at 02:20:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.178 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 162 pass: 148 fail: 14
Failed builds:
	alpha:allmodconfig
	arm:omap2plus_defconfig
	arm:vexpress_defconfig
	arm64:defconfig
	i386:defconfig
	ia64:defconfig
	mips:defconfig
	parisc:allmodconfig
	parisc64:generic-64bit_defconfig
	powerpc:defconfig
	powerpc:ppc64e_defconfig
	powerpc:cell_defconfig
	s390:defconfig
	x86_64:defconfig
Qemu test results:
	total: 485 pass: 477 fail: 8
Failed tests:
	mipsel64:64r6el_defconfig:notests:nonet:smp:ide:hd
	mipsel64:64r6el_defconfig:notests:nonet:smp:ide:hd
	mipsel64:64r6el_defconfig:notests:nonet:smp:ide:cd
	s390:defconfig:nolocktests:smp2:net,default:initrd
	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs

Caused by:

kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared

Guenter
