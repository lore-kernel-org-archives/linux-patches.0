Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09C4185C
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D2AC433C8;
	Sun,  9 Jul 2023 11:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901264;
	bh=6NG0UDJmojKsjSjmW5IQPJUwWL5kB0Z5e43SQ5ydKCw=;
	h=From:To:Cc:Subject:Date:From;
	b=i9brZNQi1EBxa9c4j6iveBU9uZINqjfpsqFHdlqccjC9sRRNKs9RGgnj4e4McPv3R
	 D6TAVoNhg5nDprv7becVG2lySfF5w0Ut5JMWTaXUHjyEuh2BMYUuzFtzzjMHqw2XAj
	 5Bog3VH8G76hw/kiPZWKefQHRNm8XAI8a2mvWqlM=
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
	conor@kernel.org
Subject: [PATCH 6.4 0/8] 6.4.3-rc1 review
Date: Sun,  9 Jul 2023 13:14:06 +0200
Message-ID: <20230709111345.297026264@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.4.3-rc1
X-KernelTest-Deadline: 2023-07-11T11:13+00:00
Content-Transfer-Encoding: 8bit

This is the start of the stable review cycle for the 6.4.3 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Tue, 11 Jul 2023 11:13:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.4.3-rc1

Suren Baghdasaryan <surenb@google.com>
    fork: lock VMAs of the parent process when forking, again

Suren Baghdasaryan <surenb@google.com>
    fork: lock VMAs of the parent process when forking

Liu Shixin <liushixin2@huawei.com>
    bootmem: remove the vmemmap pages from kmemleak in free_bootmem_page

Peter Collingbourne <pcc@google.com>
    mm: call arch_swap_restore() from do_swap_page()

Hugh Dickins <hughd@google.com>
    mm: lock newly mapped VMA with corrected ordering

Suren Baghdasaryan <surenb@google.com>
    mm: lock newly mapped VMA which can be modified after it becomes visible

Suren Baghdasaryan <surenb@google.com>
    mm: lock a vma before stack expansion

Suren Baghdasaryan <surenb@google.com>
    mm: disable CONFIG_PER_VMA_LOCK until its fixed


-------------

Diffstat:

 Makefile                     | 4 ++--
 include/linux/bootmem_info.h | 2 ++
 kernel/fork.c                | 7 +++++++
 mm/Kconfig                   | 3 ++-
 mm/memory.c                  | 7 +++++++
 mm/mmap.c                    | 6 ++++++
 6 files changed, 26 insertions(+), 3 deletions(-)


