Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7463B1D555;
	Thu, 23 May 2024 13:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470151; cv=none; b=Ey4ZDb4S1vEpLmmaWTXbXXgdPriamnkG6VLoroh3QKNHvx1iEpreR7ztqEYJYXBHd/sR8kDxTZbmlDgwYgrJFb7rO97KeDf2y+DCyWzTy44uAr8iZwvTje9PT6MHfblsIZIP6yf0+kzANZsc4HQvh02oJ6c18iFGPUR8ZQrXKnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470151; c=relaxed/simple;
	bh=Mt40WalPBV+6m7xYF/DZKqbqaHNN2wWWKrpvMV5GrIo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GX9hxNsoUEncWC1XMCD94hdHoDqJVsmYUu2l3KvYlVz0C5tKI9lQbiB6errJwlP0WLBFo3tSHMT2etHZqd2lTf9xhkQPOB42scjC8fySI2Tss+Nj/7ht1pQwa4mHvQZioZ8fSZ+pzsak7xLZP2z/tDYELKA9QQJlk+BednClhCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K1W4KnvL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K1W4KnvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C696AC2BD10;
	Thu, 23 May 2024 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470151;
	bh=Mt40WalPBV+6m7xYF/DZKqbqaHNN2wWWKrpvMV5GrIo=;
	h=From:To:Cc:Subject:Date:From;
	b=K1W4KnvLB1q5vUNfDnYpvTWbCb+y5ivuSeZNcekXiskPWMaOtBF9BJW7+dVQxxm+G
	 NbAs49Y+pWBDtymn9t5KR5SIKgC3wcrgdsEiunWRbEWStGn14qgFBeItxVhfcJSzNN
	 D46RtkeO34QZEfusnRwygI81vzpkEyU44hlGKBk8=
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
Subject: [PATCH 5.4 00/16] 5.4.277-rc1 review
Date: Thu, 23 May 2024 15:12:33 +0200
Message-ID: <20240523130325.743454852@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.277-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.277-rc1
X-KernelTest-Deadline: 2024-05-25T13:03+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.4.277 release.
There are 16 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.277-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.277-rc1

Akira Yokosawa <akiyks@gmail.com>
    docs: kernel_include.py: Cope with docutils 0.21

Daniel Thompson <daniel.thompson@linaro.org>
    serial: kgdboc: Fix NMI-safety problems from keyboard reset code

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: displayport: Fix potential deadlock

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix possible NULL dereference in amdgpu_ras_query_error_status_helper()

Dominique Martinet <dominique.martinet@atmark-techno.com>
    btrfs: add missing mutex_unlock in btrfs_relocate_sys_chunks()

Rob Herring <robh@kernel.org>
    arm64: dts: qcom: Fix 'interrupt-map' parent address cells

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Harden accesses to the reset domains

Paulo Alcantara <pc@manguebit.com>
    smb: client: fix potential OOBs in smb2_parse_contexts()

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize UMAC_CMD access

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize use of bcmgenet_set_rx_mode()

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL access

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: keep MAC in reset until PHY is up

Doug Berger <opendmb@gmail.com>
    Revert "net: bcmgenet: use RGMII loopback for MAC reset"

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"

Baokun Li <libaokun1@huawei.com>
    ext4: fix bug_on in __es_tree_search

Sergey Shtylyov <s.shtylyov@omp.ru>
    pinctrl: core: handle radix_tree_insert() errors in pinctrl_register_one_pin()


-------------

Diffstat:

 Documentation/sphinx/kernel_include.py             |  1 -
 Makefile                                           |  4 +-
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |  8 +--
 drivers/firmware/arm_scmi/reset.c                  |  6 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  3 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 22 ++++--
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  2 +
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c | 12 +++-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       | 43 +++---------
 drivers/pinctrl/core.c                             | 14 +++-
 drivers/tty/serial/kgdboc.c                        | 30 +++++++-
 drivers/usb/typec/ucsi/displayport.c               |  4 --
 fs/btrfs/volumes.c                                 |  1 +
 fs/cifs/smb2ops.c                                  |  4 +-
 fs/cifs/smb2pdu.c                                  | 79 ++++++++++++++--------
 fs/cifs/smb2proto.h                                | 10 +--
 fs/ext4/extents.c                                  | 10 +--
 tools/testing/selftests/vm/map_hugetlb.c           |  7 --
 18 files changed, 161 insertions(+), 99 deletions(-)


