Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACE735962;
	Fri,  3 Oct 2025 16:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507690; cv=none; b=UOujGrv7t+Ka0XG99HEWJhMdQ2dIpNkxOuvfrAUx/h3mG1NujleO94m+UXGVuv4NndkwcbzfyiSo/Cr+AR+1A87y6QAlF8vgXKcry+LHIRF3G/NFV4CdgcHkyxFEDSBFylyAFE1doOzVjejrYk4KrLZDtOb0wmAeVjSFyIwoOIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507690; c=relaxed/simple;
	bh=g9HdtT1YHAF709ivx3fyBaFNtM+e7YfvgP3SwcUeKG4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aFL+DVLajNTRQPUzeyiF3UsjuPmth17yarHGw3YbkdrzekAx4wKTtGKcjMJsyW7WGjZecob5KoS2owRCMbihFNqM3p7AkUCQdkcRzR2Wn9NpGfFjUQ7GP3/ZAOcRi7+qkIvhqITRCwUu6eRR5Q/LxeT0jbSlXjnfhz+dvYHniFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8uQ+Jcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8uQ+Jcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBDEC4CEF5;
	Fri,  3 Oct 2025 16:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507690;
	bh=g9HdtT1YHAF709ivx3fyBaFNtM+e7YfvgP3SwcUeKG4=;
	h=From:To:Cc:Subject:Date:From;
	b=U8uQ+JcjIgUFrN3gCcinBaQvuI5QvTcjYjXPYuLsk2PbqSpIxo7oVEAkMQ+tnOuHK
	 poIfWecNCDLYJsZ+CtVNjs14joUhJ+3wyZY6Gn3atau+8eqx/88Ji9XE3XVRKUAE+F
	 7knBIVFS0OXhP2iZ1haF6jbKwZXBfT96R9oGY92s=
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
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.16 00/14] 6.16.11-rc1 review
Date: Fri,  3 Oct 2025 18:05:34 +0200
Message-ID: <20251003160352.713189598@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.11-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.16.11-rc1
X-KernelTest-Deadline: 2025-10-05T16:03+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.16.11 release.
There are 14 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.11-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.16.11-rc1

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: audioreach: fix potential null pointer dereference

Chandra Mohan Sundar <chandramohan.explore@gmail.com>
    media: stm32-csi: Fix dereference before NULL check

Dikshita Agarwal <quic_dikshita@quicinc.com>
    media: iris: Fix memory leak by freeing untracked persist buffer

Matvey Kovalev <matvey.kovalev@ispras.ru>
    wifi: ath11k: fix NULL dereference in ath11k_qmi_m3_load()

Charan Teja Kalla <charan.kalla@oss.qualcomm.com>
    mm: swap: check for stable address space before operating on the VMA

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    media: uvcvideo: Mark invalid entities with id UVC_INVALID_ENTITY_ID

Larshin Sergey <Sergey.Larshin@kaspersky.com>
    media: rc: fix races with imon_disconnect()

Duoming Zhou <duoming@zju.edu.cn>
    media: tuner: xc5000: Fix use-after-free in xc5000_release

Duoming Zhou <duoming@zju.edu.cn>
    media: i2c: tc358743: Fix use-after-free bugs caused by orphan timer in probe

Duoming Zhou <duoming@zju.edu.cn>
    media: b2c2: Fix use-after-free causing by irq_check_work in flexcop_pci_remove

Jeongjun Park <aha310510@gmail.com>
    ALSA: usb-audio: fix race condition to UAF in snd_usbmidi_free

Wang Haoran <haoranwangsec@gmail.com>
    scsi: target: target_core_configfs: Add length check to avoid buffer overflow

Kees Cook <kees@kernel.org>
    gcc-plugins: Remove TODO_verify_il for GCC >= 16

Yu Kuai <yukuai3@huawei.com>
    blk-mq: fix blk_mq_tags double free while nr_requests grown


-------------

Diffstat:

 Makefile                                       |  4 +-
 block/blk-mq-tag.c                             |  1 +
 drivers/media/i2c/tc358743.c                   |  4 +-
 drivers/media/pci/b2c2/flexcop-pci.c           |  2 +-
 drivers/media/platform/qcom/iris/iris_buffer.c | 10 ++++
 drivers/media/platform/st/stm32/stm32-csi.c    |  4 +-
 drivers/media/rc/imon.c                        | 27 +++++++---
 drivers/media/tuners/xc5000.c                  |  2 +-
 drivers/media/usb/uvc/uvc_driver.c             | 73 ++++++++++++++++----------
 drivers/media/usb/uvc/uvcvideo.h               |  2 +
 drivers/net/wireless/ath/ath11k/qmi.c          |  2 +-
 drivers/target/target_core_configfs.c          |  2 +-
 mm/swapfile.c                                  |  3 ++
 scripts/gcc-plugins/gcc-common.h               |  7 +++
 sound/soc/qcom/qdsp6/topology.c                |  4 +-
 sound/usb/midi.c                               |  9 ++--
 16 files changed, 105 insertions(+), 51 deletions(-)


