Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DAC101C3
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 18:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7C8C433C7;
	Mon,  3 Jul 2023 18:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410554;
	bh=QSLM8BmL/Y3s6sjAZ97trfVyFWYruJB+PErAW4K9rS0=;
	h=From:To:Cc:Subject:Date:From;
	b=bGyswGH3VKcygLbLiS8o40Mb+Ys/aEYBPRAMaupahhNKfHQHM/X1OOox05RO42A2o
	 zOIXEJgZ06Ica3LWawfg3lH5bWg3TFcrVHUfyLTzGUKxuDmo+P74TIz/dhJAsRwTDe
	 cze248WtFoUplu8aDDGIQFz6FPfYbB/hSmwMCXlY=
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
	conor@kernel.org
Subject: [PATCH 6.4 00/13] 6.4.2-rc1 review
Date: Mon,  3 Jul 2023 20:54:01 +0200
Message-ID: <20230703184519.261119397@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.4.2-rc1
X-KernelTest-Deadline: 2023-07-05T18:45+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.4.2 release.
There are 13 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Jul 2023 18:45:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.4.2-rc1

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amdgpu: Validate VM ioctl flags.

Demi Marie Obenour <demi@invisiblethingslab.com>
    dm ioctl: Avoid double-fetch of version

Ahmed S. Darwish <darwi@linutronix.de>
    docs: Set minimal gtags / GNU GLOBAL version to 6.6.5

Ahmed S. Darwish <darwi@linutronix.de>
    scripts/tags.sh: Resolve gtags empty index generation

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: revert use of page_cache_next_miss()

Finn Thain <fthain@linux-m68k.org>
    nubus: Partially revert proc_create_single_data() conversion

Dan Williams <dan.j.williams@intel.com>
    Revert "cxl/port: Enable the HDM decoder capability for switch ports"

Jeff Layton <jlayton@kernel.org>
    nfs: don't report STATX_BTIME in ->getattr

Linus Torvalds <torvalds@linux-foundation.org>
    execve: always mark stack as growing down during early stack setup

Mario Limonciello <mario.limonciello@amd.com>
    PCI/ACPI: Call _REG when transitioning D-states

Bjorn Helgaas <bhelgaas@google.com>
    PCI/ACPI: Validate acpi_pci_set_power_state() parameter

Thomas Weißschuh <linux@weissschuh.net>
    tools/nolibc: x86_64: disable stack protector for _start

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix lock_mm_and_find_vma in case VMA not found


-------------

Diffstat:

 Documentation/process/changes.rst      |  7 +++++
 Makefile                               |  4 +--
 drivers/cxl/core/pci.c                 | 27 +++--------------
 drivers/cxl/cxl.h                      |  1 -
 drivers/cxl/port.c                     | 14 ++++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c |  4 +++
 drivers/md/dm-ioctl.c                  | 33 +++++++++++++--------
 drivers/nubus/proc.c                   | 22 ++++++++++----
 drivers/pci/pci-acpi.c                 | 53 +++++++++++++++++++++++++---------
 fs/hugetlbfs/inode.c                   |  8 ++---
 fs/nfs/inode.c                         |  2 +-
 include/linux/mm.h                     |  4 ++-
 mm/hugetlb.c                           | 12 ++++----
 mm/nommu.c                             |  7 ++++-
 scripts/tags.sh                        |  9 +++++-
 tools/include/nolibc/arch-x86_64.h     |  2 +-
 tools/testing/cxl/Kbuild               |  1 -
 tools/testing/cxl/test/mock.c          | 15 ----------
 18 files changed, 128 insertions(+), 97 deletions(-)


