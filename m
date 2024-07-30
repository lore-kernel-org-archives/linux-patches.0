Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FB118A92F;
	Tue, 30 Jul 2024 16:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358734; cv=none; b=dmmNf/UO306mvQVDWzFA3lIG952eXGHAyEaaHmb4C7qHwcJ50xHdaw9hlGQbXuw61fqS0pLJv43SjJ8s+k1WG8mkarLzA7Fln76j8ynwWotJicaiIhh9QLOtjB2auI4vePeD06OVdWhIx2/595H9yqxv5OryhzgThtps6kvHJiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358734; c=relaxed/simple;
	bh=cYTts8zyldmTpu9RAeDSMD6H/w9J6deUoRrc8hlJh1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Unz+2zGd4N1xSfaYs3FOSQDbV8TToRvorSDTj8tordnoVyu2q6jVNP9bezS+T6QktdshRK/8albyrCDXkiaLEs0+n0+0HmGsx0tY5Aq16OfEu+egFqfTYGuCepbQuXMZNtEY2gvVbT2e8ZtpKKIfHrbRmzMxpyAH2bHIBNkZToE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWFylxaz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWFylxaz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B25C4AF0A;
	Tue, 30 Jul 2024 16:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358734;
	bh=cYTts8zyldmTpu9RAeDSMD6H/w9J6deUoRrc8hlJh1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWFylxazrfQ4gQUb4E48B7WWSsKwJWrMoRe8hnhQCuDoU7iEzlSb4IWvdxb0B5Z5g
	 LuKfxvh6IZ/4/nNiAebQ41r1LSsbl5ah8FQn99ZzIufQGtBTjI9ioWqPo9YxZDO6pa
	 NvZJ3gLNDDBQhR4Phda+MefPX3m55TnXPeroRHmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asutosh Das <quic_asutoshd@quicinc.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 389/809] scsi: ufs: mcq: Fix missing argument hba in MCQ_OPR_OFFSET_n
Date: Tue, 30 Jul 2024 17:44:25 +0200
Message-ID: <20240730151740.036261319@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index c532416aec229..408fef9c6fd66 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -230,8 +230,6 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
 
 /* Operation and runtime registers configuration */
 #define MCQ_CFG_n(r, i)	((r) + MCQ_QCFG_SIZE * (i))
-#define MCQ_OPR_OFFSET_n(p, i) \
-	(hba->mcq_opr[(p)].offset + hba->mcq_opr[(p)].stride * (i))
 
 static void __iomem *mcq_opr_base(struct ufs_hba *hba,
 					 enum ufshcd_mcq_opr n, int i)
@@ -342,10 +340,10 @@ void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
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
@@ -355,10 +353,10 @@ void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba)
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
index bad88bd919951..d965e4d1277e6 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -1131,6 +1131,12 @@ static inline bool is_mcq_enabled(struct ufs_hba *hba)
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



