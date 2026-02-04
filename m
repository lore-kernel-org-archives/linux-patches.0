Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AFF280CD2;
	Wed,  4 Feb 2026 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217097; cv=none; b=L3lRjgp9BhpnnRTKnTitGlpQ4lnfKvvZPMbZruq9Izd/DK0ruVcYmTU1LR8FZ1xoJgl8LivNoWkOug9dSJ2g7wbsO97ifMzDVyWZuroAfHZ2UBkYs1yBOqQovg2U9ZIqfOcZ0nLCjoe3eIFU2kHkYL+bsxSCtf4K8jinX/F1dsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217097; c=relaxed/simple;
	bh=Tgs29H53UwT1Ca9+ugR6lR3EaAF0/UrcHuVTecpIW7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T2DU2LLXu/uBRq01ZVmEh01K6DYkZzGUzHymYglnpchLbQYY83NbrdSDRlibCin5Na7tmf7PwZxt89kEWGYqfvkdVReKIfk2pI8fjCumzn0+EjijIRQ5YXnlERAgQBz2zbonzwFTzzVN9uqi09RaFht0Ao6E9qC7Wo7Yh0q07qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWP2hp4l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWP2hp4l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E643FC4CEF7;
	Wed,  4 Feb 2026 14:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217096;
	bh=Tgs29H53UwT1Ca9+ugR6lR3EaAF0/UrcHuVTecpIW7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWP2hp4lZMZHc3O/zBS6RfUgTKKkzlVuN61x0zB7mM9byQ3GxR8Z6jqj/K67BizHD
	 WL+C+bdU7RLUZHRAFP3lWwx4fixE2M/eILMO4Z/wEnYIE+tPB6fvRv3vnhK6tuo+wY
	 m4BdvZK5wqCn7QmiWSW85X6N5wS8WU6+7qBNAvRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/206] net: hns3: fix the HCLGE_FD_AD_NXT_KEY error setting issue
Date: Wed,  4 Feb 2026 15:38:46 +0100
Message-ID: <20260204143901.626865421@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dd9d5df31905a..1dae7500fa57c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5856,7 +5856,7 @@ static int hclge_fd_ad_config(struct hclge_dev *hdev, u8 stage, int loc,
 			HCLGE_FD_AD_COUNTER_NUM_S, action->counter_id);
 	hnae3_set_bit(ad_data, HCLGE_FD_AD_NXT_STEP_B, action->use_next_stage);
 	hnae3_set_field(ad_data, HCLGE_FD_AD_NXT_KEY_M, HCLGE_FD_AD_NXT_KEY_S,
-			action->counter_id);
+			action->next_input_key);
 
 	req->ad_data = cpu_to_le64(ad_data);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-- 
2.51.0



