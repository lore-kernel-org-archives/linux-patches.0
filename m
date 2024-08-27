Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EED19F485;
	Tue, 27 Aug 2024 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770221; cv=none; b=s0d+PWx9/GiYOmPWl5Sz36b5+TRcyUIMyq8as8WgT9bDYcnpPagj/guHEDRY/J/7oB2FjNnagZPTQAPZOCXF4E9aw+0CZdaL03bO2CJlh5A2FV4dKNRK3M9+YbU+leMg6GNh4IynP4lkRDkTUTSUZWIm/F10jewrRwkD0Vup83M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770221; c=relaxed/simple;
	bh=84gKEwTgPBFji81vOGX0RCT/t4fty+mfkNmv97U3Ipc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4tgBDVgvcjPWFk4fg2DF9dysPiBdFGtXRvIfPiB00ycT9i9NowFmEm6XuBnQPaOlbuJfkxvjH5mKK7C3U5cukEgbcuvo6XzKO06LHvASRlfF5g7xJ50SbvhYaBD+C8AfoBmxOL/bd4QdmFx5S2ZaPLJHOS7I0fExioeNyLWKJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJHyr7Mf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJHyr7Mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41C6C4DDF5;
	Tue, 27 Aug 2024 14:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770221;
	bh=84gKEwTgPBFji81vOGX0RCT/t4fty+mfkNmv97U3Ipc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJHyr7MfmmcWye6UxIYfEM2uEIuJiWdJWlDS1Oprx+cFeOuHStsPkvX48iey8LK5L
	 wrvnuuJFToLNeOShDhF18x+W/3UniQakmLFFRfgr/v9Z0AmIeAnj8WWLqqN8dJAhlr
	 Gi39z7kMNcr/EPCSzojkooWhvDuJAfDSCtCJjf44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/341] scsi: lpfc: Initialize status local variable in lpfc_sli4_repost_sgl_list()
Date: Tue, 27 Aug 2024 16:36:35 +0200
Message-ID: <20240827143849.653140572@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index 5af669b930193..9cd22588c8eb3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7577,7 +7577,7 @@ lpfc_sli4_repost_sgl_list(struct lpfc_hba *phba,
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



