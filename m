Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569D17C
	for <patches@lists.linux.dev>; Fri, 14 Apr 2023 05:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=rAZqO82F1I0YGFsgUNXQwTj+e9P8wOwZV9QtPxI6P38=; b=bc/u6WCFQZojSgMvyIiz3X7lyZ
	rFHkuz0ynpTeAyRE+/Jk5/cNm1npCGKkZgFqljcPNe9qAAzTX8WLMu4nPRwfQuT5LywMLCs7ld35+
	7Jd9sQIbyPJVlKs16pkNqs6ZP/bjiP4Ui9n24Y1/zPcuRF2nP9nSDlBaNBO7D0JHePLMbBu3s4+A8
	JgLwuN02OniU1Z8SOy+zln93sZ50GAhgw/IJXmQ3LjgDiwydbnYHr6D+JeXKQyBGce5epEa4WF+W3
	BDEIqRchJS7HEKn8unwFyD1nCdbyoCbKUmqdr8adj49tDFNG+Tk+BxUgxXe+9qEKtgb8d3kzRDggu
	zf7VaypQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pnBks-008KqT-1X;
	Fri, 14 Apr 2023 05:13:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: david@redhat.com,
	patches@lists.linux.dev,
	linux-modules@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pmladek@suse.com,
	petr.pavlu@suse.com,
	prarit@redhat.com,
	torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org
Cc: christophe.leroy@csgroup.eu,
	tglx@linutronix.de,
	peterz@infradead.org,
	song@kernel.org,
	rppt@kernel.org,
	dave@stgolabs.net,
	willy@infradead.org,
	vbabka@suse.cz,
	mhocko@suse.com,
	dave.hansen@linux.intel.com,
	colin.i.king@gmail.com,
	jim.cromie@gmail.com,
	catalin.marinas@arm.com,
	jbaron@akamai.com,
	rick.p.edgecombe@intel.com,
	mcgrof@kernel.org
Subject: [PATCH v3 0/2] modules/kmod: replace implementation with a sempahore
Date: Thu, 13 Apr 2023 22:13:47 -0700
Message-Id: <20230414051349.1986744-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

On this v3:

  o Tons of spell checks thanks to Miroslav Benes
  o Fixed a stupid bug where I was using the timeout without HZ as
    reported by Miroslav Benes
  o Enanced the tribal knowledge docs for the semaphore Vs mutex
    considerations folks might make as suggested by Matthew Wilcox
  o Added tags for patches

Luis Chamberlain (1):
  modules/kmod: replace implementation with a semaphore

Peter Zijlstra (1):
  Change DEFINE_SEMAPHORE() to take a number argument

 arch/mips/cavium-octeon/setup.c               |  2 +-
 arch/x86/kernel/cpu/intel.c                   |  2 +-
 drivers/firmware/efi/runtime-wrappers.c       |  2 +-
 drivers/firmware/efi/vars.c                   |  2 +-
 drivers/macintosh/adb.c                       |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  2 +-
 drivers/platform/x86/intel/ifs/sysfs.c        |  2 +-
 drivers/scsi/esas2r/esas2r_ioctl.c            |  2 +-
 .../interface/vchiq_arm/vchiq_arm.c           |  2 +-
 include/linux/semaphore.h                     | 11 ++++++--
 kernel/module/kmod.c                          | 26 +++++--------------
 kernel/printk/printk.c                        |  2 +-
 net/rxrpc/call_object.c                       |  6 ++---
 13 files changed, 28 insertions(+), 35 deletions(-)

-- 
2.39.2

