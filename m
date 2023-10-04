Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69A21D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:14:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6479CC433C7;
	Wed,  4 Oct 2023 18:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443272;
	bh=cluHQzLWox9Ye5QXUiZ4MAxIWBpPuO/FVa2KRwDZYJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwbUdUXTRsHerVwu5Utl8oRThmP+pQE6TtgL5jxiCqgpP+3g27CmoH9l24xt+ydlz
	 pHlCnZhsgFXZLfDR+aG97Hl5U9REfMiAL59cJ7dVxnWCyLWQp9pBruPiL/ad8Ff85A
	 SqpgWmExicO3BT5YFdmfvD5Ft4kwbS8Qhe13XVHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/259] net: hns3: add cmdq check for vf periodic service task
Date: Wed,  4 Oct 2023 19:54:02 +0200
Message-ID: <20231004175220.569034043@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit bd3caddf299a640efb66c6022efed7fe744db626 ]

When the vf cmdq is disabled, there is no need to keep these task running.
So this patch skip these task when the cmdq is disabled.

Fixes: ff200099d271 ("net: hns3: remove unnecessary work in hclgevf_main")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index b1b14850e958f..72cf5145e15a2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1909,7 +1909,8 @@ static void hclgevf_periodic_service_task(struct hclgevf_dev *hdev)
 	unsigned long delta = round_jiffies_relative(HZ);
 	struct hnae3_handle *handle = &hdev->nic;
 
-	if (test_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state))
+	if (test_bit(HCLGEVF_STATE_RST_FAIL, &hdev->state) ||
+	    test_bit(HCLGE_COMM_STATE_CMD_DISABLE, &hdev->hw.hw.comm_state))
 		return;
 
 	if (time_is_after_jiffies(hdev->last_serv_processed + HZ)) {
-- 
2.40.1



