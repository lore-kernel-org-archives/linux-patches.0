Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5022C1527B4;
	Mon,  6 Jan 2025 15:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177620; cv=none; b=TcQdGL61JU62/I4X5IlRqcewXyUvl3ZEQa9oxJXyYSZtei3JU4IWeXq1xWKny2TycboMsmDpjyZmE2tsLSeiZo7+y9z/eLZWRxZLwGfEEUGbKms3OnxA4IhptFBsL4qKoXDHy3VStb82aqNjks1JJiluuoKRNWhq/Vtqyn13zxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177620; c=relaxed/simple;
	bh=epK1NBZm0HqHwxte8IsE3ehq0gSs1p65KSary89NmnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL+j+gJ3XOON67/whrU22BKe/eaO5lpe9NhKvC14tB7MLphm96RMzolRV6eTLh+DvH+ky8Qy//0qTKXa9OWJTMCWDl7iIlPC/Hkg52O8D6o6ri1HcsxHeV1dgSlNjqpDBO5YpCsKf7f1jU7tmYDt/8b2Sxwm7IE7VaoTkwNhx7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u7GShm8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u7GShm8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF61FC4CED2;
	Mon,  6 Jan 2025 15:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177620;
	bh=epK1NBZm0HqHwxte8IsE3ehq0gSs1p65KSary89NmnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7GShm8fdEtTVDt8Ma2lVuRuYbE7x5QmXcAd026O0XvcTcnWfN0MAOK4ypsced88/
	 1ffbKDqh6IfYIwClmaTmggpv9fvyEhtQTFKFkLJQW05JWPUazJVLPXNmtXbifOs+Wa
	 Yn9yDWjgz0shc/LS1erjjCoYv/nUQ9jspgzfY4Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yihang Li <liyihang9@huawei.com>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.6 222/222] scsi: hisi_sas: Remove redundant checks for automatic debugfs dump
Date: Mon,  6 Jan 2025 16:17:06 +0100
Message-ID: <20250106151159.166543364@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihang Li <liyihang9@huawei.com>

commit 3f030550476566b12091687c70071d05ad433e0d upstream.

In commit 63f0733d07ce ("scsi: hisi_sas: Allocate DFX memory during dump
trigger"), the memory allocation time of the DFX is changed from device
initialization to dump occurs, so .debugfs_itct is not a valid address and
do not need to check.

The parameter hisi_sas_debugfs_enable is enough to check whether automatic
debugfs dump is triggered, so remove redunant checks.

Fixes: 63f0733d07ce ("scsi: hisi_sas: Allocate DFX memory during dump trigger")
Signed-off-by: Yihang Li <liyihang9@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Link: https://lore.kernel.org/r/1705904747-62186-3-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1579,7 +1579,7 @@ static int hisi_sas_controller_prereset(
 		return -EPERM;
 	}
 
-	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct)
+	if (hisi_sas_debugfs_enable)
 		hisi_hba->hw->debugfs_snapshot_regs(hisi_hba);
 
 	return 0;
@@ -1967,7 +1967,7 @@ static bool hisi_sas_internal_abort_time
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct hisi_sas_internal_abort_data *timeout = data;
 
-	if (hisi_sas_debugfs_enable && hisi_hba->debugfs_itct[0].itct) {
+	if (hisi_sas_debugfs_enable) {
 		/*
 		 * If timeout occurs in device gone scenario, to avoid
 		 * circular dependency like:


