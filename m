Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE88A2D0C62;
	Wed, 28 Jan 2026 15:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614535; cv=none; b=B88pxmRU5MisqqrwX9CCKF0qkDBSeu1ImQEzpy20sNTMfS/uKrviBfpo7mcznxLxCz8DAhx431/UdGMUnhIxroaK9w8rSm44AZCMPOj65SZowqbANzIiyIXLni6hSj5IyQUv0jH8oF6ZgXS8ZFqrnN1yF9AjpkSVyxFPw0Kedjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614535; c=relaxed/simple;
	bh=Tf2XtfTSpUNd1YYxko6i3iLU67EdDAULn8CWI33lZaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C4QAygjReqmc9NB5CktpvpynPL6qPEKATB7m5maTxuknbkvS+5sSpTNC465qbG6WkExlf8wwpjks0CHX+aaxI+kaQRUuP1l6s8WmeCUqdiRYUmztRKbT6DF4sRH0m28L6aF990KHLEe4v/0RkpCYVypfihh3Eo4R70lSB9T3RSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8dvGzBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8dvGzBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BACC4CEF1;
	Wed, 28 Jan 2026 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614535;
	bh=Tf2XtfTSpUNd1YYxko6i3iLU67EdDAULn8CWI33lZaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8dvGzBx1F6m9vNa2D80srLjC6kATgQoBphkBYRtb02mzNdKMC2Hg9Slyt/4hS3uP
	 fFfupUcBuM66ai1JMN1VcGa4mjJvpzBHobLbVnl2cT+P9lMd0zh1liykTF4dtfsbYj
	 BaB/n0WuHlxb8tlrVVGjt3opzmRAZKTCXuBKzIjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 166/254] net: hns3: fix wrong GENMASK() for HCLGE_FD_AD_COUNTER_NUM_M
Date: Wed, 28 Jan 2026 16:22:22 +0100
Message-ID: <20260128145350.782487915@linuxfoundation.org>
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
index 4d15eb73b9728..659d6351f26c8 100644
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



