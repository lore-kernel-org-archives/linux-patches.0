Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621016;
	b=D6lf3wCtlnsF/STlFWjmPfqR44BUwQMbuKLkN9miWsPJ5DzD1Ry10+DCwcZDf2Iclvzy
	 sU14Y76QnSf+TJX4gaK4zqOFeA/QgX4AGcAqDJS5F+lAhC425kWx5l25R20Wmx/nFUDiN
	 EfW9hDTgzSsnC0cTDv/mWkmAO5o0OsI4tCr347BgcttuTzhqjGam5l6/q7xlfnIgdj6mM
	 2AWN+LHzHpneKIe8jxtzngi9M6Hp+/40yzC/Jly/ivA9GSUeui5h7+XVvGVarX2UuVpHf
	 ukT7EnuIvLOVXjSNao5raJPALpA8GVxtlHO9Yk7KPqUDbGnW0TEJ4KLJMhyqO/KgwVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YfHm4tD/185/bZZthQGMXc/qd50+YD4x3E0j8wc8QvE=;
	b=Ewcfs8ElU6jx+LEF2Mxe8SNNcXEjAWTfmagW9GATEZUxZGpkZKWTGOvTcn+RKLBLcViV
	 gsvW3Ecyi6Nha8KnCXh2bBaSXTYZA2UFFNppjBK3WbuJj9YAGWLUgYEMHwnGov6IaZEY8
	 iAsF+5vWo7pr/DmujWN6oANPMdCyRdgVUSwnvTKTIZlAH5bp1rJ+PxWfBLrpsXDl5e+m4
	 i5tWtZPui72WHSuHwdPGRmaX35/bcGdPQOcZGxmrJXZZD63y7WXzvv+JHkvVdp69RltOX
	 LRxuN8Eb56w6PnFQ8BTBK9QxpY9LxsOs7PFEnPpe/w/0oS47M9KFbG3Im6st8/XcyQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhxb2YlM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A59606A691;
	Wed, 25 Nov 2026 15:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhxb2YlM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CF71F000D4;
	Wed, 25 Nov 2026 15:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621015;
	bh=YfHm4tD/185/bZZthQGMXc/qd50+YD4x3E0j8wc8QvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhxb2YlMkK4vGQ1mZ22T1u8QCLjPniNzH2S4eOylrWkk2qleyUwzuvvncQ7du+adz
	 4HeCfLfYZIVsvmT1wPMoeUvl4AR1BlZDirt9ReStXiYjpVZFmFjuaZkxcxYej4KgGk
	 ZD44ExI+cN2A518la4HM221mYao1PRpNo4NiZDKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zhi-Jun You <hujy652@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/990] net: ethernet: mtk_wed: skip ring reset in wdma_tx_ring_setup for WED v3
Date: Wed, 25 Nov 2026 15:24:20 +0100
Message-ID: <20261125143824.268470288@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi-Jun You <hujy652@gmail.com>

[ Upstream commit cb50f16f37fc3429085c454ee5978e05732d10ba ]

Currently WED v3 tx wdma ring, ring reset happens in a separate code
block unconditionally.

Moreover, v3 has double the size of wdma_desc and has different init
values. mtk_wed_ring_reset doens't deal with that and would corrupt the
wdma_desc.

Fix this by skipping mtk_wed_ring_reset in mtk_wdma_tx_ring_setup for
WED v3.

Fixes: e2f64db13aa1 ("net: ethernet: mtk_wed: introduce WED support for MT7988")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260711112128.971-1-hujy652@gmail.com?part=1
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20261026-wedfix-v6-1-a52f6b15d2fc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index fdb487e5d46e1..04a8da8cb3c51 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -1938,7 +1938,7 @@ mtk_wed_wdma_tx_ring_setup(struct mtk_wed_device *dev, int idx, int size,
 	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_CPU_IDX, 0);
 	wdma_w32(dev, MTK_WDMA_RING_TX(idx) + MTK_WED_RING_OFS_DMA_IDX, 0);
 
-	if (reset)
+	if (!mtk_wed_is_v3_or_greater(dev->hw) && reset)
 		mtk_wed_ring_reset(wdma, MTK_WED_WDMA_RING_SIZE, true);
 
 	if (!idx)  {
-- 
2.53.0



