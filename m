Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED0B17756
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86115C433C9;
	Wed,  9 Aug 2023 11:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580169;
	bh=ZGj42isl13P3QjbjoK9zqVUaG+jSy7GXtgp31VMvfb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ywW2YZ8wNw6h5ZiQTNWkOHf89Ph1E+qE4jXcJnMbhAoEE/vu8GVqb+zM9iosko7G
	 M0/ucnyuf6YnMiqZMrKWgOYPL9Kv54oMgjnsEVKFfsJz/NnGdGGySehwe3viZFwp5s
	 QgOvMCIPPTeqxDGF2PMcFx1ue/VlXSgZPH2icwXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hulk Robot <hulkci@huawei.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Nilesh Javali <njavali@marvell.com>,
	Ye Bin <yebin10@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 235/323] scsi: qla2xxx: Fix inconsistent format argument type in qla_os.c
Date: Wed,  9 Aug 2023 12:41:13 +0200
Message-ID: <20230809103708.836378273@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 250bd00923c72c846092271a9e51ee373db081b6 ]

Fix the following warnings:

[drivers/scsi/qla2xxx/qla_os.c:4882]: (warning) %ld in format string (no. 2)
	requires 'long' but the argument type is 'unsigned long'.
[drivers/scsi/qla2xxx/qla_os.c:5011]: (warning) %ld in format string (no. 1)
	requires 'long' but the argument type is 'unsigned long'.

Link: https://lore.kernel.org/r/20200930022515.2862532-3-yebin10@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Reviewed-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: d721b591b95c ("scsi: qla2xxx: Array index may go out of bound")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7863ad1390f8a..73f3e51ce9798 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4604,7 +4604,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	}
 	INIT_DELAYED_WORK(&vha->scan.scan_work, qla_scan_work_fn);
 
-	sprintf(vha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, vha->host_no);
+	sprintf(vha->host_str, "%s_%lu", QLA2XXX_DRIVER_NAME, vha->host_no);
 	ql_dbg(ql_dbg_init, vha, 0x0041,
 	    "Allocated the host=%p hw=%p vha=%p dev_name=%s",
 	    vha->host, vha->hw, vha,
@@ -4735,7 +4735,7 @@ qla2x00_uevent_emit(struct scsi_qla_host *vha, u32 code)
 
 	switch (code) {
 	case QLA_UEVENT_CODE_FW_DUMP:
-		snprintf(event_string, sizeof(event_string), "FW_DUMP=%ld",
+		snprintf(event_string, sizeof(event_string), "FW_DUMP=%lu",
 		    vha->host_no);
 		break;
 	default:
-- 
2.39.2



