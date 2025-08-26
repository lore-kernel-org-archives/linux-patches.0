Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2660E3376BA;
	Tue, 26 Aug 2025 11:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207673; cv=none; b=F4wXSfrsRhpmuvwWoBDLyZp0jN8Tb+in/wuGdripB0F2uUHo2+n3xhsfz/nBVRT5zWakAu2avzKgzv1M65iOvxXGGEspPT7oT5fKGRQADodXslTcb8gzC51TKjxvDpH8d0OkFPCiXatCRtIgNDd0lRauDowENWslx/2mNadB6oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207673; c=relaxed/simple;
	bh=Pxb+Th4uZ4jVtX/oJkVnkRCAFCge3L2gK7UOBk/BSP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=je5Nw6EIwzk03gwaQRCososw0iGAEFVhIYLsBFQOc9h6GH9VzrdeRDmLIy97tUmSFDQi1l1MHaxgOxwIdKOsElSMBuDuXJTc7fdbqwQIjgDAp3hsCIFHddtbmmk6oGtBxYfRoEBMhGkIaUBm3BL8AoeLW9RYYex+k3cIa8to2QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKGv3DMM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKGv3DMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C98C4CEF4;
	Tue, 26 Aug 2025 11:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207672;
	bh=Pxb+Th4uZ4jVtX/oJkVnkRCAFCge3L2gK7UOBk/BSP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKGv3DMM0MqjO1RvPe/2h0J6iB0McujFvaZ+RTQi6pXOn7j5fm2xIrTuYNi5kZdrq
	 1w2aTk/gpQ7/YV+ODIYE8F8DCm0Vb0TcxSctLBdGzmIKVpUrv9mK7C1SkPAJK6vezF
	 1QQh9iQDDu9mA9jESTI+GU1Es5xpMnyAh/FOeMl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 273/457] scsi: mpi3mr: Drop unnecessary volatile from __iomem pointers
Date: Tue, 26 Aug 2025 13:09:17 +0200
Message-ID: <20250826110944.126732452@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 6853885b21cb1d7157cc14c9d30cc17141565bae ]

The volatile qualifier is redundant for __iomem pointers.

Cleaned up usage in mpi3mr_writeq() and sysif_regs pointer as per
Upstream compliance.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250627194539.48851-3-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: c91e140c82eb ("scsi: mpi3mr: Serialize admin queue BAR writes on 32-bit systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |    2 +-
 drivers/scsi/mpi3mr/mpi3mr_fw.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -1185,7 +1185,7 @@ struct mpi3mr_ioc {
 	char name[MPI3MR_NAME_LENGTH];
 	char driver_name[MPI3MR_NAME_LENGTH];
 
-	volatile struct mpi3_sysif_registers __iomem *sysif_regs;
+	struct mpi3_sysif_registers __iomem *sysif_regs;
 	resource_size_t sysif_regs_phys;
 	int bars;
 	u64 dma_mask;
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -23,12 +23,12 @@ module_param(poll_queues, int, 0444);
 MODULE_PARM_DESC(poll_queues, "Number of queues for io_uring poll mode. (Range 1 - 126)");
 
 #if defined(writeq) && defined(CONFIG_64BIT)
-static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
+static inline void mpi3mr_writeq(__u64 b, void __iomem *addr)
 {
 	writeq(b, addr);
 }
 #else
-static inline void mpi3mr_writeq(__u64 b, volatile void __iomem *addr)
+static inline void mpi3mr_writeq(__u64 b, void __iomem *addr)
 {
 	__u64 data_out = b;
 


