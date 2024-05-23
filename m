Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6563A13A897;
	Thu, 23 May 2024 13:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470211; cv=none; b=cQp0W8z5Vta4fC8Bm+r1whJ7eslZDyqzwaGqfeypoc0ZkxhPvRqnLZE92G6RZdbMYQPMeM8+YxdiiT/+lGHoQdXHbqVJqK2RwOXc3fjjaRssAJw6uECE4uMd0eGWxroWlJ2uYA3TX0K9N0br/PSlAOIyeklQz7v9wTyBWCKQuJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470211; c=relaxed/simple;
	bh=EvnzBjcmnpVtd570HCf9DX1kYFonpcTI0KodIPfqSrA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RCypsbYCyr7m9AmQFnOQLiqCD3O0nWM6re2An+CVVxt1RzHp0AY9BVnyfDv8ZSiO9k7SuwDal0ropur4eKW3E5dodkXeqA5kRfw/vIfX7YFvzrall3QDST0b6YwCbrhgCJhKsK4fDiBc/lMrkamn1Jdpphv2H+O4JRaNrUPVBFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVsu1lVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVsu1lVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F80C32781;
	Thu, 23 May 2024 13:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470211;
	bh=EvnzBjcmnpVtd570HCf9DX1kYFonpcTI0KodIPfqSrA=;
	h=From:To:Cc:Subject:Date:From;
	b=TVsu1lVh6MqJSZNWRPRg49vKnV6g4DLmbwnQbc7ZWM53119Gaaw5WosC5R9WOt1IT
	 XTJzkRqvvKvdX6Kz6/5FrQ5cAeh4OywYdPa5LyJWgSZZg+L8m5cvQav1uOrPmdIZpj
	 LemXiaSuXjrF9dW51Iw7qS+g/1QAfkLR0yyXPajQ=
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
Subject: [PATCH 5.10 00/15] 5.10.218-rc1 review
Date: Thu, 23 May 2024 15:12:42 +0200
Message-ID: <20240523130326.451548488@linuxfoundation.org>
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
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.218-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.218-rc1
X-KernelTest-Deadline: 2024-05-25T13:03+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 5.10.218 release.
There are 15 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.218-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.218-rc1

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

Paolo Abeni <pabeni@redhat.com>
    mptcp: ensure snd_nxt is properly initialized on connect

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Harden accesses to the reset domains

Sean Christopherson <seanjc@google.com>
    KVM: x86: Clear "has_error_code", not "error_code", for RM exception injection

Eric Dumazet <edumazet@google.com>
    netlink: annotate lockless accesses to nlk->max_recvmsg_len

liqiong <liqiong@nfschina.com>
    ima: fix deadlock when traversing "ima_default_rules".

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize UMAC_CMD access

Doug Berger <opendmb@gmail.com>
    net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL access

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"

Juergen Gross <jgross@suse.com>
    x86/xen: Drop USERGS_SYSRET64 paravirt call

Sergey Shtylyov <s.shtylyov@omp.ru>
    pinctrl: core: handle radix_tree_insert() errors in pinctrl_register_one_pin()


-------------

Diffstat:

 Documentation/sphinx/kernel_include.py             |  1 -
 Makefile                                           |  4 +--
 arch/x86/entry/entry_64.S                          | 17 ++++++------
 arch/x86/include/asm/irqflags.h                    |  7 -----
 arch/x86/include/asm/paravirt.h                    |  5 ----
 arch/x86/include/asm/paravirt_types.h              |  8 ------
 arch/x86/kernel/asm-offsets_64.c                   |  2 --
 arch/x86/kernel/paravirt.c                         |  5 +---
 arch/x86/kernel/paravirt_patch.c                   |  4 ---
 arch/x86/kvm/x86.c                                 | 11 ++++++--
 arch/x86/xen/enlighten_pv.c                        |  1 -
 arch/x86/xen/xen-asm.S                             | 21 ---------------
 arch/x86/xen/xen-ops.h                             |  2 --
 drivers/firmware/arm_scmi/reset.c                  |  6 ++++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  3 +++
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 12 ++++++++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  2 ++
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  6 +++++
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |  4 +++
 drivers/pinctrl/core.c                             | 14 +++++++---
 drivers/tty/serial/kgdboc.c                        | 30 +++++++++++++++++++++-
 drivers/usb/typec/ucsi/displayport.c               |  4 ---
 fs/btrfs/volumes.c                                 |  1 +
 net/mptcp/protocol.c                               |  2 ++
 net/netlink/af_netlink.c                           | 15 ++++++-----
 security/integrity/ima/ima_policy.c                | 29 ++++++++++++++-------
 tools/testing/selftests/vm/map_hugetlb.c           |  7 -----
 27 files changed, 123 insertions(+), 100 deletions(-)


