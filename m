Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA9913C66A;
	Thu, 23 May 2024 13:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470331; cv=none; b=sh2fYVPYbdCXzl4Qtk5qpw5gXzQd3M1WPhowEYvxO8++Dtt1Yxb2Kc25DS0zyULcmOrbmCm2cs/eOkZy5qRVqS92DPa0EjOZKCred9VJmS8RjAko0XvmuJHa2EBdCk4365CxCdZ5aI5MArZyHh3daVggPb8b/m66zhw+UYqqs/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470331; c=relaxed/simple;
	bh=rf0H/0zXq6MWa/jgcYccnJNhQhS7/5+iqtLrcPg9K8o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=IckVHZCY5sHN+tRWR/NPHYPDYFWfMN5IDEgpLzAkJiR7jGoMDWBzNlXfm3kyyeRIpo8yTDLV8gmW7d0lBw2y3tAoLFP5Bpd3AsNTO0rYy9kS5iDhWrmiFFtEx5i3vTrkgkWkiDY9xSggMoXQYBbpjoJ+KtWKBO588DQzc97AChU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FwzfM1vP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FwzfM1vP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E10CC32781;
	Thu, 23 May 2024 13:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470331;
	bh=rf0H/0zXq6MWa/jgcYccnJNhQhS7/5+iqtLrcPg9K8o=;
	h=From:To:Cc:Subject:Date:From;
	b=FwzfM1vPePs3kcDanivbTCC+jQ91ERA+HhmErhRZ8HTF819qlBabg7Th2RNAPUoE1
	 P+Govhe/c303VXcaEkDma0yk908l+3nf0AWUuCrEwqykEdx6mDw0b0RTZ510njfKmD
	 YPzioB+spGi4l2rMvOntLBB3JThZXPK6pKlhoOzA=
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
Subject: [PATCH 5.15 00/23] 5.15.160-rc1 review
Date: Thu, 23 May 2024 15:12:56 +0200
Message-ID: <20240523130327.956341021@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.160-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.160-rc1
X-KernelTest-Deadline: 2024-05-25T13:03+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.15.160 release.
There are 23 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.160-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.160-rc1

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

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    usb: typec: ucsi: displayport: Fix potential deadlock

Carlos Llamas <cmllamas@google.com>
    binder: fix max_thread type inconsistency

Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
    drm/amdgpu: Fix possible NULL dereference in amdgpu_ras_query_error_status_helper()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Clear "has_error_code", not "error_code", for RM exception injection

Eric Dumazet <edumazet@google.com>
    netlink: annotate data-races around sk->sk_err

Eric Dumazet <edumazet@google.com>
    netlink: annotate lockless accesses to nlk->max_recvmsg_len

Jakub Kicinski <kuba@kernel.org>
    net: tls: handle backlogging of crypto requests

Jakub Kicinski <kuba@kernel.org>
    tls: fix race between async notify and socket close

Jakub Kicinski <kuba@kernel.org>
    net: tls: factor out tls_*crypt_async_wait()

Sabrina Dubroca <sd@queasysnail.net>
    tls: extract context alloc/initialization out of tls_set_sw_offload

Jakub Kicinski <kuba@kernel.org>
    tls: rx: simplify async wait

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize UMAC_CMD access

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL access

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"

Jarkko Sakkinen <jarkko@kernel.org>
    KEYS: trusted: Fix memory leak in tpm2_key_encode()

NeilBrown <neilb@suse.de>
    nfsd: don't allow nfsd threads to be signalled.

Sergey Shtylyov <s.shtylyov@omp.ru>
    pinctrl: core: handle radix_tree_insert() errors in pinctrl_register_one_pin()

Jose Fernandez <josef@netflix.com>
    drm/amd/display: Fix division by zero in setup_dsc_config


-------------

Diffstat:

 .../admin-guide/hw-vuln/core-scheduling.rst        |   4 +-
 Documentation/sphinx/kernel_include.py             |   1 -
 Makefile                                           |   4 +-
 arch/x86/kvm/x86.c                                 |  11 +-
 drivers/android/binder.c                           |   2 +-
 drivers/android/binder_internal.h                  |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |   3 +
 drivers/gpu/drm/amd/display/dc/dsc/dc_dsc.c        |   7 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  12 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |   2 +
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   6 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   4 +
 drivers/pinctrl/core.c                             |  14 +-
 drivers/remoteproc/mtk_scp.c                       |  10 +-
 drivers/tty/serial/kgdboc.c                        |  30 +++-
 drivers/usb/typec/ucsi/displayport.c               |   4 -
 fs/nfs/callback.c                                  |   9 +-
 fs/nfsd/nfs4proc.c                                 |   5 +-
 fs/nfsd/nfssvc.c                                   |  12 --
 include/net/tls.h                                  |   6 -
 net/netlink/af_netlink.c                           |  23 +--
 net/sunrpc/svc_xprt.c                              |  16 +-
 net/tls/tls_sw.c                                   | 199 +++++++++++----------
 security/keys/trusted-keys/trusted_tpm2.c          |  25 ++-
 tools/testing/selftests/vm/map_hugetlb.c           |   7 -
 25 files changed, 243 insertions(+), 175 deletions(-)


