Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC7B2E266C;
	Sat, 17 Oct 2026 17:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257580; cv=none; b=gbW/UL/552hj4/LsJSYja1k0q4ahW6acikQ7pia38seYjiaPkIWkW314z/FSPls51y+HYIEIz4KCdeI5EeT4LTMb3dEB1EpYeiTFWqkuVFVUSEOY9VM6OxuPyF2wWAVFuffHpzSdArvzt7xgyg8J7Be0yakvxOlGvmSzEF9W+cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257580; c=relaxed/simple;
	bh=iC1RVh1eiJIeqf1IGlv8VgdjifT9KE+FHm/Sl6QJAog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d/yIuvgYaH3lXaxcWtvU+H2Mk1TZnJFfOWyi4tHMqLyf7L9V9aC5ieEkaVggxoM9gYQgwz3igsEFNXauZodBrGSvQxODo3IJkHF60Spyz2GRYNFrFRSH/U7HW+St1ukIptUb8GADydSieWrynxoEztBUVgvwsWVJyjRb2phQ8Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvVqwqrT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvVqwqrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 208931F000C5;
	Sat, 17 Oct 2026 17:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257578;
	bh=l90FgmkIwPZ+mai15FxlleObHbA89SGmqmtbegT/HKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvVqwqrTM2CmVTP7XrqeVumk0qI9Rk6v0yQYdZ86GSX1j1AA8tjebbDUTlN/7dWVw
	 56Cbqy+1vztAENe2jqgrgyaVKZqpQOYpBdeYu20qHGntTRbZjHtsAr/xu7fhaqL66s
	 0oJQyoi6rrRubt0qJm47XRxPljtvJZPovXZ8xUBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0603/1674] scsi: ufs: mcq: Remove unused parameters
Date: Sat, 17 Oct 2026 17:47:55 +0200
Message-ID: <20261017160446.561866324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: ChanWoo Lee <cw9316.lee@samsung.com>

[ Upstream commit 01f256228c0f89c4b48fbc7c67b64a26cdcfd740 ]

The 'hwq' parameter is not used in this function. Remove unused parameters.

Signed-off-by: ChanWoo Lee <cw9316.lee@samsung.com>
Link: https://lore.kernel.org/r/20240105021041.20400-3-cw9316.lee@samsung.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 375f3a5691dd ("scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index cb8f0652a4bee..02e3b41694e0b 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -255,9 +255,7 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_write_cqis);
  * Current MCQ specification doesn't provide a Task Tag or its equivalent in
  * the Completion Queue Entry. Find the Task Tag using an indirect method.
  */
-static int ufshcd_mcq_get_tag(struct ufs_hba *hba,
-				     struct ufs_hw_queue *hwq,
-				     struct cq_entry *cqe)
+static int ufshcd_mcq_get_tag(struct ufs_hba *hba, struct cq_entry *cqe)
 {
 	u64 addr;
 
@@ -275,7 +273,7 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
 				   struct ufs_hw_queue *hwq)
 {
 	struct cq_entry *cqe = ufshcd_mcq_cur_cqe(hwq);
-	int tag = ufshcd_mcq_get_tag(hba, hwq, cqe);
+	int tag = ufshcd_mcq_get_tag(hba, cqe);
 
 	if (cqe->command_desc_base_addr) {
 		ufshcd_compl_one_cqe(hba, tag, cqe);
-- 
2.53.0



