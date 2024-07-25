Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2FC19D074;
	Thu, 25 Jul 2024 14:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918511; cv=none; b=WKBM0Z8NCKdYVdnUjqAvOfk5PzuJ5MTJLULiyAepCBZEx/s+WSvIbA6pHhgz/eqFPTfnuTQhARF+3nHaS+Hj8BieMNIcklKQPxrK+Ke/p9EaseSsbRANcEu7gEe2f0UfGLgqSF3D2odyZp+EV7DN+CqGj2oiTPd53Xm3YdQMnaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918511; c=relaxed/simple;
	bh=PDBbUin/14b6/69p0pC8d8ass0y7UoXiTELSVkW600s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rna1/2epzw4njGOttsvn20Y4jVKx37m0mVW0WBkUZqF8QITB/Y3zQ6O96C32UOd4On2x2O7fCLUNGx8ReBDIacJILQGuVKwu6LaVd1jM4n6DcxFWcC4fscpUYYYxRc6opLnCNj0ZiIb6wSWz+ZP93T8dg25fdurFArhgsUC5x0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVmjmj1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVmjmj1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70092C116B1;
	Thu, 25 Jul 2024 14:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918511;
	bh=PDBbUin/14b6/69p0pC8d8ass0y7UoXiTELSVkW600s=;
	h=From:To:Cc:Subject:Date:From;
	b=xVmjmj1ncCQt83wC2aWuCGOOGHgl+uVEv33Etn1+0nblClqK4lWLomqHPH6GfMP7T
	 OQR3snhYj/yoL6xhmzfL+NSABn/kDRql/3vof5OyiFY8oOfdpuaS3+kApejiNyVptw
	 Gle/09Sr8a+JdyDZ8FuPDjaGgYbJTvKr8++YYoT8=
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
Subject: [PATCH 4.19 00/33] 4.19.319-rc1 review
Date: Thu, 25 Jul 2024 16:36:23 +0200
Message-ID: <20240725142728.511303502@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.319-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.319-rc1
X-KernelTest-Deadline: 2024-07-27T14:27+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 4.19.319 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.319-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.319-rc1

Jann Horn <jannh@google.com>
    filelock: Fix fcntl/close race recovery compat path

lei lu <llfamsec@gmail.com>
    jfs: don't walk off the end of ealist

lei lu <llfamsec@gmail.com>
    ocfs2: add bounds checking to ocfs2_check_dir_entry()

Paolo Abeni <pabeni@redhat.com>
    net: relax socket state check at accept time.

Kuan-Wei Chiu <visitorckw@gmail.com>
    ACPI: processor_idle: Fix invalid comparison with insertion sort for latency

Masahiro Yamada <masahiroy@kernel.org>
    ARM: 9324/1: fix get_user() broken with veneer

Jann Horn <jannh@google.com>
    filelock: Remove locks reliably when fcntl/close race is detected

Edward Adam Davis <eadavis@qq.com>
    hfsplus: fix uninit-value in copy_name

John Hubbard <jhubbard@nvidia.com>
    selftests/vDSO: fix clang build errors and warnings

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    spi: imx: Don't expect DMA for i.MX{25,35,50,51,53} cspi devices

Christian Brauner <brauner@kernel.org>
    fs: better handle deep ancestor chains in is_subdir()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Bluetooth: hci_core: cancel all works upon hci_unregister_dev()

Yunshui Jiang <jiangyunshui@kylinos.cn>
    net: mac802154: Fix racy device stats updates by DEV_STATS_INC() and DEV_STATS_ADD()

Daniele Palmas <dnlplm@gmail.com>
    net: usb: qmi_wwan: add Telit FN912 compositions

Shengjiu Wang <shengjiu.wang@nxp.com>
    ALSA: dmaengine_pcm: terminate dmaengine before synchronize

Heiko Carstens <hca@linux.ibm.com>
    s390/sclp: Fix sclp_init() cleanup on failure

Ian Ray <ian.ray@gehealthcare.com>
    gpio: pca953x: fix pca953x_irq_bus_sync_unlock race

Chen Ni <nichen@iscas.ac.cn>
    can: kvaser_usb: fix return value for hif_usb_send_regout

Thomas GENTY <tomlohave@gmail.com>
    bytcr_rt5640 : inverse jack detect for Archos 101 cesium

Jonathan Denose <jdenose@google.com>
    Input: elantech - fix touchpad state on resume for Lenovo N24

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: cfg80211: wext: add extra SIOCSIWSCAN data check

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: demote client disconnect warning on suspend to debug

Yuntao Wang <yuntao.wang@linux.dev>
    fs/file: fix the check in find_next_fd()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: remove wrong expr_trans_bool()

Masahiro Yamada <masahiroy@kernel.org>
    kconfig: gconf: give a proper initial state to the Save button

Eric Dumazet <edumazet@google.com>
    ila: block BH in ila_output()

Hans de Goede <hdegoede@redhat.com>
    Input: silead - Always support 10 fingers

Dmitry Antipov <dmantipov@yandex.ru>
    wifi: mac80211: fix UBSAN noise in ieee80211_prep_hw_scan()

Nicolas Escande <nico.escande@gmail.com>
    wifi: mac80211: mesh: init nonpeer_pm to active by default in mesh sdata

Armin Wolf <W_Armin@gmx.de>
    ACPI: EC: Avoid returning AE_OK on errors in address space handler

Armin Wolf <W_Armin@gmx.de>
    ACPI: EC: Abort address space access upon error

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Set qed_slowpath_params to zero before use

Kees Cook <keescook@chromium.org>
    gcc-plugins: Rename last_stmt() for GCC 14+


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/include/asm/uaccess.h                     | 14 +------
 drivers/acpi/ec.c                                  |  9 ++++-
 drivers/acpi/processor_idle.c                      | 40 ++++++++-----------
 drivers/gpio/gpio-pca953x.c                        |  2 +
 drivers/input/mouse/elantech.c                     | 31 +++++++++++++++
 drivers/input/touchscreen/silead.c                 | 19 +++------
 drivers/misc/mei/main.c                            |  2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |  2 +-
 drivers/net/usb/qmi_wwan.c                         |  2 +
 drivers/s390/char/sclp.c                           |  1 +
 drivers/scsi/qedf/qedf_main.c                      |  1 +
 drivers/spi/spi-imx.c                              |  2 +-
 fs/dcache.c                                        | 31 +++++++--------
 fs/file.c                                          |  4 +-
 fs/hfsplus/xattr.c                                 |  2 +-
 fs/jfs/xattr.c                                     | 23 +++++++++--
 fs/locks.c                                         | 18 ++++-----
 fs/ocfs2/dir.c                                     | 46 ++++++++++++++--------
 net/bluetooth/hci_core.c                           |  4 ++
 net/ipv4/af_inet.c                                 |  4 +-
 net/ipv6/ila/ila_lwt.c                             |  7 +++-
 net/mac80211/mesh.c                                |  1 +
 net/mac80211/scan.c                                | 14 +++++--
 net/mac802154/tx.c                                 |  8 ++--
 net/wireless/scan.c                                |  8 +++-
 scripts/gcc-plugins/gcc-common.h                   |  4 ++
 scripts/kconfig/expr.c                             | 29 --------------
 scripts/kconfig/expr.h                             |  1 -
 scripts/kconfig/gconf.c                            |  3 +-
 scripts/kconfig/menu.c                             |  2 -
 sound/core/pcm_dmaengine.c                         | 12 ++++++
 sound/soc/intel/boards/bytcr_rt5640.c              | 11 ++++++
 tools/testing/selftests/vDSO/parse_vdso.c          | 16 +++++---
 .../selftests/vDSO/vdso_standalone_test_x86.c      | 18 ++++++++-
 35 files changed, 235 insertions(+), 160 deletions(-)


