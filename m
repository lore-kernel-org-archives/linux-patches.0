Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74A53FFE;
	Tue, 23 Jan 2024 00:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970935; cv=none; b=sjDk1M2rDnZtKnojcRmdDoyINNM1fM975Z3TW6inmskwhem4BdhgGpMjPsn/zbEEZpCAVhOw1fDTbOIpedtj9gApXV6DUfZik0c2h5jkVKue2hKwv6g48VoA/YYWliUABbVDCoRSSWb9ul5rAUjjXwAOqIE5JNSkzaWC9vNzM4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970935; c=relaxed/simple;
	bh=XYqmdawO6i/WPkMOjAdu1uF/KrrY32LgtKobrKwv6wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ii9hmH7SlTY/AZln4HqgaXM5rWNBIdJMlRCf208BHp3zag3gYGroWCCUwoOZnJKNEgqkL6PhZbFNSCtcgKFajUivDueN2RT5ATDPcbBfrIdIIJpZSyDzkZO9o/Tdfqsu4EhqOzUw23egJ2oxT4FIEOmX5d1tBGZE3QR+6JxgcwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGxglaPh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGxglaPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BB8C43390;
	Tue, 23 Jan 2024 00:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970934;
	bh=XYqmdawO6i/WPkMOjAdu1uF/KrrY32LgtKobrKwv6wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGxglaPhTcbrxRmEbGXz4nwChD/Ngc+KiYtFG9KKhSCFDUXEHv/MBu8ojxWxgmvQN
	 qvNQR6a+eDwAXMOuGfsaUlER+uCQ3EA3v+rgdYgyjTBAu0O4q0/maqvAo46yL2sE7V
	 v4PbUw3stozgBDvZfaM8FF8wWCRvfy7ZX0gzWx8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/417] scsi: hisi_sas: Correct the number of global debugfs registers
Date: Mon, 22 Jan 2024 15:54:46 -0800
Message-ID: <20240122235755.869069536@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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
index ee2065e83f9b..0c80ff9affa3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3330,7 +3330,7 @@ static void debugfs_snapshot_global_reg_v3_hw(struct hisi_hba *hisi_hba)
 	u32 *databuf = hisi_hba->debugfs_regs[dump_index][DEBUGFS_GLOBAL].data;
 	int i;
 
-	for (i = 0; i < debugfs_axi_reg.count; i++, databuf++)
+	for (i = 0; i < debugfs_global_reg.count; i++, databuf++)
 		*databuf = hisi_sas_read32(hisi_hba, 4 * i);
 }
 
-- 
2.43.0



