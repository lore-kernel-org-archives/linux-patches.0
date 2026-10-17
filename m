Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF283AF665;
	Sat, 17 Oct 2026 17:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257583; cv=none; b=BKIoVbagcSkK+c4ecGzWrdykzu26SRI6yhtX/9jHAvlVd+4emqhHM0mn3CepUCn0CRHGwck+LK8rbGq/l4OHbgPDHNsah3mgkNap0n5fxyAiCF/VtD9ckpgsn85KOXGTdZasAciSSWa1PS5h19EBJm/iR8wWrr5AmiWgC7nhRPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257583; c=relaxed/simple;
	bh=dqerQuQF2w2DwxH+prswFZSYENKKQgPJmYh0GEfvm9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tpkMtrkSwCwhRejzGn9/Zfz9riiJqdCVWpYYUTpw6oechikypl+l26MtPGcTxvHmoxCB0666u//EEf/KbzpwbQGUYax9B46k2QnI4U/5oCWmohJftBHERuUdBMuEdOHkAr98ImXtjBEszlXBc+eYp81WYQ8rfUEHBtj50saLpGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxfWz3LD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxfWz3LD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D0E1F000C5;
	Sat, 17 Oct 2026 17:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257581;
	bh=3U23b8yMqW2DfSXP1APrZ7UcnpZn9ljtlFjyOBY8nk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lxfWz3LDDZmLMXO3j42e/oaw188b9+IeP2Tm2MLY6y6VYsnI8vc1TbUbb7oaYsni9
	 uXeGj0oFo7rCaFwvxRQhGz7ZWVS87pl8KZQ83txtLIC/SkMAJmCXkoAT9yaecKoB7M
	 DptY4/lsAJLcAzO9urOTciSiXVcQIiaHFVSf0FRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avri Altman <avri.altman@sandisk.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0604/1674] scsi: ufs: core: Move an assignment in ufshcd_mcq_process_cqe()
Date: Sat, 17 Oct 2026 17:47:56 +0200
Message-ID: <20261017160446.587568132@linuxfoundation.org>
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
index 02e3b41694e0b..90314980deed1 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -273,9 +273,10 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
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



