Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFC0482E9;
	Wed, 15 May 2024 08:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715761607; cv=none; b=o14qdZX8oCS+08cLb+DrbJ7/ORHluhpsHK1mM6zXEbN3FEAZPo6KidsWscGoR/z+M/t/BtnZqwIa1CG+3HVwPQT8n6XlQiAXmJMu9FIo7+yogGcorD2PA0gAcsKri9ByxYsiFFVRvjNm9uTCbxyZMOTevEBZzED6hy8p6zL8vJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715761607; c=relaxed/simple;
	bh=oBjUWM9Ueajikuvb1TVY6pQjtCf2aE1BFiQMqZCZ8Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IRHykIHXnR8gD7a8P8d3gBz8boMIklCxxD1Qzn07OggVGEBujfEPtfPGJNwm4pq2ktf7J3Cvu9NHP1ureMLKmua8XX+1R8/hgdr4gmB2v0SpfTDqGdRQ1m1T0KcT9OlJHZBom6buFlJuA/gmmBlGaHPSVbT0tLSuHY9OEhTpmpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAEHkl5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAEHkl5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB70C116B1;
	Wed, 15 May 2024 08:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715761607;
	bh=oBjUWM9Ueajikuvb1TVY6pQjtCf2aE1BFiQMqZCZ8Yk=;
	h=From:To:Cc:Subject:Date:From;
	b=ZAEHkl5F6AvMBaIQJ+PH0UcVSPbqYSvbnhEg90Szxx9NC5AQXdZCMQOk/wwRqCeYP
	 EMMXvlwnuEa156QxA3UEdAD4j8e840I/Z9zsTaa/I89ip+vnqHorVBMW9un+HJ0Z7H
	 PPshhBFp0zeCGN4DfnQyT69189VVjtvr3lx0tbxM=
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
Subject: [PATCH 6.9 0/5] 6.9.1-rc1 review
Date: Wed, 15 May 2024 10:26:37 +0200
Message-ID: <20240515082345.213796290@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.1-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.9.1-rc1
X-KernelTest-Deadline: 2024-05-17T08:23+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.9.1 release.
There are 5 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.1-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.9.1-rc1

Ben Greear <greearb@candelatech.com>
    wifi: mt76: mt7915: add missing chanctx ops

Silvio Gissi <sifonsec@amazon.com>
    keys: Fix overwrite of key expiration on instantiation

Nikhil Rao <nikhil.rao@intel.com>
    dmaengine: idxd: add a write() method for applications to submit work

Arjan van de Ven <arjan@linux.intel.com>
    dmaengine: idxd: add a new security check to deal with a hardware erratum

Arjan van de Ven <arjan@linux.intel.com>
    VFIO: Add the SPR_DSA and SPR_IAX devices to the denylist


-------------

Diffstat:

 Makefile                                         |  4 +-
 drivers/dma/idxd/cdev.c                          | 77 ++++++++++++++++++++++++
 drivers/dma/idxd/idxd.h                          |  3 +
 drivers/dma/idxd/init.c                          |  4 ++
 drivers/dma/idxd/registers.h                     |  3 -
 drivers/dma/idxd/sysfs.c                         | 27 ++++++++-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c |  4 ++
 drivers/vfio/pci/vfio_pci.c                      |  2 +
 include/linux/pci_ids.h                          |  2 +
 security/keys/key.c                              |  3 +-
 10 files changed, 121 insertions(+), 8 deletions(-)


