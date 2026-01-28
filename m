Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2314E2F0C70;
	Wed, 28 Jan 2026 15:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615096; cv=none; b=OmmRvwtjnlPVbcoL+83wJyBHFWRzfQrD5FyIAWZvG7oBdBHc/+mSihSis4dzDaKCCP4SB7cjDS5UL8Bs4dxaBs9yFZvJKFOJUfX+Eojlg8TPCAiiO1UfMMg2J9YVQO13fVDSjsfQhWu38AGTD+XpBM2bkDCQTmVKRtJBXdoGo7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615096; c=relaxed/simple;
	bh=1jlyYbgMp7J3Pxb8hICz0i2f5+B7W1SE3FYLwJ0+djU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3lXvan1wEyvA2xDI7mJybvtTrMQYe0Mdv4ch0Hy4nt26VEmbjBQv/KYwQOc8D3D61I61mWDWElOtD2TN5Aec1by+MBY7baBW1x+GZ1dBqyjvinmZeVFTxtH4Bo6YsUBP5wfc8lZPkRfjuM3R5WH5/n2piBDYKfTUUrSNm8ZiW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuQFkTW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuQFkTW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCF0C116C6;
	Wed, 28 Jan 2026 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615096;
	bh=1jlyYbgMp7J3Pxb8hICz0i2f5+B7W1SE3FYLwJ0+djU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuQFkTW3xDEkeTHRZX+B56gGWLYWc/KH3glpcZa283Bq+dtakXEXVCt4qtvwV+/IT
	 /bLB19YjuJGYEb2Np2ormu0HOaJYkiGCM5i6Nq/53OSVCL2xMQPe6TvU8FErdaQfgj
	 WZpME5Yv9RxUy8rPEVzGTas3d4FcuWJZjjaVojEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/169] net: hns3: fix wrong GENMASK() for HCLGE_FD_AD_COUNTER_NUM_M
Date: Wed, 28 Jan 2026 16:22:39 +0100
Message-ID: <20260128145336.742996417@linuxfoundation.org>
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

[ Upstream commit d57c67c956a1bad15115eba6e59d77a6dfeba01d ]

HCLGE_FD_AD_COUNTER_NUM_M should be at GENMASK(19, 13),
rather than at GENMASK(20, 13), because bit 20 is
HCLGE_FD_AD_NXT_STEP_B.

This patch corrects the wrong definition.

Fixes: 117328680288 ("net: hns3: Add input key and action config support for flow director")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260119132840.410513-2-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 9bb708fa42f24..416e02e7b995f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -731,7 +731,7 @@ struct hclge_fd_tcam_config_3_cmd {
 #define HCLGE_FD_AD_QID_M		GENMASK(11, 2)
 #define HCLGE_FD_AD_USE_COUNTER_B	12
 #define HCLGE_FD_AD_COUNTER_NUM_S	13
-#define HCLGE_FD_AD_COUNTER_NUM_M	GENMASK(20, 13)
+#define HCLGE_FD_AD_COUNTER_NUM_M	GENMASK(19, 13)
 #define HCLGE_FD_AD_NXT_STEP_B		20
 #define HCLGE_FD_AD_NXT_KEY_S		21
 #define HCLGE_FD_AD_NXT_KEY_M		GENMASK(25, 21)
-- 
2.51.0



