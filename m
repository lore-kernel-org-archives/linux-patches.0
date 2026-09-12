Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD08377ABA;
	Sat, 12 Sep 2026 18:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239233; cv=none; b=qAlWKHeebqv7FcW7bm+3EbzYTUly8yu1l2XXdVsKpYsq7Ap2FtLzRwauySPGq/3bafY3z/P9NKTjeErAGf8LSOYIiYrlC15GTmsBUPt76zYz43bt9K1+TyQpQ6lBwbds8J6EtXBiAad95xS5FHyi1auwhNW4B3VgKxLOLY7oNTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239233; c=relaxed/simple;
	bh=eoiAx8J4Yw7qF5n/w8ghZ0i1vcuPTvlb6mzWsee3m9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfldKHjuKf3CdbYZv2FTFUkje0qBTH+290/Idch5uv5lQ2pQTUXDspL/IzCuv18dtKX73NXibMo3nZK+aacJ6HwL/Kobds8hqt59PseP0mq4sEKqT/mjrqiNs22ccH+GEXvPKhhNUzPfH6GywnJMXbSqWG1n4FeT7Eji4NgxqRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x3HB3V4F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x3HB3V4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606FD1F000FF;
	Sat, 12 Sep 2026 18:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239232;
	bh=tWXOZIwI2heDKB5W2+dnpNsjyh9XCOBpHGjWNnjp12E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3HB3V4FxRNXl71dVNBgmkgfPMWwUn73AbAnpp3AMhW31rKeti2cc1XysIU53hHVa
	 b2CrcKP5E9ZboCSdpzCa3rUmbcqFrjBcmJ0waFhtDw/seI2E9CRnP8J+o0SN0teB/f
	 4aPL66+EIUxxrvTGMAJcdwgwjVWE5nA545LHufAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Barnett <kevin.barnett@microchip.com>,
	Scott Teel <scott.teel@microchip.com>,
	Scott Benesh <scott.benesh@microchip.com>,
	Mike McGowen <Mike.McGowen@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 621/935] scsi: smartpqi: Fix BUILD_BUG_ON() statements
Date: Sat, 12 Sep 2026 09:00:51 +0200
Message-ID: <20260912065541.080054138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mike McGowen <Mike.McGowen@microchip.com>

[ Upstream commit 5e6935864d814c3a62dd0945fd155634481f11c2 ]

Add calls to the functions at the beginning driver initialization.

The BUILD_BUG_ON() statements that are currently in functions named
verify_structures() in the modules smartpqi_init.c and smartpqi_sis.c do
not work as currently implemented.

Link: https://lore.kernel.org/r/164375214355.440833.13129778749209816497.stgit@brunhilda.pdev.net
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Signed-off-by: Mike McGowen <Mike.McGowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 225548863f0a ("scsi: smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 5 ++++-
 drivers/scsi/smartpqi/smartpqi_sis.c  | 2 +-
 drivers/scsi/smartpqi/smartpqi_sis.h  | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 6ecc56fb9fb25..1df17ef2ec93a 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -54,6 +54,7 @@ MODULE_DESCRIPTION("Driver for Microchip Smart Family Controller version "
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
+static void pqi_verify_structures(void);
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
 static void pqi_ctrl_offline_worker(struct work_struct *work);
@@ -9295,6 +9296,8 @@ static int __init pqi_init(void)
 	int rc;
 
 	pr_info(DRIVER_NAME "\n");
+	pqi_verify_structures();
+	sis_verify_structures();
 
 	pqi_sas_transport_template = sas_attach_transport(&pqi_sas_transport_functions);
 	if (!pqi_sas_transport_template)
@@ -9318,7 +9321,7 @@ static void __exit pqi_cleanup(void)
 module_init(pqi_init);
 module_exit(pqi_cleanup);
 
-static void __attribute__((unused)) verify_structures(void)
+static void pqi_verify_structures(void)
 {
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
 		sis_host_to_ctrl_doorbell) != 0x20);
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index d66eb8ea161c5..f48ffdc465563 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -479,7 +479,7 @@ int sis_wait_for_fw_triage_completion(struct pqi_ctrl_info *ctrl_info)
 	return rc;
 }
 
-static void __attribute__((unused)) verify_structures(void)
+void sis_verify_structures(void)
 {
 	BUILD_BUG_ON(offsetof(struct sis_base_struct,
 		revision) != 0x0);
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index bd92ff49f3855..5f3575261a8ed 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -12,6 +12,7 @@
 #if !defined(_SMARTPQI_SIS_H)
 #define _SMARTPQI_SIS_H
 
+void sis_verify_structures(void);
 int sis_wait_for_ctrl_ready(struct pqi_ctrl_info *ctrl_info);
 int sis_wait_for_ctrl_ready_resume(struct pqi_ctrl_info *ctrl_info);
 bool sis_is_firmware_running(struct pqi_ctrl_info *ctrl_info);
-- 
2.53.0



