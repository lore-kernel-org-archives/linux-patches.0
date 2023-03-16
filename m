Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A7A2561
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 08:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7D0C433D2;
	Thu, 16 Mar 2023 08:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678956583;
	bh=evZsOLQ/RDFCme3QDzcNmfgG0DIRUR7CczVo9QT8Urg=;
	h=From:To:Cc:Subject:Date:From;
	b=puh1/giXPL3Y/KkQJDFqqw0PT8fF/eSatPJhBslrJXF/ZZXfDkBQgOGXA7IgKUzBo
	 Cm2m2+/r5qFE26J3PlKOGYbFopJDFugjhz857/+BSGQP9s+3ck/jAtCaMm9INYhELT
	 edQZPp57FYZ+rSJoh6ZoxvqRO8QsZb4a+HEtO5rQ=
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
Subject: [PATCH 4.14 00/20] 4.14.310-rc2 review
Date: Thu, 16 Mar 2023 09:49:41 +0100
Message-Id: <20230316083335.429724157@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.310-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.310-rc2
X-KernelTest-Deadline: 2023-03-18T08:33+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 4.14.310 release.
There are 20 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.310-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.310-rc2

Rhythm Mahajan <rhythm.m.mahajan@oracle.com>
    x86/cpu: Fix LFENCE serialization check in init_amd()

John Harrison <John.C.Harrison@Intel.com>
    drm/i915: Don't use BAR mappings for ring buffers with LLC

Tung Nguyen <tung.q.nguyen@dektech.com.au>
    tipc: improve function tipc_wait_for_cond()

Paul Elder <paul.elder@ideasonboard.com>
    media: ov5640: Fix analogue gain control

Alvaro Karsz <alvaro.karsz@solid-run.com>
    PCI: Add SolidRun vendor ID

Nathan Chancellor <nathan@kernel.org>
    macintosh: windfarm: Use unsigned type for 1-bit bitfields

Edward Humes <aurxenon@lunos.org>
    alpha: fix R_ALPHA_LITERAL reloc for large modules

xurui <xurui@kylinos.cn>
    MIPS: Fix a compilation issue

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    clk: qcom: mmcc-apq8084: remove spdm clocks

Shigeru Yoshida <syoshida@redhat.com>
    net: caif: Fix use-after-free in cfusbl_device_notify()

Eric Dumazet <edumazet@google.com>
    ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()

Kang Chen <void0red@gmail.com>
    nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties

Fedor Pchelkin <pchelkin@ispras.ru>
    nfc: change order inside nfc_se_io error path

Zhihao Cheng <chengzhihao1@huawei.com>
    ext4: zero i_disksize when initializing the bootloader inode

Ye Bin <yebin10@huawei.com>
    ext4: fix WARNING in ext4_update_inline_data

Ye Bin <yebin10@huawei.com>
    ext4: move where set the MAY_INLINE_DATA flag is set

Darrick J. Wong <djwong@kernel.org>
    ext4: fix another off-by-one fsmap error on 1k block filesystems

Eric Whitney <enwlinux@gmail.com>
    ext4: fix RENAME_WHITEOUT handling for inline directories

Andrew Cooper <andrew.cooper3@citrix.com>
    x86/CPU/AMD: Disable XSAVES on AMD family 0x17

Theodore Ts'o <tytso@mit.edu>
    fs: prevent out-of-bounds array speculation when closing a file descriptor


-------------

Diffstat:

 Makefile                                 |   4 +-
 arch/alpha/kernel/module.c               |   4 +-
 arch/mips/include/asm/mach-rc32434/pci.h |   2 +-
 arch/x86/kernel/cpu/amd.c                |  11 +-
 drivers/clk/qcom/mmcc-apq8084.c          | 271 -------------------------------
 drivers/gpu/drm/i915/intel_ringbuffer.c  |   4 +-
 drivers/macintosh/windfarm_lm75_sensor.c |   4 +-
 drivers/macintosh/windfarm_smu_sensors.c |   4 +-
 drivers/media/i2c/ov5640.c               |   2 +-
 drivers/nfc/fdp/i2c.c                    |   4 +
 fs/ext4/fsmap.c                          |   2 +
 fs/ext4/inline.c                         |   1 -
 fs/ext4/inode.c                          |   7 +-
 fs/ext4/ioctl.c                          |   1 +
 fs/ext4/namei.c                          |  13 +-
 fs/ext4/xattr.c                          |   3 +
 fs/file.c                                |   1 +
 include/linux/pci_ids.h                  |   2 +
 net/caif/caif_usb.c                      |   3 +
 net/ipv6/ila/ila_xlat.c                  |   1 +
 net/nfc/netlink.c                        |   2 +-
 net/tipc/socket.c                        |   2 +-
 22 files changed, 53 insertions(+), 295 deletions(-)


