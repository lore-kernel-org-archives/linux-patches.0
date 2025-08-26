Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21449374C4;
	Tue, 26 Aug 2025 14:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217041; cv=none; b=bKCubdEqCG+Q5K8WBx326lN+OcoYmpwhYjRcR6PIy3AZ+hEWNk5T2IzzRO4uHZRoW8koSkYNkKmJI4a+2ns0dvIOfYF/PQ2PPn48uTeSrkQRKQ9/TOHhxoglnf7bVANJV97ZeU9zwYNjEvBQEvcZeGmWAzcGToS2FaydP/binEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217041; c=relaxed/simple;
	bh=xOUMMlvNlkBsn7jhN5wCaSUruNqOmF+8tUZo/crnUco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKEz6xIQ24e+fHPKGAwe0zPtkJ4f1ciS8uxQW442TIqpXprEg5AMJDBZDIX9r9RBE1otxnlhClQzAYdGQVMb6z5xWMQtnyqNYB4syZpT9QSNAzzqspSHVxxQP+7FaF54dQvQIycPKCnFhAND1r3T6m6abPY+oXuKEorF/pZQlew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUY3nz14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUY3nz14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C239C4CEF1;
	Tue, 26 Aug 2025 14:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217039;
	bh=xOUMMlvNlkBsn7jhN5wCaSUruNqOmF+8tUZo/crnUco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUY3nz14lpcuRQZyEw2b+bZi3uaQvVKuOGX9Mt7x0U2VBa+IAtfv6ka+mYFd2pna7
	 ScCw/19MYBeS1jW750iYTWR3zz/sa07pmVtFzSfXKUc7CZswrYld5LkPjSj5EGAacE
	 51F3G/53Upz4aAaOyQ0dSyLYs4ykC+DkMMe3LGVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 606/644] scsi: mpi3mr: Drop unnecessary volatile from __iomem pointers
Date: Tue, 26 Aug 2025 13:11:37 +0200
Message-ID: <20250826111001.567903099@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -714,7 +714,7 @@ struct mpi3mr_ioc {
 	char name[MPI3MR_NAME_LENGTH];
 	char driver_name[MPI3MR_NAME_LENGTH];
 
-	volatile struct mpi3_sysif_registers __iomem *sysif_regs;
+	struct mpi3_sysif_registers __iomem *sysif_regs;
 	resource_size_t sysif_regs_phys;
 	int bars;
 	u64 dma_mask;
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -11,12 +11,12 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 
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
 


