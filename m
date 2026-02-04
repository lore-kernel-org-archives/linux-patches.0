Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282854218A0;
	Wed,  4 Feb 2026 15:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217859; cv=none; b=eCcpYtX6FeEijOlOqKqdbtPXXtrEIUyHF5T7sVgbMOdGo4zZ/pEc/m+C+CgntfWid9j/RyXEFQd5b1jFwtG12DHNOeAqsG2wgO6/Q1Pk/NoXXgjcClXYT08d+bTG0wRhjo8ZfkkH71404S+wyW0Mgo08S9XWPCUjrS3tWr74j1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217859; c=relaxed/simple;
	bh=MFCR0NfoQF9C7XPTECmOJpQgbpyQC/9X3xbGtxrCzEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MoI6MEI3byj074tdsdzAsHC90k2ULn3v61oORbw4YkzDytoTzFt2hQbhUQCrZLuIuSIMuWyYG9+GkO3ClLOyVm6tiECWxo+iYxcNua72IeeqD09h3LvNNN4Ixq+OrrzSmZOgvstIzR/7mJj8T32izvE2jxVIiLAeK1422TwDZA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2QNy/vN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2QNy/vN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92F5AC4CEF7;
	Wed,  4 Feb 2026 15:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217859;
	bh=MFCR0NfoQF9C7XPTECmOJpQgbpyQC/9X3xbGtxrCzEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2QNy/vNqXpxhEzJ/JAF6tSAn9/tjEMc44rl4kvh/Lhc8L4VjzE8Mvz69olxG/iOr
	 HQrEAR4lGzBpiyboQ+b0oN+QdT5F0EcetzVL2AE83qDWH8xXdWHcE/34+E5lkQlj1o
	 hfEENDmM0sS4rO+C/p9vrAcdtkvV4ZW+bP8W373o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 141/280] net: hns3: fix the HCLGE_FD_AD_NXT_KEY error setting issue
Date: Wed,  4 Feb 2026 15:38:35 +0100
Message-ID: <20260204143914.709995939@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a92f056b25613..42173a076163f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5717,7 +5717,7 @@ static int hclge_fd_ad_config(struct hclge_dev *hdev, u8 stage, int loc,
 			HCLGE_FD_AD_COUNTER_NUM_S, action->counter_id);
 	hnae3_set_bit(ad_data, HCLGE_FD_AD_NXT_STEP_B, action->use_next_stage);
 	hnae3_set_field(ad_data, HCLGE_FD_AD_NXT_KEY_M, HCLGE_FD_AD_NXT_KEY_S,
-			action->counter_id);
+			action->next_input_key);
 
 	req->ad_data = cpu_to_le64(ad_data);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-- 
2.51.0



