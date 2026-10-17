Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4CE355F49;
	Sat, 17 Oct 2026 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252676; cv=none; b=VEJhZ9IONS/EMxPVaGKCdGNE1l9s4qK8Hxo6+WSlqBc8v2Ft8JrfNqR8ZtJszkj2xGvSUm+H3BGbFsGG6HO0HYkRj6AZRoyaoqcQBWEIHAzv51MiaAsRmjiRvuZwQws8vjKbISmi+q6PbWkYT9GD32+PHgYar8uXulRcMUPZwF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252676; c=relaxed/simple;
	bh=UH+/SIl+eBVwOUoliXb8yjVIN46wT3fT0AZ6z4bWfSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjUK1E/FuVOulSxogxugg3LSm9/uI6eFtioMg1WNr9aWRfrte7sFZbGK53/MMtYjrOL+OL5PkwHU8q137uCJxEIFfU3IHFQ/SyG/vNW89McaqIpXlBbj7L1YoZSq5/IQCMNivJStiw2RoIkC8gPFWl88P6PArPZHBDFBKyJIo7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQoNMHdy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQoNMHdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B059F1F000C4;
	Sat, 17 Oct 2026 15:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252674;
	bh=xPSus447zz5QACoaDEujCQVtcq6fskv2r73P95aM+4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GQoNMHdy9FY8bY6WOltD3Bi6V5PpHx5P4knIVXwUZRhK7Zb7K8fBjOkHZ8wkglr5O
	 CCfFL9425ICwthwl8OlGHDVsPvt69xZbR6Nigigy+jFyXgHjx7Uibvac7gnxGBeK86
	 UIVAgmytmNeWlUWZZRYJLXcf+i5aS0mKgMbuOjjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 26/52] scsi: ufs: core: Add a comment block above ufshcd_mcq_compl_all_cqes_lock()
Date: Sat, 17 Oct 2026 17:54:27 +0200
Message-ID: <20261017155105.696719044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 1373df88d53594a32534fd8960c51d1d09be8ecb ]

Document the aspects of ufshcd_mcq_compl_all_cqes_lock() that are
nontrivial in a comment block above this function.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20260401202506.1445324-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 375f3a5691dd ("scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 632f4522a4d63..51e3c65ba94b1 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -319,6 +319,14 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
 	}
 }
 
+/*
+ * This function is called from the UFS error handler with the UFS host
+ * controller disabled (HCE = 0). Reading host controller registers, e.g. the
+ * CQ tail pointer (CQTPy), may not be safe with the host controller disabled.
+ * Hence, iterate over all completion queue entries. This won't result in
+ * double completions because ufshcd_mcq_process_cqe() clears a CQE after it
+ * has been processed.
+ */
 void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
 				    struct ufs_hw_queue *hwq)
 {
-- 
2.53.0



