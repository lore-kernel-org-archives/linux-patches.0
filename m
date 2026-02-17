Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59B5374178;
	Tue, 17 Feb 2026 20:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360901; cv=none; b=gSvGtPVw/4sfFtT63N+2FANqluOZ+7gsHy3d6tHK1XOxTfNrx9igftW2LzlBOnj+pjzPaMjLPGzmWGIaS8tl2Cswifm0v3e4S3uQMI9a5VAXRVAS1MFqsPia+W3ttwMUD6IUZ9yfjxNRkp2EkoRJVL7HxPtVQhyEO1pw1FHCn6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360901; c=relaxed/simple;
	bh=i0QEWX8411cYRurUfHkw3rmJ8KW8JILg1hYzr0qv7ls=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mCaKEodxmrllYCvLbwtMr+cRZ1PPmWhpYncy0Q2r7rq/97cIDQha0PhnsUK9EYcN+mWa8/iSPjObgHD7IdmCA4mO4zhePCC2hHprV8AVknHri4H7soUbidqTw6NPawSH9M2Nb1XPfQoOX1EVn+1g08jSpmLp4bIP/ffCYY2d1vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JuXQmj+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JuXQmj+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243A2C4CEF7;
	Tue, 17 Feb 2026 20:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360901;
	bh=i0QEWX8411cYRurUfHkw3rmJ8KW8JILg1hYzr0qv7ls=;
	h=From:To:Cc:Subject:Date:From;
	b=JuXQmj+K39Xp9rSIeuwuzZYaZqIbPSwW0laZrKQ530Os9lHdLnrsq0UBhwT1VnlGa
	 RWhuN5R5+qEX5LeS4hv9kR0dMrV96Ui1aJKprEoniVi/fm6Ggg7lGA70aO639BFGOa
	 f0JSuEkTLAY9/7Er+BAjSq4/r/cK/sJrQCfps6J4=
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
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 5.10 00/24] 5.10.251-rc1 review
Date: Tue, 17 Feb 2026 21:31:13 +0100
Message-ID: <20260217200000.708219618@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.251-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.251-rc1
X-KernelTest-Deadline: 2026-02-19T20:00+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.251 release.
There are 24 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.251-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.251-rc1

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit FN920C04 RNDIS compositions

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid UAF in f2fs_write_end_io()

Yongpeng Yang <yangyongpeng@xiaomi.com>
    f2fs: fix out-of-bounds access in sysfs attribute read/write

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    fbdev: smscufx: properly copy ioctl memory to kernelspace

Guangshuo Li <lgs201920130244@gmail.com>
    fbdev: rivafb: fix divide error in nv3_arb()

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Fix bsg_done() causing double free

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Free sp in error path to fix system crash

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Validate sp before freeing associated memory

Bibo Mao <maobibo@loongson.cn>
    crypto: virtio - Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req

Matthieu Baerts (NGI0) <matttbe@kernel.org>
    selftests: mptcp: pm: ensure unknown flags are ignored

Alexander Aring <aahringo@redhat.com>
    fs: dlm: fix invalid derefence of sb_lvbptr

Alban Bedel <alban.bedel@lht.dlh.de>
    gpiolib: acpi: Fix gpio count with string references

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    platform/x86: classmate-laptop: Add missing NULL pointer checks

Brahmajit Das <listout@listout.xyz>
    drm/tegra: hdmi: sor: Fix error: variable ‘j’ set but not used

Deepanshu Kartikey <kartikey406@gmail.com>
    romfs: check sb_set_blocksize() return value

Xuewen Yan <xuewen.yan@unisoc.com>
    gpio: sprd: Change sprd_gpio lock to raw_spin_lock

Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
    ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU

Danilo Krummrich <dakr@kernel.org>
    gpio: omap: do not register driver in probe()

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Query FW again before proceeding with login

Anil Gurumurthy <agurumurthy@marvell.com>
    scsi: qla2xxx: Delay module unload while fabric scan in progress

Edward Adam Davis <eadavis@qq.com>
    nilfs2: Fix potential block overflow that cause system hang

Bibo Mao <maobibo@loongson.cn>
    crypto: virtio - Add spinlock protection with virtqueue notification

Kees Cook <kees@kernel.org>
    crypto: omap - Allocate OMAP_CRYPTO_FORCE_COPY scatterlists correctly

Thorsten Blum <thorsten.blum@linux.dev>
    crypto: octeontx - Fix length check to avoid truncation in ucode_load_store


-------------

Diffstat:

 Makefile                                          |  4 +-
 drivers/crypto/marvell/octeontx/otx_cptpf_ucode.c |  2 +-
 drivers/crypto/omap-crypto.c                      |  2 +-
 drivers/crypto/virtio/virtio_crypto_algs.c        |  2 -
 drivers/crypto/virtio/virtio_crypto_core.c        |  5 ++
 drivers/gpio/gpio-omap.c                          | 22 +++++++--
 drivers/gpio/gpio-sprd.c                          |  8 ++--
 drivers/gpio/gpiolib-acpi.c                       |  1 +
 drivers/gpu/drm/tegra/hdmi.c                      |  4 +-
 drivers/gpu/drm/tegra/sor.c                       |  4 +-
 drivers/platform/x86/classmate-laptop.c           | 32 +++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.c                    |  5 +-
 drivers/scsi/qla2xxx/qla_gs.c                     | 36 +++++++-------
 drivers/scsi/qla2xxx/qla_init.c                   | 19 +++++++-
 drivers/scsi/qla2xxx/qla_isr.c                    | 19 +++++++-
 drivers/scsi/qla2xxx/qla_os.c                     |  3 +-
 drivers/usb/serial/option.c                       |  6 +++
 drivers/video/fbdev/riva/riva_hw.c                |  3 ++
 drivers/video/fbdev/smscufx.c                     |  8 +++-
 fs/dlm/lock.c                                     |  2 +-
 fs/f2fs/data.c                                    | 12 +++--
 fs/f2fs/sysfs.c                                   | 58 ++++++++++++++++++++---
 fs/nilfs2/sufile.c                                |  4 ++
 fs/romfs/super.c                                  |  5 +-
 sound/pci/hda/patch_realtek.c                     |  4 ++
 tools/testing/selftests/net/mptcp/pm_netlink.sh   |  2 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c     | 11 +++++
 27 files changed, 226 insertions(+), 57 deletions(-)


