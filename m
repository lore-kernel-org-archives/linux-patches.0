Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD152F25F6;
	Fri, 10 Oct 2025 13:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102591; cv=none; b=FI0T2jVMxiRIIabnY6WwLXLa/D8YxmbRtFUHxnJoYWJCNPw0Tagb6cPpkGakd1JrKCybLfrsbTu3jSn5vClzvTnWjD5liuOSMXz4rQ2y657h1GNMEptOk+ye9bQ04A6kPlgDyUanoyLmT8Zx4j0FpXaDSYN2zylQ93c9AJ/qqso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102591; c=relaxed/simple;
	bh=UOvgpvgHCJKzXQ+krMTH0HNnHMX0rn1QIWlOqs4vDcU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I/lScqbt5fXtGBb3DSDtHwE7Acre9Vg2Dxdp5S3eqQnNEbMdIInrmXS/Q3dP1Fr1zV/gc3xCzEXZRJvImWkPtCgKdbHe5RS06sIlm8mfBseERJ6PGV+YyVy0J0pz5I+EoGiMHfAI44ApKoMpAQ1nWo5CMSH/u17vwKhObuJM5EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U5hGrlm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U5hGrlm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C83C4CEF1;
	Fri, 10 Oct 2025 13:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102590;
	bh=UOvgpvgHCJKzXQ+krMTH0HNnHMX0rn1QIWlOqs4vDcU=;
	h=From:To:Cc:Subject:Date:From;
	b=U5hGrlm4+GXj62MbzJv+6Llm3JcIl7S9b2GPS7tWd4P+yRv+P3BqVW1IyyQhlPV3s
	 Tyl03JVLu7Yo636YHI+K+xD6cT5MuWe/Hlo+lishv6qhujbeVod2EH88NNAaalfNYE
	 N1x8gC6HzmzQK2Y/AHcTtkxeSbqH/RHIe631DmHw=
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
Subject: [PATCH 6.6 00/28] 6.6.111-rc1 review
Date: Fri, 10 Oct 2025 15:16:18 +0200
Message-ID: <20251010131330.355311487@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.111-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.111-rc1
X-KernelTest-Deadline: 2025-10-12T13:13+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.111 release.
There are 28 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.111-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.111-rc1

Sean Christopherson <seanjc@google.com>
    KVM: x86: Don't (re)check L1 intercepts when completing userspace I/O

Nalivayko Sergey <Sergey.Nalivayko@kaspersky.com>
    net/9p: fix double req put in p9_fd_cancelled

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: rng - Ensure set_ent is always present

Charlie Jenkins <charlie@rivosinc.com>
    riscv: mm: Do not restrict mmap address based on hint

Charlie Jenkins <charlie@rivosinc.com>
    riscv: mm: Use hint address in mmap if available

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    driver core/PM: Set power.no_callbacks along with power.no_pm

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    staging: axis-fifo: flush RX FIFO on read errors

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    staging: axis-fifo: fix TX handling on copy_from_user() failure

Ovidiu Panait <ovidiu.panait.oss@gmail.com>
    staging: axis-fifo: fix maximum TX packet length check

Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
    serial: stm32: allow selecting console when the driver is module

Arnaud Lecomte <contact@arnaud-lcm.com>
    hid: fix I2C read buffer overflow in raw_event() for mcp2221

Jeongjun Park <aha310510@gmail.com>
    ALSA: usb-audio: fix race condition to UAF in snd_usbmidi_free

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Kill timer properly at removal

Christoffer Sandberg <cs@tuxedo.de>
    platform/x86/amd/pmc: Add Stellaris Slim Gen6 AMD to spurious 8042 quirks list

Duy Nguyen <duy.nguyen.rh@renesas.com>
    can: rcar_canfd: Fix controller mode setting

Chen Yufeng <chenyufeng@iie.ac.cn>
    can: hi311x: fix null pointer dereference when resuming from sleep before interface was enabled

David Sterba <dsterba@suse.com>
    btrfs: ref-verify: handle damaged extent root tree

Jack Yu <jack.yu@realtek.com>
    ASoC: rt5682s: Adjust SAR ADC button mode to fix noise issue

hupu <hupu.gm@gmail.com>
    perf subcmd: avoid crash in exclude_cmds when excludes is empty

aprilgrimoire <aprilgrimoire@proton.me>
    platform/x86/amd/pmc: Add MECHREVO Yilong15Pro to spurious_8042 list

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: limit MAX_TAG_SIZE to 255

Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
    ASoC: amd: acp: Adjust pdm gain value

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtlwifi: rtl8192cu: Don't claim USB ID 07b8:8188

Xiaowei Li <xiaowei.li@simcom.com>
    USB: serial: option: add SIMCom 8230C compositions

Duoming Zhou <duoming@zju.edu.cn>
    media: i2c: tc358743: Fix use-after-free bugs caused by orphan timer in probe

Duoming Zhou <duoming@zju.edu.cn>
    media: tuner: xc5000: Fix use-after-free in xc5000_release

Ricardo Ribalda <ribalda@chromium.org>
    media: tunner: xc5000: Refactor firmware load

Will Deacon <will@kernel.org>
    KVM: arm64: Fix softirq masking in FPSIMD register saving sequence


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm64/kernel/fpsimd.c                         |  8 ++-
 arch/riscv/include/asm/processor.h                 | 33 ++---------
 arch/x86/kvm/emulate.c                             |  9 ++-
 arch/x86/kvm/kvm_emulate.h                         |  3 +-
 arch/x86/kvm/x86.c                                 | 15 ++---
 crypto/rng.c                                       |  8 +++
 drivers/hid/hid-mcp2221.c                          |  4 ++
 drivers/md/dm-integrity.c                          |  2 +-
 drivers/media/i2c/tc358743.c                       |  4 +-
 drivers/media/tuners/xc5000.c                      | 41 ++++++-------
 drivers/net/can/rcar/rcar_canfd.c                  |  7 ++-
 drivers/net/can/spi/hi311x.c                       | 33 ++++++-----
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    |  1 -
 drivers/platform/x86/amd/pmc/pmc-quirks.c          | 15 +++++
 drivers/staging/axis-fifo/axis-fifo.c              | 68 ++++++++++------------
 drivers/tty/serial/Kconfig                         |  2 +-
 drivers/usb/serial/option.c                        |  6 ++
 fs/btrfs/ref-verify.c                              |  9 ++-
 include/linux/device.h                             |  3 +
 net/9p/trans_fd.c                                  |  8 +--
 sound/soc/amd/acp/amd.h                            |  2 +-
 sound/soc/codecs/rt5682s.c                         | 17 +++---
 sound/usb/midi.c                                   | 10 ++--
 tools/lib/subcmd/help.c                            |  3 +
 25 files changed, 166 insertions(+), 149 deletions(-)


