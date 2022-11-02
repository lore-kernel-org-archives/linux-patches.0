Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745D4629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7241AC433D6;
	Wed,  2 Nov 2022 03:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667358291;
	bh=MbsjvXhqEO/k07jpr/JlXaHbxHzfI6JX+07V6T3xoUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrGwtPna3QbvJY/yw+JXGvyI3d8688g2asfsuayfL01jPN1QWrqRUbxbqOm57lOZA
	 U3nnUsO7EvUESzi6w6W7DInYjGowVoxUBjwohuT8iI2DD0Y39CuuaNEGOP8p628d/e
	 o+rdT2uf2BRlCUNkfnud8VBSWwAUP/7zPnfeA0iY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Smart <jsmart2021@gmail.com>
Subject: [PATCH 5.15 048/132] Revert "scsi: lpfc: Fix element offset in __lpfc_sli_release_iocbq_s4()"
Date: Wed,  2 Nov 2022 03:32:34 +0100
Message-Id: <20221102022100.884099582@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: James Smart <jsmart2021@gmail.com>

This reverts commit 6e99860de6f4e286c386f533c4d35e7e283803d4.

LTS 5.15 pulled in several lpfc "SLI Path split" patches.  The Path
Split mods were a 14-patch set, which refactors the driver from
to split the sli-3 hw (now eol) from the sli-4 hw and use sli4
structures natively. The patches are highly inter-related.

Given only some of the patches were included, it created a situation
where FLOGI's fail, thus SLI Ports can't start communication.

Reverting this patch as its a fix specific to the Path Split patches,
which were partially included and now being pulled from 5.15.

Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_sli.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1384,7 +1384,7 @@ static void
 __lpfc_sli_release_iocbq_s4(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq)
 {
 	struct lpfc_sglq *sglq;
-	size_t start_clean = offsetof(struct lpfc_iocbq, wqe);
+	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
 	unsigned long iflag = 0;
 	struct lpfc_sli_ring *pring;
 


