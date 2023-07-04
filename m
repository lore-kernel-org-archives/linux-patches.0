Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAD03FEC
	for <patches@lists.linux.dev>; Tue,  4 Jul 2023 08:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BBFC433C7;
	Tue,  4 Jul 2023 08:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688460508;
	bh=HYPUrqcNnyCYsLbTui2R56OphdLhLN8tpRinwJHhqQM=;
	h=From:To:Cc:Subject:Date:From;
	b=YKGmADOz7cwTz7DRXPHeJGmnbptZCnr1BoN5ZcK1uHbRBuOpgvdSVwTjYqC8ZIY7l
	 z6BwOwDrk/5t4GOuZaxR87BQzIalfAoxATO6QsiERiUY1X93oMEQCAIQapWbftDc0T
	 Z+SoSgInFNx5l9HqQz99TWlkHgHj3F7vkLwkmzbo=
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
Subject: [PATCH 6.4 00/15] 6.4.2-rc2 review
Date: Tue,  4 Jul 2023 09:48:24 +0100
Message-ID: <20230704084611.900603362@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.2-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.4.2-rc2
X-KernelTest-Deadline: 2023-07-06T08:46+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.4.2 release.
There are 15 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 06 Jul 2023 08:46:01 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.2-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.4.2-rc2

Linus Torvalds <torvalds@linux-foundation.org>
    gup: avoid stack expansion warning for known-good case

SeongJae Park <sj@kernel.org>
    arch/arm64/mm/fault: Fix undeclared variable error in do_page_fault()

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
 arch/arm64/mm/fault.c                  |  2 --
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
 mm/memory.c                            |  4 +++
 mm/nommu.c                             |  7 ++++-
 scripts/tags.sh                        |  9 +++++-
 tools/include/nolibc/arch-x86_64.h     |  2 +-
 tools/testing/cxl/Kbuild               |  1 -
 tools/testing/cxl/test/mock.c          | 15 ----------
 20 files changed, 132 insertions(+), 99 deletions(-)


