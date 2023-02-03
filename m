Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525A11FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77498C433D2;
	Fri,  3 Feb 2023 10:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419788;
	bh=vZz2fXuEaeQwNy1wZBxCZF+GAUxemlvH6I6lLPmPJ6I=;
	h=From:To:Cc:Subject:Date:From;
	b=XjMfxlEN7olZOODqYKZYGkZGPX5ZqAww4gmv2kMLUzXkbNLCHx/sp8qqH9XO8DAT3
	 k+8bfAOgwKwdPDUaRZtntju2yOPvo6Cl8IaOqnugfCukleKyhaR6kn3Xh2ogA4oBsQ
	 0HTDmDl6ymnddt/bK/oNi4yCAVM+FtA4kOcu5I80=
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
Subject: [PATCH 5.10 0/9] 5.10.167-rc1 review
Date: Fri,  3 Feb 2023 11:13:29 +0100
Message-Id: <20230203101006.422534094@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.167-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.167-rc1
X-KernelTest-Deadline: 2023-02-05T10:10+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.167 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.167-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.167-rc1

Yan Zhai <yan@cloudflare.com>
    net: fix NULL pointer in skb_segment_list

Soenke Huster <soenke.huster@eknoes.de>
    Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt

Dave Hansen <dave.hansen@intel.com>
    ACPI: processor idle: Practically limit "Dummy wait" workaround to old Intel systems

Hui Wang <hui.wang@canonical.com>
    dmaengine: imx-sdma: Fix a possible memory leak in sdma_transfer_init

Yu Kuai <yukuai3@huawei.com>
    blk-cgroup: fix missing pd_online_fn() while activating policy

Hao Sun <sunhao.th@gmail.com>
    bpf: Skip task with pid=1 in send_signal_common()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: imx8mq-thor96: fix no-mmc property for SDHCI

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: vf610: Fix pca9548 i2c-mux node names

Geert Uytterhoeven <geert+renesas@glider.be>
    ARM: dts: imx: Fix pca9547 i2c-mux node name


-------------

Diffstat:

 Makefile                                        |  4 ++--
 arch/arm/boot/dts/imx53-ppd.dts                 |  2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-b.dts       |  2 +-
 arch/arm/boot/dts/vf610-zii-dev-rev-c.dts       |  2 +-
 arch/arm64/boot/dts/freescale/imx8mq-thor96.dts |  4 ++--
 block/blk-cgroup.c                              |  4 ++++
 drivers/acpi/processor_idle.c                   | 23 ++++++++++++++++++++---
 drivers/dma/imx-sdma.c                          |  4 +++-
 kernel/trace/bpf_trace.c                        |  3 +++
 net/bluetooth/hci_event.c                       | 13 +++++++++++++
 net/core/skbuff.c                               |  5 ++---
 11 files changed, 52 insertions(+), 14 deletions(-)


