Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF9B2D0C62;
	Wed, 28 Jan 2026 15:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614542; cv=none; b=TghqKszeUM5Z3RwnT11B/qmV/7ZWr3tDiKyJk+JQiO6roqYD5lZf9gOAThUDTy7bvgFoQlQ6bTIQB7la6MF/I21RF2at4zjOEsSHfYBfPE64zhvbwTSBRzO//KoZZ4GwNlEoc0J32TdJk4O9ohpZ6TbgN+uqgFl2HXBu0ewRQtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614542; c=relaxed/simple;
	bh=3jJc+ByqzsTicWlKTgvpkoF1mBJrx4umyOgY0nOlKnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S94hfuqOLC9WC8dtGpZhHZODBxaeYRbHPsprsPlaJGwpa38PdZLQ5EwTJLF5SUvlkFW5dG+XuN5ooIiR60tOSuNir3xH+IFefG8V0ytvEU4TsfFSxl1LYWcN2Wa1tgFnvNOoVl3hGKdunrw1chHBDt4bwtBENyFZb+hL0O6fkMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZqRSVjt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZqRSVjt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EA4C4CEF1;
	Wed, 28 Jan 2026 15:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614542;
	bh=3jJc+ByqzsTicWlKTgvpkoF1mBJrx4umyOgY0nOlKnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqRSVjt6FixR1Mxh1fPVfZTkaIFRD0sUtHOTYUuMoG1wzfktZBWFUyE8J1ksJCP7O
	 4L4W3sRgrpA4WSXXKCh/ncZJUtfsQjf62QAaqfWU4wvDEDqegBBw5CzDOI4n8QQchW
	 cq+IKDPz1gZsGiZpHUqxD1xIhC1Iy4DY7bLidrJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/254] net: hns3: fix the HCLGE_FD_AD_NXT_KEY error setting issue
Date: Wed, 28 Jan 2026 16:22:23 +0100
Message-ID: <20260128145350.817734591@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit f87e034d16e43af984380a95c32c25201b7759a7 ]

Use next_input_key instead of counter_id to set HCLGE_FD_AD_NXT_KEY.

Fixes: 117328680288 ("net: hns3: Add input key and action config support for flow director")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260119132840.410513-3-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 2df0c6305b908..72a5df4e3a329 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5617,7 +5617,7 @@ static int hclge_fd_ad_config(struct hclge_dev *hdev, u8 stage, int loc,
 			HCLGE_FD_AD_COUNTER_NUM_S, action->counter_id);
 	hnae3_set_bit(ad_data, HCLGE_FD_AD_NXT_STEP_B, action->use_next_stage);
 	hnae3_set_field(ad_data, HCLGE_FD_AD_NXT_KEY_M, HCLGE_FD_AD_NXT_KEY_S,
-			action->counter_id);
+			action->next_input_key);
 
 	req->ad_data = cpu_to_le64(ad_data);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-- 
2.51.0



