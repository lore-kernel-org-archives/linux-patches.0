Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672A414A8B;
	Fri,  3 Oct 2025 16:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507752; cv=none; b=EOaGEzRJf85+HSjlYxpTC/wVqsCIS8kkwmTxTqQJ4kW00MRFT682PIlhnlmu1B6wUPttnGrSMBtDGgxubgc4wXHMeznYARJZK2AEhxZlCq4/q6Ofw9fKH+NJP79VOLTobh6fDY0s5W9xOXIkO9LmiSGyMWlhT8WpZp5jRv9/0HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507752; c=relaxed/simple;
	bh=S4YPweji9yCv6gFmP1x6JDNbUY/FdmbUMq2v2P3kYH4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TL3zX/RKXPzaB16diFn1BFz57GPkuHUnLsue7Tt/unqbPAgL1TiR9N4FU2wLxrebzddoBCKaj9wE/rXmZaYBs1GNAXT9gAlFxnZ1H2H0R+V50obO5BYOBjr0lS5yhbTtwkgrTAmTufH93Zobweld9PG6xUQZ5hNYsMlxiejKnjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5zUXEYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5zUXEYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BBF1C4CEF5;
	Fri,  3 Oct 2025 16:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507750;
	bh=S4YPweji9yCv6gFmP1x6JDNbUY/FdmbUMq2v2P3kYH4=;
	h=From:To:Cc:Subject:Date:From;
	b=K5zUXEYV1MHqdIMuAu+lIOu57RBsIsSYcj+lv1GHy/j5MNvu7JSldlHuENXBQM5Cw
	 xEXEsS9rl3hkKXGMdSlXMe8FVoTQ6dXnGh3xx17WHeABr/wrZftQTYY7QWuk4p+9Vb
	 QWmYlfkaIqVlIklnyL96RDOieLxVTG337ytu72ow=
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
Subject: [PATCH 6.6 0/7] 6.6.110-rc1 review
Date: Fri,  3 Oct 2025 18:06:08 +0200
Message-ID: <20251003160331.487313415@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.110-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.6.110-rc1
X-KernelTest-Deadline: 2025-10-05T16:03+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.6.110 release.
There are 7 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 05 Oct 2025 16:02:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.110-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.6.110-rc1

Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
    ASoC: qcom: audioreach: fix potential null pointer dereference

Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
    media: uvcvideo: Mark invalid entities with id UVC_INVALID_ENTITY_ID

Larshin Sergey <Sergey.Larshin@kaspersky.com>
    media: rc: fix races with imon_disconnect()

Duoming Zhou <duoming@zju.edu.cn>
    media: b2c2: Fix use-after-free causing by irq_check_work in flexcop_pci_remove

Wang Haoran <haoranwangsec@gmail.com>
    scsi: target: target_core_configfs: Add length check to avoid buffer overflow

Kees Cook <kees@kernel.org>
    gcc-plugins: Remove TODO_verify_il for GCC >= 16

Breno Leitao <leitao@debian.org>
    crypto: sha256 - fix crash at kexec


-------------

Diffstat:

 Makefile                              |  4 +-
 drivers/media/pci/b2c2/flexcop-pci.c  |  2 +-
 drivers/media/rc/imon.c               | 27 +++++++++----
 drivers/media/usb/uvc/uvc_driver.c    | 73 ++++++++++++++++++++++-------------
 drivers/media/usb/uvc/uvcvideo.h      |  2 +
 drivers/target/target_core_configfs.c |  2 +-
 include/crypto/sha256_base.h          |  2 +-
 scripts/gcc-plugins/gcc-common.h      |  7 ++++
 sound/soc/qcom/qdsp6/topology.c       |  4 +-
 9 files changed, 82 insertions(+), 41 deletions(-)


