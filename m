Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6046332ECA;
	Fri, 17 Oct 2025 15:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715173; cv=none; b=WxziAO4gX0gSqI25k8d5o6gY2trod0M5lvsg2+4t6mloHlb6b1zc2ar+lT4xFA8X4GBkN0BswKbYuD0awK7NFPCgVg9dcHMKUxVyzaHtlV/BjvsjJwg4enqqtTDXWJPGUPQOmi3nu07HSb9fDlwTt+92t6rFl6MFsEBSmMmdme0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715173; c=relaxed/simple;
	bh=MTLs49ZwJCoX9jBOxPcsYNNDz6qxAwSXyX2qPv+NRSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Out2nKstrVFSEJp47JHBndJlNALS6jt6L77tmddUvTPhbFlQnDNnQ4vwdeLlq4ejxRGKiLLMQIors/pY2KNSO/RorrqaRXBZBdtsemZySzXO5odP0XqxDkuPIO6EB0gqBi+voIHjjsI1PSCo9j9W0Z47y3nCEGNf5EUCiIOt1M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kY62XCAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kY62XCAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F1AC4CEFE;
	Fri, 17 Oct 2025 15:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715173;
	bh=MTLs49ZwJCoX9jBOxPcsYNNDz6qxAwSXyX2qPv+NRSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kY62XCAZUPeAouk6sT+ySKDiAo/+E4gCNk4pMgrlX4KxC+TVg/lIkyOiLMLJS0hqF
	 6pRgtLh1iNuMjeIEGZs7OR+dsL/U/AHgA9rBSHgy4TURujct/jxHkyaz4orMAtz30h
	 r8BMwOaSa0xyIAcNk1+pyipbnvK0uPTWezGwrd1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 122/371] net: airoha: Fix loopback mode configuration for GDM2 port
Date: Fri, 17 Oct 2025 16:51:37 +0200
Message-ID: <20251017145206.348122356@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit fea8cdf6738a8b25fccbb7b109b440795a0892cb ]

Add missing configuration for loopback mode in airhoha_set_gdm2_loopback
routine.

Fixes: 9cd451d414f6e ("net: airoha: Add loopback support for GDM2")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20251008-airoha-loopback-mode-fix-v2-1-045694fe7f60@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c  | 4 +++-
 drivers/net/ethernet/airoha/airoha_regs.h | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index e6b802e3d8449..6d23c5c049b9a 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1709,7 +1709,9 @@ static void airhoha_set_gdm2_loopback(struct airoha_gdm_port *port)
 	airoha_fe_wr(eth, REG_GDM_RXCHN_EN(2), 0xffff);
 	airoha_fe_rmw(eth, REG_GDM_LPBK_CFG(2),
 		      LPBK_CHAN_MASK | LPBK_MODE_MASK | LPBK_EN_MASK,
-		      FIELD_PREP(LPBK_CHAN_MASK, chan) | LPBK_EN_MASK);
+		      FIELD_PREP(LPBK_CHAN_MASK, chan) |
+		      LBK_GAP_MODE_MASK | LBK_LEN_MODE_MASK |
+		      LBK_CHAN_MODE_MASK | LPBK_EN_MASK);
 	airoha_fe_rmw(eth, REG_GDM_LEN_CFG(2),
 		      GDM_SHORT_LEN_MASK | GDM_LONG_LEN_MASK,
 		      FIELD_PREP(GDM_SHORT_LEN_MASK, 60) |
diff --git a/drivers/net/ethernet/airoha/airoha_regs.h b/drivers/net/ethernet/airoha/airoha_regs.h
index 150c85995cc1a..0c8f61081699c 100644
--- a/drivers/net/ethernet/airoha/airoha_regs.h
+++ b/drivers/net/ethernet/airoha/airoha_regs.h
@@ -151,6 +151,9 @@
 #define LPBK_LEN_MASK			GENMASK(23, 10)
 #define LPBK_CHAN_MASK			GENMASK(8, 4)
 #define LPBK_MODE_MASK			GENMASK(3, 1)
+#define LBK_GAP_MODE_MASK		BIT(3)
+#define LBK_LEN_MODE_MASK		BIT(2)
+#define LBK_CHAN_MODE_MASK		BIT(1)
 #define LPBK_EN_MASK			BIT(0)
 
 #define REG_GDM_TXCHN_EN(_n)		(GDM_BASE(_n) + 0x24)
-- 
2.51.0



