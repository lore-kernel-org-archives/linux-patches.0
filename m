Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F752FF16C;
	Wed, 10 Dec 2025 07:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352168; cv=none; b=aqwls8+Eb6GQ6b/cliFuvnt4Wk3x9nXgunODUWv7kx3Pdxll0NhHqhDLgEip+fU+tLD0buE2Bf2TTwyNTxYDLIeyTV9ov7UjqtQvoeKKGf4ikIFQPypDVOP5i7OC+PBidwEqOQWQqkuxGxViLGoWYDfw8uEjgLSyBAGBE/mOo8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352168; c=relaxed/simple;
	bh=Qyj65oagwPZw4EirhXXN9lPBZR8mwRWQrnTYZ4z1Bfg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ePL8B7V/fatSsRGNphAaCfOiO2/ELcFpxtaau2QNji5BV8TxdEOIaE2s+PKQUgGaUdAJSfYcdz5qMzV53X5r5+hA4x/W13uLz4OJQnnt7yx9k6sObF4m13Qs7bnhoWEBJgBwlyTzpDqkJ4WeT6p9B7/9ZBRO29dgRe+3yl9GdCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCa8LTQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCa8LTQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A739C4CEF1;
	Wed, 10 Dec 2025 07:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352167;
	bh=Qyj65oagwPZw4EirhXXN9lPBZR8mwRWQrnTYZ4z1Bfg=;
	h=From:To:Cc:Subject:Date:From;
	b=VCa8LTQcKUJxWLE6A4w1qm7/uwkm1YacfYf4Ee5Pp38hKVX0ulcsZhhFLWLXAwmYP
	 KsSeLucXpq3Bf2FF3rXSj3JW6Rj4QxS8yPQpOl8crBb09vywgUfQiGAlVuIZ+laqKY
	 X5QKhPDR83cBCX7yw5V/9APxQ/Ihc6iK8DZjnzXw=
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
	achill@achill.org,
	sr@sladewatkins.com
Subject: [PATCH 6.18 00/29] 6.18.1-rc1 review
Date: Wed, 10 Dec 2025 16:30:10 +0900
Message-ID: <20251210072944.363788552@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.18.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.18.1-rc1
X-KernelTest-Deadline: 2025-12-12T07:29+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.18.1 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 12 Dec 2025 07:29:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.18.1-rc1

Navaneeth K <knavaneeth786@gmail.com>
    staging: rtl8723bs: fix out-of-bounds read in OnBeacon ESR IE parsing

Navaneeth K <knavaneeth786@gmail.com>
    staging: rtl8723bs: fix stack buffer overflow in OnAssocReq IE parsing

Navaneeth K <knavaneeth786@gmail.com>
    staging: rtl8723bs: fix out-of-bounds read in rtw_get_ie() parser

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    comedi: check device's attached status in compat ioctls

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    comedi: multiq3: sanitize config options in multiq3_attach()

Ian Abbott <abbotti@mev.co.uk>
    comedi: c6xdigio: Fix invalid PNP driver unregistration

Antoniu Miclaus <antoniu.miclaus@analog.com>
    iio: adc: ad4080: fix chip identification

Zenm Chen <zenmchen@gmail.com>
    wifi: rtw88: Add USB ID 2001:3329 for D-Link AC13U rev. A1

Zenm Chen <zenmchen@gmail.com>
    wifi: rtl8xxxu: Add USB ID 2001:3328 for D-Link AN3U rev. A1

Gopi Krishna Menon <krishnagopi487@gmail.com>
    Documentation/rtla: rename common_xxx.rst files to common_xxx.txt

Johan Hovold <johan@kernel.org>
    USB: serial: kobil_sct: fix TIOCMBIS and TIOCMBIC

Johan Hovold <johan@kernel.org>
    USB: serial: belkin_sa: fix TIOCMBIS and TIOCMBIC

Biju Das <biju.das.jz@bp.renesas.com>
    serial: sh-sci: Fix deadlock during RSCI FIFO overrun error

Biju Das <biju.das.jz@bp.renesas.com>
    dt-bindings: serial: rsci: Drop "uart-has-rtscts: false"

Magne Bruno <magne.bruno@addi-data.com>
    serial: add support of CPCI cards

Johan Hovold <johan@kernel.org>
    USB: serial: ftdi_sio: match on interface number for jtag

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: move Telit 0x10c7 composition in the right place

Fabio Porcedda <fabio.porcedda@gmail.com>
    USB: serial: option: add Telit Cinterion FE910C04 new compositions

Slark Xiao <slark_xiao@163.com>
    USB: serial: option: add Foxconn T99W760

Omar Sandoval <osandov@fb.com>
    KVM: SVM: Don't skip unrelated instruction if INT3/INTO is replaced

Nikita Zhandarovich <n.zhandarovich@fintech.ru>
    comedi: pcl818: fix null-ptr-deref in pcl818_ai_cancel()

Alice Ryhl <aliceryhl@google.com>
    rust_binder: fix race condition on death_list

Alexey Nepomnyashih <sdl@nppct.ru>
    ext4: add i_data_sem protection in ext4_destroy_inline_data_nolock()

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: zstd - fix double-free in per-CPU stream cleanup

Alexander Sverdlin <alexander.sverdlin@gmail.com>
    locking/spinlock/debug: Fix data-race in do_raw_write_lock

Qianchang Zhao <pioooooooooip@gmail.com>
    ksmbd: ipc: fix use-after-free in ipc_msg_send_request

Deepanshu Kartikey <kartikey406@gmail.com>
    ext4: refresh inline data size before write operations

Ye Bin <yebin10@huawei.com>
    jbd2: avoid bug_on in jbd2_journal_get_create_access() when file system corrupted

Bagas Sanjaya <bagasdotme@gmail.com>
    Documentation: process: Also mention Sasha Levin as stable tree maintainer


-------------

Diffstat:

 .../devicetree/bindings/serial/renesas,rsci.yaml   |  2 -
 Documentation/process/2.Process.rst                |  6 +-
 .../{common_appendix.rst => common_appendix.txt}   |  0
 ...on_hist_options.rst => common_hist_options.txt} |  0
 .../{common_options.rst => common_options.txt}     |  0
 ...cription.rst => common_osnoise_description.txt} |  0
 ...oise_options.rst => common_osnoise_options.txt} |  0
 ...mmon_timerlat_aa.rst => common_timerlat_aa.txt} |  0
 ...ription.rst => common_timerlat_description.txt} |  0
 ...lat_options.rst => common_timerlat_options.txt} |  0
 ...mmon_top_options.rst => common_top_options.txt} |  0
 Documentation/tools/rtla/rtla-hwnoise.rst          |  8 +--
 Documentation/tools/rtla/rtla-osnoise-hist.rst     | 10 +--
 Documentation/tools/rtla/rtla-osnoise-top.rst      | 10 +--
 Documentation/tools/rtla/rtla-osnoise.rst          |  4 +-
 Documentation/tools/rtla/rtla-timerlat-hist.rst    | 12 ++--
 Documentation/tools/rtla/rtla-timerlat-top.rst     | 12 ++--
 Documentation/tools/rtla/rtla-timerlat.rst         |  4 +-
 Documentation/tools/rtla/rtla.rst                  |  2 +-
 Makefile                                           |  4 +-
 arch/x86/include/asm/kvm_host.h                    |  9 +++
 arch/x86/kvm/svm/svm.c                             | 24 ++++----
 arch/x86/kvm/x86.c                                 | 21 +++++++
 crypto/zstd.c                                      |  7 +--
 drivers/android/binder/node.rs                     |  6 +-
 drivers/comedi/comedi_fops.c                       | 42 +++++++++++--
 drivers/comedi/drivers/c6xdigio.c                  | 46 ++++++++++----
 drivers/comedi/drivers/multiq3.c                   |  9 +++
 drivers/comedi/drivers/pcl818.c                    |  5 +-
 drivers/iio/adc/ad4080.c                           |  9 ++-
 drivers/net/wireless/realtek/rtl8xxxu/core.c       |  3 +
 drivers/net/wireless/realtek/rtw88/rtw8822cu.c     |  2 +
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c     | 14 +++--
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      | 13 ++--
 drivers/tty/serial/8250/8250_pci.c                 | 37 +++++++++++
 drivers/tty/serial/sh-sci.c                        | 12 +++-
 drivers/usb/serial/belkin_sa.c                     | 28 +++++----
 drivers/usb/serial/ftdi_sio.c                      | 72 ++++++++--------------
 drivers/usb/serial/kobil_sct.c                     | 18 +++---
 drivers/usb/serial/option.c                        | 22 ++++++-
 fs/ext4/inline.c                                   | 14 ++++-
 fs/jbd2/transaction.c                              | 19 ++++--
 fs/smb/server/transport_ipc.c                      |  7 ++-
 kernel/locking/spinlock_debug.c                    |  4 +-
 44 files changed, 343 insertions(+), 174 deletions(-)


