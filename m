Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835D41E497;
	Thu, 23 May 2024 13:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470547; cv=none; b=aaVL6FpKs0MnzG9JESbJaWmzPnON4BAE9cH+tMDk2uu+Ipmi9enT1mVTKk0IJFgDatWzRi+z4T6OPPRXoJX/Dlro13u31DRfgUtVQuL90X/RXIfhkF9dgTbJIfK5tbm1JoKzOkIQesNnKysHHqiJIpyEV6c6I+0mNWDQzHxkahs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470547; c=relaxed/simple;
	bh=cAMqcshjNY7oZ9DZf6rf0+n+26VChVTtA6o+CUumKfU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GH79jmQIgjdvCSWRdFOkoeJ43aw5Rq8mThmjiI+GJCPSGtAXCujlx/SLsWUmuyzTxvk16W3WCxhtSFoabBs7rc5jrR+jm4ftZgOaOZzdNNRTLFm0mcIQvZ+aGA6WF/5+6kLCcholRmv1iSblBkUn48GJmqeKz3OEOKlP0s6SlJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WG2+xg8z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WG2+xg8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD395C3277B;
	Thu, 23 May 2024 13:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470547;
	bh=cAMqcshjNY7oZ9DZf6rf0+n+26VChVTtA6o+CUumKfU=;
	h=From:To:Cc:Subject:Date:From;
	b=WG2+xg8z0tKbQBMIbvIaZrKyc0jfVSfwwUGLyu+MJnR6PJJpcn02jZbAvukxh33gi
	 DNGRVPr1C03ajhy3YlUeh4esjC0XYK+0SeQE9wTmynOlj2vQc5UJuNPiE26H2vaeIJ
	 SeUIVEyfd08MqzSFI4UTBlMI/XRnFHVgqLeI3IYE=
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
Subject: [PATCH 6.8 00/23] 6.8.11-rc1 review
Date: Thu, 23 May 2024 15:13:27 +0200
Message-ID: <20240523130329.745905823@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.8.11-rc1
X-KernelTest-Deadline: 2024-05-25T13:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.8.11 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.8.11-rc1

Christoph Hellwig <hch@lst.de>
    block: add a partscan sysfs attribute for disks

Christoph Hellwig <hch@lst.de>
    block: add a disk_has_partscan helper

SeongJae Park <sj@kernel.org>
    Docs/admin-guide/mm/damon/usage: fix wrong example of DAMOS filter matching sysfs file

Akira Yokosawa <akiyks@gmail.com>
    docs: kernel_include.py: Cope with docutils 0.21

Thomas Weißschuh <linux@weissschuh.net>
    admin-guide/hw-vuln/core-scheduling: fix return type of PR_SCHED_CORE_GET

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Do not use WARN when encode fails

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

Christian Brauner <brauner@kernel.org>
    erofs: reliably distinguish block based and fscache mode

Baokun Li <libaokun1@huawei.com>
    erofs: get rid of erofs_fs_context

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix memory leak in tpm2_key_encode()

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: L2CAP: Fix div-by-zero in l2cap_le_flowctl_init()

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: L2CAP: Fix slab-use-after-free in l2cap_connect()

Jacob Keller <jacob.e.keller@intel.com>
    ice: remove unnecessary duplicate checks for VF VSI ID

Jacob Keller <jacob.e.keller@intel.com>
    ice: pass VSI pointer into ice_vc_isvalid_q_id

Ronald Wahl <ronald.wahl@raritan.com>
    net: ks8851: Fix another TX stall caused by wrong ISR flag handling

Jose Fernandez <josef@netflix.com>
    drm/amd/display: Fix division by zero in setup_dsc_config


-------------

Diffstat:

 Documentation/ABI/stable/sysfs-block               |  10 ++
 .../admin-guide/hw-vuln/core-scheduling.rst        |   4 +-
 Documentation/admin-guide/mm/damon/usage.rst       |   2 +-
 Documentation/sphinx/kernel_include.py             |   1 -
 Makefile                                           |   4 +-
 block/genhd.c                                      |  15 ++-
 block/partitions/core.c                            |   5 +-
 drivers/android/binder.c                           |   2 +-
 drivers/android/binder_internal.h                  |   2 +-
 drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c        |   7 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |  22 ++--
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |   3 -
 drivers/net/ethernet/micrel/ks8851_common.c        |  18 +--
 drivers/net/usb/ax88179_178a.c                     |  37 ++++--
 drivers/remoteproc/mtk_scp.c                       |  10 +-
 drivers/tty/serial/kgdboc.c                        |  30 ++++-
 drivers/usb/dwc3/gadget.c                          |   4 +-
 drivers/usb/typec/tipd/core.c                      |  51 ++++++---
 drivers/usb/typec/tipd/tps6598x.h                  |  11 ++
 drivers/usb/typec/ucsi/displayport.c               |   4 -
 fs/erofs/internal.h                                |   7 --
 fs/erofs/super.c                                   | 124 +++++++++------------
 include/linux/blkdev.h                             |  13 +++
 include/net/bluetooth/hci.h                        |   9 ++
 include/net/bluetooth/hci_core.h                   |   1 +
 net/bluetooth/hci_conn.c                           |  71 ++++++++----
 net/bluetooth/hci_event.c                          |  31 ++++--
 net/bluetooth/iso.c                                |   2 +-
 net/bluetooth/l2cap_core.c                         |  38 +++----
 net/bluetooth/sco.c                                |   6 +-
 security/keys/trusted-keys/trusted_tpm2.c          |  25 ++++-
 31 files changed, 339 insertions(+), 230 deletions(-)


