Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5F21E4B1;
	Mon, 15 Apr 2024 14:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191616; cv=none; b=uXUl5K0jiBo0zdxQB54t85k6K7us4+0kkrmhBhe7TrMZT/wq7u87cPgL5uztv882P34J5ODNUKXf7FyKNyXo5frS84P63mp0LpCmC/rhpAArPMEHChReWItNjXSilR7jGZcrgWMhZXGn8DizniAthZaZiWTAX7J0EQdOmC0g/WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191616; c=relaxed/simple;
	bh=xAiYLduALJ4qJeX7b1WRHbxn4Bahqk6TSWxyv2Avwdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6s+gjKL8P3x2n1exMqJEnFH9HgYXjsrUGg2tNZPzp9/jQ+5QtLRrnOkLhMSUyiRShee9d41aNR7iaFepbg7iPwWHqiQNyNTDrFnVjVIhLxf5uTtQCLwtrs9BgnuTt25LajwzxAUBOKeWWIjF6SqZp+snCk4wQXTlAC3RQ8rsIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbcGoMS7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbcGoMS7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A24C113CC;
	Mon, 15 Apr 2024 14:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191616;
	bh=xAiYLduALJ4qJeX7b1WRHbxn4Bahqk6TSWxyv2Avwdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbcGoMS7g/Gdt/gf3Ig9+IhxXpjyJcqu0AWsmwG9Lc8tvDR9rh4Er0Q0o936nsdKQ
	 cVS4aRQn0bx8MEiqBrgUKSoHNnsvmqlj/mpcIM6wNg37PA7jMYYQXKLPCDkYch7tjq
	 dxYrSAZ+iRIMq1TINtlpdsWlh1qIaSDNpQaxBKZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xiabing <xiabing12@h-partners.com>,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/122] scsi: hisi_sas: Modify the deadline for ata_wait_after_reset()
Date: Mon, 15 Apr 2024 16:19:54 +0200
Message-ID: <20240415141954.245887552@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 0098c55e0881f0b32591f2110410d5c8b7f9bd5a ]

We found that the second parameter of function ata_wait_after_reset() is
incorrectly used. We call smp_ata_check_ready_type() to poll the device
type until the 30s timeout, so the correct deadline should be (jiffies +
30000).

Fixes: 3c2673a09cf1 ("scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset")
Co-developed-by: xiabing <xiabing12@h-partners.com>
Signed-off-by: xiabing <xiabing12@h-partners.com>
Co-developed-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/20240402035513.2024241-3-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b155ac800979c..e4363b8c6ad26 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1792,7 +1792,7 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 	if (dev_is_sata(device)) {
 		struct ata_link *link = &device->sata_dev.ap->link;
 
-		rc = ata_wait_after_reset(link, HISI_SAS_WAIT_PHYUP_TIMEOUT,
+		rc = ata_wait_after_reset(link, jiffies + HISI_SAS_WAIT_PHYUP_TIMEOUT,
 					  smp_ata_check_ready_type);
 	} else {
 		msleep(2000);
-- 
2.43.0



