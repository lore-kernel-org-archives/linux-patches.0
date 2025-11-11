Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8EF33FE26;
	Tue, 11 Nov 2025 01:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824024; cv=none; b=rWtgF1gPuRCs6s1VBLEf8fbGwNr2o9yC157/XLp3o1z0HaTfuEEtUjGajUcQ/uYXqsRT7krT6o2SJEHBSom6JWpcqZMP8i6p51z6ewb3xt2s39DNeBXLeVNu3yzh/9IUcThUkozk2EgnDG3glnffymI52toyPrhiIJacKFpM768=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824024; c=relaxed/simple;
	bh=keZmqWeOPgZa2p0VY/x9ShlnPC00vgHoE5LN1tRWHsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5r8apf2dTprozXhmZIDXzxZS7/ZPI/Ile5H6sFszrLjHaOmQojlXEMs6f9I0VrvJYPcrwVTSxZ7yJs4tD5DZa5yS6Gz0Qzjgw2N3RGvurMPKvMbaAgZcbgTo+NBGw45WSycdDsLvaOm22XusK4xoCtNxuSLnmZqlJG5z9/3TRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJqBkH1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJqBkH1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67353C4CEF5;
	Tue, 11 Nov 2025 01:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824024;
	bh=keZmqWeOPgZa2p0VY/x9ShlnPC00vgHoE5LN1tRWHsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJqBkH1KkbgmoyoMuLkmb+3+QZ0KUFTe8o1ovz6IHVVSz8HC3dCAIyYh3l2yolRTV
	 F8zwsmcLaGPGudM0Tbqr+ffHNHAshoid+fGEsrvZxSbt0RUZprJSuQ1KBsbZtua5Zp
	 8S6p+CiWZrpeHjieMOcdGKKpK7GFAuuIkUc/19kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 373/565] scsi: ufs: core: Disable timestamp functionality if not supported
Date: Tue, 11 Nov 2025 09:43:49 +0900
Message-ID: <20251111004535.260302077@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit fb1f4568346153d2f80fdb4ffcfa0cf4fb257d3c ]

Some Kioxia UFS 4 devices do not support the qTimestamp attribute.  Set
the UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT for these devices such that no
error messages appear in the kernel log about failures to set the
qTimestamp attribute.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Tested-by: Nitin Rawat <quic_nitirawa@quicinc.com> # on SM8650-QRD
Reviewed-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Message-ID: <20250909190614.3531435-1-bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 6 +++++-
 include/ufs/ufs_quirks.h  | 3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d4dbb6769efa2..fca05834eefc2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -295,6 +295,9 @@ static const struct ufs_dev_quirk ufs_fixups[] = {
 	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
 	  .model = "THGLF2G9D8KBADG",
 	  .quirk = UFS_DEVICE_QUIRK_PA_TACTIVATE },
+	{ .wmanufacturerid = UFS_VENDOR_TOSHIBA,
+	  .model = "THGJFJT1E45BATP",
+	  .quirk = UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT },
 	{}
 };
 
@@ -8670,7 +8673,8 @@ static void ufshcd_set_timestamp_attr(struct ufs_hba *hba)
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	struct utp_upiu_query_v4_0 *upiu_data;
 
-	if (dev_info->wspecversion < 0x400)
+	if (dev_info->wspecversion < 0x400 ||
+	    hba->dev_quirks & UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT)
 		return;
 
 	ufshcd_dev_man_lock(hba);
diff --git a/include/ufs/ufs_quirks.h b/include/ufs/ufs_quirks.h
index f52de5ed1b3b6..83563247c36cb 100644
--- a/include/ufs/ufs_quirks.h
+++ b/include/ufs/ufs_quirks.h
@@ -113,4 +113,7 @@ struct ufs_dev_quirk {
  */
 #define UFS_DEVICE_QUIRK_PA_HIBER8TIME          (1 << 12)
 
+/* Some UFS 4 devices do not support the qTimestamp attribute */
+#define UFS_DEVICE_QUIRK_NO_TIMESTAMP_SUPPORT	(1 << 13)
+
 #endif /* UFS_QUIRKS_H_ */
-- 
2.51.0



