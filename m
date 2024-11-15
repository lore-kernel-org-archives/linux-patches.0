Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B6A2BB1B;
	Fri, 15 Nov 2024 06:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653977; cv=none; b=L+VBO9JEaQwwbgQA5nZnYHm2ZaCEpIC2y2VvOMVTOzp9uPntwj9DR1JolH1aNcV1ZKZgfzalsR1fPZkvJ9lbq1kvVUPqsoVG1LxuwGUNUvlV5VGrTzrOhkh4vIroDo22hD8Q+pKxe2pyt5ve57oQtzy2oen/DaAd7b6lTJM80Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653977; c=relaxed/simple;
	bh=Iw0maWuVk35Bzc5A/pGLcIZyak5wPQYKA9zSoI0rMMw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tZhvqUHz3KxNBF93dB9/OXITIUz06ggvkur97MCOhcYydXIRUZrGKQXSZaIT3sx2B0ZUjsLIGi75Jhb4ghIBaje3x+d1kellkUmtyF4x92LytZOIGN499PSWk6hlRCflM8iFCPz7cVhcB4yuHjWy6XtXkpseLCfTBO9EoUJ4waE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fo+XKfa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fo+XKfa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19228C4CED2;
	Fri, 15 Nov 2024 06:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653977;
	bh=Iw0maWuVk35Bzc5A/pGLcIZyak5wPQYKA9zSoI0rMMw=;
	h=From:To:Cc:Subject:Date:From;
	b=fo+XKfa9DbkgIj1FC7mQf+XksalbQD/n8Os6+EGSTbbZK/q0XIjS/qRiru4TDQ40G
	 qGQE2cJPc3OpUmYbvK6NHAYNPA+JY7djpZqsUFC7ra7jzzfMYvJjw4vH3vw0rHJwM0
	 B4+USH9dILZmRZ6EgC8iGV8vwdr/yrvbwdGUXgIw=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org
Subject: [PATCH 5.15 00/22] 5.15.173-rc1 review
Date: Fri, 15 Nov 2024 07:38:46 +0100
Message-ID: <20241115063721.172791419@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.173-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.173-rc1
X-KernelTest-Deadline: 2024-11-17T06:37+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.173 release.
There are 22 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.173-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.173-rc1

Linus Torvalds <torvalds@linux-foundation.org>
    9p: fix slab cache name creation for real

Jan Kara <jack@suse.cz>
    udf: Avoid directory type conversion failure due to ENOMEM

Jan Kara <jack@suse.cz>
    udf: Allocate name buffer in directory iterator on heap

Yuanzheng Song <songyuanzheng@huawei.com>
    mm/memory: add non-anonymous page check in the copy_present_page()

Qun-Wei Lin <qun-wei.lin@mediatek.com>
    mm: krealloc: Fix MTE false alarm in __do_krealloc

Hagar Hemdan <hagarhem@amazon.com>
    io_uring: fix possible deadlock in io_register_iowq_max_workers()

Li Nan <linan122@huawei.com>
    md/raid10: improve code of mrdev in raid10_sync_request

Reinhard Speyerer <rspmn@arcor.de>
    net: usb: qmi_wwan: add Fibocom FG132 0x0112 composition

Hans de Goede <hdegoede@redhat.com>
    HID: lenovo: Add support for Thinkpad X1 Tablet Gen 3 keyboard

Kenneth Albanowski <kenalba@chromium.org>
    HID: multitouch: Add quirk for Logitech Bolt receiver w/ Casa touchpad

Alessandro Zanni <alessandro.zanni87@gmail.com>
    fs: Fix uninitialized value issue in from_kuid and from_kgid

Yuan Can <yuancan@huawei.com>
    vDPA/ifcvf: Fix pci_read_config_byte() return code handling

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/powernv: Free name on error in opal_event_init()

Ian Forbes <ian.forbes@broadcom.com>
    drm/vmwgfx: Limit display layout ioctl array size to VMWGFX_NUM_DISPLAY_UNITS

Julian Vetter <jvetter@kalrayinc.com>
    sound: Make CONFIG_SND depend on INDIRECT_IOMEM instead of UML

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: marvell/cesa - Disable hash algorithms

Rik van Riel <riel@surriel.com>
    bpf: use kvzmalloc to allocate BPF verifier environment

WangYuli <wangyuli@uniontech.com>
    HID: multitouch: Add quirk for HONOR MagicBook Art 14 touchpad

Stefan Blum <stefanblum2004@gmail.com>
    HID: multitouch: Add support for B2402FVA track point

SurajSonawane2415 <surajsonawane0215@gmail.com>
    block: Fix elevator_get_default() checking for NULL q->tag_set

Sergey Matsievskiy <matsievskiysv@gmail.com>
    irqchip/ocelot: Fix trigger register address

Pedro Falcato <pedro.falcato@gmail.com>
    9p: Avoid creating multiple slab caches with the same name


-------------

Diffstat:

 Makefile                                      |  4 ++--
 arch/powerpc/platforms/powernv/opal-irqchip.c |  1 +
 block/elevator.c                              |  4 ++--
 drivers/crypto/marvell/cesa/hash.c            | 12 ++++++------
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h           |  4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c           |  4 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.h           |  3 ---
 drivers/hid/hid-ids.h                         |  1 +
 drivers/hid/hid-lenovo.c                      |  8 ++++++++
 drivers/hid/hid-multitouch.c                  | 13 +++++++++++++
 drivers/irqchip/irq-mscc-ocelot.c             |  4 ++--
 drivers/md/raid10.c                           | 23 ++++++++++++-----------
 drivers/net/usb/qmi_wwan.c                    |  1 +
 drivers/vdpa/ifcvf/ifcvf_base.c               |  2 +-
 fs/ocfs2/file.c                               |  9 ++++++---
 fs/udf/directory.c                            | 27 +++++++++++++++++++--------
 fs/udf/udfdecl.h                              |  2 +-
 io_uring/io_uring.c                           |  5 +++++
 kernel/bpf/verifier.c                         |  4 ++--
 mm/memory.c                                   | 11 +++++++++++
 mm/slab_common.c                              |  2 +-
 net/9p/client.c                               | 12 +++++++++++-
 sound/Kconfig                                 |  2 +-
 23 files changed, 111 insertions(+), 47 deletions(-)


