Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE41248BA6;
	Wed, 15 Jan 2025 10:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937989; cv=none; b=M/vCZML8GuGIoi6zlu0LsE0hKbQgr6FXf4IqzTTm0ilaej5SlXiHcaqtA1j9C8l1gWyNVfpbtlNzUiXKgWGfl95VUJNBRcIIZ3RJdWnWc7NAGVNuyoIDwJ594qe2dk2hSENHTTwVUAO/5bkkXu3qYWSwRLYUok5Bx6ZVGhLODoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937989; c=relaxed/simple;
	bh=BbwmXF8hk8b+6LbWrDEpkuoVNLcpeCt3Q6vWxx9rTGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYpRulfZ4K8BPjs5UXQfP0HhejXr8TnvWBvkMbPVsVbpWejvnUiVtyqLKgpf7OgFwe3Rl2iiW435cNQ6BQCGfZ8aHMmklvw0n7Zwm6leIQEkBqPKzNRfPjr6pA/4aN1cenQGswWHi5e9ss9dzzHv0g6iy7SWirHQUbVaULoJIfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMm4UJQ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMm4UJQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE7AC4CEDF;
	Wed, 15 Jan 2025 10:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937988;
	bh=BbwmXF8hk8b+6LbWrDEpkuoVNLcpeCt3Q6vWxx9rTGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMm4UJQ/6qSbNb3xwCWj2G6PUyz9GPrnTBPXpnNCRGbtp9APRMqVDnPX0o8TML7ZY
	 3LA4UwjgWavzvWIJ3ZDjNBER4MuEJw5GznKsxUZq8GlFLiqJmLa4DPQkDE5qaMM2w2
	 vnZhAfEl48AZEGntghYCXY69nLKB4l5ZMd72h3Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/189] net: hns3: initialize reset_timer before hclgevf_misc_irq_init()
Date: Wed, 15 Jan 2025 11:35:46 +0100
Message-ID: <20250115103608.349949414@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 247fd1e33e1cd156aabe444e932d2648d33f1245 ]

Currently the misc irq is initialized before reset_timer setup. But
it will access the reset_timer in the irq handler. So initialize
the reset_timer earlier.

Fixes: ff200099d271 ("net: hns3: remove unnecessary work in hclgevf_main")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20250106143642.539698-6-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index ab54e6155e93..d47bd8d6145f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2315,6 +2315,8 @@ static void hclgevf_state_init(struct hclgevf_dev *hdev)
 	clear_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state);
 
 	INIT_DELAYED_WORK(&hdev->service_task, hclgevf_service_task);
+	/* timer needs to be initialized before misc irq */
+	timer_setup(&hdev->reset_timer, hclgevf_reset_timer, 0);
 
 	mutex_init(&hdev->mbx_resp.mbx_mutex);
 	sema_init(&hdev->reset_sem, 1);
@@ -3014,7 +3016,6 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 		 HCLGEVF_DRIVER_NAME);
 
 	hclgevf_task_schedule(hdev, round_jiffies_relative(HZ));
-	timer_setup(&hdev->reset_timer, hclgevf_reset_timer, 0);
 
 	return 0;
 
-- 
2.39.5



