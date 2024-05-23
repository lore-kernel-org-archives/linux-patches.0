Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62CC14A62D;
	Thu, 23 May 2024 13:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470252; cv=none; b=GDKb1H0j3T7l86619y9FvulhtgGa7xMCAEwa8IgNFr0JVYh7PmXy13yH0TUnkJi/bIAazRHw92Uo48cLSCfw3hT/88hTI7VlfCLJfBeHeAZF3IfODK2P1Yek+ggxVPl1N8wUXaxPxEEqsHtcPeDyfp26Q0r9FcRFwFU1UELtGiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470252; c=relaxed/simple;
	bh=/4a/xj7cfRIZDCnPtNaV7cN+oIvMYqd0ViXOU/2Moz4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IVXN+XCEX5oIcfkX6Fe5Yy+P5ksYJ7H6O3KcL+p3VEOLByQvYc9Zrc3LPpbFskeqt9wqXabs+vwNOdGZ6UVwyl9jUO39/VOltl5blpkST88/wsQOz9XTvN287ao1MbId4Z+mFv+6RsNXu0J/8Ao6qpRXao0zLGuRYY+0R2R4zpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVJU7Nmr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVJU7Nmr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F06C2BD10;
	Thu, 23 May 2024 13:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470251;
	bh=/4a/xj7cfRIZDCnPtNaV7cN+oIvMYqd0ViXOU/2Moz4=;
	h=From:To:Cc:Subject:Date:From;
	b=QVJU7NmrrdI6MAaUJzDIiO8XRmKm+T4mMIvoj6UTrJHXfh6dfpQIjcvRlZQy5xZCT
	 Y7FNDfTtOum7zzevN7ATi4TQnYH9Xx3TNOl9OuKXpggLXiXN5B9+SUNbB/lnNcn4ht
	 N4LWp5mAioQ9ejDUKoWxPtH0UxSMzZ8QAPZMkIEI=
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
	allen.lkml@gmail.com,
	broonie@kernel.org
Subject: [PATCH 6.9 00/25] 6.9.2-rc1 review
Date: Thu, 23 May 2024 15:12:45 +0200
Message-ID: <20240523130330.386580714@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.9.2-rc1
X-KernelTest-Deadline: 2024-05-25T13:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.9.2 release.
There are 25 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.9.2-rc1

Christoph Hellwig <hch@lst.de>
    block: add a partscan sysfs attribute for disks

Christoph Hellwig <hch@lst.de>
    block: add a disk_has_partscan helper

SeongJae Park <sj@kernel.org>
    Docs/admin-guide/mm/damon/usage: fix wrong schemes effective quota update command

SeongJae Park <sj@kernel.org>
    Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file

Akira Yokosawa <akiyks@gmail.com>
    docs: kernel_include.py: Cope with docutils 0.21

Thomas Weißschuh <linux@weissschuh.net>
    admin-guide/hw-vuln/core-scheduling: fix return type of PR_SCHED_CORE_GET

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Do not use WARN when encode fails

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    Revert "media: v4l2-ctrls: show all owned controls in log_status"

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    remoteproc: mediatek: Make sure IPI buffer fits in L2TCM

Daniel Thompson <daniel.thompson@linaro.org>
    serial: kgdboc: Fix NMI-safety problems from keyboard reset code

Javier Carrasco <javier.carrasco@wolfvision.net>
    usb: typec: tipd: fix event checking for tps6598x

Javier Carrasco <javier.carrasco@wolfvision.net>
    usb: typec: tipd: fix event checking for tps25750

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: displayport: Fix potential deadlock

Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
    net: usb: ax88179_178a: fix link status when link is set to down/up

Prashanth K <quic_prashk@quicinc.com>
    usb: dwc3: Wait unconditionally after issuing EndXfer command

Carlos Llamas <cmllamas@google.com>
    binder: fix max_thread type inconsistency

Bard Liao <yung-chuan.liao@linux.intel.com>
    ASoC: Intel: sof_sdw: use generic rtd_init function for Realtek SDW DMICs

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix memory leak in tpm2_key_encode()

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: L2CAP: Fix div-by-zero in l2cap_le_flowctl_init()

Uros Bizjak <ubizjak@gmail.com>
    x86/percpu: Use __force to cast from __percpu address space

Ronald Wahl <ronald.wahl@raritan.com>
    net: ks8851: Fix another TX stall caused by wrong ISR flag handling

Jose Fernandez <josef@netflix.com>
    drm/amd/display: Fix division by zero in setup_dsc_config

Perry Yuan <perry.yuan@amd.com>
    cpufreq: amd-pstate: fix the highest frequency issue which limits performance

Ben Greear <greearb@candelatech.com>
    wifi: iwlwifi: Use request_module_nowait

Peter Tsao <peter.tsao@mediatek.com>
    Bluetooth: btusb: Fix the patch for MT7920 the affected to MT7921


-------------

Diffstat:

 Documentation/ABI/stable/sysfs-block               | 10 +++
 .../admin-guide/hw-vuln/core-scheduling.rst        |  4 +-
 Documentation/admin-guide/mm/damon/usage.rst       |  6 +-
 Documentation/sphinx/kernel_include.py             |  1 -
 Makefile                                           |  4 +-
 arch/x86/include/asm/percpu.h                      |  6 +-
 block/genhd.c                                      | 15 +++--
 block/partitions/core.c                            |  5 +-
 drivers/android/binder.c                           |  2 +-
 drivers/android/binder_internal.h                  |  2 +-
 drivers/bluetooth/btusb.c                          |  1 +
 drivers/cpufreq/amd-pstate.c                       | 22 ++++++-
 drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c        |  7 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          | 18 ++----
 drivers/net/ethernet/micrel/ks8851_common.c        | 18 +-----
 drivers/net/usb/ax88179_178a.c                     | 37 +++++++----
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       | 10 +--
 drivers/remoteproc/mtk_scp.c                       | 10 ++-
 drivers/tty/serial/kgdboc.c                        | 30 ++++++++-
 drivers/usb/dwc3/gadget.c                          |  4 +-
 drivers/usb/typec/tipd/core.c                      | 51 ++++++++++-----
 drivers/usb/typec/tipd/tps6598x.h                  | 11 ++++
 drivers/usb/typec/ucsi/displayport.c               |  4 --
 include/linux/blkdev.h                             | 13 ++++
 include/net/bluetooth/hci.h                        |  9 +++
 include/net/bluetooth/hci_core.h                   |  1 +
 net/bluetooth/hci_conn.c                           | 75 +++++++++++++++-------
 net/bluetooth/hci_event.c                          | 31 +++++----
 net/bluetooth/iso.c                                |  2 +-
 net/bluetooth/l2cap_core.c                         | 17 +----
 net/bluetooth/sco.c                                |  6 +-
 security/keys/trusted-keys/trusted_tpm2.c          | 25 ++++++--
 sound/soc/intel/boards/Makefile                    |  1 +
 sound/soc/intel/boards/sof_sdw.c                   | 12 ++--
 sound/soc/intel/boards/sof_sdw_common.h            |  1 +
 sound/soc/intel/boards/sof_sdw_rt_dmic.c           | 52 +++++++++++++++
 36 files changed, 357 insertions(+), 166 deletions(-)


