Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA6A13BAE2
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 09:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719997749; cv=none; b=DDafxC+DPyQJthPpYDK7yovosfghal/nch5QyVRsb7CaGAB8iBkq5VVi7JQosI+I1H48iy0T3KlXVXI7Y/TEdkC2TAZUDiZ1Nyp9uiGC62rkr9d1yRKuR6+C6PT8+v/DaF5pWw1GqLFV3MSXC9VwKwKomzQ7rauiNzNhTbrhFdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719997749; c=relaxed/simple;
	bh=Q+dDCEE0NYhW9N7macndPjBmHx3DgdcFCWy5QsBxmbA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m31s8HGxLg7ld3bWyZc2kwm9pAaAU4w/w4RBNw7XqEbkd1PT3cbv7CgMoKXAmOtGiEvdJK05hVvB8ecVvOwkzTZftFWKNPUeNwQQrxjJw/rDbiHGfGIoPGVAFO8cgMN3TmbYgRxCAtdXxD7QcjhNkoyFkNyR237GuCnutG6cIzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qdhq7h7L; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qdhq7h7L"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-4f2aa6916e2so1410761e0c.3
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 02:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1719997747; x=1720602547; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J4/FsZ/Xgm2yNtP4JlZEMSDNR2rIdHMnZ1HyaIZt/z4=;
        b=qdhq7h7L1NN0sO8NSTrp3oQ4nPRO6MaLHM1pWb6dPa1r6R2lmmWk3Vq8mj9b7lTYG4
         INfxZkw2qzj57IdRa8VqrY6VB80doBxgh6yqbJzZVoy283qV/VTKIOUgf8kR/VcONbJt
         5xsz5L1HJ1AiZHlUc/2KBVxkKvi9lxJlOv7A06XHyW1UMofuqiJG+rYFKIl4cwxJxCh/
         9DTXWr76+SJDKqVwfyNH7NYrMPf9eJZZXxbE92pKmILWnDePkjJowh9TBoJZVAGHbQtO
         0+DEUYKYHY9FcK+0u4VmBlufH/YBpTGgkjO/emblqvC2LLR5v0WzL0m2oeW3mbP0a66T
         FVgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719997747; x=1720602547;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J4/FsZ/Xgm2yNtP4JlZEMSDNR2rIdHMnZ1HyaIZt/z4=;
        b=eIYmwdsbVdwOXVIJahjoZGZRVwqv9YhHYBuE+PXTYb17B1U7JeJu4FPd7JMlyeMJRf
         XFLZ3etVGbtKkbZFfdYrGjj+FUIgtmAGTPUF0lHeqRCZM5B68PCWIep3IvYuvZct3Qaw
         9+r4/Xd6TMgwZWdT/nwHbqwVKbJzy2rYaiw7VX8VBItliF3ULjX/tKIn/PnGh1pdwcFN
         veG+OMicwGLBNtNp/Nxx0Su6zrd++HGWKlGdzYM/FmYHe5mtATEyy+bVKHncFrvUEtSd
         SQS3lpKBE2qOGn7u3kmJFmD8i+FBuwlnOaWBNnYhMLKeRal5gKCFPpL++keht4ldNTHV
         /mcg==
X-Forwarded-Encrypted: i=1; AJvYcCXXE4JzG1g1ldwVx543gkLIBNTBkfcAsDSpjbIXa1jVrWStCa3/UwjyobOPsoHSca5+hsTlqYPQ8P/Hj7omOExvSBd8r6bGiQ==
X-Gm-Message-State: AOJu0YyAClcZ31G3ekMlapmywtKpnw3FrJ2cfRq43dBIY5Rv7r6W8eJ4
	7+3wLgHt38++UloOzMq9TP5+7WVReuZyLJTlmjKewTGOpUF2Lm/0jGKqBCfm26PSZUM07/a68Wl
	MH9XYZObyp9HK0rnXX+wKW3d614cQYNI/LJXQvQ==
X-Google-Smtp-Source: AGHT+IEvzMVTDQNBm4Nvho/bpAhQY9ss01kyvGkjiUkFUnpYA7JCZ5VK1Wb7L+EhxuFg9hFGCFIvApzy1MN/du+FGCk=
X-Received: by 2002:a05:6122:4a84:b0:4ef:280f:96ea with SMTP id
 71dfb90a1353d-4f2a565fb52mr12589732e0c.4.1719997745649; Wed, 03 Jul 2024
 02:09:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240702170243.963426416@linuxfoundation.org>
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Jul 2024 14:38:54 +0530
Message-ID: <CA+G9fYuK+dFrz3dcuUkxbP3R-5NUiSVNJ3tAcRc=Wn=Hs0C5ng@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/222] 6.9.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, linux-block <linux-block@vger.kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Jul 2024 at 22:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.9.8 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

The following kernel warning was noticed on arm64 Qualcomm db845c device while
booting stable-rc 6.9.8-rc1.

This is not always a reproducible warning.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Boot log:
------
[    0.000000] Linux version 6.9.8-rc1 (tuxmake@tuxmake) (Debian clang
version 18.1.8 (++20240615103650+3b5b5c1ec4a3-1~exp1~20240615223815.136),
Debian LLD 18.1.8) #1 SMP PREEMPT @1719942561
[    0.000000] KASLR enabled
[    0.000000] Machine model: Thundercomm Dragonboard 845c
...
[    7.097994] ------------[ cut here ]------------
[    7.097997] WARNING: CPU: 5 PID: 418 at block/blk-mq.c:262
blk_mq_unquiesce_tagset (/builds/linux/block/blk-mq.c:295
/builds/linux/block/blk-mq.c:297)
[    7.098009] Modules linked in: drm_display_helper qcom_q6v5_mss
camcc_sdm845 i2c_qcom_geni videobuf2_memops qcom_rng bluetooth
videobuf2_common spi_geni_qcom qrtr gpi phy_qcom_qmp_usb aux_bridge
stm_core slim_qcom_ngd_ctrl qcrypto phy_qcom_qmp_ufs cfg80211 rfkill
icc_osm_l3 phy_qcom_qmp_pcie lmh ufs_qcom slimbus qcom_wdt
pdr_interface llcc_qcom qcom_q6v5_pas(+) qcom_pil_info icc_bwmon
qcom_q6v5 display_connector qcom_sysmon qcom_common drm_kms_helper
qcom_glink_smem mdt_loader qmi_helpers drm backlight socinfo rmtfs_mem
[    7.098062] Hardware name: Thundercomm Dragonboard 845c (DT)
[    7.098064] Workqueue: devfreq_wq devfreq_monitor
[    7.098071] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    7.098074] pc : blk_mq_unquiesce_tagset
(/builds/linux/block/blk-mq.c:295 /builds/linux/block/blk-mq.c:297)
[    7.098077] lr : blk_mq_unquiesce_tagset
(/builds/linux/block/blk-mq.c:262 /builds/linux/block/blk-mq.c:297)
[    7.098080] sp : ffff8000812f3b40
[    7.098081] x29: ffff8000812f3b40 x28: 00000000000f4240 x27: 20c49ba5e353f7cf
[    7.098086] x26: 0000000000000000 x25: 0000000000000000 x24: ffff5bbe0a2e9910
[    7.098089] x23: ffff5bbe01f1a170 x22: ffff5bbe0a2e9220 x21: 0000000000000000
[    7.098093] x20: ffff5bbe0a2e9620 x19: ffff5bbe01f1a0e0 x18: 0000000000000002
[    7.098096] x17: 0000000000000400 x16: 0000000000000400 x15: 00000000a63e566e
[    7.098099] x14: 0000000000015eb9 x13: ffff8000812f0000 x12: ffff8000812f4000
[    7.098103] x11: 7cea885bfc7e6700 x10: ffffb0c2e5eb69ac x9 : 0000000000000000
[    7.098106] x8 : ffff5bbe0a2e9624 x7 : ffff5bbe0c828000 x6 : 0000000000000003
[    7.098110] x5 : 00000000000009d3 x4 : 000000000000039e x3 : ffff8000812f3af0
[    7.098113] x2 : ffff5bbe0a2acc00 x1 : 0000000000000000 x0 : 0000000000000000
[    7.098117] Call trace:
[    7.098118] blk_mq_unquiesce_tagset
(/builds/linux/block/blk-mq.c:295 /builds/linux/block/blk-mq.c:297)
[    7.098121] ufshcd_devfreq_scale
(/builds/linux/drivers/ufs/core/ufshcd.c:2050
/builds/linux/drivers/ufs/core/ufshcd.c:1426
/builds/linux/drivers/ufs/core/ufshcd.c:1472)
[    7.098126] ufshcd_devfreq_target
(/builds/linux/drivers/ufs/core/ufshcd.c:1581)
[    7.098129] devfreq_set_target (/builds/linux/drivers/devfreq/devfreq.c:364)
[    7.098132] devfreq_update_target (/builds/linux/drivers/devfreq/devfreq.c:0)
[    7.098134] devfreq_monitor (/builds/linux/drivers/devfreq/devfreq.c:461)
[    7.098136] process_scheduled_works
(/builds/linux/kernel/workqueue.c:3272
/builds/linux/kernel/workqueue.c:3348)
[    7.098141] worker_thread (/builds/linux/include/linux/list.h:373
/builds/linux/kernel/workqueue.c:955
/builds/linux/kernel/workqueue.c:3430)
[    7.098143] kthread (/builds/linux/kernel/kthread.c:390)
[    7.098146] ret_from_fork (/builds/linux/arch/arm64/kernel/entry.S:861)
[    7.098150] ---[ end trace 0000000000000000 ]---


Full boot log link:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.9.y/build/v6.9.7-223-g03247eed042d/testrun/24504400/suite/log-parser-boot/test/check-kernel-exception/log
 - https://lkft.validation.linaro.org/scheduler/job/7711345#L5312

Details of build and test environment:
 - https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2ihUJNrmztabOMpKVRNzLpixoUR

Build, vmlinux, System.map and Image,
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2ihUHH774XQWba653iwCVtCnpjl/

metadata:
-------
  git_describe: v6.9.7-223-g03247eed042d
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_sha: 03247eed042d6a770c3a2adaeed6b7b4a0f0b46c
  kernel-config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2ihUHH774XQWba653iwCVtCnpjl/config
  kernel_version: 6.9.8-rc1
  toolchain: clang-18
  build-url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2ihUHH774XQWba653iwCVtCnpjl/
  build_name: clang-18-lkftconfig

--
Linaro LKFT
https://lkft.linaro.org
