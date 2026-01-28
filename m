Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B33C318EE0;
	Wed, 28 Jan 2026 15:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615099; cv=none; b=Kq4ISTUGnPF4UkxS9ou3LlBzrdFck1IXz7zyo06vNG4JQMvdpfPUNssH3ggxvU5sM4cENjD1flkuAuP4YjmHpoyaoeAt1ngMYcHf1ikzox6zzDhmBSl+ME1o+vcNOSGO6dlNrjKjhqCqfGJxSvadqDrTyGj2zN3sECuCOClGnMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615099; c=relaxed/simple;
	bh=vv4N/9pDwPTdyPN9erEJ5IjfACnTscmZZhdUL8sELVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FobXkwN1eMRM9Uji5wqiQYYRIavoOnufk5QK+3cTcAaD5kNcnyopalJCjOQz7/xKOg3hmMEchedRCpOFzJBCVSvavVGFayUqSnTh4T8vsy4d0tfvPbVewY6/RNSYn/BFYkzdff+wMGYFyRgkFn59xnqjs5dUNdIpEI4oAZ+2SbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7bjujSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7bjujSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F3EC16AAE;
	Wed, 28 Jan 2026 15:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615099;
	bh=vv4N/9pDwPTdyPN9erEJ5IjfACnTscmZZhdUL8sELVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7bjujSiEkjrzlF1DPJmmVKxSvlv82f/A9lnmnUm2hvMRMyzKLkQ8e1b1RInOtltd
	 2RHOHj2/3uzRmgw4Q+jZtVG55wPHuRR2JB1w0wCMzmw+CApoJ8MrV1DE+dNVmYbjzg
	 LF6uXbzdWDIYmwAX0ZrT6fn4bbCUgwsGuyCgf3XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/169] net: hns3: fix the HCLGE_FD_AD_NXT_KEY error setting issue
Date: Wed, 28 Jan 2026 16:22:40 +0100
Message-ID: <20260128145336.778876018@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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
index 8dd970ef02ac6..7468e03051ea4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -5700,7 +5700,7 @@ static int hclge_fd_ad_config(struct hclge_dev *hdev, u8 stage, int loc,
 			HCLGE_FD_AD_COUNTER_NUM_S, action->counter_id);
 	hnae3_set_bit(ad_data, HCLGE_FD_AD_NXT_STEP_B, action->use_next_stage);
 	hnae3_set_field(ad_data, HCLGE_FD_AD_NXT_KEY_M, HCLGE_FD_AD_NXT_KEY_S,
-			action->counter_id);
+			action->next_input_key);
 
 	req->ad_data = cpu_to_le64(ad_data);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-- 
2.51.0



