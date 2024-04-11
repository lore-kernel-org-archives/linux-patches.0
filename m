Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F9F148307;
	Thu, 11 Apr 2024 10:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832079; cv=none; b=jXeBCANlAgg8guZPhuJTneeEsiBeWD7I/n/04Uvj4yPIvuRraq6/L2RMtplXHO58bSmxeuoyuckxRqCX2yWdlo3w2WKpcnmwBntf8Yh2KAmw+DyX3lXWg72HLzN1RCvJ1E34n+UvdPm1tAhN9eebfriySlG6hzIToq0CH0LFdSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832079; c=relaxed/simple;
	bh=dbobdOljRClbxcI+cMo9Xc4RKUgPgARpJRZnL4nM/88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Il+psmVHJutL2JUwYQaxmcBwgDYxljxZZAyoUq+sl1r4SFCZrAal7FHbtOaG5stYIkKs3xlrnApImT2YxboHrmsZSdUMue3WAoANWc3/cyWGgFGVulUYxZrJj7y6nzlqnvNH4ILvztKPV0ynEWJMHMvpqnlmWslgQbLOH/CfWZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuKFp/gW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuKFp/gW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74631C43330;
	Thu, 11 Apr 2024 10:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832079;
	bh=dbobdOljRClbxcI+cMo9Xc4RKUgPgARpJRZnL4nM/88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuKFp/gW3BvgJEHT7RvwUS7/kiyrAD3/VjYqaqzB0KKrmyAKOIBzwWS0TTVUjSE+g
	 RqFo15d/ACnARGUWEnE2mZKpN5MxroxeVPAl44l6bWrX4WURAukxdR/3q+N7FwNuMJ
	 zM3C+NxkcyDVBhp/uorrQ7mMXscZ0XlZ0cp5LWe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Bikash Hazarika <bhazarika@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 221/294] scsi: qla2xxx: Update manufacturer details
Date: Thu, 11 Apr 2024 11:56:24 +0200
Message-ID: <20240411095442.247449076@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bikash Hazarika <bhazarika@marvell.com>

[ Upstream commit 1ccad27716ecad1fd58c35e579bedb81fa5e1ad5 ]

Update manufacturer details to indicate Marvell Semiconductors.

Link: https://lore.kernel.org/r/20220713052045.10683-10-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 688fa069fda6 ("scsi: qla2xxx: Update manufacturer detail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_def.h | 2 +-
 drivers/scsi/qla2xxx/qla_gs.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 6645b69fc2a0f..7dfd93cb4674d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -56,7 +56,7 @@ typedef struct {
 #include "qla_nvme.h"
 #define QLA2XXX_DRIVER_NAME	"qla2xxx"
 #define QLA2XXX_APIDEV		"ql2xapidev"
-#define QLA2XXX_MANUFACTURER	"QLogic Corporation"
+#define QLA2XXX_MANUFACTURER	"Marvell Semiconductor, Inc."
 
 /*
  * We have MAILBOX_REGISTER_COUNT sized arrays in a few places,
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 20bbd69e35e51..d9ac17dbad789 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1614,7 +1614,7 @@ qla2x00_hba_attributes(scsi_qla_host_t *vha, void *entries,
 	eiter->type = cpu_to_be16(FDMI_HBA_MANUFACTURER);
 	alen = scnprintf(
 		eiter->a.manufacturer, sizeof(eiter->a.manufacturer),
-		"%s", "QLogic Corporation");
+		"%s", QLA2XXX_MANUFACTURER);
 	alen += FDMI_ATTR_ALIGNMENT(alen);
 	alen += FDMI_ATTR_TYPELEN(eiter);
 	eiter->len = cpu_to_be16(alen);
-- 
2.43.0



