Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250F81E1A05;
	Mon, 12 May 2025 17:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072686; cv=none; b=RmRJ7iszixV8xGPWZ63ZUU7IgYpBbVl3KKFexzd6zR+GJCXorrjcQ/2h5lv3OIIiAZ6trEABr6oop8KA0YbfsZ75GsmU7/yQXCi3UmztpSzf3uZBn+qccP5vjpK2TiyNDucjnQZ++vtItcwMuiFxjPKkrVp4L6AM73leFxh1/g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072686; c=relaxed/simple;
	bh=rSXZthPjBQXr3yXnnG/ABS/+sCYjW5JJaez4lT/skuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrJrlKVgOp6qYXWefHK20TgzTIQcutXT4+YDiJHSQ8ktbuclVhHOU8kCNwxMIy32Aas3f8fxKZEu8qctRBchpi9/R/NTnlB6l+xPuSpWsEQFAj5gGPVK83UTcaEHxfeIdiZnXAUkhrGyrJS9YpyiHPIR9ynk3ORIEMWv7LtnTO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kRraR2fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kRraR2fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8206DC4CEE7;
	Mon, 12 May 2025 17:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072686;
	bh=rSXZthPjBQXr3yXnnG/ABS/+sCYjW5JJaez4lT/skuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kRraR2fwYDNfNSgXQN4HTnMT7e/mSy6UkbUBMgv0+QomBuulyUNOSPA2UD73TRUKs
	 sCGb7TJxTHcq3yGI7pvssHwKKNxqSAC6b89HdCkVWMeI8/hXTHVxCg7PxNdt2KzcR9
	 BoYMdgtwyqAE+zNSMN8B53XpMdoQsMybCFkCEwTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 024/184] net: ethernet: mtk_eth_soc: do not reset PSE when setting FE
Date: Mon, 12 May 2025 19:43:45 +0200
Message-ID: <20250512172042.685343898@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit e8716b5b0dff1b3d523b4a83fd5e94d57b887c5c ]

Remove redundant PSE reset.
When setting FE register there is no need to reset PSE,
doing so may cause FE to work abnormal.

Link: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/3a5223473e086a4b54a2b9a44df7d9ddcc2bc75a
Fixes: dee4dd10c79aa ("net: ethernet: mtk_eth_soc: ppe: add support for multiple PPEs")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Link: https://patch.msgid.link/18f0ac7d83f82defa3342c11ef0d1362f6b81e88.1746406763.git.daniel@makrotopia.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index d50017012ca14..0a13f7c4684e0 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3427,9 +3427,6 @@ static int mtk_open(struct net_device *dev)
 			}
 			mtk_gdm_config(eth, target_mac->id, gdm_config);
 		}
-		/* Reset and enable PSE */
-		mtk_w32(eth, RST_GL_PSE, MTK_RST_GL);
-		mtk_w32(eth, 0, MTK_RST_GL);
 
 		napi_enable(&eth->tx_napi);
 		napi_enable(&eth->rx_napi);
-- 
2.39.5



