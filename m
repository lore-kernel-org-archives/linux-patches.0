Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8A21A6192;
	Tue, 30 Jul 2024 16:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357418; cv=none; b=Pzs8z5qTkduCVnF94gXikH1bHsFL/6QNqASzsY3H3DqBdYPOfTGqEZ9jmvjiwgi4MBBvwAEEfeTV5LMOuAKo9Z6M5c8ZzFmlNgKLlDkV9A5g3NWNnsgSp5FMAdfSMQeN9+PEV4JwucQDnjFPhC83GccvSRJV83eNLEgtfRvWTrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357418; c=relaxed/simple;
	bh=3wZIDg2WfY8ePF0xx2wFgRGmUfIr0nlUVWybplN+Y3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drhU2XedL7/3nnDGItyowpuZB93iCL1ohacDdh157Pnqf0ILS9eBj7Qboan+Cc3ppx/l4+55Uz0N14Asb7aOGZL8VtjV2vop047lFY007Q6+RAPBC+KCg0Zvz6LAiiZAJ3MdHoUGZnnEB+ttyFMlQAYfU2SJ3bJO/exMJFo0IG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJCQyKTM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJCQyKTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCD6C32782;
	Tue, 30 Jul 2024 16:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357417;
	bh=3wZIDg2WfY8ePF0xx2wFgRGmUfIr0nlUVWybplN+Y3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJCQyKTMyCbrfc5JGnry2MhFTsOiP/yfKb42X0WWv1vlj8Cd3s47lanqWM6O/qtV5
	 TrT9CDcXnlmmvyotIzF1agwKT84grsaysWlGGMcloiZzSoCgs46NHRQRK92k4Z/1Jy
	 QY7GZWoRAikp9UIGOM4VDad+/C+6WQnHK9JVamq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 253/568] scsi: ufs: mcq: Fix missing argument hba in MCQ_OPR_OFFSET_n
Date: Tue, 30 Jul 2024 17:46:00 +0200
Message-ID: <20240730151649.769202278@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minwoo Im <minwoo.im@samsung.com>

[ Upstream commit 2fc39848952dfb91a9233563cc1444669b8e79c3 ]

The MCQ_OPR_OFFSET_n macro takes 'hba' in the caller context without
receiving 'hba' instance as an argument.  To prevent potential bugs in
future use cases, add an argument 'hba'.

Fixes: 2468da61ea09 ("scsi: ufs: core: mcq: Configure operation and runtime interface")
Cc: Asutosh Das <quic_asutoshd@quicinc.com>
Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
Link: https://lore.kernel.org/r/20240519221457.772346-2-minwoo.im@samsung.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 10 ++++------
 include/ufs/ufshcd.h       |  6 ++++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index a10fc7a697109..af5ce45315b3c 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -230,8 +230,6 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
 
 /* Operation and runtime registers configuration */
 #define MCQ_CFG_n(r, i)	((r) + MCQ_QCFG_SIZE * (i))
-#define MCQ_OPR_OFFSET_n(p, i) \
-	(hba->mcq_opr[(p)].offset + hba->mcq_opr[(p)].stride * (i))
 
 static void __iomem *mcq_opr_base(struct ufs_hba *hba,
 					 enum ufshcd_mcq_opr n, int i)
@@ -344,10 +342,10 @@ void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
 		ufsmcq_writelx(hba, upper_32_bits(hwq->sqe_dma_addr),
 			      MCQ_CFG_n(REG_SQUBA, i));
 		/* Submission Queue Doorbell Address Offset */
-		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(OPR_SQD, i),
+		ufsmcq_writelx(hba, ufshcd_mcq_opr_offset(hba, OPR_SQD, i),
 			      MCQ_CFG_n(REG_SQDAO, i));
 		/* Submission Queue Interrupt Status Address Offset */
-		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(OPR_SQIS, i),
+		ufsmcq_writelx(hba, ufshcd_mcq_opr_offset(hba, OPR_SQIS, i),
 			      MCQ_CFG_n(REG_SQISAO, i));
 
 		/* Completion Queue Lower Base Address */
@@ -357,10 +355,10 @@ void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
 		ufsmcq_writelx(hba, upper_32_bits(hwq->cqe_dma_addr),
 			      MCQ_CFG_n(REG_CQUBA, i));
 		/* Completion Queue Doorbell Address Offset */
-		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(OPR_CQD, i),
+		ufsmcq_writelx(hba, ufshcd_mcq_opr_offset(hba, OPR_CQD, i),
 			      MCQ_CFG_n(REG_CQDAO, i));
 		/* Completion Queue Interrupt Status Address Offset */
-		ufsmcq_writelx(hba, MCQ_OPR_OFFSET_n(OPR_CQIS, i),
+		ufsmcq_writelx(hba, ufshcd_mcq_opr_offset(hba, OPR_CQIS, i),
 			      MCQ_CFG_n(REG_CQISAO, i));
 
 		/* Save the base addresses for quicker access */
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 7d07b256e906b..e4da397360682 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1117,6 +1117,12 @@ static inline bool is_mcq_enabled(struct ufs_hba *hba)
 	return hba->mcq_enabled;
 }
 
+static inline unsigned int ufshcd_mcq_opr_offset(struct ufs_hba *hba,
+		enum ufshcd_mcq_opr opr, int idx)
+{
+	return hba->mcq_opr[opr].offset + hba->mcq_opr[opr].stride * idx;
+}
+
 #ifdef CONFIG_SCSI_UFS_VARIABLE_SG_ENTRY_SIZE
 static inline size_t ufshcd_sg_entry_size(const struct ufs_hba *hba)
 {
-- 
2.43.0



