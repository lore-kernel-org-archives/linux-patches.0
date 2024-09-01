Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77C51DFD1;
	Sun,  1 Sep 2024 16:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209493; cv=none; b=pimSbqcOEWhOv6ibTaaJgYQ7lmzR5qO60vyPz6y6fmRX3qho2UBJuky55aXWiXg/jNJHOfgbHi9DuMMP7L16UDmFSZCYY8+rOHtQuu8CoAHzdbKW/JtmcXztx1x3eAf4UpLJkMuAbgG6aUKjkIOn44W0DPAdYFko+kT+9raA3Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209493; c=relaxed/simple;
	bh=afMlcvXSYk+i5kSTImcT51opNdNnBRee4FHENl7OiEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spMzFjlwF3G3vJ+NrBgA/+Y/ubKUId1EfKbfjvIVRlab2v79K7GJOpXlNSciVDWC9PT8mGasKc07u9jqIJRUmZM+o6awtB+X/ya4ISuDQyEswOa4YewrYbdk+ELmXK55Wk+nNfZiWpu/UjSN/0EARly01ILyToZzPC5ifWR5uPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXxSAdmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXxSAdmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F272BC4CEC3;
	Sun,  1 Sep 2024 16:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209493;
	bh=afMlcvXSYk+i5kSTImcT51opNdNnBRee4FHENl7OiEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXxSAdmYtQziqubuP5MsIyDQK0e3PdbNd3xR7+nqW0y3k7q/AOwLkbpTYmkbl0djO
	 I1wnbFu41FcdP0KooTUWccLyAMLsnm0X1H6uDcm3uDoVaDIPbS8FvGlyzm6/36CQBe
	 s4xpcY7qhPQ9Ojcrnzbvo7lM3PLtd1BnvM/Y9gqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/151] scsi: lpfc: Initialize status local variable in lpfc_sli4_repost_sgl_list()
Date: Sun,  1 Sep 2024 18:16:53 +0200
Message-ID: <20240901160816.114653567@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 923ceaba0bf30..84f90f4d5abd8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -7048,7 +7048,7 @@ lpfc_sli4_repost_sgl_list(struct lpfc_hba *phba,
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



