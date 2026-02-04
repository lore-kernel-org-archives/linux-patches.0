Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C671C5D77;
	Wed,  4 Feb 2026 14:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216395; cv=none; b=LGecWe4/0f9RfGjqeamSFNxbKOPZhuzAvHEo5RL8OuJ3sxLhwicERpDBNWv7kwXCV6G/Gzege7zZcNs4KYIzhivlV2sHqKIE0VM0DdKOYi08e5pExnIAP2TtKx0pwuQapcc2j+x+qw/tFByjHaHdfOO5wWGRDmCGelhG6TpH+Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216395; c=relaxed/simple;
	bh=jAxogVbj8OTNZn64WzlIVxnB/Q9FGa13ZbQy5Wx9h9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTyAQWpcsZlyUcrY7kw62zCgaYoko+uRP47ua1/bL73agHsFqQ6jFVGcu1oQUHy48NncWpTUWQG9zB8npZ3inGAAyRY+Nxbtfx/qedyD8odcViApOdlYslgq/JfBeSDvMNWTiO9NkCIGzivSNqnWjGHKVBpmnbWVWPRWfniJL1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfZliqle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfZliqle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAEEC4CEF7;
	Wed,  4 Feb 2026 14:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216395;
	bh=jAxogVbj8OTNZn64WzlIVxnB/Q9FGa13ZbQy5Wx9h9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cfZliqlefofykA8JJz5VR6tcAmla1PuHUMFTBXEQda06ObDeIvFajs7hU5zKLVkiG
	 gssuAuZ1YUvVkG9U0rbYh19s5DocgYjhS3Kw1FSHYKAkhxMMH4pFVhUZ7r7PuICBVi
	 30Z1D8drihgryX6Rs+J3jvCX92n8cDougnFELl8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/161] net: hns3: fix wrong GENMASK() for HCLGE_FD_AD_COUNTER_NUM_M
Date: Wed,  4 Feb 2026 15:38:59 +0100
Message-ID: <20260204143854.487656748@linuxfoundation.org>
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
index 3d70c3a47d631..67d878eb8a7d6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1038,7 +1038,7 @@ struct hclge_fd_tcam_config_3_cmd {
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



