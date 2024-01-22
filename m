Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADDC61673;
	Tue, 23 Jan 2024 01:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974947; cv=none; b=sjd8gCMJp5XlEHpTXNtHxnbjelf/ZT/SvFh5+XrFgOGlon1hSLZPSJFmW62OlEDCJ7ewhZs1CyEV1MkPahepG0CYcJucfqZgrSFU8KOkbbOihmdpyuIXOBftAzW/SmhO8QHm4x9rXHmz9K2euYyhKlBDrhtfVBWRmjmWDhBGuXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974947; c=relaxed/simple;
	bh=FiqN5Ykm7Wz+0NJP4AMHA6HT47mMYnWtHoZVZ7CKJQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHVYprsRmOK2EjaR779CYDqU6brff0GS8w16QpsEbn965rRi+Ezgzn/PhX3bfI4/qPisRx4/apAyaY73i1CN5ckxxhP/VHWmorBYte9GlKD6dBBRpn2mgmEEipUo0LT5BpO86TTwObLyzlpt5aqDms61ReNBtOR3UUIjOsN0Uu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgv30rM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgv30rM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCB4C433F1;
	Tue, 23 Jan 2024 01:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974947;
	bh=FiqN5Ykm7Wz+0NJP4AMHA6HT47mMYnWtHoZVZ7CKJQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgv30rM4cT4tZlHL+BjNqdlcHOPshEaZ4yh6u56dc7X83ymI04twfiSePcjf6a/vm
	 6tcqiXBANdj7HegC3k9WoFksWhXJrvmQCq5dnE40E/JVLBG6BGNCaPd1fSJnb76Ynq
	 slaL2z4YPXxn3ULwLEd3V9oAXiMpao4kHvOc48GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/583] scsi: hisi_sas: Correct the number of global debugfs registers
Date: Mon, 22 Jan 2024 15:53:34 -0800
Message-ID: <20240122235817.028235043@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 53c955c4f080..520fffc14282 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -3478,7 +3478,7 @@ static void debugfs_snapshot_global_reg_v3_hw(struct hisi_hba *hisi_hba)
 	u32 *databuf = hisi_hba->debugfs_regs[dump_index][DEBUGFS_GLOBAL].data;
 	int i;
 
-	for (i = 0; i < debugfs_axi_reg.count; i++, databuf++)
+	for (i = 0; i < debugfs_global_reg.count; i++, databuf++)
 		*databuf = hisi_sas_read32(hisi_hba, 4 * i);
 }
 
-- 
2.43.0



