Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75AAF847A
	for <patches@lists.linux.dev>; Wed,  1 Mar 2023 18:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4630C433EF;
	Wed,  1 Mar 2023 18:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677694051;
	bh=2xZ4YeuJ9EEGFWMj4puv5RQQp1mmyde516STCcpad1k=;
	h=From:To:Cc:Subject:Date:From;
	b=r+ywjVm+11RKm51mZrFU/wmRdekTKJrwXnj4gn1v784OqrDlW7rYBHSAPinWk8JYx
	 IIgMTqwrmrKMY6YEwvHwhuG6dbGyMiUT4XNMD4FQIilUijeuEB+HySxtNCznBOme8c
	 HsW2LuY4P70N2eeBORCfs3M+w6roQsLCSr2bnlmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@denx.de,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: [PATCH 4.19 0/9] 4.19.275-rc1 review
Date: Wed,  1 Mar 2023 19:07:16 +0100
Message-Id: <20230301180650.395562988@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.275-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.275-rc1
X-KernelTest-Deadline: 2023-03-03T18:06+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 4.19.275 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.275-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.275-rc1

Alan Stern <stern@rowland.harvard.edu>
    USB: core: Don't hold device lock while reading the "descriptors" sysfs file

Florian Zumbiehl <florz@florz.de>
    USB: serial: option: add support for VW/Skoda "Carstick LTE"

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    dmaengine: sh: rcar-dmac: Check for error num after dma_set_max_seg_size

Thomas Weißschuh <linux@weissschuh.net>
    vc_screen: don't clobber return value in vcs_read

Kuniyuki Iwashima <kuniyu@amazon.com>
    net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().

Dean Luick <dean.luick@cornelisnetworks.com>
    IB/hfi1: Assign npages earlier

David Sterba <dsterba@suse.com>
    btrfs: send: limit number of clones and allocated memory size

Vishal Verma <vishal.l.verma@intel.com>
    ACPI: NFIT: fix a potential deadlock during NFIT teardown

Johan Jonker <jbx6244@gmail.com>
    ARM: dts: rockchip: add power-domains property to dp node on rk3288


-------------

Diffstat:

 Makefile                                  | 4 ++--
 arch/arm/boot/dts/rk3288.dtsi             | 1 +
 drivers/acpi/nfit/core.c                  | 2 +-
 drivers/dma/sh/rcar-dmac.c                | 5 ++++-
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 9 ++-------
 drivers/tty/vt/vc_screen.c                | 7 ++++---
 drivers/usb/core/hub.c                    | 5 ++---
 drivers/usb/core/sysfs.c                  | 5 -----
 drivers/usb/serial/option.c               | 4 ++++
 fs/btrfs/send.c                           | 6 +++---
 net/caif/caif_socket.c                    | 1 +
 net/core/stream.c                         | 1 -
 12 files changed, 24 insertions(+), 26 deletions(-)


