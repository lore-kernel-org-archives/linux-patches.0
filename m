Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71488468B
	for <patches@lists.linux.dev>; Tue,  4 Jul 2023 08:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C630FC433C9;
	Tue,  4 Jul 2023 08:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688460522;
	bh=ztK4gfqf8b9jPihzjl8ZjJJnSrbvmffSvJobYTkZb2k=;
	h=From:To:Cc:Subject:Date:From;
	b=Ep1s9S83gAWvEJs+nyFP8GOMgsbF21xhcdvd9BCYc9YCjQl4ny/Qb/NcqVv1xGSM+
	 BPWYmhKd9XAZV2oybSfY9Krkq9CU6kbOOQKZZf4fvID8PbzbqESFtmP9UqsgmsI4po
	 lxUKFGbI7rEAb/TOxVIvvDflIEFuLY57PRhXnpDU=
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
Subject: [PATCH 6.3 00/14] 6.3.12-rc2 review
Date: Tue,  4 Jul 2023 09:48:39 +0100
Message-ID: <20230704084611.028211988@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.12-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.3.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.3.12-rc2
X-KernelTest-Deadline: 2023-07-06T08:46+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.3.12 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 06 Jul 2023 08:46:01 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.12-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.3.12-rc2

Linus Torvalds <torvalds@linux-foundation.org>
    gup: avoid stack expansion warning for known-good case

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Ensure vmin and vmax adjust for DCE

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amdgpu: Validate VM ioctl flags.

Demi Marie Obenour <demi@invisiblethingslab.com>
    dm ioctl: Avoid double-fetch of version

Ahmed S. Darwish <darwi@linutronix.de>
    docs: Set minimal gtags / GNU GLOBAL version to 6.6.5

Ahmed S. Darwish <darwi@linutronix.de>
    scripts/tags.sh: Resolve gtags empty index generation

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

Aric Cyr <aric.cyr@amd.com>
    drm/amd/display: Do not update DRR while BW optimizations pending

Max Filippov <jcmvbkbc@gmail.com>
    xtensa: fix lock_mm_and_find_vma in case VMA not found


-------------

Diffstat:

 Documentation/process/changes.rst        |  7 +++++
 Makefile                                 |  4 +--
 drivers/cxl/core/pci.c                   | 27 +++-------------
 drivers/cxl/cxl.h                        |  1 -
 drivers/cxl/port.c                       | 14 +++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c   |  4 +++
 drivers/gpu/drm/amd/display/dc/core/dc.c | 49 +++++++++++++++++------------
 drivers/md/dm-ioctl.c                    | 33 ++++++++++++--------
 drivers/nubus/proc.c                     | 22 ++++++++++---
 drivers/pci/pci-acpi.c                   | 53 ++++++++++++++++++++++++--------
 fs/nfs/inode.c                           |  2 +-
 include/linux/mm.h                       |  4 ++-
 mm/memory.c                              |  4 +++
 mm/nommu.c                               |  7 ++++-
 scripts/tags.sh                          |  9 +++++-
 tools/testing/cxl/Kbuild                 |  1 -
 tools/testing/cxl/test/mock.c            | 15 ---------
 17 files changed, 152 insertions(+), 104 deletions(-)


