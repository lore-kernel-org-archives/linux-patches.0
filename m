Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0759E322A30
	for <patches@lists.linux.dev>; Mon, 22 Dec 2025 18:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766427065; cv=none; b=dAOieix/XAt+jSN0pm+XrBrulON4Sfk0XYzfAVlDK7+WD7gUUCUQJbknuS2b8LJ094FmjHrY1waa0cCiKw3N9ZccOseE7Pya8dn4KelHyaCjhVzoZEoKAFO9ZsesccyLMycbFpovbyUNY8+SkkP/oR3osB83dfxTXs3RR9d91aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766427065; c=relaxed/simple;
	bh=0WUgzmFj2g6mXyUMyOklDH/yf1t3DLZeKp6bYlEtRcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K7eIxt0Lh3bkNMsy12skjNVBkS/A4cee6GhhkYAkpNd3fKi6O833PCC8OMcbFjxq3iFvYB2QhBzhT3Ne0fFoLIRR/SdBremZ2T+zI9EXsIJxSjiqP5NGzqE9pCcPXUuB3mNRcXLYGjJzl91sPKyLAOsd/rtXXLqXsrt4HcSwJG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kETNOpxM; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kETNOpxM"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b8e49d8b35so5154835b3a.3
        for <patches@lists.linux.dev>; Mon, 22 Dec 2025 10:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766427063; x=1767031863; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iVr+W08/gkAe0aMwVz9OuqZ0vaSf4KgRfnQxdMq0bj4=;
        b=kETNOpxMkBGfhcfCggQ6izPjFYIf7iwAKrUBTPUL1k8VPrgcohWgIVhLeCbFH8vhMr
         iHttXEzROmTnkPSw9uzUAOkv//Zph7r7tKreEvCWuhdxzUBzdPlPtAds9FzadMpX2t1q
         oqNJ4jpS7w7UAYuySzyrfeebyDsK95sO+15kh2qtH5V/9D+bAj32L+7VmPdyOgTJd5AW
         uK9+tpVAFn/Zlih9JCukmrfnpegGTljnMrw/XSVRLUeQX4y8p4K2s+EodBpJJT3eeWXv
         xgLN8rn6hYWPaqyPeAI9fDIL8XhON3TSlF/WIgNYaM1HRZLiZxOF5ySccIOG9GvaJIG+
         O0Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766427063; x=1767031863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iVr+W08/gkAe0aMwVz9OuqZ0vaSf4KgRfnQxdMq0bj4=;
        b=Ye8QpD9Tb8VWLit5a5WmqH/hk+z5g8jtaa1169I/2ZztkDb4pQpDU0paQj0gMTScl2
         Oc6tkS2UW9NemnKb+DKEMuxndf+UMONsQU7j3Tr3FJ2QImTAdhTRMoGmAMCVUAkOYyKa
         56psGd1CYiJT0HsdZGDEFICH8ro6f7hKwhkKnx1xxOIdazSnj+ey3nWQtZWny0xTtiy4
         IBRkF5U+sjoByRsJRZDrl6NPlqfk7hFOo5Fq9yMd9ugZW+c7xZarzzH6bHts4FaunHoZ
         4PYNxfRW0GODSut1UlQcibGXzBjh5A0+1sOk3ZRzlo76YmBrgkKUgvB+RG/h+y33AzVV
         nN6g==
X-Forwarded-Encrypted: i=1; AJvYcCVXR0loJIR5El1WTpMIhQJsHu50z1lIW8apMQlFK2nF2bifxamXTp16mZAzhKcPdBDzeeNviewP@lists.linux.dev
X-Gm-Message-State: AOJu0YwrVxGGHrkCEK6LWa+tquez9LYYomIz+Oq2Lfnva9JxowdI5QqW
	mIDSmJeFNwxzwzlrIOJy1RTtBLmBqMC+5lOW50WtVZ6ZJ/insRqKPXBuOA8mLg==
X-Gm-Gg: AY/fxX4hm9PpT6A3BcPdPK9eO3JZkr/3W/cFhICxLRx4F8pNEt9190g+ubQZOttd8id
	KyUlf57wS8nVYFHD721XGelPSgdsQryE+WNJ/wuXgJZqq1eFXceDUbxCKqzgTGG/QFYoN6aGVZC
	R9r5iDqonRkSAybKUrbomgrF9bLzAof2yU4sVrWStuDSMLjIsk5BM1LeaX+QBNYA2JWBznVazVx
	r84cHnn1YZm9TEhlOQg6YkqKyle5cIaiSxNS9t/wCW2XFvNpShm8GRw01GEcvzZEKDut4BJ1DZJ
	gHvPKOqmgxgwj8x7JQhVsTgZhggACiv0NI04FY8GrnpVoXKyGLG1HEMGjmwSSg/YIMoaF/zvRRu
	2gm8cZxeYHXv1t12hy/5NF9WZOtiXGdMv22X1MKFpF0tZSLrMah0RbnHriq+WX9PznoA9Zzw48H
	M3/Si05veGw4LoSZpkhePjpTm+xoOxPpOV7u2wzJLVhgxhIgb4
X-Google-Smtp-Source: AGHT+IFHta1BothcW1/+tFYc400gy/F634D3LW840Kf9vrd1sA0CB3zGQffc3Tc8iWNt7LeYjkExLg==
X-Received: by 2002:a05:6a00:440f:b0:7f7:3c4f:9407 with SMTP id d2e1a72fcca58-7ff657a4b27mr10430920b3a.26.1766427063194;
        Mon, 22 Dec 2025 10:11:03 -0800 (PST)
Received: from deb-101020-bm01.eng.stellus.in ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a843ee4sm11230244b3a.10.2025.12.22.10.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 10:11:02 -0800 (PST)
Date: Mon, 22 Dec 2025 18:11:01 +0000
From: Swarna Prabhu <sw.prabhu6@gmail.com>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>,
	"kernel@pankajraghav.com" <kernel@pankajraghav.com>,
	Chaitanya Kulkarni <kch@nvidia.com>
Subject: Re: [PATCH v4 1/2] blktests: replace module removal with patient
 module removal
Message-ID: <aUmJtfPM7A26swxN@deb-101020-bm01.eng.stellus.in>
References: <20251126171102.3663957-1-mcgrof@kernel.org>
 <20251126171102.3663957-2-mcgrof@kernel.org>
 <a38bbe68-97e8-4476-a406-5c5228167e96@acm.org>
 <7e056be2-d9c6-41f6-848d-f87e91983968@wdc.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e056be2-d9c6-41f6-848d-f87e91983968@wdc.com>

On Fri, Dec 19, 2025 at 05:29:06AM +0000, Shinichiro Kawasaki wrote:
> On 11/27/25 2:45 AM, Bart Van Assche wrote:
> > On 11/26/25 9:11 AM, Luis Chamberlain wrote:
> >> Long ago a WAIT option for module removal was added... that was then
> >> removed as it was deemed not needed as folks couldn't figure out when
> >> these races happened. The races are actually pretty easy to trigger, it
> >> was just never properly documented. A simpe blkdev_open() will easily
> >> bump a module refcnt, and these days many thing scan do that sort of
> >> thing.
> > 
> > It would be appreciated if "thing" could be replaced with a more
> > specific description of what actually happens.
> >> The proper solution is to implement then a patient module removal
> >> on kmod and that has been merged now as modprobe --wait=MSEC option.
> >> We need a work around to open code a similar solution for users of
> >> old versions of kmod. An open coded solution for fstests exists
> >> there for over a year now. This now provides the respective blktests
> >> implementation.
> > 
> > How can it be concluded what the proper solution is without explaining
> > the root cause first? Please add an explanation of the root cause. I
> > assume that the root cause is that some references are dropped
> > asynchronously after module removal has been requested for the first
> > time?
> 
> I agree that the clarification on the above points will improve the commit
> message. Said that, I do not think lack of the clarifications should delay the
> application of this series.
> 
> Swarna, Luis, if there is any URL to the "flaky bug" that Swaran faced, please
> share. I can add it as a Link tag to show another reason for this series.
>

I donot have any URL to the bug, but below is the description for it: 

I had seen a sporadic kernel hang  while running block tests (block/003) when testing  
scsi driver with sector size 16k which is detailed in the  testing description of the 
cover letter sent for RFC v1 series for scsi fix. 
(link here- https://lore.kernel.org/all/20251202021522.188419-1-sw.prabhu6@gmail.com/ ).
The fio task triggerd at test block/003 would race with udevs generated while stressing 
scsi debug module in test - block/001.

I havent been able to reproduce the hang in the current setup lately, so i pasted below the 
snippet of the dmesg i had captured when the hang occured with block/003 test:

55.240584]  __mutex_lock.constprop.0+0x3fc/0xa60
[10755.241693]  ? _raw_spin_unlock+0x15/0x30
[10755.242630]  bdev_open+0x2ac/0x3d0
[10755.243446]  ? __pfx_blkdev_open+0x10/0x10
[10755.244399]  blkdev_open+0xc6/0x120
[10755.245217]  do_dentry_open+0x242/0x430
[10755.246128]  vfs_open+0x2a/0xe0                                                                                                                         
[10755.246876]  path_openat+0x31e/0x12e0
[10755.247752]  ? getname_flags.part.0+0x26/0x1c0
[10755.248777]  do_filp_open+0xbf/0x170
[10755.249637]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[10755.250778]  ? __create_object+0x5e/0x90
[10755.251695]  ? preempt_count_add+0x47/0xa0
[10755.252645]  ? __virt_addr_valid+0xf5/0x170
[10755.253636]  ? __check_object_size+0x249/0x2d0
[10755.254670]  ? alloc_fd+0x11a/0x180
[10755.255502]  do_sys_openat2+0x70/0xd0
[10755.256360]  __x64_sys_openat+0x69/0xa0
[10755.257276]  do_syscall_64+0x50/0xb60
[10755.258138]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[10755.259294] RIP: 0033:0x7f22ceca49ee
[10755.260141] RSP: 002b:00007ffc0a8b18e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
[10755.261864] RAX: ffffffffffffffda RBX: 00007f22cc568f00 RCX: 00007f22ceca49ee
[10755.263489] RDX: 0000000000040002 RSI: 00007f22cb30d2b0 RDI: ffffffffffffff9c
[10755.265102] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[10755.266727] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000040002
[10755.268304] R13: 00007f22c3efa000 R14: 0000000000000000 R15: 000055b79b6f020a
[10755.269724]  </TASK>
[10755.270209] INFO: task fio:109969 is blocked on a mutex likely owned by task systemd-udevd:404.
[10755.271920] task:systemd-udevd   state:D stack:0     pid:404   tgid:404   ppid:1      task_flags:0x400100 flags:0x00080003
[10755.273863] Call Trace:
[10755.274324]  <TASK>
[10755.274729]  __schedule+0x54c/0xc10
[10755.275372]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[10755.276249]  schedule+0x26/0xd0
[10755.276782]  schedule_timeout+0x71/0xf0
[10755.277432]  ? __pfx_process_timeout+0x10/0x10
[10755.278167]  io_schedule_timeout+0x4d/0x70
[10755.278845]  __wait_for_common+0x99/0x1b0
[10755.279517]  ? __pfx_io_schedule_timeout+0x10/0x10
[10755.280281]  blk_execute_rq+0xeb/0x160
[10755.280857]  scsi_execute_cmd+0x11e/0x430 [scsi_mod]
[10755.281653]  ? disk_scan_partitions+0x5d/0xf0
[10755.282319]  ? __x64_sys_ioctl+0x92/0xe0
[10755.282914]  sd_spinup_disk+0x102/0x4b0 [sd_mod]
[10755.283624]  ? _raw_spin_unlock_irqrestore+0x23/0x40
[10755.284341]  sd_revalidate_disk+0xda/0x2710 [sd_mod]	


Hope this helps.

Thanks
Swarna


