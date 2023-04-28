Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8714B290A
	for <patches@lists.linux.dev>; Fri, 28 Apr 2023 11:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45B1C4339B;
	Fri, 28 Apr 2023 11:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682681382;
	bh=wjzqgalYqUzN5PR4C4CrV4WGOIBMAtKFcCltMyNGGwY=;
	h=From:To:Cc:Subject:Date:From;
	b=QF4odHbraKRDnONzPTAu6ViHf+Z1up8iHRpY6NvyvmRSDh+3ejOB3Q4Cfm3hRNtmn
	 iTu7L5iYGGtwaM0dNfZCMIRLRbZhwogEseLDXEb/+VD2ayxz3kpAYJI8BD0B+TIOnt
	 hpUUa6qNggER9LOckwvhL0B8k5E0R85+7uvHQQCY=
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
Subject: [PATCH 6.1 00/16] 6.1.27-rc1 review
Date: Fri, 28 Apr 2023 13:27:52 +0200
Message-Id: <20230428112040.063291126@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.27-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.27-rc1
X-KernelTest-Deadline: 2023-04-30T11:20+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.1.27 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.27-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.27-rc1

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: No need to relocate the dtb as it lies in the fixmap region

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Do not set initial_boot_params to the linear address of the dtb

Alexandre Ghiti <alexghiti@rivosinc.com>
    riscv: Move early dtb mapping into the fixmap region

Stephen Boyd <swboyd@chromium.org>
    driver core: Don't require dynamic_debug for initcall_debug probe timing

Arınç ÜNAL <arinc.unal@arinc9.com>
    USB: serial: option: add UNISOC vendor and TOZED LT70C product

Genjian Zhang <zhanggenjian@kylinos.cn>
    btrfs: fix uninitialized variable warnings

Ruihan Li <lrh2000@pku.edu.cn>
    bluetooth: Perform careful capability checks in hci_sock_ioctl()

Werner Sembach <wse@tuxedocomputers.com>
    gpiolib: acpi: Add a ignore wakeup quirk for Clevo NL5xNU

Daniel Vetter <daniel.vetter@ffwll.ch>
    drm/fb-helper: set x/yres_virtual in drm_fb_helper_check_var

Jisoo Jang <jisoo.jang@yonsei.ac.kr>
    wifi: brcmfmac: slab-out-of-bounds read in brcmf_get_assoc_ies()

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix accept vs worker race

Paolo Abeni <pabeni@redhat.com>
    mptcp: stops worker on unaccepted sockets at listener close

Liam R. Howlett <Liam.Howlett@oracle.com>
    mm/mempolicy: fix use-after-free of VMA iterator

David Matlack <dmatlack@google.com>
    KVM: arm64: Retry fault if vma_lookup() results become invalid

Florian Fainelli <f.fainelli@gmail.com>
    phy: phy-brcm-usb: Utilize platform_get_irq_byname_optional()

David Gow <davidgow@google.com>
    um: Only disable SSE on clang to work around old GCC bugs


-------------

Diffstat:

 Documentation/riscv/vm-layout.rst                  |   4 +-
 Makefile                                           |   4 +-
 arch/arm64/kvm/mmu.c                               |  47 ++++-----
 arch/riscv/include/asm/fixmap.h                    |   8 ++
 arch/riscv/include/asm/pgtable.h                   |   8 +-
 arch/riscv/kernel/setup.c                          |   6 +-
 arch/riscv/mm/init.c                               |  82 +++++++--------
 arch/x86/Makefile.um                               |   5 +
 drivers/base/dd.c                                  |   7 +-
 drivers/gpio/gpiolib-acpi.c                        |  13 +++
 drivers/gpu/drm/drm_fb_helper.c                    |   3 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   5 +
 drivers/phy/broadcom/phy-brcm-usb.c                |   4 +-
 drivers/usb/serial/option.c                        |   6 ++
 fs/btrfs/send.c                                    |   2 +-
 fs/btrfs/volumes.c                                 |   2 +-
 mm/mempolicy.c                                     | 115 ++++++++++-----------
 net/bluetooth/hci_sock.c                           |   9 +-
 net/mptcp/protocol.c                               |  74 ++++++++-----
 net/mptcp/protocol.h                               |   2 +
 net/mptcp/subflow.c                                |  80 +++++++++++++-
 21 files changed, 309 insertions(+), 177 deletions(-)


