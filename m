Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EED8322DCD;
	Mon, 18 Aug 2025 14:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526142; cv=none; b=UNAlMmY+phJ8aihMz9EVM4ULO/bVLioaJZha1B1YPswOPsOLQAdDR917Paakm0lsmUuFer0bJk6Vw1mwLHzlcFVIYMpUexzVn3UDXClm3fPq4rYaBqCyIyE50cIFXY2UC1SaHW1KuFyqiNeaToCl42tSQvFKeilB0dBb3DVDVzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526142; c=relaxed/simple;
	bh=fDysE0G8C0Nb6MdeIn5Stzz2Ew6joprWCMMism+o6To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7FxUvtycRiHv5e//lV2qEUff1+RzYXkzp7xjbH9kzWRIttvNd250zCWkMpsOMl6PJ8CLmlLKtjIe0tPZ0Y12vAlw0waas9afzVZ96RTtmJvrATkzAQpTOt4OnqG/fIKeGp5U2TTu+LHQDU6DQ2pPq6eUzoKh0iRZzQUZ41muLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQAfMb52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQAfMb52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE17C4CEEB;
	Mon, 18 Aug 2025 14:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526142;
	bh=fDysE0G8C0Nb6MdeIn5Stzz2Ew6joprWCMMism+o6To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQAfMb52G34N7tPFTwbPrhot5LCRtmPM/diEm9rB5eklh4tweXPMnxAo4CVNX+n/F
	 4ZlLvNu0M/s4in/+CSPRj1momQoBP9U2+2vTcU+AstqrXHpRAz+huJ7GHQfyhsFsGj
	 GgyNar4jg78ZRsfvp+yctOPnPjvwWNSa0iR4YLtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 470/570] scsi: lpfc: Remove redundant assignment to avoid memory leak
Date: Mon, 18 Aug 2025 14:47:37 +0200
Message-ID: <20250818124523.985367271@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit eea6cafb5890db488fce1c69d05464214616d800 ]

Remove the redundant assignment if kzalloc() succeeds to avoid memory
leak.

Fixes: bd2cdd5e400f ("scsi: lpfc: NVME Initiator: Add debugfs support")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://lore.kernel.org/r/20250801185202.42631-1-jiashengjiangcool@gmail.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 3fd1aa5cc78c..1b601e45bc45 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6289,7 +6289,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			}
 			phba->nvmeio_trc_on = 1;
 			phba->nvmeio_trc_output_idx = 0;
-			phba->nvmeio_trc = NULL;
 		} else {
 nvmeio_off:
 			phba->nvmeio_trc_size = 0;
-- 
2.50.1



