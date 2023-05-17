Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADD417E0
	for <patches@lists.linux.dev>; Wed, 17 May 2023 03:52:16 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-24e09b4153eso304544a91.2
        for <patches@lists.linux.dev>; Tue, 16 May 2023 20:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684295536; x=1686887536;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AUXFRmo2MSjUiP3pz0lzOFDLD9CCDZHx5JZ6kXK49MA=;
        b=YTS0qcj/hG4UhEBJb3/I8+r3muMeN3UAkFTzlWc4pOy86nF2hlfHA7HHcNw0QA7WdU
         ysiWX5b8G7mWmzoet7jUv0bFKWPXaFJCHGreU3hWRcOHCJ91BupPc//853th0Mt1i532
         qPVklvWPJCLhju91sHhOKM0X9nff7OeDHtkF66UZ29B5Evjc+jmIXfyoqPHMdDShJ3BQ
         ZHYT50y+Y8kahR3mv8MVczj1df2eQup+P8Y/Dbss7EWF7wkJWVFSve4Qw47huUc9Zif2
         We61ylGUJVMi4FZGqwYlGVTiwjh33TAlQiujlpl/9sUV7YLcaMxo4EeSI5ailX3IuKHP
         Wdsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684295536; x=1686887536;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AUXFRmo2MSjUiP3pz0lzOFDLD9CCDZHx5JZ6kXK49MA=;
        b=XTnl4/vf7eiwcs10IUVXJrfuRIpdZmSG1NjF5iIPpyMpohsu0W6JLgShq6lu6S5cor
         ++WusKrmVqKLUivL9R1p8Eb9//q3lIzM3Y0nYULY1xjInjl5ibVhyA2NAuOsh/WgfV5p
         mWJ3LU5SSGMS7El280NpFnmwstVB8ZClSelK1841G+gzDl6pJtYVCWbrAjcIYTNtpvlk
         LWhukPCIbtb+fGyVfN93XS4LSipjMDf996sq0ilTcBwlyQRGJwSV+7eL3yZr2XULDyPH
         pDmT854NBIpPeFojoSqMpOjm4zeVdd16kSz00HHdRiD5yoXHrA+VERGhnTUSDi1GFyUW
         bkJQ==
X-Gm-Message-State: AC+VfDz5yAftyAsxuSLcROf1tnpdhk9ycNaXhW9YBJKQm5J13bwwIkI0
	xLDffNX4lB8IZk2P5Sn6Ka4=
X-Google-Smtp-Source: ACHHUZ5FxCBS+0YcXJo3FhDTsN4EFNwO8RkcXyTXtu4z6LvH4lM5z60eFxhe/fPZQebwejl0so7hAg==
X-Received: by 2002:a17:90b:350:b0:250:1905:ae78 with SMTP id fh16-20020a17090b035000b002501905ae78mr39147491pjb.15.1684295535825;
        Tue, 16 May 2023 20:52:15 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t17-20020a639551000000b00519c3475f21sm14303276pgn.46.2023.05.16.20.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 20:52:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Tue, 16 May 2023 20:52:13 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/282] 5.4.243-rc1 review
Message-ID: <739bd109-b32d-46f1-b382-e55f34efc11a@roeck-us.net>
References: <20230515161722.146344674@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>

On Mon, May 15, 2023 at 06:26:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.243 release.
> There are 282 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 455 pass: 454 fail: 1
Failed tests:
	arm:sabrelite:multi_v7_defconfig:mtd2:mem256:net,default:imx6dl-sabrelite:rootfs

As far as I can see, the second SPI interface fails to instantiate.

[   21.491528] spi_imx 2008000.spi: bitbang start failed with -22

There are also various new warnings in clock code.

[   21.492631] WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:986 clk_core_disable+0x124/0x2e4
[   21.497524] WARNING: CPU: 0 PID: 1 at drivers/clk/clk.c:845 clk_core_unprepare+0x268/0x388

The warnings in clock code are gone after reverting all changes introducing
PM support for imx spi code. The boot failure is gone after reverting the
gpio conversion. In total, I reverted the following patches to fix the
boot and warning problems.

d6fcaa127cc6 Revert "spi: imx/fsl-lpspi: Convert to GPIO descriptors"
9783b21b591d Revert "spi: imx: enable runtime pm support"
4a8bdbf7462b Revert "spi: spi-imx: using pm_runtime_resume_and_get instead of pm_runtime_get_sync"
e6c5f497ff35 Revert "spi: imx: Don't skip cleanup in remove's error path"
d6ea758df74f Revert "spi: imx: fix runtime pm support for !CONFIG_PM"
b9dbd028c970 Revert "spi: imx: fix reference leak in two imx operations"

Is this really 5.4 material ?

Guenter
