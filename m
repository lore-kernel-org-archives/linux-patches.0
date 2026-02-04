Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B275165F1A;
	Wed,  4 Feb 2026 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216399; cv=none; b=rjgMYHF4mdSvntKep7ODW4qjvoANv0DSXWecz5nJrMGM5qq8uiU7TKRjoKwKz2pKSuf+RYMRa/RsV4RzuBXABPj9EtDCjKwwnbQrZf/KfSjipCQeRPvcuUOxPKFkSftZSj5fQci1otKdidpMmQUzmlUDjh9axZJbarL869CAZck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216399; c=relaxed/simple;
	bh=NBiVpGI2gs3R+UENBiCwWEnbwnOwzNpceG10vozOlyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnPTcfLyGdJJCMF2ul3QcHDw/zQYyCiC8Afn63qOuv+GjKHZVc0jISaCnhKgZYG2nQD4Z4nPxYtgeaq+5mk3IB4Nf2Zfk+W6oHYJSiiWSWTSlY2BTAKxGb8OAjyBKsQY+vAr7jYwfZ3Vf+TNJqlrzUAo0s8drjE6ZSVMB2GRWp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPToV/ys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPToV/ys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D6CC4CEF7;
	Wed,  4 Feb 2026 14:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216399;
	bh=NBiVpGI2gs3R+UENBiCwWEnbwnOwzNpceG10vozOlyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPToV/ysGEuiIoH6S50D18hAdVcvBNz/Y3BFBxylrPohP4dDQbA3/SXy8wJXQ2zCS
	 hUM5gQZFT3to4I8xlACtPraM0gSHwB0d2itadS0NRoG6o91WKUq7TUXbWW4HCYakeh
	 W0kIY3plWN4Mzw4CfXzs1xB7GBcuahSe3ubyfRKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/161] net: hns3: fix the HCLGE_FD_AD_NXT_KEY error setting issue
Date: Wed,  4 Feb 2026 15:39:00 +0100
Message-ID: <20260204143854.523718906@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 99b5b956ed8f9..fa51463bfd8b4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5109,7 +5109,7 @@ static int hclge_fd_ad_config(struct hclge_dev *hdev, u8 stage, int loc,
 			HCLGE_FD_AD_COUNTER_NUM_S, action->counter_id);
 	hnae3_set_bit(ad_data, HCLGE_FD_AD_NXT_STEP_B, action->use_next_stage);
 	hnae3_set_field(ad_data, HCLGE_FD_AD_NXT_KEY_M, HCLGE_FD_AD_NXT_KEY_S,
-			action->counter_id);
+			action->next_input_key);
 
 	req->ad_data = cpu_to_le64(ad_data);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-- 
2.51.0



