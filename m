Received: from fhigh2-smtp.messagingengine.com (fhigh2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37703137760
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 09:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719998729; cv=none; b=Hz8K+72fpJQnFa+5qSmh60ZT4HXRu1vrih+sr9p0WT2OaRzmD9tuPw6FKPv5Ipm0cxtT+fjqxXQUcBpcrhPLKkuMoHDXV34nsdqbQ63R48hM4ZsAiVwTREt8GhGW0nGZ1Eps8d6NyQNac6aKmrK1AobfVqeEWa4dnbGK/KAZht4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719998729; c=relaxed/simple;
	bh=aNr5LsPPRXyZ7znURdhRpNzyLMqjsxePdNEZVumFhEU=;
	h=MIME-Version:Message-Id:In-Reply-To:References:Date:From:To:Cc:
	 Subject:Content-Type; b=U6f8ndX3sPh5Wj9Wm4YxcS8BWOByrqZEWVvt9VCh6nI1gvOyMMRBJv9MlKyMlkXQ7uPJcP8+vkEeDmrwGEZ0dzA5WO2INkafAbin25k8q+zQw26mqY3bXBRZr+VU+AnLDZnhrwviNxOJW/SGrkzsa/itCz6cu1rXg+IyXfDtMT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=Sgsbf1jU; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Yc3bWi7N; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="Sgsbf1jU";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Yc3bWi7N"
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailfhigh.nyi.internal (Postfix) with ESMTP id 4B1D111401BD;
	Wed,  3 Jul 2024 05:25:26 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute5.internal (MEProxy); Wed, 03 Jul 2024 05:25:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1719998726; x=1720085126; bh=1EJB48ZUHi
	VP/+yG3YT6uhk4ELVB4dHK9uYd0Uk+epE=; b=Sgsbf1jUQYfka50MHVgxqd+q2D
	kcYBPT8sp01BlFcXTSJXaO+mjt18ZKxFuWgl5h7rECS0PCPyQ+Jluvd8kWv3MPKg
	gtdEQHO2iKBG0J6KSbxlSlPf1bK08b7yXQIU7p2Jwp5HBN9+zADk+vu9SxefqAV8
	LsS+LurGs1s4scFaATOOVTx4exVjrqAZF28dkGT3DbkcnONXrtyk9llOFWMO7fIN
	d0TUAkkE0MaBfBAcqw0kE1POiGbWiuNleEWw/9Ts8+RrjvDSFY7YFPohZVXvCydz
	XrsivSi2wbuSozgCey5hEVTLTV3PmuOguorDTbqQxuPFmszmiRLwgZG7cTxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1719998726; x=1720085126; bh=1EJB48ZUHiVP/+yG3YT6uhk4ELVB
	4dHK9uYd0Uk+epE=; b=Yc3bWi7NdTkraAjJ8FMA5lSjqD5Z2hGaiiebRsmCpBL3
	DeCO068ll1kVnmJjmqEEkwpvxs/uw+mVBbBh+hQGgUaKhEW7jBl6xEy34wweNkhi
	8QR853g1O0lMyDTGGUP1lzsjxOhtNzP+79ayXhyNLQ6eYTRx+e6Pgy9V5CcKBg1C
	6BGUbpdagRuAQCVUtxbbv/T5oUU01+icDE6AZd9T1+mlef41VP4+vBg46dbjpwT2
	GWK5wdd3uIx+i+MKVamADA2nMWNJT02cKXRyJ27YiIfDHsp7o6kcyJYRlbOmfNzE
	mT5fxDU/UBjFC371EtnTlnMN/m7o4JHuJ7Hx8WSWDw==
X-ME-Sender: <xms:BRmFZhX_aF1opeOf99uk22W4aqlpGWuOato-W9EKGijR2l_Z5iJYVA>
    <xme:BRmFZhmWM8Db_N1ZHCTgHDClFBsg1CCSjuAWlEoCDHs7r2jbgRGhyhQbNlAEFJGgi
    Y88i_3RhXEzsnVa-BA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudejgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdetrhhn
    ugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtth
    gvrhhnpeelhfettdekkeeggffgvedvieehudeljeetkeefjedthedtjeejhfeiudetfffh
    hfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhlihhnrghrohdrohhrghdpthhugi
    hsuhhithgvrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:BRmFZta2PTPYw-PEyN6Sjhs2F35CDrVqgoeUpXuzwCrmMJTIS7sNGg>
    <xmx:BRmFZkWJtqmVjpbWcdZKqc0fOyVJDurPudSjU4d7KcsM6hfnCCdBbQ>
    <xmx:BRmFZrk07N8bf5Xpw592SB8deAhy5doXspuNhLQVHDonsCX-2KftCw>
    <xmx:BRmFZhdFYxhyoqFSZZUntYkIAKjM7StE0EwL0viU6M9UNPQiT8LGlA>
    <xmx:BhmFZl3JePpItb98l70bxngIR7NomNzkfm7NC_Xct4aI7Ghhvnc90BEP>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 1AAEDB6008D; Wed,  3 Jul 2024 05:25:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.11.0-alpha0-566-g3812ddbbc-fm-20240627.001-g3812ddbb
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Message-Id: <c440be12-3c22-4bb6-9a10-e3fd03b87974@app.fastmail.com>
In-Reply-To: 
 <CA+G9fYuK+dFrz3dcuUkxbP3R-5NUiSVNJ3tAcRc=Wn=Hs0C5ng@mail.gmail.com>
References: <20240702170243.963426416@linuxfoundation.org>
 <CA+G9fYuK+dFrz3dcuUkxbP3R-5NUiSVNJ3tAcRc=Wn=Hs0C5ng@mail.gmail.com>
Date: Wed, 03 Jul 2024 11:24:29 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Naresh Kamboju" <naresh.kamboju@linaro.org>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Guenter Roeck" <linux@roeck-us.net>, shuah <shuah@kernel.org>,
 patches@kernelci.org, lkft-triage@lists.linaro.org,
 "Pavel Machek" <pavel@denx.de>, "Jon Hunter" <jonathanh@nvidia.com>,
 "Florian Fainelli" <f.fainelli@gmail.com>,
 "Sudip Mukherjee" <sudipm.mukherjee@gmail.com>, srw@sladewatkins.net,
 rwarsow@gmx.de, "Conor Dooley" <conor@kernel.org>,
 Allen <allen.lkml@gmail.com>, "Mark Brown" <broonie@kernel.org>,
 linux-block <linux-block@vger.kernel.org>, "Jens Axboe" <axboe@kernel.dk>,
 "Dan Carpenter" <dan.carpenter@linaro.org>,
 "Anders Roxell" <anders.roxell@linaro.org>,
 "Can Guo" <quic_cang@quicinc.com>, "Ziqi Chen" <quic_ziqichen@quicinc.com>,
 "Bart Van Assche" <bvanassche@acm.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 6.9 000/222] 6.9.8-rc1 review
Content-Type: text/plain

On Wed, Jul 3, 2024, at 11:08, Naresh Kamboju wrote:
> On Tue, 2 Jul 2024 at 22:36, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 6.9.8 release.
>> There are 222 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.8-rc1.gz
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>
> The following kernel warning was noticed on arm64 Qualcomm db845c device while
> booting stable-rc 6.9.8-rc1.
>
> This is not always a reproducible warning.

I see that commit 77691af484e2 ("scsi: ufs: core: Quiesce request
queues before checking pending cmds") got backported, and
this adds direct calls to the function that warns, so this
is my first suspicion without having done a detailed analysis.

Adding everyone from that commit to Cc.

Naresh, could you try reverting that commit?

      Arnd

> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Boot log:
> ------
> [    0.000000] Linux version 6.9.8-rc1 (tuxmake@tuxmake) (Debian clang
> version 18.1.8 (++20240615103650+3b5b5c1ec4a3-1~exp1~20240615223815.136),
> Debian LLD 18.1.8) #1 SMP PREEMPT @1719942561
> [    0.000000] KASLR enabled
> [    0.000000] Machine model: Thundercomm Dragonboard 845c
> ...
> [    7.097994] ------------[ cut here ]------------
> [    7.097997] WARNING: CPU: 5 PID: 418 at block/blk-mq.c:262
> blk_mq_unquiesce_tagset (/builds/linux/block/blk-mq.c:295
> /builds/linux/block/blk-mq.c:297)
> [    7.098009] Modules linked in: drm_display_helper qcom_q6v5_mss
> camcc_sdm845 i2c_qcom_geni videobuf2_memops qcom_rng bluetooth
> videobuf2_common spi_geni_qcom qrtr gpi phy_qcom_qmp_usb aux_bridge
> stm_core slim_qcom_ngd_ctrl qcrypto phy_qcom_qmp_ufs cfg80211 rfkill
> icc_osm_l3 phy_qcom_qmp_pcie lmh ufs_qcom slimbus qcom_wdt
> pdr_interface llcc_qcom qcom_q6v5_pas(+) qcom_pil_info icc_bwmon
> qcom_q6v5 display_connector qcom_sysmon qcom_common drm_kms_helper
> qcom_glink_smem mdt_loader qmi_helpers drm backlight socinfo rmtfs_mem
> [    7.098062] Hardware name: Thundercomm Dragonboard 845c (DT)
> [    7.098064] Workqueue: devfreq_wq devfreq_monitor
> [    7.098071] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [    7.098074] pc : blk_mq_unquiesce_tagset
> (/builds/linux/block/blk-mq.c:295 /builds/linux/block/blk-mq.c:297)
> [    7.098077] lr : blk_mq_unquiesce_tagset
> (/builds/linux/block/blk-mq.c:262 /builds/linux/block/blk-mq.c:297)
> [    7.098080] sp : ffff8000812f3b40
> [    7.098081] x29: ffff8000812f3b40 x28: 00000000000f4240 x27: 20c49ba5e353f7cf
> [    7.098086] x26: 0000000000000000 x25: 0000000000000000 x24: ffff5bbe0a2e9910
> [    7.098089] x23: ffff5bbe01f1a170 x22: ffff5bbe0a2e9220 x21: 0000000000000000
> [    7.098093] x20: ffff5bbe0a2e9620 x19: ffff5bbe01f1a0e0 x18: 0000000000000002
> [    7.098096] x17: 0000000000000400 x16: 0000000000000400 x15: 00000000a63e566e
> [    7.098099] x14: 0000000000015eb9 x13: ffff8000812f0000 x12: ffff8000812f4000
> [    7.098103] x11: 7cea885bfc7e6700 x10: ffffb0c2e5eb69ac x9 : 0000000000000000
> [    7.098106] x8 : ffff5bbe0a2e9624 x7 : ffff5bbe0c828000 x6 : 0000000000000003
> [    7.098110] x5 : 00000000000009d3 x4 : 000000000000039e x3 : ffff8000812f3af0
> [    7.098113] x2 : ffff5bbe0a2acc00 x1 : 0000000000000000 x0 : 0000000000000000
> [    7.098117] Call trace:
> [    7.098118] blk_mq_unquiesce_tagset
> (/builds/linux/block/blk-mq.c:295 /builds/linux/block/blk-mq.c:297)
> [    7.098121] ufshcd_devfreq_scale
> (/builds/linux/drivers/ufs/core/ufshcd.c:2050
> /builds/linux/drivers/ufs/core/ufshcd.c:1426
> /builds/linux/drivers/ufs/core/ufshcd.c:1472)
> [    7.098126] ufshcd_devfreq_target
> (/builds/linux/drivers/ufs/core/ufshcd.c:1581)
> [    7.098129] devfreq_set_target (/builds/linux/drivers/devfreq/devfreq.c:364)
> [    7.098132] devfreq_update_target (/builds/linux/drivers/devfreq/devfreq.c:0)
> [    7.098134] devfreq_monitor (/builds/linux/drivers/devfreq/devfreq.c:461)
> [    7.098136] process_scheduled_works
> (/builds/linux/kernel/workqueue.c:3272
> /builds/linux/kernel/workqueue.c:3348)
> [    7.098141] worker_thread (/builds/linux/include/linux/list.h:373
> /builds/linux/kernel/workqueue.c:955
> /builds/linux/kernel/workqueue.c:3430)
> [    7.098143] kthread (/builds/linux/kernel/kthread.c:390)
> [    7.098146] ret_from_fork (/builds/linux/arch/arm64/kernel/entry.S:861)
> [    7.098150] ---[ end trace 0000000000000000 ]---
>
>
> Full boot log link:
>  - 
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.9.y/build/v6.9.7-223-g03247eed042d/testrun/24504400/suite/log-parser-boot/test/check-kernel-exception/log
>  - https://lkft.validation.linaro.org/scheduler/job/7711345#L5312
>
> Details of build and test environment:
>  - 
> https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2ihUJNrmztabOMpKVRNzLpixoUR
>
> Build, vmlinux, System.map and Image,
>  - 
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2ihUHH774XQWba653iwCVtCnpjl/
>
> metadata:
> -------
>   git_describe: v6.9.7-223-g03247eed042d
>   git_repo: 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git_sha: 03247eed042d6a770c3a2adaeed6b7b4a0f0b46c
>   kernel-config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2ihUHH774XQWba653iwCVtCnpjl/config
>   kernel_version: 6.9.8-rc1
>   toolchain: clang-18
>   build-url: 
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2ihUHH774XQWba653iwCVtCnpjl/
>   build_name: clang-18-lkftconfig
>
> --
> Linaro LKFT
> https://lkft.linaro.org
