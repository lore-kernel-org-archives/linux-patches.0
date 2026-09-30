Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA4D3E40E9;
	Wed, 30 Sep 2026 18:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791639; cv=none; b=C7TLek2i+n8Bi6K+3SGzPqEXMmHnHk+pHAoUmdqqnQ1Ph/QlOfdwMsiig0AJabh5+gww+5k2Wo7wq7/56uD+/BU9jRfV0s80VNnmnN4XN7YqVtTPqmHTC2WSyAKBANPEoxfr+Hr4aR/PT0IpwzOoa6qqyZmfLWo60T2ujz6f600=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791639; c=relaxed/simple;
	bh=RDqpjbRQhbgIOH+QNOTDRPpGN7aEK6VcNBuK7/qjdjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYtdX8XpWHg+FM2Nc+/TzdUbIEGrLDn8Mpo1dgXuywzyLn3+VV1KZdLa0SR/B/ViZqoPeeXALndjTyAQxfFLgxM0/SmCG7ujnxwLgf/jtGO16C7djcRtB/M5q0ZCb0CAXPuAo4zgbwLyLXLIGRKz66U5avfZVr7nSBH5CEFtzYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAJ4olyy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAJ4olyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C491F000FF;
	Wed, 30 Sep 2026 18:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791638;
	bh=6UsgYzyoDv3/YtcxTa0ZzucZaeUAxv80dQQOICjWbzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAJ4olyyWH45lbx1Vq+I+SSS7GHr+9j3cKhjQbjG6u+Wq4KYYY7/TRfRnWgFr95xe
	 B0ONEfVn4XpFj/ROn9kjPi1Ty5ugd1QQzwJfZ5uLCZILVoYwxm8rUPCr3W4kUHtjtR
	 x5b7SRzaQB0VbVVrIlszgqE/qEPPObMuKP6qONhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 366/752] Revert "scsi: smartpqi: Fix BUILD_BUG_ON() statements"
Date: Wed, 30 Sep 2026 17:23:56 +0200
Message-ID: <20260930152406.200194821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

This reverts commit e434879e7e0880de501f745550671cb71a556bc8.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 5 +----
 drivers/scsi/smartpqi/smartpqi_sis.c  | 2 +-
 drivers/scsi/smartpqi/smartpqi_sis.h  | 1 -
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 1df17ef2ec93a..6ecc56fb9fb25 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -54,7 +54,6 @@ MODULE_DESCRIPTION("Driver for Microchip Smart Family Controller version "
 MODULE_VERSION(DRIVER_VERSION);
 MODULE_LICENSE("GPL");
 
-static void pqi_verify_structures(void);
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
 static void pqi_ctrl_offline_worker(struct work_struct *work);
@@ -9296,8 +9295,6 @@ static int __init pqi_init(void)
 	int rc;
 
 	pr_info(DRIVER_NAME "\n");
-	pqi_verify_structures();
-	sis_verify_structures();
 
 	pqi_sas_transport_template = sas_attach_transport(&pqi_sas_transport_functions);
 	if (!pqi_sas_transport_template)
@@ -9321,7 +9318,7 @@ static void __exit pqi_cleanup(void)
 module_init(pqi_init);
 module_exit(pqi_cleanup);
 
-static void pqi_verify_structures(void)
+static void __attribute__((unused)) verify_structures(void)
 {
 	BUILD_BUG_ON(offsetof(struct pqi_ctrl_registers,
 		sis_host_to_ctrl_doorbell) != 0x20);
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index f48ffdc465563..d66eb8ea161c5 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -479,7 +479,7 @@ int sis_wait_for_fw_triage_completion(struct pqi_ctrl_info *ctrl_info)
 	return rc;
 }
 
-void sis_verify_structures(void)
+static void __attribute__((unused)) verify_structures(void)
 {
 	BUILD_BUG_ON(offsetof(struct sis_base_struct,
 		revision) != 0x0);
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index 5f3575261a8ed..bd92ff49f3855 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -12,7 +12,6 @@
 #if !defined(_SMARTPQI_SIS_H)
 #define _SMARTPQI_SIS_H
 
-void sis_verify_structures(void);
 int sis_wait_for_ctrl_ready(struct pqi_ctrl_info *ctrl_info);
 int sis_wait_for_ctrl_ready_resume(struct pqi_ctrl_info *ctrl_info);
 bool sis_is_firmware_running(struct pqi_ctrl_info *ctrl_info);
-- 
2.53.0



