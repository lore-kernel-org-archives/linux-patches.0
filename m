Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8363A5E6C;
	Sat, 17 Oct 2026 16:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253194; cv=none; b=ht4+s8cxRJalQWYSv00LJ38q3YshLr1Vp+2Baqhe9OJXRl5su8IUdDyPqIBt55jvHwFgknHwYqzZilGZXWS7ox3vwzN8AJIdjZiuY9nPEaufoqPgTRq2Z6pw6uJ5KazUaTQtHmPPp5JbxZ2LTVYGny+M99iEc/XO15k1LZNOhpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253194; c=relaxed/simple;
	bh=89QPpqepwSDIBFz2/396JAbuz4hpUDAvlVXaFGaKs3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bus6+AWeDMNkhTT3lH/2VTajjVhdIkqzfgxIOxKcnJv9m8f0fox8o+6cJ54EVPGANCtsCHVFkR3HvOb2z6NH1ymkVvaS/92He3P4IuOljA9OTGkcBvaObOr+rqvou+Kya8KZN5PbZf585RaKQWfik5hwFWY6iAFOe1cp2RWm3rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJJ/u6Gx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJJ/u6Gx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E131F000C4;
	Sat, 17 Oct 2026 16:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253192;
	bh=qilreu0bJ+s/YTmx9kdLr4BbRmug7BGCRtVZnytmA/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gJJ/u6GxO46gxz3Mxz6vbSqnBi8TwGP6KDephvTyJnPPN8UlHgBQHYbfzzUhX2JnM
	 28FWaRqZ1S6yJLZFm2Y7cnDPNDu7FwjbdsC9/kl7SrMcRnC21cxN2pJHU2k+rlb741
	 gVEhIshJBgsUzPW8apIYhvNAoV6bSvfFTYO6QDhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/869] scsi: ufs: core: Move an assignment in ufshcd_mcq_process_cqe()
Date: Sat, 17 Oct 2026 17:48:00 +0200
Message-ID: <20261017160038.016882351@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit dd4299af9b049c0dcb28699327ebc1386aab4b2a ]

Since 'tag' is only used inside the if-statement, move the 'tag'
assignment into the if-statement. This patch prepares for introducing a
WARN_ON_ONCE() call in ufshcd_mcq_get_tag() if the tag lookup fails.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251031204029.2883185-9-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 375f3a5691dd ("scsi: ufs: core: Avoid unsafe MMIO reads in ufshcd_mcq_compl_all_cqes_lock()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 5e6197a6af5e2..7ce9aba6bd7d9 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -303,9 +303,10 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
 				   struct ufs_hw_queue *hwq)
 {
 	struct cq_entry *cqe = ufshcd_mcq_cur_cqe(hwq);
-	int tag = ufshcd_mcq_get_tag(hba, cqe);
 
 	if (cqe->command_desc_base_addr) {
+		int tag = ufshcd_mcq_get_tag(hba, cqe);
+
 		ufshcd_compl_one_cqe(hba, tag, cqe);
 		/* After processed the cqe, mark it empty (invalid) entry */
 		cqe->command_desc_base_addr = 0;
-- 
2.53.0



