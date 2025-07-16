Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A990321CC49;
	Wed, 16 Jul 2025 14:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752675028; cv=none; b=RIMbWPBSC3zS0vCw5ckxsonmI/kmo/aKZ6mLG0QrTIX+wpj9dzl1TIfsPhBunYfAeNiNlJt6SvP7B0UFF1jkwZ47Wx6Q4PEJcAoJvMRH8Ak50G+YmEJHVtpd+Ior2O7vUH2JTM5zJWhKqc9Sxzj6Vht+oymzMlEVXrbAGjXF/CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752675028; c=relaxed/simple;
	bh=dXcqdVHK0iXajCLLediJdp7a7OeIb1spkwCJAO6AXdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hzpOZmU09I0mNsk9OHPRLCxRYJZJJrRqOHpHngoydv4euY3DwKg/i5RtmD/g/bmlQsbYOFxyv0TV2nFjLeNtXYC7BOly0bEsKhCC9f2VQU5Msnv9S796/I9iPXRpwu5y8I+NYBrwUFo3cFdZqh/9M/M9LJ16P0J9EnME+wzcY5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TU0GjjMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TU0GjjMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA223C4CEF0;
	Wed, 16 Jul 2025 14:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752675028;
	bh=dXcqdVHK0iXajCLLediJdp7a7OeIb1spkwCJAO6AXdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TU0GjjMTgp4H1DBetGNFnXfD4AI7qw85zv1ZuIA2aG3jF+BUS/47XGAPMzGfSaAHs
	 Dal8lvtiij2qMmeSgoPLB+E08R+AhBxzS0S4f374VYlxFRs+wLw94IberUfOk5hO5C
	 97rr/v9QWRRGzY2BspYpFNxkoIP5LNdB1/hZ0APo=
Date: Wed, 16 Jul 2025 16:10:25 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	linux-tegra@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/148] 5.4.296-rc1 review
Message-ID: <2025071653-eatery-idiocy-b183@gregkh>
References: <20250715130800.293690950@linuxfoundation.org>
 <451e4d80-d033-4a7e-a874-27ab053ef249@rnnvmail203.nvidia.com>
 <97b4d154-f0b0-4d09-8106-842ca1c4768a@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97b4d154-f0b0-4d09-8106-842ca1c4768a@nvidia.com>

On Wed, Jul 16, 2025 at 11:16:51AM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 16/07/2025 11:11, Jon Hunter wrote:
> > On Tue, 15 Jul 2025 15:12:02 +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.296 release.
> > > There are 148 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.296-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Failures detected for Tegra ...
> > 
> > Test results for stable-v5.4:
> >      10 builds:	10 pass, 0 fail
> >      24 boots:	24 pass, 0 fail
> >      54 tests:	53 pass, 1 fail
> > 
> > Linux version:	5.4.296-rc1-g53e64469ea49
> > Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >                  tegra194-p2972-0000, tegra20-ventana,
> >                  tegra210-p2371-2180, tegra210-p3450-0000,
> >                  tegra30-cardhu-a04
> > 
> > Test failures:	tegra194-p2972-0000: boot.py
> 
> 
> I am seeing the following warning ...
> 
> boot: logs: [       7.316610] WARNING KERN ------------[ cut here ]------------
> boot: logs: [       7.321166] WARNING KERN WARNING: CPU: 6 PID: 80 at kernel/rcu/tree.c:2572 __call_rcu+0xf8/0x1c0
> boot: logs: [       7.328690] WARNING KERN Modules linked in:
> boot: logs: [       7.331710] WARNING KERN CPU: 6 PID: 80 Comm: kworker/6:1 Not tainted 5.4.296-rc1-g53e64469ea49 #1
> boot: logs: [       7.339422] WARNING KERN Hardware name: NVIDIA Jetson AGX Xavier Developer Kit (DT)
> boot: logs: [       7.345850] WARNING KERN Workqueue: events_freezable mmc_rescan
> boot: logs: [       7.350605] WARNING KERN pstate: 60c00009 (nZCv daif +PAN +UAO)
> boot: logs: [       7.355329] WARNING KERN pc : __call_rcu+0xf8/0x1c0
> boot: logs: [       7.359029] WARNING KERN lr : kfree_call_rcu+0x10/0x20
> boot: logs: [       7.362980] WARNING KERN sp : ffff800011be37c0
> boot: logs: [       7.366249] WARNING KERN x29: ffff800011be37c0 x28: ffff0003e9459800
> boot: logs: [       7.371481] WARNING KERN x27: ffff800011771000 x26: ffff0003e9473800
> boot: logs: [       7.376712] WARNING KERN x25: 0000000000000000 x24: 0000000000000001
> boot: logs: [       7.381941] WARNING KERN x23: ffff0003e9474000 x22: ffff0003eb8a3680
> boot: logs: [       7.387175] WARNING KERN x21: 0000000000000000 x20: ffff0003eb8a3680
> boot: logs: [       7.392405] WARNING KERN x19: 0000000000000020 x18: ffffffffffffffff
> boot: logs: [       7.397640] WARNING KERN x17: ffff8000116a44c8 x16: 0000acb4dd443472
> boot: logs: [       7.402876] WARNING KERN x15: 0000000000000006 x14: 0720072007200720
> boot: logs: [       7.408112] WARNING KERN x13: 0720072007200720 x12: 0720072007200720
> boot: logs: [       7.413342] WARNING KERN x11: 0720072007200720 x10: 0720072007200720
> boot: logs: [       7.418573] WARNING KERN x9 : 0000000000000000 x8 : ffff0003e9453600
> boot: logs: [       7.423800] WARNING KERN x7 : 0000000000000000 x6 : 000000000000003f
> boot: logs: [       7.429029] WARNING KERN x5 : 0000000000000040 x4 : ffff0003e9453400
> boot: logs: [       7.434257] WARNING KERN x3 : ffff0003e9474048 x2 : 0000000000000001
> boot: logs: [       7.439478] WARNING KERN x1 : 0000000000000000 x0 : 0000000000000000
> boot: logs: [       7.444706] WARNING KERN Call trace:
> boot: logs: [       7.447129] WARNING KERN  __call_rcu+0xf8/0x1c0
> boot: logs: [       7.450473] WARNING KERN  kfree_call_rcu+0x10/0x20
> boot: logs: [       7.454082] WARNING KERN  disk_expand_part_tbl+0xb4/0xf0
> boot: logs: [       7.458199] WARNING KERN  rescan_partitions+0xd0/0x310
> boot: logs: [       7.462167] WARNING KERN  bdev_disk_changed+0x6c/0x80
> boot: logs: [       7.466035] WARNING KERN  __blkdev_get+0x39c/0x4e0
> boot: logs: [       7.469668] WARNING KERN  blkdev_get+0x24/0x160
> boot: logs: [       7.473022] WARNING KERN  __device_add_disk+0x2fc/0x440
> boot: logs: [       7.477055] WARNING KERN  device_add_disk+0x10/0x20
> boot: logs: [       7.480744] WARNING KERN  mmc_add_disk+0x28/0xf4
> boot: logs: [       7.484188] WARNING KERN  mmc_blk_probe+0x210/0x620
> boot: logs: [       7.487885] WARNING KERN  mmc_bus_probe+0x1c/0x30
> boot: logs: [       7.491413] WARNING KERN  really_probe+0xdc/0x450
> boot: logs: [       7.494939] WARNING KERN  driver_probe_device+0x54/0xf0
> boot: logs: [       7.498971] WARNING KERN  __device_attach_driver+0xac/0x110
> boot: logs: [       7.503349] WARNING KERN  bus_for_each_drv+0x74/0xd0
> boot: logs: [       7.507130] WARNING KERN  __device_attach+0x98/0x190
> boot: logs: [       7.510912] WARNING KERN  device_initial_probe+0x10/0x20
> boot: logs: [       7.515025] WARNING KERN  bus_probe_device+0x90/0xa0
> boot: logs: [       7.518797] WARNING KERN  device_add+0x2e8/0x600
> boot: logs: [       7.522245] WARNING KERN  mmc_add_card+0x1dc/0x2c0
> boot: logs: [       7.525855] WARNING KERN  mmc_attach_mmc+0xe8/0x170
> boot: logs: [       7.529559] WARNING KERN  mmc_rescan+0x248/0x3a0
> boot: logs: [       7.532990] WARNING KERN  process_one_work+0x1a0/0x360
> boot: logs: [       7.536940] WARNING KERN  worker_thread+0x6c/0x470
> boot: logs: [       7.540547] WARNING KERN  kthread+0x148/0x150
> boot: logs: [       7.543733] WARNING KERN  ret_from_fork+0x10/0x18
> boot: logs: [       7.547243] WARNING KERN ---[ end trace c908584b2d117b20 ]---
> 
> 
> Bisect is pointing to the following commit ...
> 
> # first bad commit: [06949933ae1b2109cfef82bcdf70e3e09b4761bb] rcu: Return early if callback is not specified

Thanks for this, let me go drop it and push out a new -rc.

greg k-h
