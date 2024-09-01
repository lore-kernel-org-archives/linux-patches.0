Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BD217DFFC;
	Sun,  1 Sep 2024 16:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208815; cv=none; b=sRXXxlil/QhlBn4vFDyCA+zIcRJi5eG2civWhxrNCcFcqJjwvwSwOfSskqUUTtovRWqyO6O1QRNU8ber9iGP2uEckWK3nqq+JIsC7oLdeeGBn0IAzeGyp8skoWHg+9oyYM9Pg5kp/BoIm9fL3zjEcNZzII+aQkuDYHp7BxH+Fmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208815; c=relaxed/simple;
	bh=yRPJWKbSB7TCyaArYkZ0Dft8EXpIz+CEjrxXI532uYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itSjww39jU9uZ1FiqUxFPMg+innwA7/RSQRQJpeRoFy7w5qKYVN36QWPkPXMyPQXhPeWbtDM9FZ0FWfBUZg/dPuzEWxhMnf5v3GmYY9wX01MOmql68OTSbBnEpOZiUkLX/dFJJZI5v/6wB2zrURTWmOxq6ooc+WpYHaByGvtfyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z+fBPrM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z+fBPrM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FDDC4CEC3;
	Sun,  1 Sep 2024 16:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208815;
	bh=yRPJWKbSB7TCyaArYkZ0Dft8EXpIz+CEjrxXI532uYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z+fBPrM6y/p27TBP6ctby+1WkmnbechlY0V7xZA5ywikH1rCX1RfQKyvZ4PbzYP3I
	 IICOeVRrLO3x0kReASyhws40V7+U+8U9qVaTeE8rUkIoiTzYrLoUNeu37qFwkGIDb3
	 vNr0XR4/9YtugPeAPEvKqSU0x9j7P17OT6JokQxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/134] scsi: lpfc: Initialize status local variable in lpfc_sli4_repost_sgl_list()
Date: Sun,  1 Sep 2024 18:16:33 +0200
Message-ID: <20240901160811.878524679@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e489c68cfb631..04b9a94f2f5e5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -6902,7 +6902,7 @@ lpfc_sli4_repost_sgl_list(struct lpfc_hba *phba,
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



