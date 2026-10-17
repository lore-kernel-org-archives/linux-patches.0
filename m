Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8791B4CF477;
	Sat, 17 Oct 2026 15:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252487; cv=none; b=SVmfOPOVjJFrI0wMujyS77kDmbDu2WTkeZFi5w3JL2zGT0gk0dQSp881l16zJn3UB1Mrbb/TbXXNp+FXP6stNB4Cx74TsYmzEZ41mqhXqlbjaixMQqZPF6qNAYOharUvVotT5oeixWoGqyQbHbTjGW+/rDWVA06hqQJr7Mh6/9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252487; c=relaxed/simple;
	bh=cvM0ERiAe9O3Ku7MzR+agwiQBO0w3OAQxrXOLrpTFo4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qdMzY3Ulu885bWfOeV/YnkSsUl4dwqoK8ZPovKlcI9wQzVnuHeO8VIsyzVn8f3LMFwjDvaG0OE4vETUXds85jDwf8lTaDHLN0GwGym/JoXTIBCWtOz0uHHEq2s+mQBThhBofvM1LgJxnmg8tbS8reqOebuRnBzcnluUOeJtxnuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eINv1Qzq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eINv1Qzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AB51F000C4;
	Sat, 17 Oct 2026 15:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252486;
	bh=s6NlN76FqQnDqgRvILDz5Y1L4nf2BH0nTEER0nP3RZ8=;
	h=From:To:Cc:Subject:Date;
	b=eINv1QzqpfJ9Q6m+MuM43GtZWn8jlfJhlTGmMVm0ht6S5DfEMxW1/oXlWqiGJojw8
	 6B30ZM1wW7sAS4ONh8SIDe01yXpLHvwoh66N57QIj8R9KRoDSpPBlTKP7EDhQ3tTHr
	 4aD+bxeoqg9IR34r0ZUCdwTNIwLOP5bisZKJYqRY=
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
Subject: [PATCH 7.2 00/10] 7.2.12-rc1 review
Date: Sat, 17 Oct 2026 17:54:29 +0200
Message-ID: <20261017155059.698368299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.12-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-7.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 7.2.12-rc1
X-KernelTest-Deadline: 2026-10-19T15:51+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 7.2.12 release.
There are 10 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Mon, 19 Oct 2026 15:50:51 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.12-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 7.2.12-rc1

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs35l56: Add DAI for SDCA OT25 stream

Toke Høiland-Jørgensen <toke@toke.dk>
    wifi: atk9k: Revert "wifi: ath9k: reject short WMI command responses"

Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
    net: mana: reserve RX buffer headroom to fix forwarding performance

Dipayaan Roy <dipayanroy@linux.microsoft.com>
    net: mana: refactor mana_get_strings() and mana_get_sset_count() to use switch

Christian Brauner <brauner@kernel.org>
    readdir: take no inode lock on an immutable directory

Christian Brauner <brauner@kernel.org>
    nullfs: refuse file locks

Tejun Heo <tj@kernel.org>
    sched_ext: Fix CPU hotplug hang when a dying CPU's tasks sit in the BPF scheduler

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: validate the superblock on resume

Mikulas Patocka <mpatocka@redhat.com>
    dm-integrity: fix NULL pointer dereference when the 'R' flag is used

Lubos Rendek <l.rendek@proxmox.com>
    nfsd: fix all-zero stateid in CB_OFFLOAD for async COPY


-------------

Diffstat:

 Makefile                                           |  4 +-
 drivers/md/dm-integrity.c                          | 55 +++++++++++++
 drivers/net/ethernet/microsoft/mana/mana_bpf.c     |  8 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      | 60 ++++++++++----
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c | 95 +++++++++++++---------
 drivers/net/wireless/ath/ath9k/wmi.c               | 16 +---
 drivers/net/wireless/ath/ath9k/wmi.h               |  1 -
 fs/nfsd/nfs4proc.c                                 |  2 +
 fs/nullfs.c                                        | 30 +++++++
 fs/readdir.c                                       | 13 ++-
 include/linux/fs.h                                 |  2 +
 include/net/mana/mana.h                            | 14 +++-
 include/sound/cs35l56.h                            |  1 +
 kernel/sched/ext/ext.c                             | 29 ++++++-
 kernel/sched/sched.h                               |  5 +-
 sound/soc/codecs/cs35l56-sdw.c                     |  9 +-
 sound/soc/codecs/cs35l56.c                         | 54 ++++++++++++
 17 files changed, 312 insertions(+), 86 deletions(-)


