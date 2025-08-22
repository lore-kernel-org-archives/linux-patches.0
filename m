Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6241A19007D;
	Fri, 22 Aug 2025 12:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755866237; cv=none; b=Eo0f47uZ+gjkwQz7t1VsFj8FeLWWMJ1/T2gwp6+6R6OdWi2NfU2O08y3uZINr62Gr6MbjJi4p6t9bEEHjkmV/IO+702JzggT5k4ttZYiXRhdHO99moE+jiH4A7df7aKi3bsQxPUZ/6nwQPg2c5+p6tuQw0lX0oDE8JsRSdPD3WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755866237; c=relaxed/simple;
	bh=qV4yCJDW8fgYgPrO31lo0L8XmfA+YRYPx/g5jRK736s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K/WuhDT48R8+Y2iCgOCRyB8/qIY8F4cczXM6lUPnaLkshgjpYZvvCNS22x/264I2GDbYZC2AZoXb96rNMxAnh+HMVy6D/YoiRajTDE/vMFip/BJfAotYmVurfoHd08O365cLMinBxskD1oq1wGsHtk5idKbR0qyR4noZxI/Mkrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APMRnes3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APMRnes3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FE6C4CEED;
	Fri, 22 Aug 2025 12:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755866237;
	bh=qV4yCJDW8fgYgPrO31lo0L8XmfA+YRYPx/g5jRK736s=;
	h=From:To:Cc:Subject:Date:From;
	b=APMRnes3Worxq2nQzPT4QtJnka3GYi5lFLoxITXoykNWH42Ibck0W9TDufgTj4OdV
	 NsmAxxjx/0pi/UBAA7FhWFyLHdmvKTBS6N+RWhYUjdgSnzGDtAZB2ukJS2O2l4xCL3
	 TDj2YSP2+JlUBhM1XgVB5ny3Irgmq/0/VaVsVhFM=
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
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org
Subject: [PATCH 6.16 0/9] 6.16.3-rc1 review
Date: Fri, 22 Aug 2025 14:37:00 +0200
Message-ID: <20250822123516.780248736@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.16.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.16.3-rc1
X-KernelTest-Deadline: 2025-08-24T12:35+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.16.3 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 24 Aug 2025 12:35:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.16.3-rc1

Zhang Yi <yi.zhang@huawei.com>
    ext4: replace ext4_writepage_trans_blocks()

Zhang Yi <yi.zhang@huawei.com>
    ext4: reserved credits for one extent during the folio writeback

Zhang Yi <yi.zhang@huawei.com>
    ext4: correct the reserved credits for extent conversion

Zhang Yi <yi.zhang@huawei.com>
    ext4: enhance tracepoints during the folios writeback

Zhang Yi <yi.zhang@huawei.com>
    ext4: restart handle if credits are insufficient during allocating blocks

Zhang Yi <yi.zhang@huawei.com>
    ext4: refactor the block allocation process of ext4_page_mkwrite()

Zhang Yi <yi.zhang@huawei.com>
    ext4: fix stale data if it bail out of the extents mapping loop

Zhang Yi <yi.zhang@huawei.com>
    ext4: move the calculation of wbc->nr_to_write to mpage_folio_done()

Zhang Yi <yi.zhang@huawei.com>
    ext4: process folios writeback in bytes


-------------

Diffstat:

 Makefile                    |   4 +-
 fs/ext4/ext4.h              |   2 +-
 fs/ext4/extents.c           |   6 +-
 fs/ext4/inline.c            |   6 +-
 fs/ext4/inode.c             | 323 +++++++++++++++++++++++++++-----------------
 fs/ext4/move_extent.c       |   3 +-
 fs/ext4/xattr.c             |   2 +-
 include/trace/events/ext4.h |  47 +++++--
 8 files changed, 251 insertions(+), 142 deletions(-)


