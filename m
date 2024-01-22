Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689522B9B7;
	Tue, 23 Jan 2024 01:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974114; cv=none; b=Vzn7l9VG0UcawlhnzDwgBLAG/ObY7eYjawry8xLWFlpxtJPHgbdnDGKLYxHz4ZmNwDb1C+GzYkBWLcykjs2SSiz/6VDdZjasFnKmRP/FH54YVgfUXQdwLkYL68Aapb58JvbQl1zuyeahMUKNYjFzSVMYobGa2/kIGK3BcS+qhdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974114; c=relaxed/simple;
	bh=0CsZ/yywgPVMhH7IiUC0bvaMrJRK/zGtPlvPGP8zVX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXJ2ANopzqsCg+GtyRwjGzZXcUFKWlhhnon18EGww3CLW8Sr+xEAaIhoq/0yDoNpIxPjuy7laY41gGuDVrE1e+mnVEEOd+sa9+921TX3xy5ZCb2KIG27kRdPKoSwM9x9gy1yFyV0uqCF+Zl+cV8vmeDd7t5f3Hnw0D5qPObc5VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pf4chDk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pf4chDk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC524C433C7;
	Tue, 23 Jan 2024 01:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974113;
	bh=0CsZ/yywgPVMhH7IiUC0bvaMrJRK/zGtPlvPGP8zVX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pf4chDk7FY94ggzw9TpwjCPYjunRLEYt8qpmTuF745Wrefeh1pMr+yex3cnNo1/Hk
	 AZ7DGr6TfLkWkG3yttzjbL2WQTO+SSt5thT0kXFvr2h/YUroa0aHzlmxYDJzspSPbW
	 BRm3WoHaro0QlED7XRx4ZY8h7advUky9RQigQ3Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/374] scsi: hisi_sas: Correct the number of global debugfs registers
Date: Mon, 22 Jan 2024 15:56:42 -0800
Message-ID: <20240122235749.710059001@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihang Li <liyihang9@huawei.com>

[ Upstream commit 73e33f969ef05328766b23a99b2c07bfff765009 ]

In function debugfs_debugfs_snapshot_global_reg_v3_hw() it uses
debugfs_axi_reg.count (which is the number of axi debugfs registers) to
acquire the number of global debugfs registers.

Use debugfs_global_reg.count to acquire the number of global debugfs
registers instead.

Fixes: 623a4b6d5c2a ("scsi: hisi_sas: Move debugfs code to v3 hw driver")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1702525516-51258-6-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 4505310c0c3c..1651d03d3b46 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3331,7 +3331,7 @@ static void debugfs_snapshot_global_reg_v3_hw(struct hisi_hba *hisi_hba)
 	u32 *databuf = hisi_hba->debugfs_regs[dump_index][DEBUGFS_GLOBAL].data;
 	int i;
 
-	for (i = 0; i < debugfs_axi_reg.count; i++, databuf++)
+	for (i = 0; i < debugfs_global_reg.count; i++, databuf++)
 		*databuf = hisi_sas_read32(hisi_hba, 4 * i);
 }
 
-- 
2.43.0



