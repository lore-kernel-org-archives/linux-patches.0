Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A665341050
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301113; cv=none; b=Y3m0pcDaAMnuTbLZobZ5Kc4GDCqml5FcmVWUBUHVOytTnzsirQtrReP8YDof2WiUaaKxKJTyAD12gvd6zkTBz8xaKyih8BUb9cfa266y9O5EDdNhMqZdB0khuH0OeQ9mmUpVStIxLXNGeWMUVw7SlAWzMjceYMcpFM/afc8ppDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301113; c=relaxed/simple;
	bh=DirXIxAhwdT0lstMLCp2iCpIVTxa4NIl9yct4maVT+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jntSxtY/DL1uBmDqUgDVYb0WJugdqa7aEo/SshBH7iH5pzsN8IE7zbSaPwM33XFECeOm6aYQdg1hvArPtRUpUo45qxKkhhQ7zAlUHZaqXQXkdYm9cxVG1oMfJ88VaPLqCVBlJfrmTnhChFU33cUNyUY+/oxdMKF4RDhiaDtsrlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFkgCVAh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFkgCVAh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A892C19424;
	Sat, 28 Feb 2026 17:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301112;
	bh=DirXIxAhwdT0lstMLCp2iCpIVTxa4NIl9yct4maVT+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFkgCVAhJmP0iZCmuC/AzzP0t+vj+G1kj8prTQl9LBVGVHRtVmJlVceKM0NxTdLVS
	 e8oi+GKS4lauwAraPZkaQDfdNb1ZfnVdIZyXhUYjoOO0MMgkF52cW8tGYa/a2jon2U
	 oDOC2LTCvVNEGK7P6D+4X/tLkwN/B1rK4sh1MXcx9yEGyrffwA9E2d7xMNoWwQD8jW
	 1B2oZEp0qxdwi31AjmOEV0aIg3teGz5qBef2jrY6YGMYhwJGJUEJk3IrjUYmiHuQTS
	 Ly/qPjPVMCsVyy0ZB4EzHey7z2lqPNCs8S1SXtCehXHl7zoBNM503i98Y1Z9HCyx0V
	 Jxt+tOQ7I9d7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 268/752] net: hns3: extend HCLGE_FD_AD_QID to 11 bits
Date: Sat, 28 Feb 2026 12:39:39 -0500
Message-ID: <20260228174750.1542406-268-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 878406d4d6ef85c37fab52074771cc916e532c16 ]

Currently, HCLGE_FD_AD_QID has only 10 bits and supports a
maximum of 1023 queues. However, there are actually scenarios
where the queue_id exceeds 1023.

This patch adds an additional bit to HCLGE_FD_AD_QID to ensure
that queue_id greater than 1023 are supported.

Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260123094756.3718516-2-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  | 5 +++--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 416e02e7b995f..bc333d8710ac1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -727,8 +727,8 @@ struct hclge_fd_tcam_config_3_cmd {
 
 #define HCLGE_FD_AD_DROP_B		0
 #define HCLGE_FD_AD_DIRECT_QID_B	1
-#define HCLGE_FD_AD_QID_S		2
-#define HCLGE_FD_AD_QID_M		GENMASK(11, 2)
+#define HCLGE_FD_AD_QID_L_S		2
+#define HCLGE_FD_AD_QID_L_M		GENMASK(11, 2)
 #define HCLGE_FD_AD_USE_COUNTER_B	12
 #define HCLGE_FD_AD_COUNTER_NUM_S	13
 #define HCLGE_FD_AD_COUNTER_NUM_M	GENMASK(19, 13)
@@ -741,6 +741,7 @@ struct hclge_fd_tcam_config_3_cmd {
 #define HCLGE_FD_AD_TC_OVRD_B		16
 #define HCLGE_FD_AD_TC_SIZE_S		17
 #define HCLGE_FD_AD_TC_SIZE_M		GENMASK(20, 17)
+#define HCLGE_FD_AD_QID_H_B		21
 
 struct hclge_fd_ad_config_cmd {
 	u8 stage;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 5cc5ee9dcd982..54d0a9ba7879b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5679,11 +5679,13 @@ static int hclge_fd_ad_config(struct hclge_dev *hdev, u8 stage, int loc,
 		hnae3_set_field(ad_data, HCLGE_FD_AD_TC_SIZE_M,
 				HCLGE_FD_AD_TC_SIZE_S, (u32)action->tc_size);
 	}
+	hnae3_set_bit(ad_data, HCLGE_FD_AD_QID_H_B,
+		      action->queue_id >= HCLGE_TQP_MAX_SIZE_DEV_V2 ? 1 : 0);
 	ad_data <<= 32;
 	hnae3_set_bit(ad_data, HCLGE_FD_AD_DROP_B, action->drop_packet);
 	hnae3_set_bit(ad_data, HCLGE_FD_AD_DIRECT_QID_B,
 		      action->forward_to_direct_queue);
-	hnae3_set_field(ad_data, HCLGE_FD_AD_QID_M, HCLGE_FD_AD_QID_S,
+	hnae3_set_field(ad_data, HCLGE_FD_AD_QID_L_M, HCLGE_FD_AD_QID_L_S,
 			action->queue_id);
 	hnae3_set_bit(ad_data, HCLGE_FD_AD_USE_COUNTER_B, action->use_counter);
 	hnae3_set_field(ad_data, HCLGE_FD_AD_COUNTER_NUM_M,
-- 
2.51.0

