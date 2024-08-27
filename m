Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E631C68A0;
	Tue, 27 Aug 2024 15:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772412; cv=none; b=lDSyvc9ZY7t+j3Rjn6T6Biht7dkVsvSCBM66gOby2bAhgOmtyvJLs+Ry11AGDPU4MwhMq2aoLzJSeb9DzJruwtUKXULBbQawydiZDdV8LwXDCVnsKgZx5dVKMPXVtmjkKwrMgRG/oOm25GmxUEGHRCV4Tl9SfzzBowk2pysmiME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772412; c=relaxed/simple;
	bh=M85Vcdakzi1I4QoEHQd/Fb+gieGY639MyvtP8p95aWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjCtFMlbhJNuKgZVCsaTudnTRgTEu9NobVTSTiMWctWr6IOQI/xNJhk3iQQH+/pW1FiT0kz8pJRaTLOm2m48BOOykc+YBUC7ZDmSXXkm4TMHQJrI/B7o2vBQfN/ip7wjyAUfENt01AEN6dqxPKvRvyYGt9WkEg9CQc++nXQilhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywbiw0vE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywbiw0vE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CA6C4DE14;
	Tue, 27 Aug 2024 15:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772412;
	bh=M85Vcdakzi1I4QoEHQd/Fb+gieGY639MyvtP8p95aWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywbiw0vEzzAZM3CrM685CctZoSH6SmEhRNCOBUQunqtpoaIyuGmgFBy9AtIgf60On
	 iP3zu06jXo0qZk/P2U06D+kcd1gxiiNmN+71vv6ek41vZdQg2tSRU/dCxlWSZ1pAm/
	 WNrtcvOWNvtg6WW/nYIorySdm2MizcbME3ZkKyOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/321] scsi: lpfc: Initialize status local variable in lpfc_sli4_repost_sgl_list()
Date: Tue, 27 Aug 2024 16:37:54 +0200
Message-ID: <20240827143844.549824029@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 3d0f9342ae200aa1ddc4d6e7a573c6f8f068d994 ]

A static code analyzer tool indicates that the local variable called status
in the lpfc_sli4_repost_sgl_list() routine could be used to print garbage
uninitialized values in the routine's log message.

Fix by initializing to zero.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240131185112.149731-2-justintee8345@gmail.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 47b8102a7063a..587e3c2f7c48c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7596,7 +7596,7 @@ lpfc_sli4_repost_sgl_list(struct lpfc_hba *phba,
 	struct lpfc_sglq *sglq_entry = NULL;
 	struct lpfc_sglq *sglq_entry_next = NULL;
 	struct lpfc_sglq *sglq_entry_first = NULL;
-	int status, total_cnt;
+	int status = 0, total_cnt;
 	int post_cnt = 0, num_posted = 0, block_cnt = 0;
 	int last_xritag = NO_XRI;
 	LIST_HEAD(prep_sgl_list);
-- 
2.43.0



